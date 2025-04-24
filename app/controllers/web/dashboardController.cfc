component extends="app.Controllers.Controller" {

    function config() {
        verifies(except="dashboard,checkAdminAccess", params="key", paramsTypes="integer");
        usesLayout(template="/web/AdminController/layout");
        filters(through="checkAdminAccess");
    }

    function dashboard(){
        total_blogs = model("blog").count();
        total_testimonials = model("testimonial").count();
        total_new_user = model("user").count(where="createdat >= '#dateFormat(now(), "yyyy-mm-dd")#'");
        total_user = model("user").count();
    }
    private function checkAdminAccess() {
        // Ensure only admin users can access these methods
        if (!isCurrentUserAdmin()) {
            // Save the current URL in session
            saveRedirectUrl(cgi.script_name & "?" & cgi.query_string);
            // Redirect to login page
            redirectTo(controller="AuthController", action="login", route="auth-login");
            return false;
        }
        return true;
    }
}