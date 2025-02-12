//  Login, Register UI
// Frontend blog page
component extends="app.Controllers.Controller" {

    function config() {
        verifies(except="index,create,store,show,update,destroy", params="key", paramsTypes="integer", handler="index");
        usesLayout("/layout");
    }

    function Index() {
        blogService = new app.models.services.BlogService();
        // blogs = blogService.getAllBlogs();
    }

    function create() {
        blogService = new app.models.services.BlogService();
        // blog = blogService.createBlog();
    }

    function store() {
        blogService = new app.models.services.BlogService();
        // blog = blogService.storeBlog();
    }

    function show() {
        blogService = new app.models.services.BlogService();
        // blog = blogService.getBlog();
    }

    function update() {
        blogService = new app.models.services.BlogService();
        // blog = blogService.updateBlog();    
    }

    function destroy() {
        blogService = new app.models.services.BlogService();
        // blog = blogService.destroyBlog();
    }
}