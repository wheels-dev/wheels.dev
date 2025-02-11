component extends="wheels.migrator.Migration" hint="creates blog_post table" {

	function up() {
		transaction {
			try {
				// your code goes here
				// create blog_posts table
				t = createTable(name = 'blog_posts');
				t.string(columnNames='title');
				t.text(columnNames='content');
				t.string(columnNames='slug');
				t.boolean(columnNames='is_deleted');
				t.boolean(columnNames='is_comment_closed');
				t.integer(columnNames = 'status_id'); 				
				t.integer(columnNames = 'category_id'); 				
				t.integer(columnNames = 'post_type_id'); 				
				t.integer(columnNames = 'created_by'); 				
				t.integer(columnNames = 'updated_by'); 
				t.integer(columnNames = 'deleted_by'); 
				t.timestamps();
				t.create();

				addForeignKey(table = "blog_posts", column = "status_id", referenceTable = "post_statuses", referenceColumn = "id");
				addForeignKey(table = "blog_posts", column = "category_id", referenceTable = "categories", referenceColumn = "id");
				addForeignKey(table = "blog_posts", column = "post_type_id", referenceTable = "post_types", referenceColumn = "id");
				// addForeignKey(table = "blog_posts", column = "created_by", referenceTable = "users", referenceColumn = "id");
				// addForeignKey(table = "blog_posts", column = "updated_by", referenceTable = "users", referenceColumn = "id");
				// addForeignKey(table = "blog_posts", column = "deleted_by", referenceTable = "users", referenceColumn = "id");

				execute("
					ALTER TABLE blog_posts ADD CONSTRAINT fk_blog_posts_created_by 
					FOREIGN KEY (created_by) REFERENCES users(id);
				");

				execute("
					ALTER TABLE blog_posts ADD CONSTRAINT fk_blog_posts_updated_by 
					FOREIGN KEY (updated_by) REFERENCES users(id);
				");

				execute("
					ALTER TABLE blog_posts ADD CONSTRAINT fk_blog_posts_deleted_by 
					FOREIGN KEY (deleted_by) REFERENCES users(id);
				");

			} catch (any e) {
				local.exception = e;
				// writedump(local.exception);
				
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
				// drop blog_posts table
				dropTable('blog_posts');

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
