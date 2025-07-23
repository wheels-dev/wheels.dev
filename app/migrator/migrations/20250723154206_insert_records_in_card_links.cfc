component extends="wheels.migrator.Migration" hint="insert records in card_link" {

	function up() {
		transaction {
			try {

				// features card_links
				updateRecord(table="features", where="id=1", card_link="https://wheels.dev/3.0.0/guides/README");
				updateRecord(table="features", where="id=2", card_link="https://wheels.dev/3.0.0/guides/handling-requests-with-controllers/routing");
				updateRecord(table="features", where="id=3", card_link="https://wheels.dev/3.0.0/guides/database-interaction-through-models/database-migrations/README");
				updateRecord(table="features", where="id=4", card_link="https://wheels.dev/3.0.0/guides/working-with-wheels/documenting-your-code");
				updateRecord(table="features", where="id=5", card_link="https://wheels.dev/3.0.0/guides/working-with-cfwheels/switching-environments");
				updateRecord(table="features", where="id=6", card_link="https://wheels.dev/3.0.0/guides/command-line-tools/commands/documentation/docs");
				updateRecord(table="features", where="id=7", card_link="https://wheels.dev/3.0.0/guides/introduction/frameworks-and-cfwheels");
				updateRecord(table="features", where="id=8", card_link="https://wheels.dev/community");
				updateRecord(table="features", where="id=9", card_link="https://wheels.dev/3.0.0/guides/working-with-wheels/directory-structure");

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
