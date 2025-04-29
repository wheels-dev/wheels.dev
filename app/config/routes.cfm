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
			.get(name = "forgot-password", pattern = "auth/forgot-password", to = "web.AuthController##forgotPassword")
			.post(name = "send-reset-link", pattern = "auth/send-reset-link", to = "web.AuthController##sendResetLink")
			.get(name = "reset-password", pattern = "auth/reset-password/[token]", to = "web.AuthController##resetPassword")
			.post(name = "update-password", pattern = "auth/update-password", to = "web.AuthController##updatePassword")
			.get(name = "profile", pattern = "user/profile", to = "web.AuthController##profile")

			// Admin Controls
			// .get(name = "admin-index", pattern = "admin", to = "admin.AdminController##index")
			.get(name = "admin-blog", pattern = "admin/blog", to = "admin.AdminController##blog")
			.get(name = "admin-comment", pattern = "admin/comment", to = "admin.AdminController##comments")
			.get(name = "admin-show-blog", pattern = "admin/blog/[slug]", to = "admin.AdminController##showBlog")
			.get(name = "blog-List", pattern = "admin/blog/list", to = "admin.AdminController##blogList")
			.post(name = "admin-approve", pattern = "admin/approve", to = "admin.AdminController##approve")
			.post(name = "admin-reject", pattern = "admin/reject", to = "admin.AdminController##reject")
			.post(name = "admin-comment-publish", pattern = "admin/publish", to = "admin.AdminController##publish")
			.post(name = "admin-comment-unpublish", pattern = "admin/hide", to = "admin.AdminController##unpublish")
			.get(name="admin-dashboard", pattern="admin", to="admin.AdminController##dashboard")

			.get(name = "user-profile", pattern = "admin/user/profile", to = "admin.UserController##profile")
			.get(name = "user", pattern = "admin/user", to = "admin.UserController##Index")
			.get(name = "loadUsers", pattern = "user/list", to = "admin.UserController##loadUsers")
			.get(name = "loadRoles", pattern = "user/loadRoles", to = "admin.UserController##loadRoles")
			.get(name = "user-add", pattern = "admin/user/add", to = "admin.UserController##addUser")
			.get(name = "user-add", pattern = "admin/user/edit/[id]", to = "admin.UserController##addUser")
			.post(name = "user-store", pattern = "user/store", to = "admin.UserController##store")
			.get(name="user-delete", pattern="admin/user/delete", to="admin.UserController##delete")

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

			.get(name = "user-changePassword", pattern = "user/change-password", to = "admin.UserController##changePassword")
			.post(name = "user-updatePassword", pattern = "user/update-Password", to = "admin.UserController##updatePassword")
			.get(name = "user-update-profile-pic", pattern = "user/update-profile-pic", to = "admin.UserController##updateProfilePic")
			.post(name = "user-upload-profile-pic", pattern = "user/upload-profile-pic", to = "admin.UserController##uploadProfilePic")
		
			// Testimonial-specific routes
			.get(name="check_testimonial", pattern="testimonial/check", to="web.testimonials##check")
			.get(name="approve_testimonial", pattern="testimonial/approve/[key]", to="web.testimonials##approve")
			.get(name="feature_testimonial", pattern="testimonial/feature/[key]", to="web.testimonials##feature")
			.get(name="delete_testimonial", pattern="testimonial/delete/[key]", to="web.testimonials##delete")
			.get(name="admin-testimonial", pattern="admin/testimonial", to="admin.testimonialController##testimonials")
			.get(name = "admin-view-testimonials", pattern = "admin/testimonials/view/[id]", to = "admin.testimonialController##testimonialDetails")
			.post(name = "admin-approve-testimonials", pattern = "admin/testimonials/approve", to = "admin.testimonialController##approve")
			.post(name = "admin-reject-testimonials", pattern = "admin/testimonials/reject", to = "admin.testimonialController##reject")
			
			.post(name="clear_testimonial_prompt", pattern="testimonial/clear-prompt", to="web.Testimonial##clearPromptFlag") // Use POST to indicate an action

			// routes for categories
			.get(name = "admin-category", pattern = "admin/category", to = "admin.categoriesController##index")
			.get(name = "admin-add-category", pattern = "admin/category/add", to = "admin.categoriesController##add")
			.post(name = "admin-edit-category", pattern = "admin/category/save", to = "admin.categoriesController##store")
			.post(name = "admin-edit-category", pattern = "admin/category/edit", to = "admin.categoriesController##add")
			.post(name = "admin-delete-category", pattern = "admin/category/delete", to = "admin.categoriesController##delete")
			.get(name = "admin-load-category", pattern = "admin/loadCategories", to = "admin.categoriesController##loadCategories")

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
