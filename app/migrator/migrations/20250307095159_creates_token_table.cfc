component extends="wheels.migrator.Migration" hint="creates token table" {

	function up() {
		transaction {
			try {
				// create user_tokens table
                t = createTable(name = 'user_tokens');
                t.string(columnNames='token', null=false, default='', limit=255);
                t.boolean(columnNames='status', null=false, default='');
				t.integer(columnNames='user_id', null=false);
                t.timestamps();
                t.create();

				// add foreign key constraint
                addForeignKey(
                    table='user_tokens',
                    column='user_id',
                    referenceTable='users',
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
                execute(sql="ALTER TABLE user_tokens DROP CONSTRAINT IF EXISTS fk_user_tokens_user_id");
				
				// drop user_tokens table
                dropTable(name = 'user_tokens');
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
