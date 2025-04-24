component extends="wheels.migrator.Migration" hint="creates testimonials table and adds testimonial flag to users" {

    function up() {
        transaction {
            try {
                // Add has_testimonial column to users table
                addColumn(
                    table = "users",
                    columnType = "boolean",
                    columnName = "has_testimonial",
                    default = false,
                    null = false
                );
                
                // Create testimonials table
                t = createTable(name = 'testimonials', force=false, id=true, primaryKey='id');
                t.integer(columnNames='user_id', null=false);
                t.string(columnNames='company_name', null=false, default='', limit=255);
                t.string(columnNames='logo_path', null=true, limit=255);
                t.string(columnNames='experience_level', null=false, default='Beginner', limit=50);
                t.text(columnNames='testimonial_text', null=false);
                t.integer(columnNames='rating', null=false, default=0);
                t.boolean(columnNames='display_permission', null=false, default=false);
                t.string(columnNames='social_media_links', null=true, limit=500);
                t.string(columnNames='website_url', null=true, limit=255);
                t.boolean(columnNames='is_featured', null=false, default=false);
                t.boolean(columnNames='is_approved', null=false, default=false);
                t.string(columnNames='status', null=false, default="Pending", limit=10);
                t.timestamps();
                t.create();
                
                // Add unique index on user_id
                addIndex(
                    table = "testimonials",
                    columnNames = "user_id",
                    unique = true
                );
                
                // Add foreign key constraint
                addForeignKey(
                    table = 'testimonials',
                    column = 'user_id',
                    referenceTable = 'users',
                    referenceColumn = 'id'
                );

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
                // Drop foreign key constraints using raw SQL
                execute(sql="ALTER TABLE testimonials DROP CONSTRAINT IF EXISTS fk_testimonials_user_id");
                
                // Drop testimonials table
                dropTable(name = 'testimonials');
                
                // Remove has_testimonial column from users table
                removeColumn(table="users", columnName="has_testimonial");
                
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