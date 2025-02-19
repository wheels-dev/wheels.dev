component extends="wheels.migrator.Migration" hint="creates blog_post table" {

	function up() {
		transaction {
			try {
				// create blog_posts table
				t = createTable(name = 'blog_posts', force=false, id=true, primaryKey='id');
                t.string(columnNames='title', nullable=false, default='', limit=255);
                t.string(columnNames='slug', nullable=false, default='', limit=255, unique=true);
                t.text(columnNames='content', nullable=false);
                t.string(columnNames='excerpt', nullable=true, default='', limit=500);
                t.integer(columnNames='status_id', nullable=false);
                t.integer(columnNames='category_id', nullable=false);
                t.integer(columnNames='post_type_id', nullable=false);
                t.integer(columnNames='created_by', nullable=false);
                t.integer(columnNames='updated_by', nullable=true);
                t.integer(columnNames='deleted_by', nullable=true);
                t.datetime(columnNames='published_at', nullable=true);
                t.boolean(columnNames='is_published', nullable=false, default=false);
                t.timestamps();
                t.create();

				addForeignKey(table = "blog_posts", column = "status_id", referenceTable = "post_statuses", referenceColumn = "id");
				addForeignKey(table = "blog_posts", column = "category_id", referenceTable = "categories", referenceColumn = "id");
				addForeignKey(table = "blog_posts", column = "post_type_id", referenceTable = "post_types", referenceColumn = "id");
				// addForeignKey(table = "blog_posts", column = "created_by", referenceTable = "users", referenceColumn = "id");
				// addForeignKey(table = "blog_posts", column = "updated_by", referenceTable = "users", referenceColumn = "id");
				// addForeignKey(table = "blog_posts", column = "deleted_by", referenceTable = "users", referenceColumn = "id");
				
				// add foreign key constraint
                addForeignKey(
                    table='tags',
                    column='blog_id',
                    referenceTable='blog_posts',
                    referenceColumn='id'
                );

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
				// drop foreign key constraints using raw SQL
                execute(sql="ALTER TABLE blog_posts DROP CONSTRAINT IF EXISTS fk_blog_posts_status_id");
                execute(sql="ALTER TABLE blog_posts DROP CONSTRAINT IF EXISTS fk_blog_posts_category_id");
                execute(sql="ALTER TABLE blog_posts DROP CONSTRAINT IF EXISTS fk_blog_posts_post_type_id");
                execute(sql="ALTER TABLE blog_posts DROP CONSTRAINT IF EXISTS fk_blog_posts_created_by");
                execute(sql="ALTER TABLE blog_posts DROP CONSTRAINT IF EXISTS fk_blog_posts_updated_by");
                execute(sql="ALTER TABLE blog_posts DROP CONSTRAINT IF EXISTS fk_blog_posts_deleted_by");

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
