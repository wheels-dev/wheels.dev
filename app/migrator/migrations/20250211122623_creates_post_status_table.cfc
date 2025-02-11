component extends="wheels.migrator.Migration" hint="creates post_status table" {

	function up() {
		transaction {
			try {
				// your code goes here
				// create post_statuses table
				t = createTable(name = 'post_statuses');
				t.string(columnNames='name');
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
				// drop post_statuses table
				dropTable('post_statuses');

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
