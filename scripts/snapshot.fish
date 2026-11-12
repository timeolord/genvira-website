function create_snapshot
    set -g snapshot_db "wordpress_snapshot_$fish_pid"
    set -g snapshot_file "$state_dir/snapshot-$fish_pid.sql"
    set -l tables wp_commentmeta wp_comments wp_links wp_options wp_postmeta wp_posts wp_term_relationships wp_term_taxonomy wp_termmeta wp_terms wp_usermeta wp_users
    set -l connection --no-defaults --socket="$WP_DEV_SOCKET" -u root

    function cleanup_snapshot --on-event fish_exit
        printf 'DROP DATABASE IF EXISTS `%s`;\n' "$snapshot_db" | mariadb --no-defaults --socket="$WP_DEV_SOCKET" -u root 2>/dev/null
        rm -f "$snapshot_file" "$snapshot_file.portable"
    end

    mariadb $connection -e "CREATE DATABASE $snapshot_db"; or return 1
    mariadb-dump $connection --single-transaction --skip-lock-tables --skip-triggers wordpress $tables | mariadb $connection "$snapshot_db"
    set -l copy_status $pipestatus
    if test $copy_status[1] -ne 0; or test $copy_status[2] -ne 0
        return 1
    end
    mariadb $connection "$snapshot_db" < "$WP_DEV_SANITIZER"; or return 1
    mariadb-dump $connection --skip-comments --skip-dump-date --skip-extended-insert --skip-add-locks --skip-lock-tables --skip-triggers --order-by-primary "$snapshot_db" $tables > "$snapshot_file"; or return 1

    read -l first_line < "$snapshot_file"
    if string match -q '*enable the sandbox mode*' -- "$first_line"
        tail -n +2 "$snapshot_file" > "$snapshot_file.portable"; or return 1
        mv "$snapshot_file.portable" "$snapshot_file"; or return 1
    end
    mkdir -p "$WP_DEV_ROOT/database"
    mv "$snapshot_file" "$WP_DEV_ROOT/database/initial.sql"; or return 1
    echo 'saved database/initial.sql from a sanitized temporary copy'
    echo 'review its content before committing it'
end
