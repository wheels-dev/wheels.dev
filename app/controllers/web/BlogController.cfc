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
        var blogs = blogService.getAll();
        // Add code to render the blogs if needed
    }

    // Function to show the create blog form
    function create() {
        var categoryList = model("Category").getAll();
        var statusList = model("PostStatus").getAll();
        var postTypeList = model("PostType").getAll();
    }

    // Function to store a new blog
    function store() {
        var blogModel = model("Blog"); // Get model instance
        var blogService = new app.services.BlogService(blogModel);
        try {
            var message = blogService.saveBlog(params);
            redirectTo(action="create", success="#message#");
        } catch (any e) {
            // Handle error
            redirectTo(action="create", error="Failed to save blog post.");
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
            redirectTo(action="show", id=params.id, error="Failed to update blog post.");
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
            redirectTo(action="index", error="Failed to delete blog post.");
        }
    }

    // Function to load categories for the dropdown
    function loadCategories() {
        var categories = model("Category").getAll();
        writeDump(categories);
        renderPartial(partial="partials/categories");
    }

    // Function to load statuses for the dropdown
    function loadStatuses() {
        var statuses = model("PostStatus").getAll();
        renderPartial(partial="partials/statuses");
    }

    // Function to load post types for the dropdown
    function loadPostTypes() {
        var postTypes = model("PostType").getAll();
        renderPartial(partial="partials/postTypes");
    }
}