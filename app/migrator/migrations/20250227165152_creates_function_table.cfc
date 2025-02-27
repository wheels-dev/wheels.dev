component extends="wheels.migrator.Migration" hint="creates function table" {

	function up() {
		transaction {
			try {
				// create functions table
                t = createTable(name = 'functions');
                t.string(columnNames='name', null=false, default='', limit=255);
				t.text(columnNames='description', null=true);
				t.text(columnNames='codeblock', null=true);
				t.integer(columnNames='version_id', null=false);
				t.integer(columnNames='returntype_id', null=false);
                t.timestamps();
                t.create();

				// Add Foreign Keys
				addForeignKey(table = "functions", column = "version_id", referenceTable = "versions", referenceColumn = "id");
				addForeignKey(table = "functions", column = "returntype_id", referenceTable = "function_returntypes", referenceColumn = "id");
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
                execute(sql="ALTER TABLE functions DROP CONSTRAINT IF EXISTS fk_functions_version_id");
                execute(sql="ALTER TABLE functions DROP CONSTRAINT IF EXISTS fk_functions_returntype_id");

				// drop functions table
                dropTable(name = 'functions');
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
