<cfscript>

	// Use this file to add routes to your application and point the root route to a controller action.
	// Don't forget to issue a reload request (e.g. reload=true) after making changes.
	// See https://guides.cfwheels.org/2.5.0/v/3.0.0-snapshot/handling-requests-with-controllers/routing for more info.

	mapper()
		// CLI-Appends-Here

		.namespace("api")
			.namespace("v1")
				.get(name = "get_blog_posts", pattern = "blog", to = "api.BlogController##Index")
				.get(name = "get_blog_post", pattern = "blog/:id", to = "api.BlogController##Show")

				.get(name = "get_downloads", pattern = "downloads", to = "api.DownloadsController##Index")
			.end()
		.end()

		.namespace("")
			.get(name = "auth-login", pattern = "login", to = "web.AuthController##Login")
			.post(name = "auth-authenticate", pattern = "auth/authenticate", to = "web.AuthController##Authenticate")

			// Routes for user authentication
			.get(name = "login", pattern = "user/login", to = "web.AuthController##login")
			.get(name = "register", pattern = "user/register", to = "web.AuthController##register")
			.get(name = "forgot", pattern = "user/forgot-password", to = "web.AuthController##reset")
			.get(name = "reset", pattern = "user/reset-password", to = "web.AuthController##forgot")
			.get(name = "profile", pattern = "user/profile", to = "web.AuthController##profile")

			.get(name = "home", pattern = "home", to = "web.HomeController##Index")
			// Route for loading features,blogs,guides with HTMX
			.get(name = "loadFeatures", pattern = "home/loadFeatures", to = "web.HomeController##loadFeatures")
			.get(name = "loadBlogs", pattern = "home/loadBlogs", to = "web.HomeController##loadBlogs")
			.get(name = "loadGuides", pattern = "home/loadGuides", to = "web.HomeController##loadGuides")

			.get(name = "blog", pattern = "blog", to = "web.BlogController##Index")
			.get(name = "downloads", pattern = "downloads", to = "web.DownloadsController##Index")

			// New routes for loading categories, statuses, and post types
			.get(name = "loadCategories", pattern = "blog/loadCategories", to = "web.BlogController##loadCategories")
			.get(name = "loadStatuses", pattern = "blog/loadStatuses", to = "web.BlogController##loadStatuses")
			.get(name = "loadPostTypes", pattern = "blog/loadPostTypes", to = "web.BlogController##loadPostTypes")
			
			.get(name = "blog-create", pattern = "blog/create", to = "web.BlogController##create")
			.get(name = "blog-detail", pattern = "blog/[id]", to = "web.BlogController##show")
			// .get(name = "blog-detail", pattern = "[slug]", to = "web.BlogController##show")			
			
			.post(name = "blog-store", pattern = "blog/store", to = "web.BlogController##store")
		.end()

		// The "wildcard" call below enables automatic mapping of "controller/action" type routes.
		// This way you don't need to explicitly add a route every time you create a new action in a controller.
		.wildcard()

		// The root route below is the one that will be called on your application's home page (e.g. http://127.0.0.1/).
		//.root(to = "home##index", method = "get")
		.root(method = "get")
	.end();
</cfscript>
