component extends="wheels.migrator.Migration" hint="creates category table" {
    public void function up() {
        transaction {
            var local = {};
            try {
                // create categories table
                var t = createTable(name='categories', force=false, id=true, primaryKey='id');
                t.string(columnNames='name', nullable=false, default='', limit=255);
                t.integer(columnNames='parent_id', nullable=true);
                t.string(columnNames='description', nullable=true, default='', limit=500);
                t.timestamps();
                t.create();
                transaction action="commit";
            } catch (any e) {
                local.exception = e;
                transaction action="rollback";
                throw(
                    type="Any",
                    message=local.exception.message,
                    detail=local.exception.detail,
                    errorCode="1"
                );
            }
        }
    }

    public void function down() {
        transaction {
            var local = {};
            try {
                // drop categories table
                dropTable(name='categories');
                transaction action="commit";
            } catch (any e) {
                local.exception = e;
                transaction action="rollback";
                throw(
                    type="Any",
                    message=local.exception.message,
                    detail=local.exception.detail,
                    errorCode="1"
                );
            }
        }
    }
}
