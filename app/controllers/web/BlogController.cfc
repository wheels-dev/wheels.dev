// Frontend blog page
component extends="app.Controllers.Controller" {

    // Configuration function
    function config() {
        verifies(except="index,create,store,show,update,destroy,loadCategories,loadStatuses,loadPostTypes", params="key", paramsTypes="integer", handler="index");
        usesLayout("/layout");
    }

    // Function to list all blogs
    function index() {
        var blogModel = model("Blog"); // Get model instance
        var blogService = new app.services.BlogService(blogModel);
            
        blogs = blogModel.getAll();
    }

    // Function to show the create blog form
    function create() {
        renderView(layout="blogLayout");
    }

    // Function to store a new blog
    function store() {
        var blogModel = model("Blog"); // Get model instance
        var blogService = new app.services.BlogService(blogModel);
        try {
            var message = blogService.saveBlog(params);
            redirectTo(action="index", success="#message#");
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

        blog = blogService.getBlogById(params.id);
        blogs = blogModel.getAll();
        tags = tagService.getTagsByBlogid(params.id);
        attachments = attachmentService.getAttachmentsByBlogid(params.id);
        
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