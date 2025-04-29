component extends="wheels.migrator.Migration" hint="creates login attempts table" {

    function up() {
        transaction {
            try {
                // create login_attempts table
                t = createTable(name = 'login_attempts', force=false, id=true, primaryKey='id');
                t.string(columnNames='ip_address', null=false, limit=45);
                t.string(columnNames='email', null=true, limit=255);
                t.timestamps();
                t.create();

                // add index
                addIndex(
                    indexName='idx_ip_created',
                    table='login_attempts',
                    columnNames='ip_address,createdat'
                );

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
                // drop login_attempts table
                dropTable(name = 'login_attempts');
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