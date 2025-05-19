component extends="wheels.migrator.Migration" hint="creates comment table" {

    function up() {
        transaction {
            try {
                // create comments table
                t = createTable(name = 'comments', force=false, id=true, primaryKey='id');
                t.text(columnNames='content', null=false);
                t.integer(columnNames='comment_parent_id', null=true);
                t.integer(columnNames='blog_id', null=false);
                t.boolean(columnNames='is_approved', null=false, default=false);
                t.boolean(columnNames='is_flagged', null=false, default=false);
                t.boolean(columnNames='is_published', null=false, default=false);
                t.integer(columnNames='author_id', null=false);
                t.integer(columnNames='updated_by', null=true);
                t.integer(columnNames='deleted_by', null=true);
                t.datetime(columnNames='published_at', null=true);
                t.integer(columnNames='wp_id', null=true);
                t.timestamps();
                t.create();

                // add foreign key constraints
                addForeignKey(table = "comments", column = "blog_id", referenceTable = "blog_posts", referenceColumn = "id");
                // addForeignKey(table = "comments", column = "author_id", referenceTable = "users", referenceColumn = "id");
                // addForeignKey(table = "comments", column = "updated_by", referenceTable = "users", referenceColumn = "id");
                // addForeignKey(table = "comments", column = "deleted_by", referenceTable = "users", referenceColumn = "id");
                addForeignKey(table = "comments", column = "comment_parent_id", referenceTable = "comments", referenceColumn = "id");
                
                execute("
                    ALTER TABLE comments ADD CONSTRAINT fk_comments_created_by 
                    FOREIGN KEY (author_id) REFERENCES users(id);
                ");

                execute("
                    ALTER TABLE comments ADD CONSTRAINT fk_comments_updated_by 
                    FOREIGN KEY (updated_by) REFERENCES users(id);
                ");

                execute("
                    ALTER TABLE comments ADD CONSTRAINT fk_comments_deleted_by 
                    FOREIGN KEY (deleted_by) REFERENCES users(id);
                ");
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
                // drop foreign key constraints using raw SQL
                execute(sql="ALTER TABLE comments DROP CONSTRAINT IF EXISTS fk_comments_blog_id");
                execute(sql="ALTER TABLE comments DROP CONSTRAINT IF EXISTS fk_comments_author_id");
                execute(sql="ALTER TABLE comments DROP CONSTRAINT IF EXISTS fk_comments_updated_by");
                execute(sql="ALTER TABLE comments DROP CONSTRAINT IF EXISTS fk_comments_deleted_by");
                execute(sql="ALTER TABLE comments DROP CONSTRAINT IF EXISTS fk_comments_comment_parent_id");

                // drop comments table
                dropTable(name = 'comments');
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
