component extends="app.Controllers.Controller" {

    function config() {
        super.config();
        verifies(except="index", params="key", paramsTypes="integer");
        usesLayout("/layout");
    }
}