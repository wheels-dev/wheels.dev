component extends="app.Controllers.Controller" {

    function config() {
        verifies(except="index", params="key", paramsTypes="integer");
        usesLayout("/layout");
    }

    function index() {
        // Get settings for the community page
        settings = model("setting").findAll();
    }
}