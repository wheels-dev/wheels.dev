component extends="app.Controllers.Controller" {

    function config() {
        verifies(except="login,authenticate,logout,register,store,error,verify", params="key", paramsTypes="integer", handler="login");
        usesLayout("/layout");
    }

    function login() {
        // If already logged in, redirect
        if (isLoggedInUser()) {
            model("Log").log(
                category = "wheels.auth",
                level = "INFO",
                message = "User already logged in, redirecting to home",
                details = {
                    "user_id": session.userID,
                    "username": session.username
                }
            );
            redirectTo(controller="HomeController", action="index", route="home");
            return;
        }
        model("Log").log(
            category = "wheels.auth",
            level = "DEBUG",
            message = "Login page accessed"
        );
    }

    function authenticate() {
        param name="params.email" default="";
        param name="params.passwordHash" default="";

        try {
            model("Log").log(
                category = "wheels.auth",
                level = "DEBUG",
                message = "Authentication attempt",
                details = {
                    "email": params.email,
                    "ip_address": cgi.REMOTE_ADDR
                }
            );
            
            // Validate credentials
            var user = validateCredentials(params.email, params.passwordHash);

            if (isObject(user)) {
                model("Log").log(
                    category = "wheels.auth",
                    level = "INFO",
                    message = "Successful login",
                    details = {
                        "user_id": user.id,
                        "email": user.email,
                        "role": user.role.name
                    }
                );
                
                // Store user data in session
                session.userID = user.id;
                session.username = user.fullname;
                session.role = user.role.name;
                session.profilePic = user.profilePicture;

                // Get success data
                var successData = handleLoginSuccess(user);

                // Return JSON success response
                data={
                    "success" = true,
                    "message" = "Login Successful!",
                    "redirectUrl" = successData.redirectUrl
                };
                renderWith(data=data, hideDebugInformation=true, layout='/responseLayout');
                return; 

            } else {
                model("Log").log(
                    category = "wheels.auth",
                    level = "WARN",
                    message = "Failed login attempt",
                    details = {
                        "email": params.email,
                        "ip_address": cgi.REMOTE_ADDR
                    }
                );
                // Return JSON error response with 401 status code
                data={
                    "success" = false,
                    "message" = "Invalid login credentials."
                };
                renderWith(data=data, hideDebugInformation=true, status=401, layout='/responseLayout');
                return;
            }
        } catch (any e) {
            model("Log").log(
                category = "wheels.auth",
                level = "ERROR",
                message = "Authentication error",
                details = {
                    "error_message": e.message,
                    "error_detail": e.detail,
                    "email": params.email
                }
            );
            // Return a generic JSON error response with 500 status code
            data={
                "success" = false,
                "message" = "An unexpected error occurred during login. Please try again."
            };
            renderWith(data=data, hideDebugInformation=true, status=500 ,layout='/responseLayout');
            return;
        }
    }

    private struct function handleLoginSuccess(required User user) {
        var redirectUrl = "";
        var triggerJson = "";

        try {
            model("Log").log(
                category = "wheels.auth",
                level = "DEBUG",
                message = "Processing login success",
                details = {
                    "user_id": user.id,
                    "email": user.email
                }
            );
            
            // Determine redirect URL based on role or saved URL
            if (isObject(user.role) && user.role.name == 'Admin') {
                redirectUrl = urlFor(route="admin-dashboard");
                model("Log").log(
                    category = "wheels.auth",
                    level = "INFO",
                    message = "Admin user redirected to dashboard",
                    details = {
                        "user_id": user.id
                    }
                );
            } else if (session.keyExists("redirectAfterLogin")) {
                redirectUrl = session.redirectAfterLogin;
                structDelete(session, "redirectAfterLogin");
                model("Log").log(
                    category = "wheels.auth",
                    level = "DEBUG",
                    message = "User redirected to saved URL",
                    details = {
                        "user_id": user.id,
                        "redirect_url": redirectUrl
                    }
                );
            } else {
                redirectUrl = urlFor(route="home");
                model("Log").log(
                    category = "wheels.auth",
                    level = "DEBUG",
                    message = "User redirected to home",
                    details = {
                        "user_id": user.id
                    }
                );
            }

            if (isObject(user.role) && user.role.name != 'Admin' && !user.hasSubmittedTestimonial()) {
                session.promptForTestimonial = true;
                header(name="HX-Trigger", value='{"showTestimonialModal": {}}');
                model("Log").log(
                    category = "wheels.auth",
                    level = "DEBUG",
                    message = "Testimonial prompt set",
                    details = {
                        "user_id": user.id
                    }
                );
            }

        } catch (any e) {
            model("Log").log(
                category = "wheels.auth",
                level = "ERROR",
                message = "Error in handleLoginSuccess",
                details = {
                    "error_message": e.message,
                    "user_id": user.id
                }
            );
            redirectUrl = urlFor(route="home");
        }

        return {
            redirectUrl = redirectUrl
        };
    }

    function logout() {
        if (structKeyExists(session, "username")) {
            model("Log").log(
                category = "wheels.auth",
                level = "INFO",
                message = "User logged out",
                details = {
                    "user_id": session.userID,
                    "username": session.username
                }
            );
        }
        StructClear(session);
        redirectTo(route="home");
    }

    function register() {}

    function store() {
        try {
            model("Log").log(
                category = "wheels.auth",
                level = "DEBUG",
                message = "New user registration attempt",
                details = {
                    "email": params.email
                }
            );
            var message = saveUser(params);
            
            if(findNoCase('success', '#message#')) {
                model("Log").log(
                    category = "wheels.auth",
                    level = "INFO",
                    message = "User registration successful",
                    details = {
                        "email": params.email
                    }
                );
                renderText("<p style='color:green;'>#message#</p>");
            } else {
                model("Log").log(
                    category = "wheels.auth",
                    level = "WARN",
                    message = "User registration failed",
                    details = {
                        "email": params.email,
                        "error_message": message
                    }
                );
                renderText("<p style='color:red;'>#message#</p>");
            }
        } catch (any e) {
            model("Log").log(
                category = "wheels.auth",
                level = "ERROR",
                message = "Error in user registration",
                details = {
                    "error_message": e.message,
                    "email": params.email
                }
            );
            redirectTo(action="error", errorMessage="Invalid login credentials.");
        }
    }

    function verify() {
        param name="params.token" default="";
        model("Log").log(
            category = "wheels.auth",
            level = "DEBUG",
            message = "Email verification attempt",
            details = {
                "token": params.token
            }
        );

        user = verifyToken(params.token);
        if(isObject(user)){
            model("Log").log(
                category = "wheels.auth",
                level = "INFO",
                message = "Email verification successful",
                details = {
                    "user_id": user.id,
                    "email": user.email
                }
            );
            
            if (isObject(user)) {
                session.userID = user.id;
                session.username = user.fullname;
                session.role = user.role.name;

                session.message = "Register and Login Successfully!"
                redirectto(route="home");
                return;
            }
        } else {
            model("Log").log(
                category = "wheels.auth",
                level = "WARN",
                message = "Invalid verification token used",
                details = {
                    "token": params.token
                }
            );
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
                if(structKeyExists(userData, "newsletter")){
                newUser.newsletter = true;
                }

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
                        message = "Sign Up successfull. Please check your email to verify your account.";
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