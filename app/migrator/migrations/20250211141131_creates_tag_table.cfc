component extends="wheels.migrator.Migration" hint="creates tag table" {

	function up() {
		transaction {
			try {
				// your code goes here
				// create tags table
				t = createTable(name = 'tags');
				t.string(columnNames='name');
				t.integer(columnNames = 'blog_id'); 
				t.timestamps();
				t.create();

				addForeignKey(table = "tags", column = "blog_id", referenceTable = "blog_posts", referenceColumn = "id");

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
				// drop tags table
				dropTable('tags');
				
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
