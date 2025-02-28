component extends="wheels.migrator.Migration" hint="creates role permission table" {

	function up() {
		transaction {
			try {
				// create role_permissions table
                t = createTable(name = 'role_permissions');
				t.integer(columnNames='permission_id', null=false);
				t.integer(columnNames='role_id', null=false);
                t.timestamps();
                t.create();

				// add foreign key constraint
                addForeignKey(
                    table='role_permissions',
                    column='permission_id',
                    referenceTable='permissions',
                    referenceColumn='id'
                );
                
				addForeignKey(
                    table='role_permissions',
                    column='role_id',
                    referenceTable='roles',
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
                execute(sql="ALTER TABLE role_permissions DROP CONSTRAINT IF EXISTS fk_role_permissions_permission_id");
                execute(sql="ALTER TABLE role_permissions DROP CONSTRAINT IF EXISTS fk_role_permissions_role_id");
				
				// drop role_permissions table
                dropTable(name = 'role_permissions');
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
