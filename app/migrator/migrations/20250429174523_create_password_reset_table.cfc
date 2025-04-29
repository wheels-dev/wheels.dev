component extends="wheels.migrator.Migration" hint="creates password resets table" {

	function up() {
		transaction {
			try {
				// create password_resets table
                t = createTable(name = 'password_resets');
                t.string(columnNames='token', null=false, default='', limit=255);
                t.datetime(columnNames='expires_at', null=false);
                t.boolean(columnNames='used', null=false, default='0');
                t.integer(columnNames='user_id', null=false);
                t.timestamps();
                t.create();

				// add foreign key constraint
                addForeignKey(
                    table='password_resets',
                    column='user_id',
                    referenceTable='users',
                    referenceColumn='id'
                );

                // add indexes
                execute(sql="CREATE INDEX idx_password_resets_token ON password_resets(token)");
                execute(sql="CREATE INDEX idx_password_resets_user_id ON password_resets(user_id)");
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
				// drop foreign key constraints
                execute(sql="ALTER TABLE password_resets DROP CONSTRAINT IF EXISTS fk_password_resets_user_id");
				
				// drop indexes
                execute(sql="DROP INDEX IF EXISTS idx_password_resets_token ON password_resets");
                execute(sql="DROP INDEX IF EXISTS idx_password_resets_user_id ON password_resets");
				
				// drop password_resets table
                dropTable(name = 'password_resets');
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