// Home controller
component extends="app.Controllers.Controller" {

    function config() {
        verifies(except="index,create,loadFeatures,loadBlogs,loadGuides", params="key", paramsTypes="integer", handler="index");
        usesLayout("/layout");
    }

    /**
     * View all Rules
     **/
    function index() {
        // Add code to render the home page if needed
    }

    // Function to load features
    function loadFeatures() {
        var featureModel = model("Feature"); // Get Feature model instance
        var homeService = new app.services.HomeService(featureModel);
        try {
            features = homeService.getAllFeatures(); // Get feature list
            renderPartial(partial="partials/features"); // Return a partial view for HTMX
        } catch (any e) {
            // Handle error
            renderPartial(partial="partials/error", message="Failed to load features.");
        }
    }

    // Function to load blogs
    function loadBlogs() {
        var blogModel = model("Blog"); // Get Blog model instance
        try {
            blogs = blogModel.getAll(); // Get blog list
            renderPartial(partial="partials/blogs"); // Return a partial view for HTMX
        } catch (any e) {
            // Handle error
            renderPartial(partial="partials/error", message="Failed to load blogs.");
        }
    }
}