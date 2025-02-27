component extends="wheels.migrator.Migration" hint="creates function_returntype table" {

	function up() {
		transaction {
			try {
				// create function_returntypes table
                t = createTable(name = 'function_returntypes');
                t.string(columnNames='name', null=false, default='', limit=255);
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
				// drop function_returntypes table
                dropTable(name = 'function_returntypes');
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
