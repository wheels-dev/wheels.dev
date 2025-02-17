// Frontend home page
// home controller
component extends="app.Controllers.Controller" {

    function config() {
        verifies(except="index,create", params="key", paramsTypes="integer", handler="index");
        usesLayout("/layout");
    }

    /**
	* View all Rules
	**/
	function index() {
        featureModel = model("Feature"); // Get model instance
        homeService = new app.services.HomeService(featureModel);
        features = homeService.getAllFeatures(); // feature list to show in home page
        
        blogModel = model("Blog"); // Get model instance
        blogs = blogModel.getAllBlogs(); // blog list to show in home page
        
	}
}