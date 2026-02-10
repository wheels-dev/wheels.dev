component extends="wheels.migrator.Migration" hint="creates reading_histories table" {

	function up() {
		transaction {
			try {
				// create reading_histories table
				t = createTable(name = 'reading_histories', force=false, id=true, primaryKey='id');
				t.integer(columnNames='user_id', null=false);
				t.integer(columnNames='blog_id', null=false);
				t.datetime(columnNames='last_read_at', null=false);
				t.boolean(columnNames='is_completed', null=false, default=false);
				t.timestamps();
				t.create();

				// add unique index
				addIndex(table='reading_histories', columnNames='user_id,blog_id', unique=true);
				addIndex(table='reading_histories', columnNames='last_read_at');

			} catch (any ex) {
				local.exception = ex;
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
				// drop reading_histories table
				dropTable('reading_histories');
			} catch (any ex) {
				local.exception = ex;
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