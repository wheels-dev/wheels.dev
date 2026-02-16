component extends="app.Controllers.Controller" {

    function config() {
        super.config();
        verifies(except="index", params="key", paramsTypes="integer");
        usesLayout("/layout");
    }

    function index() {
        // Get settings for the community page
        settings = model("setting").findAll();
        contributors = getContributors();
    }

    // getContributors() is inherited from Controller.cfc
}