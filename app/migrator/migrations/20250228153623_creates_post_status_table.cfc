component extends="wheels.migrator.Migration" hint="creates post_status table" {

	function up() {
		transaction {
			try {
				// create post_statuses table
				t = createTable(name = 'post_statuses');
				t.string(columnNames='name', null=false, default='', limit=255);
				t.string(columnNames='description', null=true, default='', limit=500);
				t.boolean(columnNames='is_active', null=false, default=true);
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
				// drop post_statuses table
				dropTable(name = 'post_statuses');
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
