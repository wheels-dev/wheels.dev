component extends="app.Controllers.Controller" {

    function config() {
        verifies(except="index,enableTestimonials,checkAdminAccess,checkRoleExistance", params="key", paramsTypes="integer");

        usesLayout(template="/admin/AdminController/layout");
        filters(through="checkAdminAccess");
    }

    function index(){
        settings = model("setting").findAll();
    }

    function enableTestimonials(){
        if(structKeyExists(params, "enableTestimonials")){
            model("setting").updateAll(enableTestimonial=true);
            message = "Testimonials enabled";
        }else{
            model("setting").updateAll(enableTestimonial=false);
            message = "Testimonials disabled";
        }
        renderText(message);
    }
}