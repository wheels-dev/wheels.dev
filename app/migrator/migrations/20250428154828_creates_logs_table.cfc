component extends="wheels.migrator.Migration" hint="creates logs table" {

    function up() {
        transaction {
            try {
                // create logs table
                t = createTable(name = 'logs', force=false, id=true, primaryKey='id');
                t.string(columnNames='category', null=false, default='', limit=255);
                t.string(columnNames='level', null=false, default='INFO', limit=50);
                t.text(columnNames='message', null=false);
                t.text(columnNames='details', null=true);
                t.string(columnNames='ip_address', null=true, limit=50);
                t.string(columnNames='user_agent', null=true, limit=255);
                t.integer(columnNames='user_id', null=true, limit=36);
                t.timestamps();
                t.create();

                // add foreign key constraint
                // addForeignKey(
                //     table = 'logs',
                //     column = 'user_id',
                //     referenceTable = 'users',
                //     referenceColumn = 'id'
                // );

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
                execute(sql="ALTER TABLE logs DROP CONSTRAINT IF EXISTS fk_logs_user_id");
                
                // drop logs table
                dropTable(name = 'logs');
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