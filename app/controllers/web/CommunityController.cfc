component extends="app.Controllers.Controller" {

    function config() {
        verifies(except="index", params="key", paramsTypes="integer");
        usesLayout("/layout");
    }
}