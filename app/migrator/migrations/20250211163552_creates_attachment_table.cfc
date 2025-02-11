component extends="wheels.migrator.Migration" hint="creates attachment table" {

	function up() {
		transaction {
			try {
				// your code goes here
				// create attachments table
				t = createTable(name = 'attachments');
				t.string(columnNames='path');	
				t.integer(columnNames = 'blog_id'); 				
				t.integer(columnNames = 'comment_id');
				t.timestamps();
				t.create();

				addForeignKey(table = "attachments", column = "blog_id", referenceTable = "blog_posts", referenceColumn = "id");
				addForeignKey(table = "attachments", column = "comment_id", referenceTable = "comments", referenceColumn = "id");

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
				// drop attachments table
				dropTable('attachments');
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
