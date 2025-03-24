// Frontend blog page
component extends="app.Controllers.Controller" {

    // Configuration function
    function config() {
        verifies(except="index,create,store,show,update,destroy,loadCategories,loadStatuses,loadPostTypes,Categories,blogs", params="key", paramsTypes="integer", handler="index");
        filters(through="restrictAccess", only="create,store");
        usesLayout("/layout");
    }

    // Function to list all blogs
    function index() {
    }

    // load blog list
    function blogs() {
        
        var blogModel = model("Blog"); // Get model instance

        // Ensure default values if params are missing
        param name="year" default="";
        param name="month" default="";
        param name="category_id" default="";
        if (!len(year) && !len(month) && !len(category_id)) {

            // If no year/month is selected, show all blogs
            blogs = blogModel.getAll();
        } else if (!len(year) || !len(month)) {

            // Fetch blogs filtered by month and year
            // blogs = getAllByCategory(category_id);
        } else {
            // Fetch blogs filtered by month and year
            blogs = getAllByDate(month, year);
            
        }
        renderPartial(partial="partials/blogList", locals={blogs: blogs});
    }

    // Function to load categories for the blog list
    function categories() {
        categorylist = model("BlogCategory").getAll();
        renderPartial(partial="partials/categorylist");
    }

    // Function to show the create blog form
    function create() {
        renderView(layout="blogLayout");
    }

    // Function to store a new blog
    public void function store() {
        // Get request parameters
        var blogModel = model("Blog"); 
        try {
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
            redirectTo(action="index");
        } catch (any e) {
            // Handle error
            redirectTo(action="error", errorMessage="Failed to save blog post.");
        }
    }

    // Function to show a specific blog
    function show() {
        try {
            blogModel = model("Blog");
            
            // Get the blog by its slug
            blog = getBlogBySlug(params.slug);
            
            // If no blog is found, throw an error to be caught
            if (!structKeyExists(blog, "id")) {
                throw("Blog not found");
            }

            // Get other necessary data
            blogs = blogModel.getAll();
            tags = getTagsByBlogid(blog.id);
            categories = getCategoriesByBlogid(blog.id);
            attachments = getAttachmentsByBlogid(blog.id);
            
        } catch (any e) {
            // If an error occurs or blog not found, redirect to blog index
            redirectTo(action="index");
            return;
        }
    }


    // Function to update an existing blog
    function update() {
        var blogModel = model("Blog"); // Get model instance
        try {
            var message = updateBlog(params);
            redirectTo(action="show", id=params.id, success="#message#");
        } catch (any e) {
            // Handle error
            redirectTo(action="show", id=params.id, errorMessage="Failed to update blog post.");
        }
    }

    // Function to delete a blog
    function destroy() {
        var blogModel = model("Blog"); // Get model instance
        try {
            var message = deleteBlog(params.id);
            redirectTo(action="index", success="#message#");
        } catch (any e) {
            // Handle error
            redirectTo(action="index", errorMessage="Failed to delete blog post.");
        }
    }

    // Function to load categories for the dropdown
    function loadCategories() {
        categories = model("BlogCategory").getAll();
        renderPartial(partial="partials/categories");
    }

    // Function to load statuses for the dropdown
    function loadStatuses() {
        statuses = model("PostStatus").getAll();
        renderPartial(partial="partials/statuses");
    }

    // Function to load post types for the dropdown
    function loadPostTypes() {
        postTypes = model("PostType").getAll();
        renderPartial(partial="partials/postTypes");
    }

    function error() {
        // Add code to render the error page if needed
        renderPartial(partial="partials/_error");
    }

    // Business Logic

    private function getAll() {
        return model("Blog").findAll();
    }

    private function getAllBlogs() {
        return model("Blog").findAll(
            include="User, PostStatus, PostType",
            order="createdAt DESC"
        );
    }

    private function getAllByDate(required numeric month, required numeric year){
        return model("Blog").findAll(
            // where="id=1 AND title = 'test'",
            // where="MONTH(createdAt) = 3",
            // where="YEAR(createdAt) = '#val(year)#' AND MONTH(createdAt) = '#val(month)#'",
            // order="createdAt DESC",
            // include="User",
            // returnAs="query"
        );
    }
    
    // Fetch Blogs by Category
    private function getAllByCategory(required numeric categoryId){
        return model("Blog").findAll(
            where='categoryId = #val(categoryId)#',
            order="createdAt DESC",
            include="User",
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
                    -- categories.name AS categoryName, 
                    post_statuses.name AS statusName 
                    FROM blog_posts 
                    INNER JOIN users ON users.id = blog_posts.userId
                    -- INNER JOIN categories ON categories.id = blog_posts.categoryId
                    INNER JOIN post_statuses ON post_statuses.id = blog_posts.statusId 
                    WHERE blog_posts.id = #arguments.id#"
            }
        );
    }

    private function getBlogBySlug(required string slug) {
        // return model("Blog").findOne(where="slug = #arguments.slug#");
        return model("Blog").findOne(
            where="blog_posts.slug = '#arguments.slug#'",
            include="User, PostStatus",
            options={
                sql="SELECT blog_posts.title AS blogTitle, blog_posts.content AS blogContent, 
                    blog_posts.createdat AS createdDate, 
                    users.fullName AS authorName, 
                    -- categories.name AS categoryName, 
                    post_statuses.name AS statusName 
                    FROM blog_posts 
                    INNER JOIN users ON users.id = blog_posts.userId
                    -- INNER JOIN categories ON categories.id = blog_posts.categoryId
                    INNER JOIN post_statuses ON post_statuses.id = blog_posts.statusId 
                    WHERE blog_posts.slug = '#arguments.slug#'"
            }
        );
    }

    private function saveBlog(required struct blogData) {
        var response = { "message": "", "blogId": 0 };
    
        // Generate slug
        var slug = rereplace(lcase(blogData.title), "[^a-z0-9 ]", "-", "all");
        blogData.slug = replace(slug,  "\s+", "-", "all");
        
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

    private function Approve(id){
        var blog = model("Blog").findByKey(arguments.id);
        
        if (!isNull(blog)) {
            
            blog.status = "Approved"; //approved            
            if (blog.save()) {
                return {
                    success = true,
                    message = "blog status approved successfully"
                };
            } else {
                return {
                    success = false,
                    errors = blog.allErrors(),
                    message = "Failed to approve blog status"
                };
            }
        }
        
        return {
            success = false,
            message = "blog not found"
        };
    }
    
    private function Reject(id){
        var blog = model("Blog").findByKey(arguments.id);
        
        if (!isNull(blog)) {
            
            blog.status = "Rejected"; //reject
            
            if (blog.save()) {
                return {
                    success = true,
                    message = "blog status rejected successfully"
                };
            } else {
                return {
                    success = false,
                    errors = blog.allErrors(),
                    message = "Failed to reject blog status"
                };
            }
        }
        
        return {
            success = false,
            message = "blog not found"
        };
    }

    // Tags
    function getAllTags() {
        return model("Tag").findAll();
    }
    
    function getTagsByBlogid(required numeric id) {
        return model("Tag").findAll(include="Blog", where="blogid = #arguments.id#");
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
    
    function getCategoriesByBlogid(required numeric id) {
        return model("Category").findAll(include="Blog,BlogCategory", where="blogid = #arguments.id#");
    }

    function saveCategories(required struct blogData, blogId) {
        try {
            if (blogId > 0 && structKeyExists(blogData, "categoryId")) {
                
                var categoryArray = listToArray(blogData.categoryId, ","); // Convert categoryId string into an array
    
                // Insert new categories
                for (var category_Id in categoryArray) {
                    var newCategory = model("Category").new();
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
    
    function getAttachmentsByBlogid(required numeric id) {
        return model("Attachment").findAll(include="Blog", where="blogid = #arguments.id#");
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
}