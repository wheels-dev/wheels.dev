component extends="wheels.migrator.Migration" hint="creates role table" {

    function up() {
        transaction {
            try {
                // create roles table
                t = createTable(name = 'roles');
                t.string(columnNames='name', null=false, default='', limit=255);
                t.string(columnNames='description', null=true, default='', limit=100);
                t.timestamps();
                t.create();

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
                // drop roles table
                dropTable(name = 'roles');
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
