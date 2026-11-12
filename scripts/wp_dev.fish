if not test -f flake.nix; or not test -d wp-content
    echo 'run wp_dev from the project directory' >&2
    exit 1
end

set -gx WP_DEV_ROOT (pwd -P)
set -g state_dir "$WP_DEV_ROOT/.local"
set -g site_dir "$state_dir/wordpress"
set -g db_dir "$state_dir/mariadb"
set -gx WP_DEV_SOCKET "$state_dir/mariadb.sock"

switch "$argv[1]"
    case cli
        if not test -f "$site_dir/wp-config.php"
            echo 'start the site with wp_dev up first' >&2
            exit 1
        end
        wp --path="$site_dir" $argv[2..]
        exit $status
    case snapshot
        create_snapshot
        exit $status
    case up
    case '*'
        echo 'usage: wp_dev up | wp_dev cli <arguments> | wp_dev snapshot' >&2
        exit 1
end

mkdir -p "$state_dir"
if not mkdir "$state_dir/running" 2>/dev/null
    echo 'the site is already running or a previous run stopped unexpectedly' >&2
    echo 'if no wp_dev processes remain, remove .local/running and try again' >&2
    exit 1
end

function stop_services --on-event fish_exit
    if set -q php_pid
        kill $php_pid 2>/dev/null
        wait $php_pid 2>/dev/null
    end
    if set -q db_pid
        kill $db_pid 2>/dev/null
        wait $db_pid 2>/dev/null
    end
    rmdir "$state_dir/running" 2>/dev/null
end

function stop_on_interrupt --on-signal INT
    exit 130
end

function stop_on_termination --on-signal TERM
    exit 143
end

mkdir -p "$site_dir" "$db_dir"
for core_file in "$WP_DEV_SOURCE"/*
    if test (basename "$core_file") != wp-content
        cp -r --no-preserve=mode "$core_file" "$site_dir/"; or exit 1
    end
end
ln -sfn "$WP_DEV_ROOT/wp-content" "$site_dir/wp-content"; or exit 1
cp --remove-destination --no-preserve=mode "$WP_DEV_CONFIG" "$site_dir/wp-config.php"; or exit 1
for content_dir in themes plugins
    cp -r --update=none --no-preserve=mode "$WP_DEV_SOURCE/wp-content/$content_dir/." "$WP_DEV_ROOT/wp-content/$content_dir/"; or exit 1
end
mkdir -p "$WP_DEV_ROOT/wp-content/uploads"

if not test -d "$db_dir/mysql"
    mariadb-install-db --no-defaults --datadir="$db_dir" --auth-root-authentication-method=normal --skip-test-db >"$state_dir/db-init.log" 2>&1
    or begin
        cat "$state_dir/db-init.log" >&2
        exit 1
    end
end

mariadbd --no-defaults --datadir="$db_dir" --socket="$WP_DEV_SOCKET" --pid-file="$state_dir/mariadb.pid" --skip-networking --log-error="$state_dir/mariadb.log" &
set -g db_pid $last_pid

set -l db_ready false
for attempt in (seq 1 100)
    if mariadb-admin --no-defaults --socket="$WP_DEV_SOCKET" -u root ping >/dev/null 2>&1
        set db_ready true
        break
    end
    if not kill -0 $db_pid 2>/dev/null
        break
    end
    sleep 0.2
end
if test "$db_ready" != true
    cat "$state_dir/mariadb.log" >&2
    exit 1
end

printf '%s\n' "CREATE DATABASE IF NOT EXISTS wordpress; CREATE USER IF NOT EXISTS 'wordpress'@'localhost' IDENTIFIED BY 'wordpress'; GRANT ALL ON wordpress.* TO 'wordpress'@'localhost';" | mariadb --no-defaults --socket="$WP_DEV_SOCKET" -u root
or exit 1

echo 'open http://localhost:8080 to use wordpress'
echo 'press ctrl c to stop the site and database'
php -d upload_max_filesize=64M -d post_max_size=64M -S localhost:8080 -t "$site_dir" "$WP_DEV_ROUTER" &
set -g php_pid $last_pid
wait $php_pid
