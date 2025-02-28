component extends="app.Controllers.Controller" {

    function config() {
        verifies(except="login,register,authenticate", params="key", paramsTypes="integer", handler="login");
        usesLayout("/layout");
    }

	function login() {

	}
	
    function authenticate() {

	}


}