component extends="wheels.migrator.Migration" hint="creates category table" {

	function up() {
		transaction {
			try {
				// create categories table
                t = createTable(name = 'categories', force=false, id=true, primaryKey='id');
                t.string(columnNames='name', null=false, default='', limit=255);
                t.string(columnNames='description', null=true, default='', limit=500);
				t.integer(columnNames='parent_id', null=true);
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
				// drop categories table
                dropTable(name = 'categories');
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
