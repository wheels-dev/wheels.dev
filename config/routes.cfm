<cfscript>

	// Use this file to add routes to your application and point the root route to a controller action.
	// Don't forget to issue a reload request (e.g. reload=true) after making changes.
	// See https://wheels.dev/3.0.0/guides/handling-requests-with-controllers/routing for more info.

	mapper()
		// CLI-Appends-Here

		.namespace("api")
			.namespace("v1")
				.get(name = "get_blog_posts", pattern = "blog", to = "api.BlogController##Index")
				.get(name = "get_blog_post", pattern = "blog/[:id]", to = "api.BlogController##Show")

				.get(name = "get_downloads", pattern = "downloads", to = "api.DownloadsController##Index")
				.get(name = "check_email", pattern = "auth/check-email", to = "AuthController##checkEmail")
			.end()
		.end()

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

			.get(name = "home", pattern = "", to = "web.HomeController##Index")
			// Route for loading features,blogs,guides with HTMX
			.get(name = "loadFeatures", pattern = "home/loadFeatures", to = "web.HomeController##loadFeatures")
			.get(name = "loadBlogs", pattern = "home/loadBlogs", to = "web.HomeController##loadBlogs")
			.get(name = "loadGuides", pattern = "home/loadGuides", to = "web.HomeController##loadGuides")
			.get(name = "api_docs", pattern = "api", to = "web.ApiController##Index")

			.get(name = "blog", pattern = "blog", to = "web.BlogController##Index")
			.get(name = "blogEdit", pattern = "blog/edit/[id]", to = "web.BlogController##Edit")
			
			.get(name = "downloads", pattern = "downloads", to = "web.HomeController##downloads")

			// New routes for loading categories, statuses, and post types
			.get(name = "blog-Search", pattern = "blog/Search", to = "web.BlogController##blogSearch")
			.get(name = "loadCategories", pattern = "blog/loadCategories", to = "web.BlogController##loadCategories")
			.get(name = "loadStatuses", pattern = "blog/loadStatuses", to = "web.BlogController##loadStatuses")
			.get(name = "loadPostTypes", pattern = "blog/loadPostTypes", to = "web.BlogController##loadPostTypes")

			.get(name = "reading-history-search", pattern = "reading-history/search", to = "web.ReadingHistoryController##search")
			.get(name = "reading-history-list", pattern = "reading-history/list", to = "web.ReadingHistoryController##list")
			.get(name = "bookmarks-search", pattern = "bookmarks/search", to = "web.BookmarkController##search")
			.get(name = "Categories", pattern = "blog/Categories", to = "web.BlogController##Categories")
			// .get(name = "blogsCategory", pattern = "blog/[category]/[slug]", to = "web.BlogController##Index")
			.get(name = "blogsFilter", pattern = "blog/[filterType]/[filterValue]", to = "web.BlogController##Index")
			.get(name = "blogs", pattern = "blog/list/[filterType]/[filterValue]", to = "web.BlogController##blogs")
			.get(name = "blogFeed", pattern = "blog/feed", to = "web.BlogController##feed")
			.get(name = "commentFeed", pattern = "comment/feed", to = "web.BlogController##commentsFeed")
			.get(name = "allblogs", pattern = "blog/list", to = "web.BlogController##blogs")

			.get(name = "blog-create", pattern = "blog/create", to = "web.BlogController##create")
			.get(name = "blog-detail", pattern = "blog/[slug]", to = "web.BlogController##show")
			
			.post(name = "blog-store", pattern = "blog/store", to = "web.BlogController##store")
			.post(name = "blog-unpublish", pattern = "blog/unpublish", to = "web.BlogController##unpublish")
			.post(name = "blog-comment", pattern = "blog/comment", to = "web.BlogController##comment")
			.post(name = "check-title", pattern = "blog/check-title", to = "web.BlogController##checkTitle")
			.put(name = "blogUpdate", pattern = "blog/update/[id]", to = "web.BlogController##Update")

			.get(name="new-testimonial", pattern="testimonial/new", to="web.TestimonialController##new")
			.post(name="create-testimonial", pattern="testimonial/create", to="web.TestimonialController##create")

			.post(name="clear_testimonial_prompt", pattern="testimonial/clear-prompt", to="web.Testimonial##clearPromptFlag") // Use POST to indicate an action

			// route for docs
			.get(name = "docs", pattern = "docs", to="web.docsController##index")

			// route for community
			.get(name = "community", pattern = "community", to="web.communityController##index")

			// route for news
			.get(name = "news", pattern = "news", to="web.newsController##index")

			// Newsletter Routes
			.post(name="newsletter-subscribe", pattern="newsletter/subscribe", to="web.NewsletterController##subscribe")
			.get(name="newsletter-verify", pattern="newsletter/verify/[token]", to="web.NewsletterController##verify")
			.post(name="newsletter-unsubscribe", pattern="newsletter/unsubscribe", to="web.NewsletterController##unsubscribe")
			
			// Reading History
			.get(name="readingHistory", pattern="reading-history", to="web.ReadingHistoryController##index")
			.post(name="trackReading", pattern="reading-history/track", to="web.ReadingHistoryController##track")
			.post(name="completeReading", pattern="reading-history/complete", to="web.ReadingHistoryController##complete")
			.delete(name="clearHistory", pattern="reading-history/clear", to="web.ReadingHistoryController##clear")

			// Bookmarks
			.get(name="bookmarks", pattern="bookmarks", to="web.BookmarkController##index")
			.post(name="toggleBookmark", pattern="bookmark/toggle", to="web.BookmarkController##toggle")
			
			// route for function docs
			.get(name="loadMoreFunctions", pattern="api/*[version]/functions", to="web.ApiController##loadMoreFunctions")
			.get(name="loadFunctionBySlug", pattern="api/*[version]/function", to="web.ApiController##loadFunctionBySlug")
			.get(name="loadFunctionsBySection", pattern="api/*[version]/functions/section", to="web.ApiController##loadFunctionsBySection")
			.get(name="loadFunctionsBySectionAndCategory", pattern="api/*[version]/functions/sectionCategory", to="web.ApiController##loadFunctionsBySectionAndCategory")
			.get(name="docFunction", pattern="api/*[version]/*[slug]/.[format]", to="web.ApiController##show")
			.get(name="docVersion", pattern="api/*[version]/", to="web.ApiController##index")

			// SEO Routes
			.get(name="sitemap", pattern="generate-sitemap", to="web.HomeController##sitemap")

			// error routes
			.get(name = "error403", pattern = "error403", to = "errorController##error403")
			.get(name = "error404", pattern = "error404", to = "errorController##error404")
			.get(name = "error500", pattern = "error500", to = "errorController##error500")

			// guides
			.get(name = "load-Guides", pattern = "/guides", to = "web.GuideController##index")
			.get(name = "load-Guides-WRT-version", pattern = "*[version]/guides", to = "web.GuideController##index")
			.get(name = "load-guide-search-index", pattern = "*[version]/guides/search-book", to = "web.GuideController##getSearchBook")
			.get(name = "generate-search-guide", pattern = "guides/generate-search", to = "web.GuideController##generateSearchBook")
			.get(name = "load-guide-docs", pattern = "/guides/*[path]", to = "web.GuideController##loadGuideDocs")
			.get(name = "load-guide-docs-WRT-version", pattern = "*[version]/guides/*[path]", to = "web.GuideController##loadGuideDocs")
		.namespace("admin")
			// Admin Controls
			.get(name = "dashboard", pattern="/", to="AdminController##dashboard")

			// FeatureController routes
			.get(name = "feature", pattern = "feature", to = "FeatureController##index")
			.get(name = "addFeature", pattern = "feature/add", to = "FeatureController##addFeature")
			.get(name = "editFeature", pattern = "feature/edit/[id]", to = "FeatureController##addFeature")
			.post(name = "storeFeature", pattern = "feature/store", to = "FeatureController##store")
			.delete(name = "deleteFeature", pattern = "feature/delete/[id]", to = "FeatureController##delete")
			.get(name = "blog", pattern = "blog", to = "AdminController##blog")
			.get(name = "blogEdit", pattern = "blog/edit/[id]", to = "AdminController##editBlog")
			.post(name = "blogDelete", pattern = "blog/delete", to = "AdminController##deleteBlog")
			.put(name = "blog-update", pattern = "blog/blogUpdate/[id]", to = "AdminController##update")
			.get(name = "comment", pattern = "comment", to = "AdminController##comments")
			.get(name = "show-blog", pattern = "blog/[slug]", to = "AdminController##showBlog")
			.get(name = "blog-List", pattern = "blog/list", to = "AdminController##blogList")
			.post(name = "blog-approve", pattern = "approve", to = "AdminController##blogApprove")
			.post(name = "bulk-approve", pattern = "bulkApprove", to = "AdminController##blogBulkApprove")
			.post(name = "blog-reject", pattern = "reject", to = "AdminController##rejectBlog")
			.post(name = "bulk-reject", pattern = "bulkReject", to = "AdminController##blogBulkReject")
			.post(name = "comment-publish", pattern = "publish", to = "AdminController##commentsPublish")
			.post(name = "comment-unpublish", pattern = "hide", to = "AdminController##unpublishComment")
			.get(name = "view-comment", pattern = "commentDetails/[id]", to = "AdminController##viewComments")
			.get(name = "close-comments", pattern = "closeComments/[id]", to = "AdminController##closeComments")
			.get(name = "publish-blog", pattern = "publishblog/[id]", to = "AdminController##publishblog")
			.get(name = "import-data", pattern="import-data", to="AdminController##importData")

			// Admin Newsletter Routes
			.get(name="newsletter", pattern="newsletter", to="NewsletterController##index")
			.post(name="newsletter-send", pattern="newsletter/send", to="NewsletterController##send")
			.post(name="newsletter-unsubscribe", pattern="newsletter/unsubscribe", to="NewsletterController##unsubscribe")
			.get(name="newsletter-filter", pattern="newsletter/filterByType", to="NewsletterController##filterByType")
			.get(name="newsletter-search", pattern="newsletter/search", to="NewsletterController##search")
			.get(name="newsletter-export", pattern="newsletter/export", to="NewsletterController##export")

			.get(name="testimonial", pattern="testimonial", to="TestimonialController##testimonials")
			.get(name = "view-testimonials", pattern = "testimonials/view/[id]", to = "TestimonialController##testimonialDetails")
			.get(name = "Featured-testimonial", pattern = "featuredTestimonial/[id]", to = "TestimonialController##featuredTestimonial")
			.post(name = "approve-testimonials", pattern = "testimonials/approve", to = "TestimonialController##approve")
			.post(name = "reject-testimonials", pattern = "testimonials/reject", to = "TestimonialController##reject")

			// routes for categories
			.get(name = "category", pattern = "category", to = "categoriesController##index")
			.get(name = "add-category", pattern = "category/add", to = "categoriesController##add")
			.post(name = "save-category", pattern = "category/save", to = "categoriesController##store")
			.post(name = "edit-category", pattern = "category/edit", to = "categoriesController##add")
			.post(name = "delete-category", pattern = "category/delete", to = "categoriesController##delete")
			.get(name = "load-category", pattern = "loadCategories", to = "categoriesController##loadCategories")
			
			// route for admin roles
			.get(name = "roles", pattern = "role", to = "rolesController##index")
			.get(name = "add-role", pattern = "role/add", to = "rolesController##add")
			.post(name = "save-role", pattern = "role/save", to = "rolesController##store")
			.post(name = "edit-role", pattern = "role/edit", to = "rolesController##add")
			.post(name = "delete-role", pattern = "role/delete", to = "rolesController##delete")
			.post(name = "role-exist", pattern = "role/exist", to = "rolesController##checkRoleExistance")
			.get(name = "load-role", pattern = "loadRole", to = "rolesController##loadRoles")
			
			.get(name = "user-profile", pattern = "user/profile", to = "UserController##profile")
			.get(name = "user", pattern = "user", to = "UserController##index")
			.get(name = "loadUsers", pattern = "user/list", to = "UserController##loadUsers")
			.get(name = "loadRoles", pattern = "user/loadRoles", to = "UserController##loadRoles")
			.get(name = "user-add", pattern = "user/add", to = "UserController##addUser")
			.get(name = "user-add", pattern = "user/edit/[id]", to = "UserController##addUser")
			.post(name = "user-store", pattern = "user/store", to = "UserController##store")
			.delete(name = "user-delete", pattern= "user/delete/[obfuscatedId]", to="UserController##delete")
			.post(name = "user-unlock", pattern = "user/unlockUser/[obfuscatedId]", to = "UserController##unlockUser")
			.post(name = "user-toggle-lock", pattern = "user/toggleLock/[obfuscatedId]", to = "UserController##toggleUserLock")

			.get(name = "user-changePassword", pattern = "user/change-password", to = "UserController##changePassword")
			.post(name = "user-updatePassword", pattern = "user/update-Password", to = "UserController##updatePassword")
			.get(name = "user-update-profile-pic", pattern = "user/update-profile-pic", to = "UserController##updateProfilePic")
			.post(name = "user-upload-profile-pic", pattern = "user/upload-profile-pic", to = "UserController##uploadProfilePic")
		

			// settings routes
			.get(name="settings", pattern="settings", to="SettingsController##index")
			.get(name="email-templates", pattern="email-content", to="EmailTemplatesController##index")
			.get(name="email-view", pattern="email/edit/[id]", to="EmailTemplatesController##edit")
			.get(name="email-edit", pattern="email/view/[id]", to="EmailTemplatesController##view")
			.post(name="email-save", pattern="email/save", to="EmailTemplatesController##save")
			.post(name="testimonial-settings", pattern="settings/enableTestimonials", to="SettingsController##enableTestimonials")
			.post(name="updateSlackInvite", pattern="settings/updateSlackInvite", to="SettingsController##updateSlackInvite")
			.post(name="updateContributorApi", pattern="settings/updateContributorApi", to="SettingsController##updateContributorApi")
			.get(name="get-contributors", pattern="contributors", to="SettingsController##contributors")
			.get(name="sync-contributors", pattern="sync/contributors", to="SettingsController##syncContributors")
			.post(name="edit-contributors", pattern="edit/contributors", to="SettingsController##editContributors")
			.post(name="store-contributors", pattern="store/contributors", to="SettingsController##storeContributors")
			.post(name="delete-contributors", pattern="delete/contributors", to="SettingsController##deleteContributors")
		.end()


		// The root route below is the one that will be called on your application's home page (e.g. http://127.0.0.1/).
		//.root(to = "home##index", method = "get")
		.root(method = "get")
	.end();
</cfscript>
