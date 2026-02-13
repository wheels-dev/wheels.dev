component extends="wheels.migrator.Migration" hint="seed admin role permissions" {

	function up() {
		transaction {
			try {
				// Grant the admin role (id=1) access to ALL permissions
				execute("
					INSERT INTO role_permissions (role_id, permission_id, createdat, updatedat)
					SELECT 1, id, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
					FROM permissions
					WHERE id NOT IN (
						SELECT permission_id FROM role_permissions WHERE role_id = 1
					)
				");
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
				execute("DELETE FROM role_permissions WHERE role_id = 1");
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
