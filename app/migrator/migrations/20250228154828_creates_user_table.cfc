component extends="wheels.migrator.Migration" hint="creates user table" {

    function up() {
        transaction {
            try {
                // create users table
                t = createTable(name = 'users', force=false, id=true, primaryKey='id');
                t.string(columnNames='name', null=false, default='', limit=255);
                t.string(columnNames='email', null=false, unique=true, limit=255);
                t.string(columnNames='password_hash', null=false, limit=255);
                t.string(columnNames='profile_picture', null=true, limit=255);
                t.string(columnNames='profile_url', null=true, limit=255);
                t.boolean(columnNames='status', null=false, default=true);
                t.integer(columnNames='role_id', null=false);
                t.timestamps();
                t.create();

                // add foreign key constraint
                addForeignKey(
                    table='users',
                    column='role_id',
                    referenceTable='roles',
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
                // drop foreign key constraints using raw SQL
                execute(sql="ALTER TABLE users DROP CONSTRAINT IF EXISTS fk_users_role_id");
                
                // drop users table
                dropTable(name = 'users');
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
