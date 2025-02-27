component extends="wheels.migrator.Migration" hint="creates function_attribute table" {

	function up() {
		transaction {
			try {
				// create function_attributes table
                t = createTable(name = 'function_attributes');
                t.string(columnNames='name', null=false, default='', limit=255);
				t.string(columnNames='type', null=true);
				t.boolean(columnNames='required', null=false, default=true);
				t.boolean(columnNames='default', null=false, default=true);
				t.text(columnNames='description', null=true);
				t.integer(columnNames='function_id', null=false);
                t.timestamps();
                t.create();

				// Add Foreign Keys
				addForeignKey(table = "function_attributes", column = "function_id", referenceTable = "functions", referenceColumn = "id");
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
                execute(sql="ALTER TABLE function_attributes DROP CONSTRAINT IF EXISTS fk_function_attributes_function_id");

				// drop function_attributes table
                dropTable(name = 'function_attributes');
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
