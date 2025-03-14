// Frontend blog page
component extends="app.Controllers.Controller" {

    // Configuration function
    function config() {
        verifies(except="index,create,store,show,update,destroy,loadCategories,loadStatuses,loadPostTypes,Categories,blogs", params="key", paramsTypes="integer", handler="index");
        usesLayout("/layout");
    }

    private function restrictAccess() {
        // Ensure only blog editors can access these methods
        bloguser = isUserLoggedIn()
        if (!bloguser) {
            redirectTo(controller="AuthController", action="login", route="auth-login");
            return false;
        }
        return true;
    }

    // Function to list all blogs
    function index() {
    }

    // load blog list
    function blogs() {
        
        var blogModel = model("Blog"); // Get model instance
        var blogService = new app.services.BlogService(blogModel);

        // Ensure default values if params are missing
        param name="year" default="";
        param name="month" default="";
        param name="category_id" default="";
        if (!len(year) && !len(month) && !len(category_id)) {

            // If no year/month is selected, show all blogs
            blogs = blogModel.getAll();
        } else if (!len(year) || !len(month)) {

            // Fetch blogs filtered by month and year
            blogs = blogService.getAllByCategory(category_id);
        } else {
            // Fetch blogs filtered by month and year
            blogs = blogService.getAllByDate(month, year);
            
        }
        renderPartial(partial="partials/blogList", locals={blogs: blogs});
    }

    // Function to load categories for the blog list
    function Categories() {
        categorylist = model("Category").getAll();
        renderPartial(partial="partials/categorylist");
    }

    // Function to show the create blog form
    function create() {
        restrictAccess();
        renderView(layout="blogLayout");
    }

    // Function to store a new blog
    public void function store() {
        // Get request parameters
        var blogModel = model("Blog"); 
        var blogService = new app.services.BlogService(blogModel);

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

            response = blogService.saveBlog(params);
            tagService = new app.services.TagService(model("Tag"));
            tagService.saveTags(params, response.blogId);
            redirectTo(action="index");
        } catch (any e) {
            // Handle error
            redirectTo(action="error", errorMessage="Failed to save blog post.");
        }
    }

    // Function to show a specific blog
    function show() {
        blogModel = model("Blog"); // Get model instance
        blogService = new app.services.BlogService(blogModel);
        tagService = new app.services.TagService(model("Tag"));
        attachmentService = new app.services.AttachmentService(model("Attachment"));

        blog = blogService.getBlogBySlug(params.slug);
        blogs = blogModel.getAll();
        tags = tagService.getTagsByBlogid(blog.id);
        attachments = attachmentService.getAttachmentsByBlogid(blog.id);
        
    }

    // Function to update an existing blog
    function update() {
        var blogModel = model("Blog"); // Get model instance
        var blogService = new app.services.BlogService(blogModel);
        try {
            var message = blogService.updateBlog(params);
            redirectTo(action="show", id=params.id, success="#message#");
        } catch (any e) {
            // Handle error
            redirectTo(action="show", id=params.id, errorMessage="Failed to update blog post.");
        }
    }

    // Function to delete a blog
    function destroy() {
        var blogModel = model("Blog"); // Get model instance
        var blogService = new app.services.BlogService(blogModel);
        try {
            var message = blogService.deleteBlog(params.id);
            redirectTo(action="index", success="#message#");
        } catch (any e) {
            // Handle error
            redirectTo(action="index", errorMessage="Failed to delete blog post.");
        }
    }

    // Function to load categories for the dropdown
    function loadCategories() {
        categories = model("Category").getAll();
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
}