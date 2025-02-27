component extends="wheels.migrator.Migration" hint="creates function_use table" {

	function up() {
		transaction {
			try {
				// create function_uses table
                t = createTable(name = 'function_uses');
                t.string(columnNames='name', null=false, default='', limit=255);
				t.integer(columnNames='function_id', null=false);
                t.timestamps();
                t.create();

				// Add Foreign Keys
				addForeignKey(table = "function_uses", column = "function_id", referenceTable = "functions", referenceColumn = "id");

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
				// drop foreign key constraints using raw SQL
                execute(sql="ALTER TABLE function_uses DROP CONSTRAINT IF EXISTS fk_function_uses_function_id");

				// drop function_uses table
                dropTable(name = 'function_uses');
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
