component extends="wheels.migrator.Migration" hint="creates user table" {

	function up() {
		transaction {
			try {
				// your code goes here
				// create users table
				t = createTable(name = 'users');
				t.string(columnNames='name');
				t.string(columnNames='email', unique=true);
				t.string(columnNames='password_hash');
				t.string(columnNames='profile_picture');
				t.string(columnNames='profile_url');
				t.boolean(columnNames='status', defaultValue=true);	
				t.integer(columnNames = 'role_id'); 				
				t.timestamps();
				t.create();

				addForeignKey(table = "users", column = "role_id", referenceTable = "roles", referenceColumn = "id");

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
				// your code goes here
				// drop table users
				dropTable('users');
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
