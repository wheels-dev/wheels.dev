component extends="wheels.migrator.Migration" {

    function up() {
        announce("Setting publishedAt to 2026-01-01 for all existing blog posts");
        execute("UPDATE blog_posts SET published_at = '2026-01-01 00:00:00' WHERE published_at IS NULL OR published_at = ''");
    }

    function down() {
        announce("Reverting publishedAt dates (setting to NULL where it was 2026-01-01)");
        execute("UPDATE blog_posts SET published_at = NULL WHERE published_at = '2026-01-01 00:00:00'");
    }

}
