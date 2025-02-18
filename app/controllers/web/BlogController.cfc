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
        blogs = blogService.getAllBlogs();
    }

    function create() {
        categorylist = model("Category").getAllCategories();
        statuslist = model("PostStatus").getAllPostStatuses();
        posttypelist = model("PostType").getAllPostTypes();
    }

    function store() {
        blogModel = model("Blog"); // Get model instance
        blogService = new app.services.BlogService(blogModel);
    }

    function show() {
        blogModel = model("Blog"); // Get model instance
        blogService = new app.services.BlogService(blogModel);
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