component extends="wheels.migrator.Migration" hint="Creates blog_tags junction table and migrates existing tag data" {

    function up() {
        transaction {
            try {
                // Step 0: Drop existing blog_tags table if it exists (from previous failed migrations)
                execute(sql="DROP TABLE IF EXISTS blog_tags CASCADE");

                // Step 0b: Drop the unique_tag_name constraint if it exists
                execute(sql="ALTER TABLE tags DROP CONSTRAINT IF EXISTS unique_tag_name");

                // Step 1: First, deduplicate existing tags within each blog - keep only one record per (blog_id, name)
                execute(sql="
                    DELETE FROM tags
                    WHERE id NOT IN (
                        SELECT MIN(id)
                        FROM tags
                        GROUP BY blog_id, name
                    )
                ");

                // Step 2: Create the blog_tags junction table
                t = createTable(name = 'blog_tags', force=false, id=true, primaryKey='id');
                t.integer(columnNames='blog_id', null=false);
                t.integer(columnNames='tag_id', null=false);
                t.timestamps();
                t.create();

                // Add foreign key constraints
                addForeignKey(
                    table='blog_tags',
                    column='blog_id',
                    referenceTable='blog_posts',
                    referenceColumn='id'
                );
                addForeignKey(
                    table='blog_tags',
                    column='tag_id',
                    referenceTable='tags',
                    referenceColumn='id'
                );

                // Add unique constraint to prevent duplicate blog-tag combinations
                execute(sql="CREATE UNIQUE INDEX IF NOT EXISTS unique_blog_tag ON blog_tags (blog_id, tag_id)");

                // Step 3: Deduplicate tag names across blogs - merge duplicate names into one master tag
                // For each duplicate tag name, keep the first one (lowest ID)
                execute(sql="
                    WITH duplicates AS (
                        SELECT name, MIN(id) as master_id
                        FROM tags
                        GROUP BY name
                        HAVING COUNT(*) > 1
                    )
                    UPDATE tags
                    SET name = NULL
                    FROM duplicates d
                    WHERE tags.name = d.name AND tags.id <> d.master_id
                ");

                // Delete the marked duplicates
                execute(sql="DELETE FROM tags WHERE name IS NULL");

                // Step 4: Now add unique constraint on tag names (should work since we merged duplicates)
                execute(sql="ALTER TABLE tags ADD CONSTRAINT unique_tag_name UNIQUE (name)");

                // Step 5: Drop the old unique constraint on (blog_id, name) if it exists
                execute(sql="ALTER TABLE tags DROP CONSTRAINT IF EXISTS idx_tags_blog_id_name");

                // Step 6: Migrate existing data from tags table to blog_tags (use ON CONFLICT to skip duplicates)
                execute(sql="
                    INSERT INTO blog_tags (blog_id, tag_id, createdat, updatedat)
                    SELECT t.blog_id, t.id, t.createdat, t.updatedat
                    FROM tags t
                    WHERE t.blog_id IS NOT NULL
                    ON CONFLICT DO NOTHING
                ");

                // Step 7: Make blog_id nullable in tags table
                execute(sql="ALTER TABLE tags ALTER COLUMN blog_id DROP NOT NULL");

                // Step 8: Add description column if it doesn't exist
                execute(sql="ALTER TABLE tags ADD COLUMN IF NOT EXISTS description VARCHAR(500)");

            } catch (any ex) {
                local.exception = ex;
            }

            if (StructKeyExists(local, "exception")) {
                transaction action="rollback";
                Throw(errorCode = "1", detail = local.exception.detail, message = local.exception.message, type = "any");
            } else {
                transaction action="commit";
            }
        }
    }

    function down() {
        transaction {
            try {
                // Drop foreign key constraints
                execute(sql="ALTER TABLE blog_tags DROP CONSTRAINT IF EXISTS fk_blog_tags_blog_id");
                execute(sql="ALTER TABLE blog_tags DROP CONSTRAINT IF EXISTS fk_blog_tags_tag_id");
                
                // Drop junction table
                dropTable(name = 'blog_tags');

                // Revert tags table changes
                execute(sql="ALTER TABLE tags DROP CONSTRAINT IF EXISTS unique_tag_name");
                
            } catch (any ex) {
                local.exception = ex;
            }

            if (StructKeyExists(local, "exception")) {
                transaction action="rollback";
                Throw(errorCode = "1", detail = local.exception.detail, message = local.exception.message, type = "any");
            } else {
                transaction action="commit";
            }
        }
    }
}

