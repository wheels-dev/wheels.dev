//  Login, Register UI
// Frontend blog page
component extends="app.Controllers.Controller" {

    function config() {
        verifies(except="index,create,store,show,update,destroy", params="key", paramsTypes="integer", handler="index");
        usesLayout("/layout");
    }

    function Index() {
        blogModel = model("Blog"); // Get model instance
        blogService = new app.services.BlogService(blogModel);
        blogs = blogModel.getAllBlogs();
    }

    function create() {
        categorylist = model("Category").getAllCategories();
        statuslist = model("PostStatus").getAllPostStatuses();
        posttypelist = model("PostType").getAllPostTypes();
    }

    function store() {
        blogModel = model("Blog"); // Get model instance
        blogService = new app.services.BlogService(blogModel);
        message = blogService.saveBlog(params);
        // Redirect to the create page
        // redirectTo(action="create");
        redirectTo(action="create", success="#message#");
    }

    function show() {
        blogModel = model("Blog"); // Get model instance
        blogService = new app.services.BlogService(blogModel);
        blog = blogService.getBlogById(params.id);
        blogs = blogModel.getAllBlogs();
        tagService = new app.services.TagService(model("Tag"));
        tags = tagService.getTagsByBlogid(params.id);
        attachmentService = new app.services.AttachmentService(model("Attachment"));
        attachments = attachmentService.getAttachmentsByBlogid(params.id);
    
    }

    function update() {
        blogModel = model("Blog"); // Get model instance
        blogService = new app.services.BlogService(blogModel);
    }

    function destroy() {
        blogModel = model("Blog"); // Get model instance
        blogService = new app.services.BlogService(blogModel);
    }
}