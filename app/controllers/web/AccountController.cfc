component extends="app.Controllers.Controller" {

    function config() {
        verifies(except="Index", params="key", paramsTypes="integer", handler="Index");
        usesLayout("/layout");
    }

	function Index() {
	}

}