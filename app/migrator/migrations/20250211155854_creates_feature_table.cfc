component extends="wheels.migrator.Migration" hint="creates feature table" {

    function up() {
        transaction {
            try {
                // create features table
                t = createTable(name = 'features', force=false, id=true, primaryKey='id');
                t.string(columnNames='title', nullable=false, default='', limit=255);
                t.text(columnNames='description', nullable=true);
                t.string(columnNames='image', nullable=true, limit=255);
                t.boolean(columnNames='is_active', nullable=false, default=true);
                t.integer(columnNames='created_by', nullable=false);
                t.integer(columnNames='updated_by', nullable=true);
                t.timestamps();
                t.create();

                // add foreign key constraints
                // addForeignKey(table = "features", column = "created_by", referenceTable = "users", referenceColumn = "id");
                // addForeignKey(table = "features", column = "updated_by", referenceTable = "users", referenceColumn = "id");

                execute("
					ALTER TABLE features ADD CONSTRAINT fk_features_created_by 
					FOREIGN KEY (created_by) REFERENCES users(id);
				");

				execute("
					ALTER TABLE features ADD CONSTRAINT fk_features_updated_by 
					FOREIGN KEY (updated_by) REFERENCES users(id);
				");

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
                execute(sql="ALTER TABLE features DROP CONSTRAINT IF EXISTS fk_features_created_by");
                execute(sql="ALTER TABLE features DROP CONSTRAINT IF EXISTS fk_features_updated_by");

                // drop features table
                dropTable(name = 'features');
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
