component extends="app.Controllers.Controller" {

    function config() {
        verifies(except="login,authenticate,logout,register,store,error,verify", params="key", paramsTypes="integer", handler="login");
        usesLayout("/layout");
    }

    function login() {
        // If already logged in, redirect
        if (structKeyExists(session, "userID") && structKeyExists(session, "role")) {
            redirectTo(controller="HomeController", action="index", route="home");
            return;
        }
    }

    function authenticate() {
        param name="params.email" default="";
        param name="params.passwordHash" default="";

        try {
            // Validate credentials
            var user = validateCredentials(params.email, params.passwordHash);

            if (isObject(user)) {
                // Store user data in session
                session.userID = user.id;
                session.username = user.fullname;
                session.role = user.role.name;
                session.profilePic = user.profilePicture;

                // Get success data
                var successData = handleLoginSuccess(user); // Pass user object

                // Return JSON success response
                data={
                    "success" = true,
                    "message" = "Login Successful!",
                    "redirectUrl" = successData.redirectUrl
                };
                renderWith(data=data, hideDebugInformation=true, layout='/responseLayout');
                return; 

            } else {
                // Return JSON error response with 401 status code
                data={
                    "success" = false,
                    "message" = "Invalid login credentials."
                };
                renderWith(data=data, hideDebugInformation=true, status=401, layout='/responseLayout');
                return;
            }
        } catch (any e) {
            // Log the actual error

            // Return a generic JSON error response with 500 status code
            data={
                "success" = false,
                "message" = "An unexpected error occurred during login. Please try again."
            };
            renderWith(data=data, hideDebugInformation=true, status=500 ,layout='/responseLayout'); // Internal Server Error status
            return;
        }
    }

    private struct function handleLoginSuccess(required User user) {
        var redirectUrl = "";
        var triggerJson = ""; // Store potential trigger JSON string

        try {
            // Determine redirect URL based on role or saved URL
            if (isObject(user.role) && user.role.name == 'Admin') { // Use 'Admin' consistently
                redirectUrl = urlFor(route="admin-blog");
            } else if (session.keyExists("redirectAfterLogin")) {
                redirectUrl = session.redirectAfterLogin;
                structDelete(session, "redirectAfterLogin"); // Clear after use
            } else {
                redirectUrl = urlFor(route="home"); // Default redirect
            }

            // Check if the user has submitted a testimonial (non-admin only)
            if (isObject(user.role) && user.role.name != 'Admin' && !user.hasSubmittedTestimonial()) {
                session.promptForTestimonial = true; // Still set session flag for layout script
                // Set HX-Trigger header - HTMX will process this even with JSON response
                header(name="HX-Trigger", value='{"showTestimonialModal": {}}');
            }

        } catch (any e) {
            // Log the error

            // Fallback to home redirect if error occurs
            redirectUrl = urlFor(route="home");
        }

        // Return the calculated redirect URL and any trigger info
        return {
            redirectUrl = redirectUrl
        };
    }

    function logout() {
        StructClear(session);
        redirectTo(route="home");
    }

    function register() {}

    function store() {
        try{
            // save user logic
            var message = saveUser(params);
            if(findNoCase('success', '#message#'))
            {
                renderText("<p style='color:green;'>#message#</p>");
            } else {
                renderText("<p style='color:red;'>#message#</p>");
            }
        } catch (any e) {
            // writeDump(e); abort;
            // Handle error
            redirectTo(action="error", errorMessage="Invalid login credentials.");
        }
	}

    function verify() {
        param name="params.token" default="";

        user = verifyToken(params.token);
        if(isObject(user)){

            if (isObject(user)) {
                // Store user data in session
                session.userID = user.id;
                session.username = user.fullname;
                session.role = user.role.name;

                // Send HTMX Redirect Header
                session.message = "Register and Login Successfully!"
                redirectto(route="home");
                return;
            }
        }else{
            // Handle invalid token
            rendertext('Invalid User!');
        }
    }

    function error() {
        // Add code to render the error page if needed
        renderPartial(partial="partials/_error");
    }

    private function validateCredentials(required string email, required string passwordHash) {
        var user = model("User").findOne(where="email='#email#'", include="Role");
        if (!isObject(user)) {
            return false; // User not found
        }
        if(!application.WHEELS.plugins.bcrypt.bCryptCheckPW(passwordHash,user.passwordHash)){
            return false;
        }
        return user;
    }
    
    private function saveUser(required struct userData) {        
        var message = "";

        try {
            // Check if a user with the same email already exists
            var existingUser = model("User").findFirst( where="email = '#userData.email#'");

            if (!isObject(existingUser)) {
                // Create a new user
                var newUser = model("User").new();
                newUser.firstname = userData.firstname;
                newUser.lastname = userData.lastname;
                newUser.email = userData.email;
                newUser.passwordhash = application.WHEELS.plugins.bcrypt.bCryptHashPW(userData.passwordHash, application.WHEELS.plugins.bcrypt.bCryptGenSalt());
                newUser.roleid = GetUserRoleId(); // user role
                newUser.status = SetInactive(); // set inactive

                if(newUser.save()){
                    // Generate a unique verification token
                    var verificationToken = Hash(createUUID());

                    // Save token to the user_tokens table
                    var newToken = model("UserToken").new();
                    newToken.token = verificationToken;
                    newToken.user_id = newUser.id;
                    newToken.status = 0; // Not verified
                    newToken.save();

                    // Send verification email
                    if(sendVerificationEmail(newUser.email, verificationToken)){
                        message = "User created successfully. Please check your email to verify your account.";
                    }else{
                        message = "Error sending verification email.";
                    }
                }else{
                    message = "Error! user not created.";
                }

            } else {
                message = "A user with the same email already exists.";
            }
            
        } catch (any e) {
            // Catch any errors and store the message
            message = "Error: " & e.message;
        }
        return message;
    }

    private function sendVerificationEmail(required string email, required string token) {
        var user = model("User").findOne(where="email='#email#'");
        verifyUrl = "http://#cgi.http_host#/verify?token=#token#";
        emailContent = generateVerifyEmail(verifyUrl);
        
        if (isObject(user)){
            cfheader(name="Content-Type" value="text/html; charset=UTF-8");
            cfmail( 
                to = "#user.email#", 
                from = "#application.env.mail_from#", 
                subject = "Verify Your Email", 
                server = "#application.env.smtp_host#", 
                port = "#application.env.smtp_port#", 
                username = "#application.env.smtp_username#", 
                password = "#application.env.smtp_password#", 
                type = "html"
            ) { 
                writeOutput(emailContent);
            }
            return true;
        }
        return false;
    }

    private function verifyToken(required string token) {
        var message="";
        var token = model("UserToken").findOne(where="token='#token#'");

        if (isObject(token)) {
            var user = model("User").findByKey(include="Role", key='#token.user_id#');
            if(isObject(user)){
                user.update(status=SetActive()); // Activate user
                return user;
            }else{
                message="false";
            }
        } else {
            message = "false";
        }
        return message;
    }

    private string function generateVerifyEmail(required string verifyUrl) {
            return '
                <!DOCTYPE html>
                <html>
                <head>
                    <meta charset="UTF-8">
                    <meta name="viewport" content="width=device-width, initial-scale=1.0">
                    <title>Verify Your Account</title>
                    <style>
                        body {
                            font-family: Arial, sans-serif;
                            background-color: ##f4f4f4;
                            margin: 0;
                            padding: 0;
                        }
                        .container {
                            max-width: 600px;
                            margin: 40px auto;
                            background: ##ffffff;
                            padding: 20px;
                            border-radius: 8px;
                            box-shadow: 0px 4px 10px rgba(0, 0, 0, 0.1);
                            text-align: center;
                        }
                        .logo {
                            width: 120px;
                            margin-bottom: 20px;
                        }
                        h1 {
                            color: ##333;
                            font-size: 24px;
                        }
                        p {
                            color: ##666;
                            font-size: 16px;
                            line-height: 1.5;
                        }
                        .button {
                            display: inline-block;
                            background-color: ##007BFF;
                            color: ##ffffff;
                            text-decoration: none;
                            font-size: 18px;
                            padding: 12px 20px;
                            border-radius: 6px;
                            margin-top: 20px;
                        }
                        .footer {
                            margin-top: 30px;
                            font-size: 14px;
                            color: ##999;
                        }
                    </style>
                </head>
                <body>

                    <div class="container">
                        <img src="https://avatars.githubusercontent.com/u/159224?s=200&v=4" alt="Bootstrap" width="260">
                        <h1>Welcome to Wheels.dev!</h1>
                        <p>Thank you for signing up. Please click the button below to verify your account and get started.</p>
                        <a href="' & verifyUrl & '" class="button">Verify Your Account</a>
                        <p class="footer">If you did not sign up, you can safely ignore this email.</p>
                    </div>

                </body>
                </html>
            ';
    }
}