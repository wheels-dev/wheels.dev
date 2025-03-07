component extends="app.Controllers.Controller" {

    function config() {
        verifies(except="login,register,authenticate,logout,register,store,error,verify", params="key", paramsTypes="integer", handler="login");
        usesLayout("/layout");
    }

	function login() {
	}
	
    function authenticate() {
        param name="params.email" default="";
        param name="params.passwordHash" default="";

        try{
            // Validate credentials using AuthService
            var authService = new app.services.AuthService(model("User"));
            user = authService.validateCredentials(params.email, params.passwordHash);

            if (isObject(user)) {
                // Store user data in session
                session.userID = user.id;
                session.username = user.firstName;
                session.role = user.role.name;
                // session.permissions = user.permissions;

                // Redirect to admin dashboard
                // Send HTMX Redirect Header
                session.message = "Login Successfully!"
                header name="HX-Redirect" value="#urlFor(route='home')#";
                return;
            } else {
                renderText("<p style='color:red;'>Invalid login credentials.</p>");
            }
        } catch (any e) {
            // Handle error
            redirectTo(action="error", errorMessage="Invalid login credentials.");
        }
	}

    function logout() {
        StructDelete(session, "userId");
        redirectTo(action="login");
    }

    function register() {
	}

    function store() {
        param name="params.email" default="";
        param name="params.passwordHash" default="";
        
        try{
            // save user logic here
            var userModel = model("User"); // Get model instance
            var authService = new app.services.AuthService(userModel);
            var message = authService.saveUser(params);
            
            // Fetch the user to send verification email
            var authService = new app.services.AuthService(model("User"));
            user = authService.sendVerificationEmail(params.email, params.token);

            <!---
            // Validate credentials using AuthService
            var authService = new app.services.AuthService(model("User"));
            user = authService.validateCredentials(params.email, params.passwordHash);

            if (isObject(user)) {
                // Store user data in session
                session.userID = user.id;
                session.username = user.name;
                session.role = user.role.name;
                // session.permissions = user.permissions;

                // Redirect to admin dashboard
                // Send HTMX Redirect Header
                session.message = "Register and Login Successfully!"
                header name="HX-Redirect" value="#urlFor(route='home')#";
                return;
            } else {
                renderText("<p style='color:red;'>Invalid login credentials.</p>");
            }--->
        } catch (any e) {
            // Handle error
            redirectTo(action="error", errorMessage="Invalid login credentials.");
        }
	}

    function verify() {
        param name="params.token" default="";

        var authService = new app.services.AuthService(model("User"));
        user = authService.verifyToken(params.token);
        
        if(structKeyExists(variable, message) and message == 'true'){

            // Validate credentials using AuthService
            var authService = new app.services.AuthService(model("User"));
            user = authService.validateCredentials(user.email, user.passwordHash);

            if (isObject(user)) {
                // Store user data in session
                session.userID = user.id;
                session.username = user.name;
                session.role = user.role.name;
                // session.permissions = user.permissions;

                // Send HTMX Redirect Header
                session.message = "Register and Login Successfully!"
                header name="HX-Redirect" value="#urlFor(route='home')#";
                return;
            }
        }
    }

    function error() {
        // Add code to render the error page if needed
        renderPartial(partial="partials/_error");
    }
}