if test -d .local/mariadb; or test -e .local/running; or test -e .local/wordpress/wp-config.php
    echo 'build-static restores the committed snapshot and needs a fresh checkout' >&2
    exit 1
end

if not test -f database/initial.sql
    echo 'the committed database snapshot is missing' >&2
    exit 1
end

set -l base_path /genvira-website/
if set -q argv[1]
    set base_path "$argv[1]"
else if set -q PAGES_BASE_PATH
    set base_path "$PAGES_BASE_PATH"
    if not string match -q '*/' -- "$base_path"
        set base_path "$base_path/"
    end
end

set -l port 8080
if set -q WP_DEV_PORT
    set port "$WP_DEV_PORT"
end
set -gx WP_DEV_URL "http://localhost:$port"
mkdir -p .local
wp_dev up > .local/ci-wordpress.log 2>&1 &
set -g build_server_pid $last_pid

function stop_build_server --on-event fish_exit
    kill -TERM $build_server_pid 2>/dev/null
    wait $build_server_pid 2>/dev/null
end

function interrupt_build --on-signal INT
    exit 130
end

function terminate_build --on-signal TERM
    exit 143
end

set -l ready false
for attempt in (seq 1 200)
    if not kill -0 $build_server_pid 2>/dev/null
        break
    end
    if test -f .local/wordpress/wp-config.php; and mariadb-admin --no-defaults --socket="$PWD/.local/mariadb.sock" -u root ping >/dev/null 2>&1
        if php -r '$socket = @fsockopen("localhost", (int) $argv[1], $code, $message, 0.2); if (!$socket) exit(1); fclose($socket);' "$port" >/dev/null 2>&1
            set ready true
            break
        end
    end
    sleep 0.2
end
if test "$ready" != true
    cat .local/ci-wordpress.log >&2
    exit 1
end

wp_dev cli --skip-plugins --skip-themes db import "$PWD/database/initial.sql"; or exit 1
set -l snapshot_url (mariadb --no-defaults --socket="$PWD/.local/mariadb.sock" -u root --batch --skip-column-names wordpress -e "SELECT option_value FROM wp_options WHERE option_name = 'home'")
if test -z "$snapshot_url"
    echo 'the snapshot has no home url' >&2
    exit 1
end
wp_dev cli --skip-plugins --skip-themes search-replace "$snapshot_url" "$WP_DEV_URL" --all-tables-with-prefix --skip-columns=guid; or exit 1
wp_dev export "$base_path"; or exit 1
php scripts/verify-static.php; or exit 1
