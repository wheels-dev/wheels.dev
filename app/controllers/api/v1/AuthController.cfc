component extends="app.Controllers.Controller" {

    function config() {
        verifies(except="checkEmail", params="key", paramsTypes="integer", handler="index");
        usesLayout("/responseLayout");
    }

    function checkEmail() {        
        try {
            // Get email from query parameters
            var email = params.email ?: "";
            
            // Validate email format
            if (!len(trim(email))) {
                renderText(serializeJSON({
                    "available": false,
                    "message": "Email is required"
                }));
                return;
            }
            
            // Check email format
            if (!reFindNoCase("^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$", email)) {
                renderText(serializeJSON({
                    "available": false,
                    "message": "Please enter a valid email address"
                }));
                return;
            }
            
            // Check if email already exists
            var existingUser = model("User").findFirst(where = "email = '#email#'");
            
            if (isObject(existingUser)) {
                renderText(serializeJSON({
                    "available": false,
                    "message": "Email already exists. Please use a different email."
                }));
            } else {
                renderText(serializeJSON({
                    "available": true,
                    "message": "Email is available"
                }));
            }
            
        } catch (any e) {
            // Log the error for debugging
            model("Log").log(
                category = "wheels.auth.api",
                level = "ERROR",
                message = "Error checking email availability",
                details = {
                    "email": params.email ?: "",
                    "error": e.message
                }
            );
            
            renderText(serializeJSON({
                "available": false,
                "message": "An error occurred while checking email availability"
            }));
        }
    }
} 