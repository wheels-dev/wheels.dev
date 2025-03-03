component extends="wheels.migrator.Migration" hint="creates post_type table" {

    function up() {
        transaction {
            try {
                // create post_types table
                t = createTable(name = 'post_types', force=false, id=true, primaryKey='id');
                t.string(columnNames='name', null=false, default='', limit=255);
                t.string(columnNames='description', null=true, default='', limit=100);
                t.boolean(columnNames='is_active', null=false, default=true);
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
                // drop post_types table
                dropTable(name = 'post_types');
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
