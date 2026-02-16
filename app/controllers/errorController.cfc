component extends="app.Controllers.Controller" {

    function config() {
        super.config();
        verifies(except="error404,error403,error500", params="key", paramsTypes="integer");
        usesLayout(template="/layout");
    }

    function error403() {
    }

    function error404() {
    }

    function error500() {
    }
}