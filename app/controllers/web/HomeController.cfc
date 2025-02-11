// Frontend home page
component extends="app.Controllers.Controller" {

    function config() {
        verifies(except="index,create", params="key", paramsTypes="integer", handler="index");
        usesLayout("/layout");
    }

    /**
	* View all Rules
	**/
	function index() {
		
	}
}