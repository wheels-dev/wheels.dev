// Frontend blog page
component extends="app.Controllers.Controller" {

    // Configuration function
    function config() {
        verifies(except="index,create,store,show,update,destroy,loadCategories,loadStatuses,loadPostTypes,Categories,blogs,comment,feed,error,checkTitle,edit,update,AuthorProfileBlogs,blogSearch,commentsFeed", params="key", paramsTypes="integer", handler="index");
        filters(through="restrictAccess", only="create,store,comment,edit,update");
        usesLayout("/layout");
    }

    // Function to list all blogs
    public void function index() {
        isEditor = hasEditorAccess();
        model("Log").log(
            category = "wheels.blog",
            level = "INFO",
            message = "Blog index page accessed",
            details = {
                "ip_address": cgi.REMOTE_ADDR,
                "user_agent": cgi.HTTP_USER_AGENT
            },
            userId = GetSignedInUserId()
        );
    }

    public void function blogs() {

        // Initialize default values and sanitize inputs
        filterType = sanitizeParam(structKeyExists(params, "filterType") ? params.filterType : "", "");
        filterValue = sanitizeParam(structKeyExists(params, "filterValue") ? params.filterValue : "", "");
        page = structKeyExists(params, "page") ? max(1, val(sanitizeParam(params.page, 1))) : 1;
        perPage = structKeyExists(params, "perPage") ? max(1, min(24, val(sanitizeParam(params.perPage, 6)))) : 6;
        isInfiniteScroll = structKeyExists(params, "infiniteScroll") ? params.infiniteScroll : false;
        userId = GetSignedInUserId();
        
        // Log request details
        logBlogRequest(filterType, filterValue, page, perPage, userId);
        
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
            if (structKeyExists(result, "author")) {
                author = result.author;
            }
            
            renderPartial(partial="partials/blogList");
            
        } catch (any e) {
            handleBlogError(e, userId, page, perPage, isInfiniteScroll);
        }
    }

    // Helper function to sanitize parameters
    private string function sanitizeParam(param, defaultValue) {
        if (!structKeyExists(arguments, "param") || !len(trim(arguments.param))) {
            return arguments.defaultValue;
        }
        return trim(arguments.param);
    }

    // Helper function to log blog requests
    private void function logBlogRequest(filterType, filterValue, page, perPage, userId) {
        model("Log").log(
            category = "wheels.blog",
            level = "DEBUG", 
            message = "Blog listing page accessed",
            details = {
                "filter_type": arguments.filterType,
                "filter_value": arguments.filterValue,
                "page": arguments.page,
                "per_page": arguments.perPage,
                "ip_address": cgi.REMOTE_ADDR,
                "user_agent": cgi.HTTP_USER_AGENT,
                "timestamp": now()
            },
            userId = arguments.userId
        );
    }

    // Main data retrieval logic
    private struct function getBlogData(filterType, filterValue, page, perPage, isInfiniteScroll) {
        var result = {};
        
        // Handle special cases first
        if (len(arguments.filterType) && len(arguments.filterValue)) {
            // Normalize filter value (convert hyphens to dots)
            arguments.filterValue = replace(arguments.filterValue, "-", ".", "all");
            
            // Handle date archive filtering (year/month)
            if (isNumeric(arguments.filterType) && isNumeric(arguments.filterValue)) {
                return getBlogsByMonthYear(arguments.filterType, arguments.filterValue, arguments.page, arguments.perPage, arguments.isInfiniteScroll);
            }
            
            // Handle content filtering
            switch (lcase(arguments.filterType)) {
                case "category":
                    return getBlogsByCategory(arguments.filterValue, arguments.page, arguments.perPage, arguments.isInfiniteScroll);
                    
                case "tag":
                    return getAllByTag(arguments.filterValue, arguments.page, arguments.perPage, arguments.isInfiniteScroll);
                    
                case "author":
                    return getBlogsWithAuthorData(arguments.filterValue, arguments.page, arguments.perPage, arguments.isInfiniteScroll);
                    
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
            "id": authorId,
            "totalposts": authorStats.totalPosts,
            "totalcomments": authorStats.totalComments
        };
        
        return result;
    }

    // author statistics retrieval
    private struct function getAuthorStatistics(authorId) {
        // Try to get both stats in one query if your database supports it
        try {
            return {
                "totalPosts": model("Blog").count(where="createdBy = #arguments.authorId#"),
                "totalComments": model("Comment").count(where="authorId = #arguments.authorId#")
            };
        } catch (any e) {
            model("Log").log(
                category = "wheels.blog",
                level = "ERROR",
                message = "Error retrieving author statistics",
                details = {
                    "error_message": e.message,
                    "author_id": arguments.authorId,
                    "ip_address": cgi.REMOTE_ADDR
                },
                userId = GetSignedInUserId()
            );
            return {
                "totalPosts": 0,
                "totalComments": 0
            };
        }
    }

    // Log invalid filter attempts
    private void function logInvalidFilter(filterType, filterValue) {
        model("Log").log(
            category = "wheels.blog",
            level = "WARN",
            message = "Invalid filter type attempted",
            details = {
                "invalid_filter_type": arguments.filterType,
                "filter_value": arguments.filterValue,
                "ip_address": cgi.REMOTE_ADDR
            },
            userId = GetSignedInUserId()
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
                "error_message": arguments.error.message,
                "error_detail": arguments.error.detail ?: "",
                "error_type": arguments.error.type ?: "",
                "stack_trace": arguments.error.stackTrace ?: "",
                "ip_address": cgi.REMOTE_ADDR,
                "timestamp": now()
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
            blogs = queryNew("id,title,slug,createdby,postDate,fullName,username,profilePicture", "integer,varchar,varchar,integer,date,varchar,varchar,varchar");
            hasMore = false;
            totalCount = 0;
            hasError = true;
            errorMessage = "Unable to load blog posts at this time. Please try again later.";
        }
        
        renderPartial(partial="partials/blogList");
    }

    // Function to edit a blog post
    public void function edit() {
        try {
            // Check if user is logged in
            if (!hasEditorAccess()) {
                redirectTo(route="blog");
                return;
            }

            // Get the blog post
            var blog = model("Blog").findByKey(key=params.id, include="User,PostStatus");

            // Check if blog exists
            if (!isObject(blog)) {
                throw("Blog not found", "BlogNotFound");
            }

            // Check if user has permission to edit this post
            if (!hasEditorAccess() && blog.userId != session.userID) {
                throw("You don't have permission to edit this post", "UnauthorizedAccess");
            }


            // Get categories and tags for the form
            var categories = model("Category").findAll(order="name ASC");
            var postTypes = model("PostType").findAll(order="name ASC");
            var blogCategories = model("BlogCategory").findAll(where="blogId = #blog.id#");
            var blogTags = model("Tag").findAll(where="blogId = #blog.id#");

            // Prepare data for the view
            var selectedCategories = [];
            for (var cat in blogCategories) {
                arrayAppend(selectedCategories, cat.categoryId);
            }

            var selectedTags = [];
            for (var tag in blogTags) {
                arrayAppend(selectedTags, tag.name);
            }

            // Set view variables
            blog.categories = selectedCategories;
            blog.tags = arrayToList(selectedTags, ",");

            // Render the edit form with the blog data
            renderView(template="create", blog=blog, categories=categories, postTypes=postTypes, isEdit=true);

        } catch (any e) {
            // Log the error
            model("Log").log(
                category = "wheels.blog",
                level = "ERROR",
                message = "Error editing blog post: #e.message#",
                details = {
                    "error": e,
                    "blog_id": structKeyExists(params, "key") ? params.key : "",
                    "user_id": GetSignedInUserId(),
                    "ip_address": cgi.REMOTE_ADDR
                }
            );

            // Redirect with error message
            redirectTo(route="blog");
        }
    }

    private function getBlogsByAuthor(required authorId, numeric page=1, numeric perPage=6, boolean isInfiniteScroll=false) {
        var result = {
            query = model("Blog").findAll(
                where="statusid <> 1 AND status = 'Approved' AND isPublished = 'true' AND createdBy = #authorId#",
                include="User",
                order="postDate DESC",
                page = arguments.page,
                perPage = arguments.perPage
            ),
            hasMore = false,
            totalCount = 0
        };

        result.totalCount = model("Blog").count(
            where="statusid <> 1 AND status = 'Approved' AND isPublished = 'true' AND createdBy = #authorId#"
        );
        result.hasMore = (page * perPage) < result.totalCount;

        if (result.query.recordCount == 0) {
           redirectTo(route="blog");
        }

        return result;
    }

    private function getBlogAuthorId(required authorParam) {
		// Check if authorParam is numeric (ID) or string (username)
		if (isNumeric(authorParam)) {
			return val(authorParam);
		} else {
			// Lookup user by username
			var user = model("user").findOne(where="username = '#authorParam#'");
			if (isObject(user)) {
				return user.id;
			} else {
				// User not found, redirect
				redirectTo(route="blog");
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

        if (len(trim(searchTerm))) {
            var query = model("blog").findAll(
                where="status ='Approved' AND isPublished='true'
                AND (slug LIKE '%#searchTerm#%' OR title LIKE '%#searchTerm#%' OR content LIKE '%#searchTerm#%' OR fullname LIKE '%#searchTerm#%' OR email LIKE '%#searchTerm#%')",
                include="User, PostStatus, PostType",
                order = "postDate DESC",
                page = page,
                perPage = perPage
            );
            
            if (isInfiniteScroll) {
                totalCount = model("blog").count(
                    include="User, PostStatus, PostType",
                    where="status ='Approved' AND isPublished='true'
                    AND (slug LIKE '%#searchTerm#%' OR title LIKE '%#searchTerm#%' OR content LIKE '%#searchTerm#%' OR fullname LIKE '%#searchTerm#%' OR email LIKE '%#searchTerm#%')"
                );
                hasMore = (page * perPage) < totalCount;
                isSearched = true;

                query.addColumn("hasMore", "boolean");
                query.addColumn("totalCount", "integer");
            }

            blogs = query;
            if(blogs.recordCount == 0) {
                isFallBack = true;
                result = getAllBlogs(page, perPage, isInfiniteScroll);
                blogs = result.query;
            }
            renderPartial(partial="partials/blogList");
        } else {
            // return all publish blogs with pagination
            result = getAllBlogs(page, perPage, isInfiniteScroll);
            blogs = result.query;
            hasMore = result.hasMore;
            totalCount = result.totalCount;
            renderPartial(partial="partials/blogList");
        }
    }
    // Function to load categories for the blog list
    function categories() {
        model("Log").log(
            category = "wheels.blog",
            level = "DEBUG",
            message = "Categories loaded",
            details = {
                "ip_address": cgi.REMOTE_ADDR
            },
            userId = GetSignedInUserId()
        );
        categorylist = model("Category").getAll();
        renderPartial(partial="partials/categorylist");
    }

    // Function to show the create blog form
    function create() {
        if (!hasEditorAccess()) {
            redirectTo(route="blog");
            return;
        }
        categories = model("Category").findAll(order="name ASC");
        postTypes = model("PostType").findAll(order="name ASC");
        model("Log").log(
            category = "wheels.blog",
            level = "INFO",
            message = "Blog creation form accessed",
            details = {
                "ip_address": cgi.REMOTE_ADDR
            },
            userId = GetSignedInUserId()
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
                throw("You don't have permission to create a blog post", "UnauthorizedAccess");
            }
            model("Log").log(
                category = "wheels.blog",
                level = "INFO",
                message = "New blog post creation attempted",
                details = {
                    "title": params.title,
                    "ip_address": cgi.REMOTE_ADDR
                },
                userId = GetSignedInUserId()
            );

            params.coverImagePath = "";
            var uploadPath = expandPath("/files/"); // Define the upload directory

            if (!directoryExists(uploadPath)) {
                directoryCreate(uploadPath);
            }

            // Handle file upload
            if (structKeyExists(params, "attachment") && isDefined("params.attachment")) {
                var uploadedFile = fileUpload(uploadPath, "attachment");

                if (!structIsEmpty(uploadedFile) && structKeyExists(uploadedFile, "serverFile")) {
                    var originalFileName = uploadedFile.serverFile; // This is the uploaded file name
                    var fileExtension = listLast(originalFileName, "."); // Extract extension
                    var uniqueFileName = createUUID() & "." & fileExtension; // Generate unique name

                    // Rename file to unique name
                    var newFilePath = uploadPath & "/" & uniqueFileName;
                    fileMove(uploadedFile.serverDirectory & "/" & originalFileName, newFilePath);

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
                details = {
                    "blog_id": response.blogId,
                    "title": params.title,
                    "ip_address": cgi.REMOTE_ADDR
                },
                userId = GetSignedInUserId()
            );

            renderText(response.message);
        } catch (any e) {
            model("Log").log(
                category = "wheels.blog",
                level = "ERROR",
                message = "Failed to save blog post",
                details = {
                    "error_message": e.message,
                    "error_detail": e.detail,
                    "error_type": e.type,
                    "title": params.title,
                    "ip_address": cgi.REMOTE_ADDR
                },
                userId = GetSignedInUserId()
            );
            // Handle error
            redirectTo(action="error", errorMessage="Failed to save blog post.");
        }
    }

    // Function to show a specific blog
    function show() {
        try {
            model("Log").log(
                category = "wheels.blog",
                level = "INFO",
                message = "Blog post viewed",
                details = {
                    "slug": params.slug,
                    "ip_address": cgi.REMOTE_ADDR
                },
                userId = GetSignedInUserId()
            );

            blogModel = model("Blog");

            // Get the blog by its slug
            blog = getBlogBySlug(params.slug);

            // If no blog is found, throw an error to be caught
            if (!structKeyExists(blog, "id")) {
                throw("Blog not found");
            }

            // Get other necessary data
            tags = getTagsByBlogid(blog.id);
            categories = getCategoriesByBlogid(blog.id);
            attachments = getAttachmentsByBlogid(blog.id);
            comments = getAllCommentsByBlogid(blog.id);

        } catch (any e) {
            model("Log").log(
                category = "wheels.blog",
                level = "ERROR",
                message = "Blog post not found",
                details = {
                    "error_message": e.message,
                    "error_detail": e.detail,
                    "slug": params.slug,
                    "ip_address": cgi.REMOTE_ADDR
                },
                userId = GetSignedInUserId()
            );
            // If an error occurs or blog not found, redirect to blog index
            redirectTo(action="index");
            return;
        }
    }

    // Function to update an existing blog
    public void function update() {
        // Get request parameters
        var blogModel = model("Blog");
        var blogId = params.id;

        try {
            model("Log").log(
                category = "wheels.blog",
                level = "INFO",
                message = "Blog post update attempted",
                details = {
                    "blog_id": blogId,
                    "title": params.title,
                    "ip_address": cgi.REMOTE_ADDR
                },
                userId = GetSignedInUserId()
            );

            // Set additional parameters from the form
            params.isDraft = isNumeric(params.isDraft) ? params.isDraft : 0;

            response = updateBlog(params, blogId);

            // Update relationships
            deleteBlogTags(blogId);
            deleteBlogCategories(blogId);

            // Handle tags which are passed as a comma-separated string in postTags
            if (structKeyExists(params, "postTags") && len(trim(params.postTags))) {
                params.tags = params.postTags;
                saveTags(params, blogId);
            }

            // Handle categories which are passed as selected values in categoryId
            if (structKeyExists(params, "categoryId") && len(trim(params.categoryId))) {
                saveCategories(params, blogId);
            }

            model("Log").log(
                category = "wheels.blog",
                level = "INFO",
                message = "Blog post updated successfully",
                details = {
                    "blog_id": blogId,
                    "title": params.title,
                    "ip_address": cgi.REMOTE_ADDR
                },
                userId = GetSignedInUserId()
            );

            redirectTo(route="blog");
        } catch (any e) {
            model("Log").log(
                category = "wheels.blog",
                level = "ERROR",
                message = "Failed to update blog post",
                details = {
                    "blog_id": blogId,
                    "error_message": e.message,
                    "error_detail": e.detail,
                    "error_type": e.type,
                    "title": params.title,
                    "ip_address": cgi.REMOTE_ADDR
                },
                userId = GetSignedInUserId()
            );
            // Handle error
            redirectTo(action="error", errorMessage="Failed to update blog post.");
        }
    }

    // function to check title is unique
    function checkTitle() {
        try {
            model("Log").log(
                category = "wheels.blog",
                level = "DEBUG",
                message = "Title uniqueness check",
                details = {
                    "title": form.title,
                    "id": structKeyExists(form, "id") ? form.id : 0,
                    "ip_address": cgi.REMOTE_ADDR
                },
                userId = GetSignedInUserId()
            );

            if(structKeyExists(form, "title")) {
                // Build the query condition
                var whereClause = "title='#form.title#'";

                // If we're in edit mode, exclude the current blog post
                if(structKeyExists(form, "id") && isNumeric(form.id) && form.id > 0) {
                    whereClause &= " AND id != #form.id#";
                }

                // Check if any other blogs have this title
                var blogModel = model("Blog").findAll(where=whereClause);

                if(blogModel.recordCount != 0) {
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
                    "error_message": e.message,
                    "error_detail": e.detail,
                    "title": form.title,
                    "id": structKeyExists(form, "id") ? form.id : 0,
                    "ip_address": cgi.REMOTE_ADDR
                },
                userId = GetSignedInUserId()
            );
            // Handle error
            renderText('<span class="text-danger">Error checking title: ' & e.message & '</span>');
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
                details = {
                    "blog_id": params.id,
                    "ip_address": cgi.REMOTE_ADDR
                },
                userId = GetSignedInUserId()
            );

            var message = deleteBlog(params.id);

            model("Log").log(
                category = "wheels.blog",
                level = "INFO",
                message = "Blog post deleted successfully",
                details = {
                    "blog_id": params.id,
                    "ip_address": cgi.REMOTE_ADDR
                },
                userId = GetSignedInUserId()
            );

            redirectTo(action="index", success="#message#");
        } catch (any e) {
            model("Log").log(
                category = "wheels.blog",
                level = "ERROR",
                message = "Failed to delete blog post",
                details = {
                    "error_message": e.message,
                    "error_detail": e.detail,
                    "blog_id": params.id,
                    "ip_address": cgi.REMOTE_ADDR
                },
                userId = GetSignedInUserId()
            );
            // Handle error
            redirectTo(action="index", errorMessage="Failed to delete blog post.");
        }
    }

    // Function to load categories for the dropdown
    function loadCategories() {
        model("Log").log(
            category = "wheels.blog",
            level = "DEBUG",
            message = "Categories dropdown loaded",
            details = {
                "ip_address": cgi.REMOTE_ADDR
            },
            userId = GetSignedInUserId()
        );
        categories = model("Category").getAll();
        renderPartial(partial="partials/categories");
    }

    // Function to load statuses for the dropdown
    function loadStatuses() {
        model("Log").log(
            category = "wheels.blog",
            level = "DEBUG",
            message = "Statuses dropdown loaded",
            details = {
                "ip_address": cgi.REMOTE_ADDR
            },
            userId = GetSignedInUserId()
        );
        statuses = model("PostStatus").getAll();
        renderPartial(partial="partials/statuses");
    }

    // Function to load post types for the dropdown
    function loadPostTypes() {
        model("Log").log(
            category = "wheels.blog",
            level = "DEBUG",
            message = "Post types dropdown loaded",
            details = {
                "ip_address": cgi.REMOTE_ADDR
            },
            userId = GetSignedInUserId()
        );
        postTypes = model("PostType").getAll();
        renderPartial(partial="partials/postTypes");
    }

    function error() {
        model("Log").log(
            category = "wheels.blog",
            level = "ERROR",
            message = "Error page displayed",
            details = {
                "ip_address": cgi.REMOTE_ADDR
            },
            userId = GetSignedInUserId()
        );
        // Add code to render the error page if needed
        renderPartial(partial="partials/_error");
    }

    public function feed() {
        model("Log").log(
            category = "wheels.blog",
            level = "INFO",
            message = "Blog feed accessed",
            details = {
                "ip_address": cgi.REMOTE_ADDR
            },
            userId = GetSignedInUserId()
        );

        // Fetch all blogs
        blogPosts = model("Blog").findAll(
            where="status = 'Approved' AND isPublished = 'true'",
            include="User",
            order="postDate DESC"
        );

        // Render the feed view
        renderPartial(partial="partials/feed");
    }

    public function commentsFeed() {
        model("Log").log(
            category = "wheels.blog",
            level = "INFO",
            message = "Blog comments feed accessed",
            details = { "ip_address": cgi.REMOTE_ADDR },
            userId = GetSignedInUserId()
        );

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
        for (comment in comments) {
            if (!arrayContains(authorIds, comment.authorId)) {
                arrayAppend(authorIds, comment.authorId);
            }
        }

        // Fetch all related users at once
        authors = model("User").findAll(where="id IN (#arrayToList(authorIds)#)", returnAs="structs");

        // Map authors by ID for quick lookup
        authorMap = {};
        for (author in authors) {
            authorMap[author.id] = author;
        }

        renderPartial(partial="partials/commentsFeed", locals={
            comments = comments,
            authorMap = authorMap
        });

    }

    // Business Logic

    private function getAll() {
        return model("Blog").findAll();
    }

    private function getAllBlogs(numeric page=1, numeric perPage=6, boolean isInfiniteScroll=false) {
        var result = {
            query = model("Blog").findAll(
                where="statusid <> 1 AND status = 'Approved' AND isPublished = 'true'",
                include="User",
                order="postDate DESC",
                page = arguments.page,
                perPage = arguments.perPage
            ),
            hasMore = false,
            totalCount = 0
        };

        result.totalCount = model("Blog").count(
            where="statusid <> 1 AND status = 'Approved' AND isPublished = 'true'"
        );
        result.hasMore = (page * perPage) < result.totalCount;

        return result;
    }

    private function getBlogsByMonthYear(required numeric year, required string month, numeric page=1, numeric perPage=6, boolean isInfiniteScroll=false) {
        // Create start and end date for the selected month
        var startdate = "#year#-#NumberFormat(month, '00')#-01 00:00:00";
        var enddate = "#year#-#NumberFormat(month, '00')#-#DaysInMonth('#year#-#NumberFormat(month, '00')#-01')# 23:59:59";

        var result = {
            query = model("Blog").findAll(
                where="blog_posts.post_created_date BETWEEN '#startdate#' AND '#enddate#' AND blog_posts.status='Approved'",
                order="createdat DESC",
                include="User",
                returnAs="query",
                page = arguments.page,
                perPage = arguments.perPage
            ),
            hasMore = false,
            totalCount = 0
        };

        result.totalCount = model("Blog").count(
            where="blog_posts.post_created_date BETWEEN '#startdate#' AND '#enddate#' AND blog_posts.status='Approved'"
        );
        result.hasMore = (page * perPage) < result.totalCount;

        return result;
    }

    // Fetch Blogs by Category
    public function getBlogsByCategory(required string categoryName, numeric page=1, numeric perPage=6, boolean isInfiniteScroll=false) {
        // Get category ID from name
        var category = model("Category").findOne(where="name = '#arguments.categoryName#'");
        if (!isObject(category)) return {query=queryNew(""), hasMore=false, totalCount=0};

        // Get all blog-category mappings with that category
        var blogCategoryQuery = model("BlogCategory")
            .findAll(where="categoryId = '#category.id#'", returnAs="query");
        if (blogCategoryQuery.recordCount == 0) return {query=queryNew(""), hasMore=false, totalCount=0};

        // Extract blogIds
        var blogIds = blogCategoryQuery.columnData("blogId");

        var result = {
            query = model("Blog").findAll(
                where="id IN (#arrayToList(blogIds)#) AND categoryId = '#category.id#' AND status ='Approved' AND isPublished='true'",
                order="createdAt DESC",
                include="User,BlogCategory",
                returnAs="query",
                page = arguments.page,
                perPage = arguments.perPage
            ),
            hasMore = false,
            totalCount = 0
        };

        result.totalCount = model("Blog").count(
            where="id IN (#arrayToList(blogIds)#) AND categoryId = '#category.id#' AND status ='Approved' AND isPublished='true'",
            include="User,BlogCategory"
        );
        result.hasMore = (page * perPage) < result.totalCount;

        return result;
    }

    // Fetch Blogs by Tag
    private function getAllByTag(required string tag, numeric page=1, numeric perPage=6, boolean isInfiniteScroll=false) {
        var result = {
            query = model("Blog").findAll(
                where="name = '#tag#'",
                order="createdAt DESC",
                include="User,tag",
                returnAs="query",
                page = arguments.page,
                perPage = arguments.perPage
            ),
            hasMore = false,
            totalCount = 0
        };

        result.totalCount = model("Blog").count(where="name = '#tag#'");
        result.hasMore = (page * perPage) < result.totalCount;

        return result;
    }

    private function getBlogById(required numeric id) {
        return model("Blog").findOne(
            where="blog_posts.id = #arguments.id#",
            include="User, PostStatus",
            options={
                sql="SELECT blog_posts.title AS blogTitle, blog_posts.content AS blogContent,
                    blog_posts.createdat AS createdDate,
                    users.fullName AS authorName,
                    post_statuses.name AS statusName
                    FROM blog_posts
                    INNER JOIN users ON users.id = blog_posts.userId
                    INNER JOIN post_statuses ON post_statuses.id = blog_posts.statusId
                    WHERE blog_posts.id = #arguments.id#"
            }
        );
    }

    private function saveBlog(required struct blogData) {
        var response = { "message": "", "blogId": 0 };

        // Generate slug
        var slug = rereplace(lcase(blogData.title), "[^a-z0-9]", "-", "all"); // Replace non-alphanumeric with "-"
        slug = rereplace(slug, "-+", "-", "all");
        blogData.slug = slug;


        if (blogData.isdraft eq 1) {
            blogData.statusId = 1; // Draft
        } else {
            blogData.statusId = 2; // Under Review
        }

        try {
            // Check if the blog ID is greater than 0 (editing an existing post)
            if (structKeyExists(blogData, "id") && blogData.id > 0) {
                var blog = model("Blog").findByKey(blogData.id);

                if (not isNull(blog)) {
                    // Update the existing blog post
                    blog.title = blogData.title;
                    blog.content = blogData.content;
                    blog.statusId = blogData.statusId;
                    blog.postTypeId = blogData.postTypeId;
                    blog.slug = blogData.slug;
                    blog.updatedAt = now();
                    blog.updatedBy = GetSignedInUserId();
                    blog.save();

                    response.blogId = blog.id;
                    response.message = "Blog post updated successfully.";
                } else {
                    response.message = "Blog post not found for editing.";
                }
            } else {
                // Check if a blog post with the same title already exists
                var existingBlog = model("Blog").findFirst(
                    where="title = '#blogData.title#' AND slug = '#blogData.slug#'"
                );

                if (!isObject(existingBlog)) {
                    // Create a new blog post
                    var newBlog = model("Blog").new();
                    newBlog.title = blogData.title;
                    newBlog.content = blogData.content;
                    newBlog.slug = blogData.slug;
                    newBlog.statusId = blogData.statusId;
                    newBlog.postTypeId = blogData.postTypeId;
                    newBlog.coverImagePath = blogData.coverImagePath;
                    newBlog.createdAt = now();
                    newBlog.updatedAt = now();
                    newBlog.createdBy = GetSignedInUserId();
                    if(blogData.postCreatedDate neq " "){
                        newBlog.postCreatedDate = blogData.postCreatedDate;
                    } else {
                        newBlog.postCreatedDate = now();
                    }
                    newBlog.save();

                    response.blogId = newBlog.id;
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

    // Helper function to update blog post
    function updateBlog(required struct params, required numeric blogId) {
        var response = { "success": false, "message": "", "blogId": blogId };

        try {
            // Find the blog by ID
            var blog = model("Blog").findByKey(blogId);

            if (isNull(blog)) {
                response.message = "Blog post not found for updating.";
                return response;
            }

            // Generate slug
            var slug = rereplace(lcase(params.title), "[^a-z0-9]", "-", "all"); // Replace non-alphanumeric with "-"
            slug = rereplace(slug, "-+", "-", "all");
            params.slug = slug;

            // Set status based on isDraft flag
            if (structKeyExists(params, "isDraft") && params.isDraft eq 1) {
                params.statusId = 1; // Draft
            } else {
                params.statusId = 2; // Under Review
            }

            // Check if a blog with the same title/slug exists (that isn't this one)
            var existingBlog = model("Blog").findFirst(
                where="title = '#params.title#' AND slug = '#params.slug#' AND id != #blogId#"
            );

            if (isObject(existingBlog)) {
                response.message = "Another blog post with the same title already exists.";
                return response;
            }

            // Update the blog post
            blog.title = params.title;
            blog.content = params.content;
            blog.slug = params.slug;
            blog.statusId = params.statusId;

            // Only update these if they exist in params
            if (structKeyExists(params, "postTypeId")) {
                blog.postTypeId = params.postTypeId;
            }

            if (structKeyExists(params, "postCreatedDate") && len(trim(params.postCreatedDate))) {
                blog.postCreatedDate = params.postCreatedDate;
            }

            // Update tracking fields
            blog.updatedAt = now();
            blog.updatedBy = GetSignedInUserId();

            // Save the blog post
            blog.save();

            response.success = true;
            response.message = "Blog post updated successfully.";
        }
        catch (any e) {
            response.message = "Error updating blog: " & e.message;
            model("Log").log(
                category = "wheels.blog",
                level = "ERROR",
                message = "Error in updateBlog function",
                details = {
                    "blog_id": blogId,
                    "error_message": e.message,
                    "error_detail": e.detail,
                    "error_type": e.type
                },
                userId = GetSignedInUserId()
            );
        }

        return response;
    }

    private function deleteBlog(required numeric id) {
        var message = "";

        try {
            var blog = model("Blog").findByKey(id);

            if (not isNull(blog)) {
                blog.isDeleted = true;
                blog.updatedAt = now();
                blog.updatedBy = 1; // Replace with logged-in user ID
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

    function saveTags(required struct blogData, blogId) {
        try {
            if (blogId > 0 && structKeyExists(blogData, "postTags")) {

                var tagArray = listToArray(blogData.postTags, ","); // Convert postTags string into an array

                // Insert new tags
                for (var tagName in tagArray) {
                    var newTag = model("Tag").new();
                    newTag.name = trim(tagName); // Trim spaces if any
                    newTag.blogId = blogId;
                    newTag.createdAt = now();
                    newTag.updatedAt = now();
                    newTag.save();
                }
            }
        } catch (any e) {
            local.exception = e;
        }
    }

    // Function to delete tags associated with a blog post
    function deleteBlogTags(required numeric blogId) {
        try {
            if (blogId > 0) {
                // direct delete approach
                model("Tag").deleteAll(where="blogId = #blogId#");

                return true;
            }
            return false;
        } catch (any e) {
            model("Log").log(
                category = "wheels.blog",
                level = "ERROR",
                message = "Failed to delete blog tags",
                details = {
                    "blog_id": blogId,
                    "error_message": e.message,
                    "error_detail": e.detail,
                    "error_type": e.type
                },
                userId = GetSignedInUserId()
            );
            return false;
        }
    }

    // Categories

    function getAllCategories() {
        return model("Category").findAll();
    }

    function saveCategories(required struct blogData, blogId) {
        try {
            if (blogId > 0 && structKeyExists(blogData, "categoryId")) {

                var categoryArray = listToArray(blogData.categoryId, ","); // Convert categoryId string into an array

                // Insert new categories
                for (var category_Id in categoryArray) {
                    var newCategory = model("BlogCategory").new();
                    newCategory.categoryId = category_Id;
                    newCategory.blogId = blogId;
                    newCategory.createdAt = now();
                    newCategory.updatedAt = now();
                    newCategory.save();
                }
            }
        } catch (any e) {
    model("Log").log(
        category = "wheels.blog.tags",
        level = "ERROR",
        message = "Failed to save blog tags for blogId: #blogId#",
        details = {
            "blog_id": blogId,
            "error_message": e.message,
            "error_detail": e.detail,
            "error_type": e.type
        },
        userId = GetSignedInUserId()
    );
        }
    }

    // Function to delete categories associated with a blog post
    function deleteBlogCategories(required numeric blogId) {
        try {
            if (blogId > 0) {
                // Find all category associations for this blog post
                model("BlogCategory").deleteAll(where="blogId = #blogId#");

                return true;
            }
            return false;
        } catch (any e) {
            model("Log").log(
                category = "wheels.blog",
                level = "ERROR",
                message = "Failed to delete blog categories",
                details = {
                    "blog_id": blogId,
                    "error_message": e.message,
                    "error_detail": e.detail,
                    "error_type": e.type
                },
                userId = GetSignedInUserId()
            );
            return false;
        }
    }

    //Attachement

    function getAllAttachments() {
        return model("Attachment").findAll();
    }

    function getAllCommentsByBlogid(required numeric id) {
        var comments = model("Comment").findAll(include="User", where="isPublished = 1 AND blogid = '#arguments.id#' AND commentParentId ISNULL ");

        return comments;
    }

    public struct function uploadFile(file) {
        var uploadPath = expandPath("/public/files");
        var filePath = uploadPath & file.serverFileName;

        // Ensure the upload directory exists
        if (!directoryExists(uploadPath)) {
            directoryCreate(uploadPath);
        }

        // Move the uploaded file to the upload directory
        fileWrite(filePath, file.fileContent);

        return {
            filePath: filePath,
            fileName: file.serverFileName
        };
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
                    details = {
                        "userId": GetSignedInUserId(),
                        "ip_address": cgi.REMOTE_ADDR
                    }
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
            if(structKeyExists(response, "Id")){
                comments = commentModel.findAll(include="User", where="id ='#response.Id#' AND isPublished = 1");
                renderPartial(partial="partials/comment");
            }
        } catch (any e) {
            // Handle error
            flashInsert(error="Failed to save comment.");
            redirectTo(action="error");
        }
    }

    private function saveComment(required struct commentData) {
        var response = { "message": "", "blogId": 0 };

        try {
            // Check if the commentParentId is greater than 0 (saving reply against a comment)
            if (structKeyExists(commentData, "commentParentId") && commentData.commentParentId > 0) {

                // Create a new comment(reply)
                var newComment = model("Comment").new();
                newComment.content = commentData.content;
                newComment.commentParentId = commentData.commentParentId;
                newComment.blogId = commentData.blogId;
                newComment.publishedAt = now();
                newComment.createdAt = now();
                newComment.updatedAt = now();
                newComment.authorId = GetSignedInUserId();
                newComment.isPublished = Published();
                newComment.save();

                response.Id = newComment.Id;
                response.blogId = newComment.blogId;
                response.message = "comment created successfully.";
            } else {
                // Create a new comment
                var newComment = model("Comment").new();
                newComment.content = commentData.content;
                newComment.blogId = commentData.blogId;
                newComment.publishedAt = now();
                newComment.createdAt = now();
                newComment.updatedAt = now();
                newComment.authorId = GetSignedInUserId();
                newComment.isPublished = Published();
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
}
