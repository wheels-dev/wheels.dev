component extends="app.Controllers.Controller" {

    function config() {
        verifies(except="login,register,authenticate", params="key", paramsTypes="integer", handler="login");
        usesLayout("/layout");
    }

	function login() {
        renderView(layout="AuthLayout");
	}
	
    function authenticate() {
        param name="params.email" default="";
        param name="params.password" default="";

        try{
            // Validate credentials using AuthService
            var authService = new app.services.AuthService(model("User"));
            user = authService.validateCredentials(params.email, params.password);

            if (isObject(user)) {
                // Store user data in session
                session.userID = user.id;
                session.username = user.name;
                session.role = user.role.name;
                // session.permissions = user.permissions;

                // Redirect to admin dashboard
                redirectTo(route="home", success="Login Successfully!");
            } else {
                renderText("<p style='color:red;'>Invalid login credentials.</p>");
            }
        } catch (any e) {
            // Handle error
            redirectTo(action="error", errorMessage="Invalid login credentials.");
        }
        
	}

    function error() {
        // Add code to render the error page if needed
        renderPartial(partial="partials/_error");
    }
}