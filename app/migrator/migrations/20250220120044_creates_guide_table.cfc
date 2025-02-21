component extends="wheels.migrator.Migration" hint="creates guide table" {

	function up() {
		transaction {
			try {
				// your code goes here
				// create guides table
				t = createTable(name='guides', force=false, id=true, primaryKey='id');
				t.string(columnNames='tab', nullable=false, default='', limit=255);
				t.string(columnNames='title', nullable=false, default='', limit=255);
				t.string(columnNames='subtitle', nullable=false, default='', limit=255);
				t.string(columnNames='heading_1', nullable=false, default='', limit=255);
				t.string(columnNames='heading_2', nullable=false, default='', limit=255);
				t.string(columnNames='heading_url', nullable=false, default='', limit=255);
				t.text(columnNames='content', nullable=false);
				t.integer(columnNames='parent_id', nullable=true);
				t.string(columnNames='description', nullable=true, default='', limit=500);
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
				// your code goes here
				// drop guides table
				dropTable(name = 'guides');
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
