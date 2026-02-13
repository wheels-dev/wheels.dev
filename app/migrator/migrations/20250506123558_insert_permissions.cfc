/*
  |-------------------------------------------------------------------------------------------|
	| Parameter     | Required | Type    | Default | Description                                |
  |-------------------------------------------------------------------------------------------|
	| table         | Yes      | string  |         | Name of table to add record to             |
	| columnNames   | Yes      | string  |         | Use column name as argument name and value |
  |-------------------------------------------------------------------------------------------|

    EXAMPLE:
      addRecord(table='members',id=1,username='admin',password='#Hash("admin")#');
*/
component extends="wheels.migrator.Migration" hint="insert permissions" {

	function up() {
		transaction {
			try {
				// Use execute() because addRecord converts booleans to integers which CockroachDB rejects
				execute("INSERT INTO permissions (name, controller, status, description, createdat, updatedat) VALUES ('dashboard', 'AdminController', true, 'View Dashboard', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)");
				execute("INSERT INTO permissions (name, controller, status, description, createdat, updatedat) VALUES ('blog', 'AdminController', true, 'View Blogs list', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)");
				execute("INSERT INTO permissions (name, controller, status, description, createdat, updatedat) VALUES ('blogApprove', 'AdminController', true, 'Approve Blog', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)");
				execute("INSERT INTO permissions (name, controller, status, description, createdat, updatedat) VALUES ('rejectBlog', 'AdminController', true, 'Reject Blog', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)");
				execute("INSERT INTO permissions (name, controller, status, description, createdat, updatedat) VALUES ('blogApprove', 'AdminController', true, 'Blog Bulk Approval', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)");
				execute("INSERT INTO permissions (name, controller, status, description, createdat, updatedat) VALUES ('rejectBlog', 'AdminController', true, 'Blog Bulk Rejection', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)");
				execute("INSERT INTO permissions (name, controller, status, description, createdat, updatedat) VALUES ('comments', 'AdminController', true, 'View Comments', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)");
				execute("INSERT INTO permissions (name, controller, status, description, createdat, updatedat) VALUES ('commentsPublish', 'AdminController', true, 'Publish Comment', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)");
				execute("INSERT INTO permissions (name, controller, status, description, createdat, updatedat) VALUES ('unPublishComment', 'AdminController', true, 'Hide Comments', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)");
				execute("INSERT INTO permissions (name, controller, status, description, createdat, updatedat) VALUES ('index', 'UserController', true, 'View User', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)");
				execute("INSERT INTO permissions (name, controller, status, description, createdat, updatedat) VALUES ('addUser', 'UserController', true, 'Add / Edit User', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)");
				execute("INSERT INTO permissions (name, controller, status, description, createdat, updatedat) VALUES ('delete', 'UserController', true, 'Delete User', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)");
				execute("INSERT INTO permissions (name, controller, status, description, createdat, updatedat) VALUES ('index', 'NewsletterController', true, 'View Newsletter dashboard', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)");
				execute("INSERT INTO permissions (name, controller, status, description, createdat, updatedat) VALUES ('send', 'NewsletterController', true, 'Send Newsletter', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)");
				execute("INSERT INTO permissions (name, controller, status, description, createdat, updatedat) VALUES ('export', 'NewsletterController', true, 'Export Newsletter Subscriber List', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)");
				execute("INSERT INTO permissions (name, controller, status, description, createdat, updatedat) VALUES ('unsubscribe', 'NewsletterController', true, 'Unsubscribe Newsletter', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)");
				execute("INSERT INTO permissions (name, controller, status, description, createdat, updatedat) VALUES ('testimonial', 'testimonialController', true, 'View Testimonials', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)");
				execute("INSERT INTO permissions (name, controller, status, description, createdat, updatedat) VALUES ('approve', 'testimonialController', true, 'Approve Testimonial', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)");
				execute("INSERT INTO permissions (name, controller, status, description, createdat, updatedat) VALUES ('reject', 'testimonialController', true, 'Reject Testimonial', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)");
				execute("INSERT INTO permissions (name, controller, status, description, createdat, updatedat) VALUES ('index', 'CategoriesController', true, 'View Categories', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)");
				execute("INSERT INTO permissions (name, controller, status, description, createdat, updatedat) VALUES ('add', 'CategoriesController', true, 'Add / Edit Categories', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)");
				execute("INSERT INTO permissions (name, controller, status, description, createdat, updatedat) VALUES ('delete', 'CategoriesController', true, 'Delete categories', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)");
				execute("INSERT INTO permissions (name, controller, status, description, createdat, updatedat) VALUES ('index', 'RolesController', true, 'View Role', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)");
				execute("INSERT INTO permissions (name, controller, status, description, createdat, updatedat) VALUES ('add', 'RolesController', true, 'Add / Edit Role', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)");
				execute("INSERT INTO permissions (name, controller, status, description, createdat, updatedat) VALUES ('delete', 'RolesController', true, 'Delete Role', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)");

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
