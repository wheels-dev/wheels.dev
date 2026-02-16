component extends="wheels.migrator.Migration" {

    function up() {
        announce("Fixing publishedAt for blog posts that still have NULL published_at");
        execute("UPDATE blog_posts SET published_at = COALESCE(post_created_date, createdat, '2026-01-01 00:00:00') WHERE published_at IS NULL");
    }

    function down() {
        announce("No-op: cannot safely revert published_at fix");
    }

}
