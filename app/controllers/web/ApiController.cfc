// Frontend home page
// home controller
component extends="app.Controllers.Controller" {

    function config() {
        verifies(except="index,loadVersions", params="key", paramsTypes="integer", handler="index");
        usesLayout("/layout");
    }

    /**
	* View all Rules
	**/
	function index() {
	}

    // Function to load versions
    function loadVersions() {
        versions = model("Version").getAll();
        renderPartial(partial="partials/versions");
    }

}