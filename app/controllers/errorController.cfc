component extends="app.Controllers.Controller" {

    function config() {
        verifies(except="error404,error403", params="key", paramsTypes="integer");
        usesLayout(template ="/admin/AdminController/layout");
    }

    function error403(){
    }
}