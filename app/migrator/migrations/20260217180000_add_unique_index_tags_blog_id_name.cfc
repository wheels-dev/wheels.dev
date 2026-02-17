component extends="wheels.migrator.Migration" hint="adds unique index on tags(blog_id, name) to prevent duplicate tags per blog post" {

	function up() {
		transaction {
			try {
				execute("CREATE UNIQUE INDEX idx_tags_blog_id_name ON tags (blog_id, name)");
			} catch (any ex) {
				local.exception = ex;
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
				execute("DROP INDEX IF EXISTS idx_tags_blog_id_name");
			} catch (any ex) {
				local.exception = ex;
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
