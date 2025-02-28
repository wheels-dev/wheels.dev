component extends="wheels.migrator.Migration" hint="creates permission table" {

	function up() {
		transaction {
			try {
				// create permissions table
                t = createTable(name = 'permissions');
                t.string(columnNames='name', null=false, default='', limit=255);
                t.boolean(columnNames='status', null=false, default='');
				t.integer(columnNames='module_id', null=false);
                t.timestamps();
                t.create();

				// add foreign key constraint
                addForeignKey(
                    table='permissions',
                    column='module_id',
                    referenceTable='modules',
                    referenceColumn='id'
                );
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
                execute(sql="ALTER TABLE permissions DROP CONSTRAINT IF EXISTS fk_permissions_module_id");
				
				// drop permissions table
                dropTable(name = 'permissions');
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
