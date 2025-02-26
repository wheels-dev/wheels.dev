component extends="wheels.migrator.Migration" hint="creates guide table" {

	function up() {
		transaction {
			try {
				// your code goes here
				// create guides table
				t = createTable(name='guides', force=false, id=true, primaryKey='id');
				t.string(columnNames='tab', null=false, default='', limit=255);
				t.string(columnNames='title', null=true, default='', limit=255);
				t.string(columnNames='subtitle', null=true, default='', limit=255);
				t.string(columnNames='heading_1', null=true, default='', limit=255);
				t.string(columnNames='heading_2', null=true, default='', limit=255);
				t.string(columnNames='heading_url', null=true, default='', limit=255);
				t.text(columnNames='content', null=false);
				t.integer(columnNames='parent_id', null=true);
				t.string(columnNames='description', null=true, default='', limit=500);
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
