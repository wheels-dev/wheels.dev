component extends="wheels.migrator.Migration" hint="creates cached_releases table for GitHub releases caching" {

    function up() {
        transaction {
            try {
                t = createTable(name='cached_releases', force=false, id=true, primaryKey='id');
                t.text(columnNames='data', null=false);
                t.datetime(columnNames='last_updated', null=false);
                t.timestamps();
                t.create();
            } catch (any e) {
                local.exception = e;
            }

            if (StructKeyExists(local, "exception")) {
                transaction action="rollback";
                throw(errorCode="1", detail=local.exception.detail, message=local.exception.message, type="any");
            } else {
                transaction action="commit";
            }
        }
    }

    function down() {
        transaction {
            try {
                dropTable('cached_releases');
            } catch (any e) {
                local.exception = e;
            }

            if (StructKeyExists(local, "exception")) {
                transaction action="rollback";
                throw(errorCode="1", detail=local.exception.detail, message=local.exception.message, type="any");
            } else {
                transaction action="commit";
            }
        }
    }
}