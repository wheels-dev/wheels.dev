// Frontend home page
// home controller
component extends="app.Controllers.Controller" {

    function config() {
        verifies(except="index,create,loadFeatures,loadBlogs,loadGuides", params="key", paramsTypes="integer", handler="index");
        usesLayout("/layout");
    }

    /**
	* View all Rules
	**/
	function index() {
	}

    function loadFeatures() {
        featureModel = model("Feature"); // Get Feature model instance
        homeService = new app.services.HomeService(featureModel);
        features = homeService.getAllFeatures(); // Get feature list
        
        renderPartial(partial="partials/_features", locals={ features = features }); // Return a partial view for HTMX
    }

    function loadBlogs() {
        blogModel = model("Blog"); // Get Blog model instance
        blogs = blogModel.getAll(); // Get blog list
        
        renderPartial(partial="partials/_blogs", locals={ blogs = blogs }); // Return a partial view for HTMX
    }
    
    function loadGuides() {
        guideModel = model("Guide"); // Get Guide model instance
        guides = guideModel.getAllGuides(); // Get Guide list
        
        renderPartial(partial="partials/_guides", locals={ guides = guides }); // Return a partial view for HTMX
    }
    
}