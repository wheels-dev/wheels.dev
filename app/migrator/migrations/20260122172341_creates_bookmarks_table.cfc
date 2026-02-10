component extends="wheels.migrator.Migration" hint="creates bookmarks table" {

	function up() {
		transaction {
			try {
				// create bookmarks table
				t = createTable(name = 'bookmarks', force=false, id=true, primaryKey='id');
				t.integer(columnNames='user_id', null=false);
				t.integer(columnNames='blog_id', null=false);
				t.timestamps();
				t.create();

				// add unique index
				addIndex(table='bookmarks', columnNames='user_id,blog_id', unique=true);

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
				// drop bookmarks table
				dropTable('bookmarks');
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