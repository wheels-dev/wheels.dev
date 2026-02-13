component extends="wheels.migrator.Migration" hint="insert records in card_link" {

	function up() {
		transaction {
			try {
				// Use execute() because updateRecord() calls get("adapterName") for timestamp columns which fails on CockroachDB
				execute("UPDATE features SET card_link = 'https://wheels.dev/3.0.0/guides/README', updatedat = CURRENT_TIMESTAMP WHERE id = 1");
				execute("UPDATE features SET card_link = 'https://wheels.dev/3.0.0/guides/handling-requests-with-controllers/routing', updatedat = CURRENT_TIMESTAMP WHERE id = 2");
				execute("UPDATE features SET card_link = 'https://wheels.dev/3.0.0/guides/database-interaction-through-models/database-migrations/README', updatedat = CURRENT_TIMESTAMP WHERE id = 3");
				execute("UPDATE features SET card_link = 'https://wheels.dev/3.0.0/guides/working-with-wheels/documenting-your-code', updatedat = CURRENT_TIMESTAMP WHERE id = 4");
				execute("UPDATE features SET card_link = 'https://wheels.dev/3.0.0/guides/working-with-cfwheels/switching-environments', updatedat = CURRENT_TIMESTAMP WHERE id = 5");
				execute("UPDATE features SET card_link = 'https://wheels.dev/3.0.0/guides/command-line-tools/commands/documentation/docs', updatedat = CURRENT_TIMESTAMP WHERE id = 6");
				execute("UPDATE features SET card_link = 'https://wheels.dev/3.0.0/guides/introduction/frameworks-and-cfwheels', updatedat = CURRENT_TIMESTAMP WHERE id = 7");
				execute("UPDATE features SET card_link = 'https://wheels.dev/community', updatedat = CURRENT_TIMESTAMP WHERE id = 8");
				execute("UPDATE features SET card_link = 'https://wheels.dev/3.0.0/guides/working-with-wheels/directory-structure', updatedat = CURRENT_TIMESTAMP WHERE id = 9");

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
