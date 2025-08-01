component extends="wheels.migrator.Migration" hint="adds locked column to users table for admin-controlled lock/unlock functionality" {

    function up() {
        transaction {
            try {
                // add locked column to users table
                addColumn(
                    table = 'users',
                    columnType = 'boolean',
                    columnName = 'locked',
                    null = false,
                    default = false
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
                // remove locked column from users table
                removeColumn(
                    table = 'users',
                    columnName = 'locked'
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
} 