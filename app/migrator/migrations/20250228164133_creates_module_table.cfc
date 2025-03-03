component extends="wheels.migrator.Migration" hint="creates module table" {

	function up() {
		transaction {
			try {
				// create modules table
                t = createTable(name = 'modules');
                t.string(columnNames='name', null=false, default='', limit=255);
                t.string(columnNames='description', null=true, default='', limit=100);
                t.boolean(columnNames='status', null=false, default='');
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
				// drop modules table
                dropTable(name = 'modules');
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
