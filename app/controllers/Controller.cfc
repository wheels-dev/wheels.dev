/**
 * This is the parent controller file that all your controllers should extend.
 * You can add functions to this file to make them available in all your controllers.
 * Do not delete this file.
 *
 * NOTE: When extending this controller and implementing `config()` in the child controller, don't forget to call this
 * base controller's `config()` via `super.config()`, or else the call to `protectsFromForgery` below will be skipped.
 *
 * Example controller extending this one:
 *
 * component extends="Controller" {
 *   function config() {
 *     // Call parent config method
 *     super.config();
 *
 *     // Your own config code here.
 *     // ...
 *   }
 * }
 */
component extends="wheels.Controller" {

	function config() {
		protectsFromForgery();
	}

	/**
     * Check if user is logged In
     */
    function isUserLoggedIn() {
        return (
            structKeyExists(session, "USERID") && 
            structKeyExists(session, "role") && 
            (session.role == "Editor" || 
            session.role == "Admin")
        );
    }

	/**
     * Check if current user is an admin
     */
    function isCurrentUserAdmin() {
        // Assumes session management is handled elsewhere
        return (
            structKeyExists(session, "USERID") && 
            structKeyExists(session, "role") && 
            session.role == "Admin"
        );
    }

    function f_getVersions(){
		versions=getAvailableVersions();
	}

    public function restrictAccess() {        
        // Check if the user is logged in
        if (!structKeyExists(session, "USERID") || !structKeyExists(session, "role")) {
            redirectTo(controller="AuthController", action="login", route="auth-login");
            return false;
        }

        // Allow only specific roles
        if (!listFindNoCase("Editor,Admin", session.role)) {
            // redirectTo(controller="HomeController", action="index");
            return false;
        }

        return true;
    }
}
