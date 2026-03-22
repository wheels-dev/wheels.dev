// Frontend blog page
component extends="app.Controllers.Controller" {

	// Configuration function
	function config() {
		super.config();
		verifies(
			except = "index,create,store,show,update,destroy,loadCategories,loadStatuses,loadPostTypes,Categories,blogs,comment,feed,error,checkTitle,edit,update,AuthorProfileBlogs,blogSearch,commentsFeed,unpublish,myPosts",
			params = "key",
			paramsTypes = "integer",
			handler = "index"
		);
		filters(through = "restrictAccess", only = "create,store,comment,edit,update,myPosts");
		usesLayout("/layout");
	}

	// Function to list all blogs
	public void function index() {
		isEditor = hasEditorAccess();
	}

	public void function myPosts() {
		var userId = getSignedInUserId();
		var validStatuses = "all,draft,published,pending";
		statusFilter = (StructKeyExists(params, "status") && ListFindNoCase(validStatuses, params.status))
		 ? params.status
		 : "all";

		// Expose statuses to view (controller methods aren't available in views)
		statuses = blogStatuses();

		var statusCountsQuery = model("Blog").findAll(
			select = "statusId, COUNT(*) as cnt",
			where = "createdBy = #userId# AND blog_posts.statusId <> #statuses.TRASH#",
			group = "statusId",
			returnAs = "query"
		);

		statusCounts = {"all" = 0, "draft" = 0, "published" = 0, "pending" = 0};
		for (var row in statusCountsQuery) {
			statusCounts.all += row.cnt;
			if (row.statusId == statuses.DRAFT) statusCounts.draft = row.cnt;
			else if (row.statusId == statuses.POSTED) statusCounts.published = row.cnt;
			else if (row.statusId == statuses.PENDING_REVIEW) statusCounts.pending = row.cnt;
		}

		var where = "createdBy = #userId# AND blog_posts.statusId <> #statuses.TRASH#";
		if (statusFilter == "draft") {
			where &= " AND blog_posts.statusId = #statuses.DRAFT#";
		} else if (statusFilter == "published") {
			where &= " AND blog_posts.statusId = #statuses.POSTED#";
		} else if (statusFilter == "pending") {
			where &= " AND blog_posts.statusId = #statuses.PENDING_REVIEW#";
		}

		myBlogs = model("Blog").findAll(
			select = "id, title, slug, statusId, createdAt, publishedAt, updatedAt",
			where = where,
			order = "updatedAt DESC"
		);
	}

	public void function blogs() {
		// Initialize default values and sanitize inputs
		filterType = sanitizeParam(StructKeyExists(params, "filterType") ? params.filterType : "", "");
		filterValue = sanitizeParam(StructKeyExists(params, "filterValue") ? params.filterValue : "", "");
		page = StructKeyExists(params, "page") ? Max(1, Val(sanitizeParam(params.page, 1))) : 1;
		perPage = StructKeyExists(params, "perPage") ? Max(1, Min(24, Val(sanitizeParam(params.perPage, 6)))) : 6;
		isInfiniteScroll = StructKeyExists(params, "infiniteScroll") ? params.infiniteScroll : false;
		userId = getSignedInUserId();

		try {
			var result = getBlogData(filterType, filterValue, page, perPage, isInfiniteScroll);

			if (result.query.recordCount == 0) {
				// Show fallback blogs
				var fallback = getBlogData("", "", 1, perPage, isInfiniteScroll);
				blogs = fallback.query;
				isFallback = true;
			} else {
				blogs = result.query;
				isFallback = false;
			}
			// Set template variables
			hasMore = result.hasMore;
			totalCount = result.totalCount;

			// Set author info if filtering by author
			if (StructKeyExists(result, "author")) {
				author = result.author;
			}

			renderPartial(partial = "partials/blogList");
		} catch (any e) {
			handleBlogError(e, userId, page, perPage, isInfiniteScroll);
		}
	}

	// Helper function to sanitize parameters
	private string function sanitizeParam(param, defaultValue) {
		if (!StructKeyExists(arguments, "param") || !Len(Trim(arguments.param))) {
			return arguments.defaultValue;
		}
		return Trim(arguments.param);
	}

	// Main data retrieval logic
	private struct function getBlogData(filterType, filterValue, page, perPage, isInfiniteScroll) {
		var result = {};

		// Handle special cases first
		if (Len(arguments.filterType) && Len(arguments.filterValue)) {
			// Normalize filter value (convert hyphens to dots)
			arguments.filterValue = Replace(arguments.filterValue, "-", ".", "all");

			// Handle date archive filtering (year/month)
			if (IsNumeric(arguments.filterType) && IsNumeric(arguments.filterValue)) {
				return getBlogsByMonthYear(
					arguments.filterType,
					arguments.filterValue,
					arguments.page,
					arguments.perPage,
					arguments.isInfiniteScroll
				);
			}

			// Handle content filtering
			switch (LCase(arguments.filterType)) {
				case "category":
					return getBlogsByCategory(
						arguments.filterValue,
						arguments.page,
						arguments.perPage,
						arguments.isInfiniteScroll
					);
				case "tag":
					return getAllByTag(arguments.filterValue, arguments.page, arguments.perPage, arguments.isInfiniteScroll);
				case "author":
					return getBlogsWithAuthorData(
						arguments.filterValue,
						arguments.page,
						arguments.perPage,
						arguments.isInfiniteScroll
					);
				default:
					// Invalid filter type, fallback to all blogs
					logInvalidFilter(arguments.filterType, arguments.filterValue);
					return getAllBlogs(arguments.page, arguments.perPage, arguments.isInfiniteScroll);
			}
		}

		// Default: return all blogs
		return getAllBlogs(arguments.page, arguments.perPage, arguments.isInfiniteScroll);
	}

	// Optimized author blog retrieval with author data
	private struct function getBlogsWithAuthorData(authorIdentifier, page, perPage, isInfiniteScroll) {
		var authorId = getBlogAuthorId(arguments.authorIdentifier);
		var result = getBlogsByAuthor(authorId, arguments.page, arguments.perPage, arguments.isInfiniteScroll);

		// Get author statistics in a single optimized query if possible
		var authorStats = getAuthorStatistics(authorId);

		result.author = {
			"id" = authorId,
			"totalposts" = authorStats.totalPosts,
			"totalcomments" = authorStats.totalComments
		};

		return result;
	}

	// author statistics retrieval
	private struct function getAuthorStatistics(authorId) {
		// Try to get both stats in one query if your database supports it
		try {
			return {
				"totalPosts" = model("Blog").count(where = "createdBy = #arguments.authorId#"),
				"totalComments" = model("Comment").count(where = "authorId = #arguments.authorId#")
			};
		} catch (any e) {
			model("Log").log(
				category = "wheels.blog",
				level = "ERROR",
				message = "Error retrieving author statistics",
				details = {"error_message" = e.message, "author_id" = arguments.authorId, "ip_address" = cgi.REMOTE_ADDR},
				userId = getSignedInUserId()
			);
			return {"totalPosts" = 0, "totalComments" = 0};
		}
	}

	// Log invalid filter attempts
	private void function logInvalidFilter(filterType, filterValue) {
		model("Log").log(
			category = "wheels.blog",
			level = "WARN",
			message = "Invalid filter type attempted",
			details = {
				"invalid_filter_type" = arguments.filterType,
				"filter_value" = arguments.filterValue,
				"ip_address" = cgi.REMOTE_ADDR
			},
			userId = getSignedInUserId()
		);
	}

	// Centralized error handling
	private void function handleBlogError(error, userId, page, perPage, isInfiniteScroll) {
		// Log the error
		model("Log").log(
			category = "wheels.blog",
			level = "ERROR",
			message = "Error in blogs(): #arguments.error.message#",
			details = {
				"error_message" = arguments.error.message,
				"error_detail" = arguments.error.detail ?: "",
				"error_type" = arguments.error.type ?: "",
				"stack_trace" = arguments.error.stackTrace ?: "",
				"ip_address" = cgi.REMOTE_ADDR,
				"timestamp" = Now()
			},
			userId = arguments.userId
		);

		// Provide fallback data
		try {
			var fallbackResult = getAllBlogs(1, arguments.perPage, arguments.isInfiniteScroll);
			blogs = fallbackResult.query;
			hasMore = fallbackResult.hasMore;
			totalCount = fallbackResult.totalCount;

			// Set error flag for template
			hasError = true;
			errorMessage = "We're experiencing some technical difficulties. Showing recent posts instead.";
		} catch (any fallbackError) {
			// If even fallback fails, create empty result
			blogs = QueryNew(
				"id,title,slug,createdby,publishedAt,fullName,username,profilePicture",
				"integer,varchar,varchar,integer,date,varchar,varchar,varchar"
			);
			hasMore = false;
			totalCount = 0;
			hasError = true;
			errorMessage = "Unable to load blog posts at this time. Please try again later.";
		}

		renderPartial(partial = "partials/blogList");
	}

	// Function to edit a blog post
	public void function edit() {
		try {
			// Check if user is logged in
			if (!hasEditorAccess()) {
				redirectTo(route = "blog");
				return;
			}

			// Get the blog post
			blog = model("Blog").findByKey(key = params.id, include = "User,PostStatus");

			// Check if blog exists
			if (!IsObject(blog)) {
				Throw("Blog not found", "BlogNotFound");
			}

			// Check if user has permission to edit this post
			if (!hasEditorAccess() && blog.createdBy != session.userID) {
				Throw("You don't have permission to edit this post", "UnauthorizedAccess");
			}

			// Get categories and tags for the form
			categories = model("Category").findAll(order = "name ASC");
			postTypes = model("PostType").findAll(order = "name ASC");
			var blogCategories = model("BlogCategory").findAll(where = "blogId = #blog.id#");
			var blogTags = model("BlogTag").findAll(where = "blogId = #blog.id#", include = "Tag");

			// Prepare data for the view
			var selectedCategories = [];
			for (var cat in blogCategories) {
				ArrayAppend(selectedCategories, Val(cat.categoryId));
			}

			var selectedTags = [];
			for (var blogTag in blogTags) {
				ArrayAppend(selectedTags, blogTag.name);
			}

			// Set view variables
			blog.categories = selectedCategories;
			blog.tags = ArrayToList(selectedTags, ",");
			isEdit = true;

			renderView(template = "create");
		} catch (any e) {
			// Log the error
			model("Log").log(
				category = "wheels.blog",
				level = "ERROR",
				message = "Error editing blog post: #e.message#",
				details = {
					"error" = e,
					"blog_id" = StructKeyExists(params, "key") ? params.key : "",
					"user_id" = getSignedInUserId(),
					"ip_address" = cgi.REMOTE_ADDR
				}
			);

			// Redirect with error message
			redirectTo(route = "blog");
		}
	}

	private function getBlogsByAuthor(
		required authorId,
		numeric page = 1,
		numeric perPage = 6,
		boolean isInfiniteScroll = false
	) {
		var result = {
			query = model("Blog").findAll(
				where = "blog_posts.statusId <> #blogStatuses().DRAFT# AND blog_posts.status = 'Approved' AND blog_posts.publishedAt IS NOT NULL AND blog_posts.publishedAt <= '#Now()#' AND blog_posts.createdBy = #arguments.authorId#",
				include = "User",
				order = "publishedAt DESC",
				page = arguments.page,
				perPage = arguments.perPage
			),
			hasMore = false,
			totalCount = 0
		};

		result.totalCount = model("Blog").count(
			where = "blog_posts.statusId <> #blogStatuses().DRAFT# AND blog_posts.status = 'Approved' AND blog_posts.publishedAt IS NOT NULL AND blog_posts.publishedAt <= '#Now()#' AND blog_posts.createdBy = #arguments.authorId#"
		);
		result.hasMore = (page * perPage) < result.totalCount;

		if (result.query.recordCount == 0) {
			redirectTo(route = "blog");
		}

		return result;
	}

	private function getBlogAuthorId(required authorParam) {
		// Check if authorParam is numeric (ID) or string (username)
		if (IsNumeric(authorParam)) {
			return Val(authorParam);
		} else {
			// Lookup user by username
			var user = model("user").findOne(where = "username = :username", params={username={value=arguments.authorParam, cfsqltype="cf_sql_varchar"}});
			if (IsObject(user)) {
				return user.id;
			} else {
				// User not found, redirect
				redirectTo(route = "blog");
				return false;
			}
		}
	}

	function blogSearch() {
		param name="params.searchTerm" default="";
		param name="params.page" default="1";
		param name="params.perPage" default="6";
		param name="params.infiniteScroll" default="false";
		param name="params.isSearched" default="false";

		searchTerm = params.searchTerm;
		page = params.page;
		perPage = params.perPage;
		isInfiniteScroll = params.infiniteScroll;

		if (Len(Trim(searchTerm))) {
			var searchPattern = "%#searchTerm#%";
			var query = model("blog").findAll(
				where = "blog_posts.status ='Approved' AND blog_posts.publishedAt IS NOT NULL AND blog_posts.publishedAt <= '#Now()#' AND (blog_posts.slug LIKE :pattern OR blog_posts.title LIKE :pattern OR blog_posts.content LIKE :pattern OR fullname LIKE :pattern OR email LIKE :pattern)",
				params = {pattern={value=searchPattern, cfsqltype="cf_sql_varchar"}},
				include = "User, PostStatus, PostType",
				order = "publishedAt DESC",
				page = page,
				perPage = perPage
			);

			if (isInfiniteScroll) {
				totalCount = model("blog").count(
					include = "User, PostStatus, PostType",
					where = "blog_posts.status ='Approved' AND blog_posts.publishedAt IS NOT NULL AND blog_posts.publishedAt <= '#Now()#' AND (blog_posts.slug LIKE :pattern OR blog_posts.title LIKE :pattern OR blog_posts.content LIKE :pattern OR fullname LIKE :pattern OR email LIKE :pattern)",
					params = {pattern={value=searchPattern, cfsqltype="cf_sql_varchar"}}
				);
				hasMore = (page * perPage) < totalCount;
				isSearched = true;

				query.addColumn("hasMore", "boolean");
				query.addColumn("totalCount", "integer");
			}

			blogs = query;
			if (blogs.recordCount == 0) {
				isFallBack = true;
				result = getAllBlogs(page, perPage, isInfiniteScroll);
				blogs = result.query;
			}
			renderPartial(partial = "partials/blogList");
		} else {
			// return all publish blogs with pagination
			result = getAllBlogs(page, perPage, isInfiniteScroll);
			blogs = result.query;
			hasMore = result.hasMore;
			totalCount = result.totalCount;
			renderPartial(partial = "partials/blogList");
		}
	}
	// Function to load categories for the blog list
	function categories() {
		categorylist = model("Category").findAll(where = "isActive = 1", cache = 60);
		renderPartial(partial = "partials/categorylist");
	}

	// Function to show the create blog form
	function create() {
		if (!hasEditorAccess()) {
			redirectTo(route = "blog");
			return;
		}
		categories = model("Category").findAll(order = "name ASC");
		postTypes = model("PostType").findAll(order = "name ASC");
		model("Log").log(
			category = "wheels.blog",
			level = "INFO",
			message = "Blog creation form accessed",
			details = {"ip_address" = cgi.REMOTE_ADDR},
			userId = getSignedInUserId()
		);
		saveRedirectUrl(cgi.script_name & "?" & cgi.query_string);
		isEdit = false;
	}

	// Function to store a new blog
	public void function store() {
		// Get request parameters
		var blogModel = model("Blog");
		try {
			// Check if user has editor access
			if (!hasEditorAccess()) {
				Throw("You don't have permission to create a blog post", "UnauthorizedAccess");
			}
			model("Log").log(
				category = "wheels.blog",
				level = "INFO",
				message = "New blog post creation attempted",
				details = {"title" = params.title, "ip_address" = cgi.REMOTE_ADDR},
				userId = getSignedInUserId()
			);

			params.coverImagePath = "";
			var uploadPath = ExpandPath("/files/"); // Define the upload directory

			if (!DirectoryExists(uploadPath)) {
				DirectoryCreate(uploadPath);
			}

			// Handle file upload
			if (StructKeyExists(params, "attachment") && IsDefined("params.attachment")) {
				var uploadedFile = FileUpload(uploadPath, "attachment");

				if (!StructIsEmpty(uploadedFile) && StructKeyExists(uploadedFile, "serverFile")) {
					var originalFileName = uploadedFile.serverFile;
					var fileExtension = LCase(ListLast(originalFileName, "."));
					var allowedExtensions = "jpg,jpeg,png,gif,webp,pdf,doc,docx";
					var allowedContentTypes = "image/jpeg,image/png,image/gif,image/webp,application/pdf,application/msword,application/vnd.openxmlformats-officedocument.wordprocessingml.document";
					var maxFileSizeBytes = 10 * 1024 * 1024; // 10MB

					// Validate file extension
					if (!ListFindNoCase(allowedExtensions, fileExtension)) {
						FileDelete(uploadedFile.serverDirectory & "/" & originalFileName);
						Throw("Invalid file type. Allowed types: #allowedExtensions#", "InvalidFileType");
					}

					// Validate MIME content type
					if (StructKeyExists(uploadedFile, "contentType") && StructKeyExists(uploadedFile, "contentSubType")) {
						var detectedContentType = uploadedFile.contentType & "/" & uploadedFile.contentSubType;
						if (!ListFindNoCase(allowedContentTypes, detectedContentType)) {
							FileDelete(uploadedFile.serverDirectory & "/" & originalFileName);
							Throw("Invalid file content type. The uploaded file does not match allowed types.", "InvalidContentType");
						}
					}

					// Validate file size
					if (uploadedFile.fileSize > maxFileSizeBytes) {
						FileDelete(uploadedFile.serverDirectory & "/" & originalFileName);
						Throw("File size exceeds the 10MB limit.", "FileTooLarge");
					}

					var uniqueFileName = CreateUUID() & "." & fileExtension;

					// Rename file to unique name
					var newFilePath = uploadPath & "/" & uniqueFileName;
					FileMove(uploadedFile.serverDirectory & "/" & originalFileName, newFilePath);

					// Store the relative file path
					params.coverImagePath = "/files/" & uniqueFileName;
				}
			}

			response = saveBlog(params);
			saveTags(params, response.blogId);
			saveCategories(params, response.blogId);

			model("Log").log(
				category = "wheels.blog",
				level = "INFO",
				message = "New blog post created successfully",
				details = {"blog_id" = response.blogId, "title" = params.title, "ip_address" = cgi.REMOTE_ADDR},
				userId = getSignedInUserId()
			);

			renderText(response.message);
		} catch (any e) {
			model("Log").log(
				category = "wheels.blog",
				level = "ERROR",
				message = "Failed to save blog post",
				details = {
					"error_message" = e.message,
					"error_detail" = e.detail,
					"error_type" = e.type,
					"title" = params.title,
					"ip_address" = cgi.REMOTE_ADDR
				},
				userId = getSignedInUserId()
			);
			// Handle error
			redirectTo(action = "error", errorMessage = "Failed to save blog post.");
		}
	}

	// Function to show a specific blog
	function show() {
		try {
			blogModel = model("Blog");

			// Get the blog by its slug
			blog = getBlogBySlug(params.slug);

			// If no blog is found, throw an error to be caught
			if (!StructKeyExists(blog, "id")) {
				Throw("Blog not found");
			}

			// Process embeds in content
      blog.content = embedAndAutoLink(blog.content);

			// Set blog post data for layout meta tags (avoids DB query in view)
			request.blogPostForMeta = blog;

			// Get other necessary data
			tags = getTagsByBlogid(blog.id);
			categories = getCategoriesByBlogid(blog.id);
			attachments = getAttachmentsByBlogid(blog.id);
			comments = getAllCommentsByBlogid(blog.id);
			allBlogComments = model("Comment").findAll(
				include = "User",
				where = "isPublished = 1 AND blogid = #blog.id#",
				order = "commentParentId, createdAt",
				cache = 5
			);

			// Track reading history
			if (StructKeyExists(session, "userID")) {
				history = model("ReadingHistory").findOne(
					where = "userId = #session.userID# AND blogId = #blog.id#",
					includeSoftDeletes = true
				);
				if (IsObject(history)) {
					if (history.deletedAt != "") {
						history.update(lastReadAt = Now(), deletedAt = "");
					} else {
						history.update(lastReadAt = Now());
					}
				} else {
					history = model("ReadingHistory").create(userId = session.userID, blogId = blog.id, lastReadAt = Now());
				}

				// Check if bookmarked
				isBookmarked = model("Bookmark").exists(where = "userId = #session.userID# AND blogId = #blog.id#");
			} else {
				isBookmarked = false;
			}
		} catch (any e) {
			model("Log").log(
				category = "wheels.blog",
				level = "ERROR",
				message = "Blog post not found",
				details = {
					"error_message" = e.message,
					"error_detail" = e.detail,
					"slug" = params.slug,
					"ip_address" = cgi.REMOTE_ADDR
				},
				userId = getSignedInUserId()
			);
			redirectTo(action = "index");
			return;
		}
	}

	// Function to update an existing blog
	public function update() {
		var blogId = params.id;
		result = {success = false, message = "", blogId = blogId};
		try {
			model("Log").log(
				category = "wheels.blog",
				level = "INFO",
				message = "Blog post update attempted",
				details = {"blog_id" = blogId, "title" = params.title, "ip_address" = cgi.REMOTE_ADDR},
				userId = getSignedInUserId()
			);
			params.isDraft = IsNumeric(params.isDraft) ? params.isDraft : 0;

			// Allow title change and check uniqueness
			if (StructKeyExists(params, "title")) {
				var existingBlog = model("Blog").findFirst(where = "title = :title AND id != :blogId", params={title={value=params.title, cfsqltype="cf_sql_varchar"}, blogId={value=blogId, cfsqltype="cf_sql_integer"}});
				if (IsObject(existingBlog)) {
					result.success = false;
					result.message = "A blog post with this title already exists.";
					model("Log").log(
						category = "wheels.blog",
						level = "DEBUG",
						message = "[UPDATE] Duplicate title found",
						details = {"blog_id" = blogId, "title" = params.title},
						userId = getSignedInUserId()
					);
					renderWith(data = result, hideDebugInformation = true, layout = '/responseLayout');
					return;
				}
			}

			transaction {
				result = updateBlog(params, blogId);

				if (!result.success) {
					Throw(type = "BlogUpdateFailed", message = result.message);
				}

				deleteBlogTags(blogId);
				deleteBlogCategories(blogId);

				if (StructKeyExists(params, "postTags") && Len(Trim(params.postTags))) {
					params.tags = params.postTags;
					saveTags(params, blogId);
				}

				if (StructKeyExists(params, "categoryId") && Len(Trim(params.categoryId))) {
					saveCategories(params, blogId);
				}
			}

			model("Log").log(
				category = "wheels.blog",
				level = "INFO",
				message = "Blog post updated successfully",
				details = {"blog_id" = blogId, "title" = params.title, "ip_address" = cgi.REMOTE_ADDR},
				userId = getSignedInUserId()
			);
			result.success = true;
			if (!StructKeyExists(result, "message") || !Len(result.message)) {
				result.message = "Blog post updated successfully.";
			}
			// Add redirectUrl to show page
			result.redirectUrl = urlFor(action = "show", slug = params.slug);
		} catch (any e) {
			model("Log").log(
				category = "wheels.blog",
				level = "ERROR",
				message = "Failed to update blog post",
				details = {
					"blog_id" = blogId,
					"error_message" = e.message,
					"error_detail" = e.detail,
					"error_type" = e.type,
					"title" = params.title,
					"ip_address" = cgi.REMOTE_ADDR
				},
				userId = getSignedInUserId()
			);
			result.success = false;
			result.message = "Failed to update blog post.";
		}
		renderWith(data = result, hideDebugInformation = true, layout = '/responseLayout');
		return;
	}

	// function to check title is unique
	function checkTitle() {
		try {
			model("Log").log(
				category = "wheels.blog",
				level = "DEBUG",
				message = "Title uniqueness check",
				details = {
					"title" = form.title,
					"id" = StructKeyExists(form, "id") ? form.id : 0,
					"ip_address" = cgi.REMOTE_ADDR
				},
				userId = getSignedInUserId()
			);

			if (StructKeyExists(form, "title")) {
				var queryParams = {title={value=form.title, cfsqltype="cf_sql_varchar"}};
				var whereClause = "title = :title";

				if (StructKeyExists(form, "id") && IsNumeric(form.id) && form.id > 0) {
					whereClause &= " AND id != :formId";
					queryParams.formId = {value=form.id, cfsqltype="cf_sql_integer"};
				}

				var blogModel = model("Blog").findAll(where = whereClause, params = queryParams);

				if (blogModel.recordCount != 0) {
					renderText('<span class="text-danger">A blog already exists with this title!</span><input type="hidden" id="titleExists" value="1">');
				} else {
					renderText('<span class="text-success">Title is available</span><input type="hidden" id="titleExists" value="0">');
				}
			}
		} catch (any e) {
			model("Log").log(
				category = "wheels.blog",
				level = "ERROR",
				message = "Error checking title uniqueness",
				details = {
					"error_message" = e.message,
					"error_detail" = e.detail,
					"title" = form.title,
					"id" = StructKeyExists(form, "id") ? form.id : 0,
					"ip_address" = cgi.REMOTE_ADDR
				},
				userId = getSignedInUserId()
			);
			// Handle error
			renderText('<span class="text-danger">Error checking title. Please try again.</span>');
		}
	}

	// Function to delete a blog
	function destroy() {
		var blogModel = model("Blog"); // Get model instance
		try {
			model("Log").log(
				category = "wheels.blog",
				level = "INFO",
				message = "Blog post deletion attempted",
				details = {"blog_id" = params.id, "ip_address" = cgi.REMOTE_ADDR},
				userId = getSignedInUserId()
			);

			var message = deleteBlog(params.id);

			model("Log").log(
				category = "wheels.blog",
				level = "INFO",
				message = "Blog post deleted successfully",
				details = {"blog_id" = params.id, "ip_address" = cgi.REMOTE_ADDR},
				userId = getSignedInUserId()
			);

			redirectTo(action = "index", success = "#message#");
		} catch (any e) {
			model("Log").log(
				category = "wheels.blog",
				level = "ERROR",
				message = "Failed to delete blog post",
				details = {
					"error_message" = e.message,
					"error_detail" = e.detail,
					"blog_id" = params.id,
					"ip_address" = cgi.REMOTE_ADDR
				},
				userId = getSignedInUserId()
			);
			// Handle error
			redirectTo(action = "index", errorMessage = "Failed to delete blog post.");
		}
	}

	// Function to load categories for the dropdown
	function loadCategories() {
		categories = model("Category").getAll();
		renderPartial(partial = "partials/categories");
	}

	// Function to load statuses for the dropdown
	function loadStatuses() {
		statuses = model("PostStatus").getAll();
		renderPartial(partial = "partials/statuses");
	}

	// Function to load post types for the dropdown
	function loadPostTypes() {
		postTypes = model("PostType").getAll();
		renderPartial(partial = "partials/postTypes");
	}

	function error() {
		renderPartial(partial = "partials/_error");
	}

	public function feed() {
		// Fetch all blogs
		blogPosts = model("Blog").findAll(
			where = "blog_posts.status = 'Approved' AND blog_posts.publishedAt IS NOT NULL AND blog_posts.publishedAt <= '#Now()#'",
			include = "User",
			order = "publishedAt DESC",
			cache = 10
		);

		// Render the feed view
		renderPartial(partial = "partials/feed");
	}

	public function commentsFeed() {
		// Get recent comments with related blog post
		comments = model("Comment").findAll(
			where = "isPublished = 1",
			include = "Blog",
			order = "createdAt DESC",
			limit = 20,
			returnAs = "structs"
		);

		// Collect unique authorIds
		authorIds = [];
		for (key in comments) {
			comment = comments[key];
			if (IsStruct(comment) and StructKeyExists(comment, "authorId")) {
				if (!ArrayContains(authorIds, comment.authorId)) {
					ArrayAppend(authorIds, comment.authorId);
				}
			}
		}

		// Fetch all related users at once
		var authorIdList = ArrayToList(authorIds);
		authors = model("User").findAll(where = "id IN (#authorIdList#)", returnAs = "structs");

		// Map authors by ID for quick lookup
		authorMap = {};
		for (key in authors) {
			author = authors[key];
			authorMap[author.id] = author;
		}

		renderPartial(partial = "partials/commentsFeed", locals = {comments = comments, authorMap = authorMap});
	}

	// Business Logic

	private function getAllBlogs(numeric page = 1, numeric perPage = 6, boolean isInfiniteScroll = false) {
		var result = {
			query = model("Blog").findAll(
				where = "blog_posts.statusId <> #blogStatuses().DRAFT# AND blog_posts.status = 'Approved' AND blog_posts.publishedAt IS NOT NULL AND blog_posts.publishedAt <= '#Now()#'",
				include = "User",
				order = "publishedAt DESC",
				page = arguments.page,
				perPage = arguments.perPage,
				cache = 5
			),
			hasMore = false,
			totalCount = 0
		};

		result.totalCount = model("Blog").count(
			where = "blog_posts.statusId <> #blogStatuses().DRAFT# AND blog_posts.status = 'Approved' AND blog_posts.publishedAt IS NOT NULL AND blog_posts.publishedAt <= '#Now()#'",
			cache = 5
		);
		result.hasMore = (page * perPage) < result.totalCount;

		return result;
	}

	private function getBlogsByMonthYear(
		required numeric year,
		required string month,
		numeric page = 1,
		numeric perPage = 6,
		boolean isInfiniteScroll = false
	) {
		// Create start and end date for the selected month
		var startdate = "#year#-#NumberFormat(month, '00')#-01 00:00:00";
		var enddate = "#year#-#NumberFormat(month, '00')#-#DaysInMonth('#year#-#NumberFormat(month, '00')#-01')# 23:59:59";

		var result = {
			query = model("Blog").findAll(
				where = "blog_posts.published_at BETWEEN '#startdate#' AND '#enddate#' AND blog_posts.status='Approved' AND blog_posts.publishedAt IS NOT NULL AND blog_posts.publishedAt <= '#Now()#'",
				order = "publishedAt DESC",
				include = "User",
				returnAs = "query",
				page = arguments.page,
				perPage = arguments.perPage
			),
			hasMore = false,
			totalCount = 0
		};

		result.totalCount = model("Blog").count(
			where = "blog_posts.published_at BETWEEN '#startdate#' AND '#enddate#' AND blog_posts.status='Approved' AND blog_posts.publishedAt IS NOT NULL AND blog_posts.publishedAt <= '#Now()#'"
		);
		result.hasMore = (page * perPage) < result.totalCount;

		return result;
	}

	// Fetch Blogs by Category
	public function getBlogsByCategory(
		required string categoryName,
		numeric page = 1,
		numeric perPage = 6,
		boolean isInfiniteScroll = false
	) {
		// Get category ID from name
		var category = model("Category").findOne(where = "name = '#arguments.categoryName#'");
		if (!IsObject(category)) return {query = QueryNew(""), hasMore = false, totalCount = 0};

		var blogCategoryQuery = model("BlogCategory").findAll(where = "categoryId = #category.id#", returnAs = "query");
		if (blogCategoryQuery.recordCount == 0) return {query = QueryNew(""), hasMore = false, totalCount = 0};

		var blogIds = blogCategoryQuery.columnData("blogId");
		var blogIdList = ArrayToList(blogIds);

		var result = {
			query = model("Blog").findAll(
				where = "blog_posts.id IN (#blogIdList#) AND categoryId = #category.id# AND blog_posts.status ='Approved' AND blog_posts.publishedAt IS NOT NULL AND blog_posts.publishedAt <= '#Now()#'",
				order = "publishedAt DESC",
				include = "User,BlogCategory",
				returnAs = "query",
				page = arguments.page,
				perPage = arguments.perPage
			),
			hasMore = false,
			totalCount = 0
		};

		result.totalCount = model("Blog").count(
			where = "blog_posts.id IN (#blogIdList#) AND categoryId = #category.id# AND blog_posts.status ='Approved' AND blog_posts.publishedAt IS NOT NULL AND blog_posts.publishedAt <= '#Now()#'",
			include = "User,BlogCategory"
		);
		result.hasMore = (page * perPage) < result.totalCount;

		return result;
	}

	// Fetch Blogs by Tag
	private function getAllByTag(
		required string tag,
		numeric page = 1,
		numeric perPage = 6,
		boolean isInfiniteScroll = false
	) {
		// First, find the tag by name
		var targetTag = model("Tag").findOne(where = "name = '#arguments.tag#'");

		if (!IsObject(targetTag)) {
			return {query = QueryNew(""), hasMore = false, totalCount = 0};
		}

		// Get all blog_ids associated with this tag
		var blogTags = model("BlogTag").findAll(where = "tagId = #targetTag.id#", returnAs = "query");

		if (blogTags.recordCount == 0) {
			return {query = QueryNew(""), hasMore = false, totalCount = 0};
		}

		var blogIds = ValueList(blogTags.blogId);

		var result = {
			query = model("Blog").findAll(
				where = "blog_posts.id IN (#blogIds#) AND blog_posts.status ='Approved' AND blog_posts.publishedAt IS NOT NULL AND blog_posts.publishedAt <= '#Now()#'",
				order = "publishedAt DESC",
				include = "User",
				returnAs = "query",
				page = arguments.page,
				perPage = arguments.perPage
			),
			hasMore = false,
			totalCount = 0
		};

		result.totalCount = model("Blog").count(
			where = "blog_posts.id IN (#blogIds#) AND blog_posts.status ='Approved' AND blog_posts.publishedAt IS NOT NULL AND blog_posts.publishedAt <= '#Now()#'"
		);
		result.hasMore = (page * perPage) < result.totalCount;

		return result;
	}

	private function getBlogById(required numeric id) {
		return model("Blog").findOne(where = "blog_posts.id = #arguments.id#", include = "User, PostStatus");
	}

	private function saveBlog(required struct blogData) {
		var response = {"message" = "", "blogId" = 0};

		// Generate slug
		var slug = ReReplace(LCase(blogData.title), "[^a-z0-9]", "-", "all"); // Replace non-alphanumeric with "-"
		slug = ReReplace(slug, "-+", "-", "all");
		blogData.slug = slug;


		// Determine status based on draft flag and user role
		if (blogData.isdraft eq 1) {
			blogData.statusId = blogStatuses().DRAFT;
			blogData.status = "";
			blogData.publishedAt = "";
		} else if (isUserAdmin()) {
			// Auto-approve and publish for admin users
			blogData.statusId = blogStatuses().POSTED;
			blogData.status = "Approved";
			if (
				StructKeyExists(blogData, "postCreatedDate") && !IsNull(blogData.postCreatedDate) && !IsEmpty(
					blogData.postCreatedDate
				)
			) {
				blogData.publishedAt = blogData.postCreatedDate;
			} else {
				blogData.publishedAt = Now();
				blogData.postCreatedDate = Now();
			}
		} else {
			blogData.statusId = blogStatuses().PENDING_REVIEW;
			blogData.status = "";
			blogData.publishedAt = "";
		}

		try {
			// Check if the blog ID is greater than 0 (editing an existing post)
			if (StructKeyExists(blogData, "id") && blogData.id > 0) {
				var blog = model("Blog").findByKey(blogData.id);

				if (IsObject(blog)) {
					// Update the existing blog post
					blog.title = blogData.title;
					blog.content = blogData.content;
					blog.statusId = blogData.statusId;
					blog.status = blogData.status;
					blog.publishedAt = blogData.publishedAt;
					blog.postTypeId = blogData.postTypeId;
					blog.slug = blogData.slug;
					blog.updatedAt = Now();
					blog.updatedBy = getSignedInUserId();
					blog.save();

					response.blogId = blog.id;
					response.message = "Blog post updated successfully.";
				} else {
					response.message = "Blog post not found for editing.";
				}
			} else {
				// Check if a blog post with the same title already exists
				var existingBlog = model("Blog").findFirst(where = "title = '#blogData.title#' AND slug = '#blogData.slug#'");

				if (!IsObject(existingBlog)) {
					// Create a new blog post
					var newBlog = model("Blog").new();
					newBlog.title = blogData.title;
					newBlog.content = blogData.content;
					newBlog.slug = blogData.slug;
					newBlog.statusId = blogData.statusId;
					newBlog.postTypeId = blogData.postTypeId;
					newBlog.coverImagePath = blogData.coverImagePath;
					newBlog.createdAt = Now();
					newBlog.updatedAt = Now();
					newBlog.createdBy = getSignedInUserId();

					// Set approval status fields for admin auto-approval
					if (StructKeyExists(blogData, "status")) {
						newBlog.status = blogData.status;
					}
					if (
						StructKeyExists(blogData, "postCreatedDate") && !IsNull(blogData.postCreatedDate) && !IsEmpty(
							blogData.postCreatedDate
						)
					) {
						newBlog.publishedAt = blogData.postCreatedDate;
						newBlog.postCreatedDate = blogData.postCreatedDate;
					} else {
						newBlog.postCreatedDate = Now();
					}
					newBlog.save();

					// Retrieve the generated ID by looking up the just-created blog by slug.
					// Wheels' PostgreSQL adapter does not always return the auto-generated
					// primary key after INSERT (e.g. when the column uses a BIGINT default
					// or trigger-based ID generation rather than SERIAL).
					if (!Len(Trim(newBlog.id))) {
						var createdBlog = model("Blog").findOne(where = "slug = '#blogData.slug#'");
						if (IsObject(createdBlog)) {
							response.blogId = createdBlog.id;
						}
					} else {
						response.blogId = newBlog.id;
					}
					response.message = "Blog post created successfully.";
				} else {
					response.message = "A blog post with the same title already exists.";
				}
			}
		} catch (any e) {
			response.message = "Error: " & e.message;
		}

		return response;
	}

	// updateBlog() is inherited from Controller.cfc

	private function deleteBlog(required numeric id) {
		var message = "";

		try {
			var blog = model("Blog").findByKey(id);

			if (IsObject(blog)) {
				blog.isDeleted = true;
				blog.updatedAt = Now();
				blog.updatedBy = getSignedInUserId();
				blog.save();
				message = "Blog post deleted successfully.";
			} else {
				message = "Blog post not found for deletion.";
			}
		} catch (any e) {
			// Catch any errors and store the message
			message = "Error: " & e.message;
		}

		// Return the message
		return message;
	}

	// Tags
	function getAllTags() {
		return model("Tag").findAll();
	}

	// saveTags() is inherited from Controller.cfc
	// deleteBlogTags() is inherited from Controller.cfc

	// Categories

	function getAllCategories() {
		return model("Category").findAll();
	}

	// saveCategories() is inherited from Controller.cfc
	// deleteBlogCategories() is inherited from Controller.cfc

	// Attachement

	function getAllAttachments() {
		return model("Attachment").findAll();
	}

	function getAllCommentsByBlogid(required numeric id) {
		var comments = model("Comment").findAll(
			include = "User",
			where = "isPublished = 1 AND blogid = #arguments.id# AND commentParentId IS NULL",
			cache = 5
		);

		return comments;
	}

	public struct function uploadFile(file) {
		var uploadPath = ExpandPath("/public/files");
		var filePath = uploadPath & file.serverFileName;

		// Ensure the upload directory exists
		if (!DirectoryExists(uploadPath)) {
			DirectoryCreate(uploadPath);
		}

		// Move the uploaded file to the upload directory
		FileWrite(filePath, file.fileContent);

		return {filePath = filePath, fileName = file.serverFileName};
	}

	// Function to store comment
	public void function comment() {
		var commentModel = model("Comment");
		try {
			// Check if user can comment using helper function
			if (!canUserComment()) {
				model("Log").log(
					category = "wheels.blog",
					level = "WARN",
					message = "Unauthorized comment attempt",
					details = {"userId" = getSignedInUserId(), "ip_address" = cgi.REMOTE_ADDR}
				);
				// Do not allow commenting
				renderText("Comments are closed");
				return;
			}

			blog = getBlogById(params.blogId);
			if (params.content.trim() == "" || params.content.trim() == "<p> </p>" || params.content.trim() == "<p><br></p>") {
				response = {};
			} else {
				response = saveComment(params);
			}
			if (StructKeyExists(response, "Id")) {
				comments = commentModel.findAll(include = "User", where = "id = #response.Id# AND isPublished = 1");
				renderPartial(partial = "partials/comment");
			}
		} catch (any e) {
			// Handle error
			flashInsert(error = "Failed to save comment.");
			redirectTo(action = "error");
		}
	}

	private function saveComment(required struct commentData) {
		var response = {"message" = "", "blogId" = 0};

		try {
			// Check if the commentParentId is greater than 0 (saving reply against a comment)
			if (StructKeyExists(commentData, "commentParentId") && commentData.commentParentId > 0) {
				// Create a new comment(reply)
				var newComment = model("Comment").new();
				newComment.content = commentData.content;
				newComment.commentParentId = commentData.commentParentId;
				newComment.blogId = commentData.blogId;
				newComment.publishedAt = Now();
				newComment.createdAt = Now();
				newComment.updatedAt = Now();
				newComment.authorId = getSignedInUserId();
				newComment.isPublished = published();
				newComment.save();

				response.Id = newComment.Id;
				response.blogId = newComment.blogId;
				response.message = "comment created successfully.";
			} else {
				// Create a new comment
				var newComment = model("Comment").new();
				newComment.content = commentData.content;
				newComment.blogId = commentData.blogId;
				newComment.publishedAt = Now();
				newComment.createdAt = Now();
				newComment.updatedAt = Now();
				newComment.authorId = getSignedInUserId();
				newComment.isPublished = published();
				newComment.save();

				response.Id = newComment.Id;
				response.blogId = newComment.blogId;
				response.message = "comment created successfully.";
			}
		} catch (any e) {
			response.message = "Error: " & e.message;
		}

		return response;
	}

	public void function unpublish() {
		try {
			var currentUserId = getSignedInUserId();
			if (!IsNumeric(currentUserId)) {
				Throw("Unauthorized access", "UserNotAuthenticated");
			}

			if (!StructKeyExists(params, "id") || !IsNumeric(params.id)) {
				Throw("Invalid blog ID", "InvalidRequest");
			}

			var blogId = params.id;
			var blog = model("Blog").findByKey(blogId);
			var user = model("User").findByKey(currentUserId);

			if (!IsObject(blog)) {
				renderText("Blog not found");
				return;
			}

			if (blog.createdBy != currentUserId AND !isUserAdmin()) {
				renderText(" UnauthorizedAccess : You do not have permission to unpublish this blog");
				return;
			}

			blog.publishedAt = "";
			blog.save();

			model("Log").log(
				category = "wheels.blog",
				level = "INFO",
				message = "Blog unpublished",
				details = {"blog_id" = blog.id, "user_id" = currentUserId, "ip_address" = cgi.REMOTE_ADDR},
				userId = currentUserId
			);

			renderText("Blog unpublished successfully.");
		} catch (any e) {
			model("Log").log(
				category = "wheels.blog",
				level = "ERROR",
				message = "Error unpublishing blog: #e.message#",
				details = {
					"error_message" = e.message,
					"blog_id" = StructKeyExists(params, "id") ? params.id : "",
					"user_id" = getSignedInUserId(),
					"ip_address" = cgi.REMOTE_ADDR
				}
			);
			renderText("An error occurred while trying to unpublish the blog.");
		}
	}

}
