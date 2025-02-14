component extends="wheels.migrator.Migration" hint="creates attachment table" {

    function up() {
        transaction {
            try {
                // create attachments table
                t = createTable(name = 'attachments', force=false, id=true, primaryKey='id');
                t.string(columnNames='path', nullable=false, limit=255);
                t.string(columnNames='file_name', nullable=false, limit=255);
                t.string(columnNames='file_type', nullable=false, limit=50);
                t.integer(columnNames='file_size', nullable=false);
                t.integer(columnNames='blog_id', nullable=true);
                t.integer(columnNames='comment_id', nullable=true);
                t.integer(columnNames='uploaded_by', nullable=false);
                t.timestamps();
                t.create();

                // add foreign key constraints
                addForeignKey(table = "attachments", column = "blog_id", referenceTable = "blog_posts", referenceColumn = "id");
                addForeignKey(table = "attachments", column = "comment_id", referenceTable = "comments", referenceColumn = "id");
                addForeignKey(table = "attachments", column = "uploaded_by", referenceTable = "users", referenceColumn = "id");

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
                execute(sql="ALTER TABLE attachments DROP CONSTRAINT IF EXISTS fk_attachments_blog_id");
                execute(sql="ALTER TABLE attachments DROP CONSTRAINT IF EXISTS fk_attachments_comment_id");
                execute(sql="ALTER TABLE attachments DROP CONSTRAINT IF EXISTS fk_attachments_uploaded_by");

                // drop attachments table
                dropTable(name = 'attachments');
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
