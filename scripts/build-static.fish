set -l base_url
if set -q argv[1]
    set base_url "$argv[1]"
else if set -q PAGES_BASE_URL
    set base_url "$PAGES_BASE_URL"
end

if test -n "$base_url"
    zola build --force --base-url "$base_url"; or exit 1
    node scripts/verify-static.mjs "$base_url"; or exit 1
else
    zola build --force; or exit 1
    node scripts/verify-static.mjs; or exit 1
end
