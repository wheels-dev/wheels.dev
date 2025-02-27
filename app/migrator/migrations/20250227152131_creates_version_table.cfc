component extends="wheels.migrator.Migration" hint="creates version table" {

	function up() {
		transaction {
			try {
				// create versions table
                t = createTable(name = 'versions');
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
				// drop versions table
                dropTable(name = 'versions');
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
