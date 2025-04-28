// Frontend blog page
component extends="app.Controllers.Controller" {

    // Configuration function
    function config() {
        verifies(except="index,create,store,show,update,destroy,loadCategories,loadStatuses,loadPostTypes,Categories,blogs,comment,feed,error,checkTitle", params="key", paramsTypes="integer", handler="index");
        filters(through="restrictAccess", only="create,store,comment");
        usesLayout("/layout");
    }

    // Function to list all blogs
    public void function index() {
        model("Log").log(
            category = "wheels.blog",
            level = "INFO",
            message = "Blog index page accessed",
            details = {
                "ip_address": cgi.REMOTE_ADDR,
                "user_agent": cgi.HTTP_USER_AGENT
            },
            userId = structKeyExists(session, "userID") ? session.userID : 0
        );
    }

    public void function blogs() {
        try {
            model("Log").log(
                category = "wheels.blog",
                level = "DEBUG",
                message = "Blog listing page accessed",
                details = {
                    "filter_type": structKeyExists(params, "filterType") ? params.filterType : "",
                    "filter_value": structKeyExists(params, "filterValue") ? params.filterValue : "",
                    "ip_address": cgi.REMOTE_ADDR
                },
                userId = structKeyExists(session, "userID") ? session.userID : 0
            );

            var blogModel = model("Blog"); // Load model

            // --- Filter by category or tag ---
            if (structKeyExists(params, "filterType") && structKeyExists(params, "filterValue")) {
                // Normalize value (e.g., convert "design-ui" to "design.ui")
                params.filterValue = replace(params.filterValue, "-", ".", "all");

                // If filterType is a year and filterValue is a month (numeric), handle as archive
                if (isNumeric(params.filterType) && isNumeric(params.filterValue)) {
                    blogs = getBlogsByMonthYear(params.filterType, params.filterValue);
                } else {
                    switch (lcase(params.filterType)) {
                        case "category":
                            blogs = getBlogsByCategory(params.filterValue);
                            break;
                        case "tag":
                            blogs = getAllByTag(params.filterValue);
                            break;
                        default:
                            blogs = getAllBlogs(); // fallback in case of unknown filterType
                    }
                }
            } else {
                blogs = getAllBlogs(); // default listing
            }

            renderPartial(partial="partials/blogList");
        } catch (any e) {
            model("Log").log(
                category = "wheels.blog",
                level = "ERROR",
                message = "Error in blogs(): #e.message#",
                details = {
                    "error_message": e.message,
                    "error_detail": e.detail,
                    "error_type": e.type,
                    "ip_address": cgi.REMOTE_ADDR
                },
                userId = structKeyExists(session, "userID") ? session.userID : 0
            );

            // Optionally show fallback
            blogs = getAllBlogs(); // fallback content
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
            userId = structKeyExists(session, "userID") ? session.userID : 0
        );
        categorylist = model("Category").getAll();
        renderPartial(partial="partials/categorylist");
    }

    // Function to show the create blog form
    function create() {
        model("Log").log(
            category = "wheels.blog",
            level = "INFO",
            message = "Blog creation form accessed",
            details = {
                "ip_address": cgi.REMOTE_ADDR
            },
            userId = structKeyExists(session, "userID") ? session.userID : 0
        );
        saveRedirectUrl(cgi.script_name & "?" & cgi.query_string);
    }

    // Function to store a new blog
    public void function store() {
        // Get request parameters
        var blogModel = model("Blog"); 
        try {
            model("Log").log(
                category = "wheels.blog",
                level = "INFO",
                message = "New blog post creation attempted",
                details = {
                    "title": params.title,
                    "ip_address": cgi.REMOTE_ADDR
                },
                userId = structKeyExists(session, "userID") ? session.userID : 0
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
                userId = structKeyExists(session, "userID") ? session.userID : 0
            );

            redirectTo(route="blog");
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
                userId = structKeyExists(session, "userID") ? session.userID : 0
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
                userId = structKeyExists(session, "userID") ? session.userID : 0
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
                userId = structKeyExists(session, "userID") ? session.userID : 0
            );
            // If an error occurs or blog not found, redirect to blog index
            redirectTo(action="index");
            return;
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
                    "ip_address": cgi.REMOTE_ADDR
                },
                userId = structKeyExists(session, "userID") ? session.userID : 0
            );

            if(structKeyExists(form, "title")){
                var blogModel = model("Blog").findAll(where="title='#form.title#'");
                if(blogModel.recordCount != 0){
                    renderText('<span class="text-danger">A blog already exist with this title!</span><input type="hidden" id="titleExists" value="1">');
                }else{
                    renderText('<input type="hidden" id="titleExists" value="0">');
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
                    "ip_address": cgi.REMOTE_ADDR
                },
                userId = structKeyExists(session, "userID") ? session.userID : 0
            );
            // Handle error
            renderText("Error: " & e);
        }
    }

    // Function to update an existing blog
    function update() {
        var blogModel = model("Blog"); // Get model instance
        try {
            model("Log").log(
                category = "wheels.blog",
                level = "INFO",
                message = "Blog post update attempted",
                details = {
                    "blog_id": params.id,
                    "ip_address": cgi.REMOTE_ADDR
                },
                userId = structKeyExists(session, "userID") ? session.userID : 0
            );

            var message = updateBlog(params);

            model("Log").log(
                category = "wheels.blog",
                level = "INFO",
                message = "Blog post updated successfully",
                details = {
                    "blog_id": params.id,
                    "ip_address": cgi.REMOTE_ADDR
                },
                userId = structKeyExists(session, "userID") ? session.userID : 0
            );

            redirectTo(action="show", id=params.id, success="#message#");
        } catch (any e) {
            model("Log").log(
                category = "wheels.blog",
                level = "ERROR",
                message = "Failed to update blog post",
                details = {
                    "error_message": e.message,
                    "error_detail": e.detail,
                    "blog_id": params.id,
                    "ip_address": cgi.REMOTE_ADDR
                },
                userId = structKeyExists(session, "userID") ? session.userID : 0
            );
            // Handle error
            redirectTo(action="show", id=params.id, errorMessage="Failed to update blog post.");
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
                userId = structKeyExists(session, "userID") ? session.userID : 0
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
                userId = structKeyExists(session, "userID") ? session.userID : 0
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
                userId = structKeyExists(session, "userID") ? session.userID : 0
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
            userId = structKeyExists(session, "userID") ? session.userID : 0
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
            userId = structKeyExists(session, "userID") ? session.userID : 0
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
            userId = structKeyExists(session, "userID") ? session.userID : 0
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
            userId = structKeyExists(session, "userID") ? session.userID : 0
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
            userId = structKeyExists(session, "userID") ? session.userID : 0
        );
        // Fetch all blogs
        blogPosts = model("Blog").findAll(include="User", order="createdAt DESC", limit=20);
        
        // Render the feed view
        renderPartial(partial="partials/feed");
    }

    // Business Logic

    private function getAll() {
        return model("Blog").findAll();
    }

    private function getAllBlogs() {
        return model("Blog").findAll(
            where="statusid <> 1 AND status ='Approved'",
            include="User, PostStatus, PostType",
            order = "COALESCE(post_created_date, blog_posts.createdat) DESC"
        );
    }

    private function getBlogsByMonthYear(required numeric year, required string month) {
        // Create start and end date for the selected month
        var startdate = "#year#-#NumberFormat(month, '00')#-01 00:00:00";
        var enddate = "#year#-#NumberFormat(month, '00')#-#DaysInMonth('#year#-#NumberFormat(month, '00')#-01')# 23:59:59";

        return model("Blog").findAll(
            where="blog_posts.post_created_date BETWEEN '#startdate#' AND '#enddate#'",
            order="createdat DESC",
            include="User",
            returnAs="query"
        );
    }
    
    // Fetch Blogs by Category
    public function getBlogsByCategory(required string categoryName) {
        // Get category ID from name
        var category = model("Category").findOne(where="name = '#arguments.categoryName#'");
        if (!isObject(category)) return [];

        // Get all blog-category mappings with that category
        var blogCategoryQuery = model("BlogCategory")
            .findAll(where="categoryId = #category.id#", returnAs="query");

        if (blogCategoryQuery.recordCount == 0) return [];

        // Extract blogIds
        var blogIds = blogCategoryQuery.columnData("blogId");

        // Get blog posts with matching IDs
        return model("Blog").findAll(
            where="id IN (#arrayToList(blogIds)#) AND category_id = '#category.id#'",
            order="createdAt DESC",
            include="User,BlogCategory",
            returnAs="query"
        );
    }
    
    // Fetch Blogs by Tag
    private function getAllByTag(required string tag){
        return model("Blog").findAll(
            where="name = '#tag#'",
            order="createdAt DESC",
            include="User,tag",
            returnAs="query"
        );
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
                var blog = model("Blog").findById(blogData.id);
    
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

    /**
    * Saves a new blog post
    */
    private function saveNewBlog(required struct blogData) {
        var response = { "message": "", "blogId": 0 };

        // Check for duplicate title
        var existingBlog = model("Blog").findOne(
            where="title = #blogData.title# AND slug = #blogData.slug#"
        );

        if (!isObject(existingBlog)) {
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
            
            if (len(trim(blogData.postCreatedDate))) {
                newBlog.postCreatedDate = blogData.postCreatedDate;
            }

            newBlog.save();
            response.blogId = newBlog.id;
            response.message = "Blog post created successfully.";
        } else {
            response.message = "A blog post with the same title already exists.";
        }

        return response;
    }

    /**
    * Updates an existing blog post
    */
    private function updateBlog(required struct blogData) {
        var response = { "message": "", "blogId": 0 };

        var blog = model("Blog").findById(blogData.id);

        if (!isNull(blog)) {
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

        return response;
    } 

    private function updateBlog(required struct blogData) {
        return saveBlog(blogData);
    }

    private function deleteBlog(required numeric id) {
        var message = "";

        try {
            var blog = model("Blog").findById(id);

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
            local.exception = e;
        }
    }

    //Attachement

    function getAllAttachments() {
        return model("Attachment").findAll();
    }
    
    function getAllCommentsByBlogid(required numeric id) {
        var comments = model("Comment").findAll(include="User", where='isPublished = 1 AND blogid = #arguments.id#');
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
            blog = getBlogById(params.blogId);
            if (params.content.trim() == "" || params.content.trim() == "<p><br></p>") {
            } else {
                response = saveComment(params);
            }
            redirectTo(action="show", slug=blog.slug);
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

                response.blogId = newComment.blogId;
                response.message = "comment created successfully.";
            }
        } catch (any e) {
            response.message = "Error: " & e.message;
        }
    
        return response;
    }  
}