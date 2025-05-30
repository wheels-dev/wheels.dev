component extends="wheels.migrator.Migration" hint="add slack invite link to settings" {

    function up() {
        transaction {
            try {
                addColumn(table = 'settings', columnType = 'string', columnName = 'slack_invite_link', default = '', null = true, limit = 255);
            } catch (any e) {
                local.exception = e;
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
                removeColumn(table = 'settings', columnName = 'slack_invite_link');
            } catch (any e) {
                local.exception = e;
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