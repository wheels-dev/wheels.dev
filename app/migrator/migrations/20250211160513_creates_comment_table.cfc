component extends="wheels.migrator.Migration" hint="creates comment table" {

	function up() {
		transaction {
			try {
				// your code goes here
				// create comments table
				t = createTable(name = 'comments');
				t.text(columnNames='content');
				t.boolean(columnNames='is_deleted');
				t.integer(columnNames='comment_parent_id'); 				
				t.integer(columnNames = 'blog_id'); 				
				t.integer(columnNames = 'auther_id'); 				
				t.integer(columnNames = 'updated_by'); 
				t.integer(columnNames = 'deleted_by'); 
				t.timestamps();
				t.create();

				addForeignKey(table = "comments", column = "blog_id", referenceTable = "blog_posts", referenceColumn = "id");
				// addForeignKey(table = "comments", column = "auther_id", referenceTable = "users", referenceColumn = "id");
				// addForeignKey(table = "comments", column = "updated_by", referenceTable = "users", referenceColumn = "id");
				// addForeignKey(table = "comments", column = "deleted_by", referenceTable = "users", referenceColumn = "id");

				execute("
					ALTER TABLE comments ADD CONSTRAINT fk_comments_auther_id 
					FOREIGN KEY (auther_id) REFERENCES users(id);
				");

				execute("
					ALTER TABLE comments ADD CONSTRAINT fk_comments_updated_by 
					FOREIGN KEY (updated_by) REFERENCES users(id);
				");

				execute("
					ALTER TABLE comments ADD CONSTRAINT fk_comments_deleted_by 
					FOREIGN KEY (deleted_by) REFERENCES users(id);
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
				// your code goes here
				// drop comments table
				dropTable('comments');
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
