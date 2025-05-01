component extends="app.Controllers.Controller" {

    function config() {
        verifies(except="index,add,store,edit,delete,loadRoles,checkAdminAccess", params="key", paramsTypes="integer");

        usesLayout(template="/admin/AdminController/layout");
        filters(through="checkAdminAccess");
    }

    function index(){
        roles = model("role").getAllRoles();
    }
}