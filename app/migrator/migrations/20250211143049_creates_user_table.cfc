component extends="wheels.migrator.Migration" hint="creates user table" {

    function up() {
        transaction {
            try {
                // create users table
                t = createTable(name = 'users', force=false, id=true, primaryKey='id');
                t.string(columnNames='name', nullable=false, default='', limit=255);
                t.string(columnNames='email', nullable=false, unique=true, limit=255);
                t.string(columnNames='password_hash', nullable=false, limit=255);
                t.string(columnNames='profile_picture', nullable=true, limit=255);
                t.string(columnNames='profile_url', nullable=true, limit=255);
                t.boolean(columnNames='status', nullable=false, default=true);
                t.integer(columnNames='role_id', nullable=false);
                t.timestamps();
                t.create();

                // add foreign key constraint
                addForeignKey(
                    table='users',
                    column='role_id',
                    referenceTable='roles',
                    referenceColumn='id',
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
