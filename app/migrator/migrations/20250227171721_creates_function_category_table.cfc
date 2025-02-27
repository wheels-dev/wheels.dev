component extends="wheels.migrator.Migration" hint="creates function_category table" {

	function up() {
		transaction {
			try {
				// create function_categories table
                t = createTable(name = 'function_categories');
                t.string(columnNames='name', null=false, default='', limit=255);
				t.integer(columnNames='parent_id', null=true);
				t.integer(columnNames='function_id', null=false);
                t.timestamps();
                t.create();

				// Add Foreign Keys
				addForeignKey(table = "function_categories", column = "function_id", referenceTable = "functions", referenceColumn = "id");

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
                execute(sql="ALTER TABLE function_categories DROP CONSTRAINT IF EXISTS fk_function_categories_function_id");

				// drop function_categories table
                dropTable(name = 'function_categories');
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
