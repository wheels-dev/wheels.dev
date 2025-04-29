component extends="wheels.migrator.Migration" hint="creates remember tokens table" {

    function up() {
        transaction {
            try {
                // create remember_tokens table
                t = createTable(name = 'remember_tokens', force=false, id=true, primaryKey='id');
                t.string(columnNames='token', null=false, limit=255);
                t.integer(columnNames='user_id', null=false);
                t.datetime(columnNames='expires_at', null=false);
                t.timestamps();
                t.create();

                // add indexes
                addIndex(
                    indexName='idx_token',
                    table='remember_tokens',
                    columnNames='token'
                );
                addIndex(
                    indexName='idx_user',
                    table='remember_tokens',
                    columnNames='user_id'
                );

                // add foreign key constraint
                addForeignKey(
                    table='remember_tokens',
                    column='user_id',
                    referenceTable='users',
                    referenceColumn='id'
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
                // drop foreign key constraint
                execute(sql="ALTER TABLE remember_tokens DROP CONSTRAINT IF EXISTS fk_remember_tokens_user");
                
                // drop remember_tokens table
                dropTable(name = 'remember_tokens');
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