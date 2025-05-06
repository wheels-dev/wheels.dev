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
				addRecord(table = 'permissions', name = 'dashboard', controller="AdminController", status=true, description="View Dashboard");
				addRecord(table = 'permissions', name = 'blog', controller="AdminController", status=true, description="View Blogs list");
				addRecord(table = 'permissions', name = 'blogApprove', controller="AdminController", status=true, description="Approve Blog");
				addRecord(table = 'permissions', name = 'rejectBlog', controller="AdminController", status=true, description="Reject Blog");
				addRecord(table = 'permissions', name = 'blogApprove', controller="AdminController", status=true, description="Blog Bulk Approval");
				addRecord(table = 'permissions', name = 'rejectBlog', controller="AdminController", status=true, description="Blog Bulk Rejection");
				addRecord(table = 'permissions', name = 'comments', controller="AdminController", status=true, description="View Comments");
				addRecord(table = 'permissions', name = 'commentsPublish', controller="AdminController", status=true, description="Publish Comment");
				addRecord(table = 'permissions', name = 'unPublishComment', controller="AdminController", status=true, description="Hide Comments");
				addRecord(table = 'permissions', name = 'index', controller="UserController", status=true, description="View User");
				addRecord(table = 'permissions', name = 'addUser', controller="UserController", status=true, description="Add / Edit User");
				addRecord(table = 'permissions', name = 'delete', controller="UserController", status=true, description="Delete User");
				addRecord(table = 'permissions', name = 'index', controller="NewsletterController", status=true, description="View Newsletter dashboard");
				addRecord(table = 'permissions', name = 'send', controller="NewsletterController", status=true, description="Send Newsletter");
				addRecord(table = 'permissions', name = 'export', controller="NewsletterController", status=true, description="Export Newsletter Subscriber List");
				addRecord(table = 'permissions', name = 'unsubscribe', controller="NewsletterController", status=true, description="Unsubscribe Newsletter");
				addRecord(table = 'permissions', name = 'testimonial', controller="testimonialController", status=true, description="View Testimonials");
				addRecord(table = 'permissions', name = 'approve', controller="testimonialController", status=true, description="Approve Testimonial");
				addRecord(table = 'permissions', name = 'reject',  controller="testimonialController", status=true, description="Reject Testimonial");
				addRecord(table = 'permissions', name = 'index', controller="CategoriesController", status=true, description="View Categories");
				addRecord(table = 'permissions', name = 'add',  controller="CategoriesController", status=true, description="Add / Edit Categories");
				addRecord(table = 'permissions', name = 'delete', controller="CategoriesController", status=true, description="Delete categories");
				addRecord(table = 'permissions', name = 'index', controller="RolesController",  status=true, description="View Role");
				addRecord(table = 'permissions', name = 'add', controller="RolesController", status=true, description="Add / Edit Role");
				addRecord(table = 'permissions', name = 'delete', controller="RolesController", status=true, description="Delete Role");

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
