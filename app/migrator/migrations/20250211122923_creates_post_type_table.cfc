component extends="wheels.migrator.Migration" hint="creates post_type table" {

	function up() {
		transaction {
			try {
				// your code goes here
				// create post_types table
				t = createTable(name = 'post_types');
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
				// drop post_types table
				dropTable('post_types');
				
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
