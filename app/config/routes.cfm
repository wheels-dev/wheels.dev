<cfscript>

	// Use this file to add routes to your application and point the root route to a controller action.
	// Don't forget to issue a reload request (e.g. reload=true) after making changes.
	// See https://guides.cfwheels.org/2.5.0/v/3.0.0-snapshot/handling-requests-with-controllers/routing for more info.

	mapper()
		// CLI-Appends-Here

		.namespace("api")
			.namespace("v1")
				.get(name = "get_blog_posts", pattern = "blog", to = "api.BlogController##Index")
				.get(name = "get_blog_post", pattern = "blog/[:id]", to = "api.BlogController##Show")

				.get(name = "get_downloads", pattern = "downloads", to = "api.DownloadsController##Index")
			.end()
		.end()

		.namespace("")
			.get(name = "auth-login", pattern = "login", to = "web.AuthController##Login")
			.get(name = "auth-register", pattern = "register", to = "web.AuthController##Register")
			.get(name = "auth-verify", pattern = "verify", to = "web.AuthController##verify")
			.get(name = "auth-logout", pattern = "logout", to = "web.AuthController##Logout")
			.post(name = "auth-authenticate", pattern = "auth/authenticate", to = "web.AuthController##Authenticate")
			.post(name = "auth-store", pattern = "auth/store", to = "web.AuthController##Store")

			// Routes for user authentication
			.get(name = "forgot", pattern = "user/forgot-password", to = "web.AuthController##reset")
			.get(name = "reset", pattern = "user/reset-password", to = "web.AuthController##forgot")
			.get(name = "profile", pattern = "user/profile", to = "web.AuthController##profile")

			// Admin Controls
			.get(name = "admin-index", pattern = "admin", to = "web.AdminController##index")
			.get(name = "admin-blog", pattern = "admin/blog", to = "web.AdminController##blog")
			.get(name = "admin-show-blog", pattern = "admin/blog/[slug]", to = "web.AdminController##showBlog")
			.get(name = "BlogList", pattern = "admin/blog/list", to = "web.AdminController##BlogList")
			.post(name = "admin-approve", pattern = "admin/approve", to = "web.AdminController##approve")
			.post(name = "admin-reject", pattern = "admin/reject", to = "web.AdminController##reject")

			.get(name = "user-profile", pattern = "admin/user/profile", to = "web.UserController##profile")
			.get(name = "user", pattern = "admin/user", to = "web.UserController##Index")
			.get(name = "loadUsers", pattern = "user/list", to = "web.UserController##loadUsers")
			.get(name = "loadRoles", pattern = "user/loadRoles", to = "web.UserController##loadRoles")
			.get(name = "user-add", pattern = "admin/user/add", to = "web.UserController##addUser")
			.post(name = "user-store", pattern = "user/store", to = "web.UserController##store")
			.get(name="user-delete", pattern="admin/user/delete", to="web.UserController##delete")

			.get(name = "home", pattern = "", to = "web.HomeController##Index")
			// Route for loading features,blogs,guides with HTMX
			.get(name = "loadFeatures", pattern = "home/loadFeatures", to = "web.HomeController##loadFeatures")
			.get(name = "loadBlogs", pattern = "home/loadBlogs", to = "web.HomeController##loadBlogs")
			.get(name = "loadGuides", pattern = "home/loadGuides", to = "web.HomeController##loadGuides")
			.get(name = "api_docs", pattern = "api", to = "web.ApiController##Index")

			.get(name = "blog", pattern = "blog", to = "web.BlogController##Index")
			.get(name = "blogEdit", pattern = "blog/edit/[id]", to = "web.BlogController##Edit")
			
			.get(name = "downloads", pattern = "downloads", to = "web.DownloadsController##Index")

			// New routes for loading categories, statuses, and post types
			.get(name = "loadCategories", pattern = "blog/loadCategories", to = "web.BlogController##loadCategories")
			.get(name = "loadStatuses", pattern = "blog/loadStatuses", to = "web.BlogController##loadStatuses")
			.get(name = "loadPostTypes", pattern = "blog/loadPostTypes", to = "web.BlogController##loadPostTypes")
			.get(name = "Categories", pattern = "blog/Categories", to = "web.BlogController##Categories")
			// .get(name = "blogsCategory", pattern = "blog/[category]/[slug]", to = "web.BlogController##Index")
			.get(name = "blogsFilter", pattern = "blog/[filterType]/[filterValue]", to = "web.BlogController##Index")
			.get(name = "blogs", pattern = "blog/list/[filterType]/[filterValue]", to = "web.BlogController##blogs")
			.get(name = "blogFeed", pattern = "blog/feed", to = "web.BlogController##feed")
			.get(name = "allblogs", pattern = "blog/list", to = "web.BlogController##blogs")

			.get(name = "blog-create", pattern = "blog/create", to = "web.BlogController##create")
			.get(name = "blog-detail", pattern = "blog/[slug]", to = "web.BlogController##show")			
			
			.post(name = "blog-store", pattern = "blog/store", to = "web.BlogController##store")
			.post(name = "blog-comment", pattern = "blog/comment", to = "web.BlogController##comment")
			.post(name = "check-title", pattern = "blog/check-title", to = "web.BlogController##checkTitle")

			.get(name = "user-changePassword", pattern = "user/change-password", to = "web.userController##changePassword")
			.post(name = "user-updatePassword", pattern = "user/update-Password", to = "web.userController##updatePassword")
			.get(name = "user-update-profile-pic", pattern = "user/update-profile-pic", to = "web.userController##updateProfilePic")
			.post(name = "user-upload-profile-pic", pattern = "user/upload-profile-pic", to = "web.userController##uploadProfilePic")
		
			// Testimonial-specific routes
			.get(name="check_testimonial", pattern="testimonials/check", to="web.testimonials##check")
			.get(name="approve_testimonial", pattern="testimonials/approve/[key]", to="web.testimonials##approve")
			.get(name="feature_testimonial", pattern="testimonials/feature/[key]", to="web.testimonials##feature")
			.get(name="delete_testimonial", pattern="testimonials/delete/[key]", to="web.testimonials##delete")

			// routes for testimonials
			.resources("web.testimonial")
		.end()
			
		.namespace("")
			.get(name="loadMoreFunctions", pattern="api/*[version]/functions", to="web.ApiController##loadMoreFunctions")
			.get(name="loadFunctionBySlug", pattern="api/*[version]/function", to="web.ApiController##loadFunctionBySlug")
			.get(name="loadFunctionsBySection", pattern="api/*[version]/functions/section", to="web.ApiController##loadFunctionsBySection")
			.get(name="loadFunctionsBySectionAndCategory", pattern="api/*[version]/functions/sectionCategory", to="web.ApiController##loadFunctionsBySectionAndCategory")
			.get(name="docFunction", pattern="api/*[version]/*[slug]/.[format]", to="web.ApiController##show")
			.get(name="docFunction", pattern="api/*[version]/*[slug]/", to="web.ApiController##show")
			.get(name="docVersion", pattern="api/*[version]/", to="web.ApiController##index")
		.end()

		// The "wildcard" call below enables automatic mapping of "controller/action" type routes.
		// This way you don't need to explicitly add a route every time you create a new action in a controller.
		.wildcard()

		// The root route below is the one that will be called on your application's home page (e.g. http://127.0.0.1/).
		//.root(to = "home##index", method = "get")
		.root(method = "get")
	.end();
</cfscript>
