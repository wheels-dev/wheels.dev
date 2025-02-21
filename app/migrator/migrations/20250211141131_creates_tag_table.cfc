component extends="wheels.migrator.Migration" hint="creates tag table" {

    function up() {
        transaction {
            try {
                // create tags table
                t = createTable(name = 'tags', force=false, id=true, primaryKey='id');
                t.string(columnNames='name', nullable=false, default='', limit=255);
                t.integer(columnNames='blog_id', nullable=false);
                t.string(columnNames='description', nullable=true, default='', limit=500);
                t.boolean(columnNames='is_active', nullable=false, default=true);
                t.timestamps();
                t.create();

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
                execute(sql="ALTER TABLE tags DROP CONSTRAINT IF EXISTS fk_tags_blog_id");
                
                // drop tags table
                
                dropTable(name = 'tags');
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
