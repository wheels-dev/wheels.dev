// Frontend guide page
// guides controller
component extends="app.Controllers.Controller" {

    function config() {
        verifies(except="index,create,loadingGuides", params="key", paramsTypes="integer", handler="index");
        usesLayout("/layout");
    }

    /**
	* View all Rules
	**/
	function index() {
	}
    
    function loadingGuides() {
        var guideModel = model("Guide"); // Get Guide model instance
        try {
            guides = guideModel.getAll(); // Get Guide list
            renderPartial(partial="partials/guides"); // Return a partial view for HTMX
        } catch (any e) {
            // Handle error
            renderPartial(partial="partials/error", message="Failed to load guides.");
        }
    }
    
}