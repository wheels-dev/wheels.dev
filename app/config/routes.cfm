<cfscript>

	// Use this file to add routes to your application and point the root route to a controller action.
	// Don't forget to issue a reload request (e.g. reload=true) after making changes.
	// See https://guides.cfwheels.org/2.5.0/v/3.0.0-snapshot/handling-requests-with-controllers/routing for more info.

	mapper()
		// CLI-Appends-Here

		.namespace("api")
			.namespace("v1")
				.post(name = "", pattern = "", to = "##")
				
				.get(name = "", pattern = "", to = "##")
			.end()
		.end()

		.namespace("")
			.get(name = "home", pattern = "", to = "web.HomeController##Index")
			.get(name = "guides", pattern = "guides", to = "web.GuidesController##Index")
			.get(name = "api_docs", pattern = "api", to = "web.ApiController##Index")
			.get(name = "blog", pattern = "blog", to = "web.BlogController##Index")
			.get(name = "downloads", pattern = "downloads", to = "web.DownloadsController##Index")
		.end()

		// The "wildcard" call below enables automatic mapping of "controller/action" type routes.
		// This way you don't need to explicitly add a route every time you create a new action in a controller.
		.wildcard()

		// The root route below is the one that will be called on your application's home page (e.g. http://127.0.0.1/).
		//.root(to = "home##index", method = "get")
		.root(method = "get")
	.end();
</cfscript>
