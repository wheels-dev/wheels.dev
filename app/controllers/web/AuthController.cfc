component extends="app.Controllers.Controller" {

    function config() {
        verifies(except="login,authenticate,logout,register,store,error,verify,forgotPassword,sendResetLink,resetPassword,updatePassword", params="key", paramsTypes="integer", handler="login");
        usesLayout("/layout");
        filters(through="authenticate", except="login,logout,authenticate,register,store,error,verify,forgotPassword,sendResetLink,resetPassword,updatePassword");
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
        param name="params.password" default="";
        param name="params.rememberMe" default=false;

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
            
            // Check if user is locked out
            if (model("LoginAttempt").isUserLocked(params.email)) {
                model("Log").log(
                    category = "wheels.auth",
                    level = "WARN",
                    message = "Account locked - too many failed attempts",
                    details = {
                        "email": params.email,
                        "ip_address": cgi.REMOTE_ADDR
                    }
                );
                data = {
                    "success" = false,
                    "message" = "Account locked due to too many failed attempts. Please contact an administrator to reset your account."
                };
                renderWith(data=data, hideDebugInformation=true, status=423, layout='/responseLayout');
                return;
            }
            
            // Validate credentials
            var user = validateCredentials(params.email, params.password);

            if (isObject(user)) {
                // Clear failed attempts on successful login
                model("LoginAttempt").clearFailedAttempts(params.email);
                
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
                session.lastActivity = now();

                // Handle remember me
                if (structKeyExists(params, "rememberMe")) {
                    var token = createRememberMeToken(user);
                    if (len(token)) {
                        cfcookie(name="remember_me", value=token, expires="30");
                    } else {
                        model("Log").log(
                            category = "wheels.auth",
                            level = "WARN",
                            message = "Remember me token creation failed, proceeding without remember me",
                            details = {
                                "user_id": user.id,
                                "email": user.email
                            }
                        );
                    }
                }

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
                // Record failed attempt
                model("LoginAttempt").recordFailedAttempt(params.email, cgi.REMOTE_ADDR);
                
                // Get remaining attempts
                var remainingAttempts = model("LoginAttempt").getRemainingAttempts(params.email);
                
                model("Log").log(
                    category = "wheels.auth",
                    level = "WARN",
                    message = "Failed login attempt",
                    details = {
                        "email": params.email,
                        "ip_address": cgi.REMOTE_ADDR,
                        "remaining_attempts": remainingAttempts
                    }
                );
                
                // Return JSON error response with 401 status code
                data={
                    "success" = false,
                    "message" = "Invalid login credentials. " & (remainingAttempts > 0 ? "You have #remainingAttempts# attempt(s) remaining." : "Account will be locked after next failed attempt.")
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
            renderWith(data=data, hideDebugInformation=true, status=500, layout='/responseLayout');
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
                redirectUrl = urlFor(route="home");
                // redirectUrl = session.redirectAfterLogin;
                // structDelete(session, "redirectAfterLogin");
                // model("Log").log(
                //     category = "wheels.auth",
                //     level = "DEBUG",
                //     message = "User redirected to saved URL",
                //     details = {
                //         "user_id": user.id,
                //         "redirect_url": redirectUrl
                //     }
                // );
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

            // Check if user needs to submit testimonial
            if (isObject(user.role) && user.role.name != 'Admin') {
                var testimonial = model("Testimonial").findOne(where="userId = '#user.id#'");
                
                model("Log").log(
                    category = "wheels.auth",
                    level = "DEBUG",
                    message = "Checking if user needs testimonial prompt",
                    details = {
                        "user_id": user.id,
                        "has_testimonial": isObject(testimonial),
                        "role": user.role.name
                    }
                );
                
                if (!isObject(testimonial)) {
                    // Set the session flag to prompt for testimonial
                    session.promptForTestimonial = true;
                    
                    model("Log").log(
                        category = "wheels.auth",
                        level = "INFO",
                        message = "Testimonial prompt flag set for user",
                        details = {
                            "user_id": user.id,
                            "session_flag": "promptForTestimonial"
                        }
                    );
                }
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
        try {
            // Log the logout attempt if user is logged in
            if (structKeyExists(session, "userID")) {
                model("Log").log(
                    category = "wheels.auth",
                    level = "INFO",
                    message = "User logged out",
                    details = {
                        "user_id": session.userID,
                        "username": session.username,
                        "ip_address": cgi.REMOTE_ADDR
                    }
                );

                // Clear remember me token if exists
                if (cfcookie.keyExists("remember_me")) {
                    var token = cfcookie.remember_me;
                    var rememberToken = model("RememberToken").findOne(where="token='#token#'");
                    if (isObject(rememberToken)) {
                        rememberToken.delete();
                    }
                    cfcookie(name="remember_me", value="", expires="now");
                }
            }

            // Clear session data
            StructClear(session);
            
            // Set success message
            rc.successMessage = "You have been successfully logged out.";
            
            // Redirect to home page 
            redirectTo(route="home");

        } catch (any e) {
            model("Log").log(
                category = "wheels.auth",
                level = "ERROR",
                message = "Error during logout",
                details = {
                    "error_message": e.message,
                    "error_detail": e.detail,
                    "ip_address": cgi.REMOTE_ADDR
                }
            );
            
            // Even if there's an error, try to clear the session and redirect
            try {
                StructClear(session);
                redirectTo(route="home");
            } catch (any redirectError) {
                // If redirect fails, render error page
                renderPartial(partial="partials/error", errorMessage="An error occurred during logout. Please try again.");
            }
        }
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
        param name="params.errorMessage" default="An unexpected error occurred. Please try again.";
        
        try {
            // Log the error
            model("Log").log(
                category = "wheels.auth",
                level = "ERROR",
                message = "Auth error page accessed",
                details = {
                    "error_message": params.errorMessage,
                    "ip_address": cgi.REMOTE_ADDR,
                    "user_agent": cgi.HTTP_USER_AGENT
                }
            );

            // Set error message in request context for the view
            rc.errorMessage = params.errorMessage;
            
            // Render error page with appropriate layout
            renderPartial(partial="partials/_error", errorMessage=params.errorMessage);

        } catch (any e) {
            // If error occurs while handling error, log it and show generic message
            model("Log").log(
                category = "wheels.auth",
                level = "CRITICAL",
                message = "Error handling error page",
                details = {
                    "original_error": params.errorMessage,
                    "error_message": e.message,
                    "error_detail": e.detail,
                    "ip_address": cgi.REMOTE_ADDR
                }
            );
            
            // Show generic error message
            renderText("<h1>Error</h1><p>An unexpected error occurred. Please try again later.</p>");
        }
    }

    private function validateCredentials(required string email, required string password) {
        var user = model("User").findOne(where="email='#email#'", include="Role");
        if (!isObject(user)) {
            return false; // User not found
        }
        if(!application.WHEELS.plugins.bcrypt.bCryptCheckPW(password, user.passwordHash)){
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

    private boolean function isRateLimited(required string ipAddress) {
        var attempts = model("LoginAttempt").findAll(where="ip_address='#ipAddress#' AND created_at > '#dateAdd("n", -15, now())#'");
        return attempts.recordCount >= 3;
    }

    private string function createRememberMeToken(required User user) {
        try {
            var token = hash(createUUID() & user.id & now());
            var rememberToken = model("RememberToken").new();
            rememberToken.token = token;
            rememberToken.user_id = user.id;
            rememberToken.expiresAt = dateAdd("d", 30, now());
            
            if (rememberToken.save()) {
                model("Log").log(
                    category = "wheels.auth",
                    level = "INFO",
                    message = "Remember me token created successfully",
                    details = {
                        "user_id": user.id,
                        "token": token
                    }
                );
                return token;
            } else {
                model("Log").log(
                    category = "wheels.auth",
                    level = "ERROR",
                    message = "Failed to create remember me token",
                    details = {
                        "user_id": user.id,
                        "errors": rememberToken.allErrors()
                    }
                );
                return "";
            }
        } catch (any e) {
            model("Log").log(
                category = "wheels.auth",
                level = "ERROR",
                message = "Exception while creating remember me token",
                details = {
                    "user_id": user.id,
                    "error_message": e.message,
                    "error_detail": e.detail
                }
            );
            return "";
        }
    }

    function forgotPassword() {
        // If already logged in, redirect
        if (isLoggedInUser()) {
            redirectTo(controller="HomeController", action="index", route="home");
            return;
        }
    }

    function sendResetLink() {
        param name="params.email" default="";
        
        try {
            var user = model("User").findOne(where="email = '#params.email#'");
            
            if (isObject(user)) {
                // Generate reset token
                var token = generateResetToken();

                // Save token to database
                tokendetails = model("PasswordReset").create(
                    userId = user.id,
                    token = token,
                    expiresAt = dateAdd("h", 1, now())
                );
                
                // Send reset email
                sendResetEmail(user.email, token);
                
                data = {
                    "success" = true,
                    "message" = "Password reset instructions have been sent to your email."
                };
            } else {
                data = {
                    "success" = false,
                    "message" = "No account found with that email address."
                };
            }
            
            renderText("#data.message#");    
        } catch (any e) {
            model("Log").log(
                category = "wheels.auth",
                level = "ERROR",
                message = "Error sending reset link",
                details = {
                    "error_message": e.message,
                    "email": params.email
                }
            );
            
            data = {
                "success" = false,
                "message" = "An error occurred while processing your request. Please try again."
            };
            renderWith(data=data, hideDebugInformation=true, status=500, layout='/responseLayout');
        }
    }

    function resetPassword() {
        param name="params.token" default="";
        
        try {
            var reset = model("PasswordReset").findOne(
                where="token = '#params.token#' AND expiresAt > '#now()#' AND used = 0"
            );

            if (!isObject(reset)) {
                redirectTo(action="login");
                return;
            }
            
            // Pass token to view for form submission
            rc.token = params.token;
            
        } catch (any e) {
            model("Log").log(
                category = "wheels.auth",
                level = "ERROR",
                message = "Error processing reset password request",
                details = {
                    "error_message": e.message,
                    "token": params.token
                }
            );
            redirectTo(action="login");
        }
    }

    function updatePassword() {
        param name="params.token" default="";
        param name="params.password" default="";
        param name="params.confirmPassword" default="";
        
        try {
            // Validate token
            var reset = model("PasswordReset").findOne(
                where="token = '#params.token#' AND expiresAt > '#now()#' AND used = 0"
            );
            
            if (!isObject(reset)) {
                data = {
                    "success" = false,
                    "message" = "Invalid or expired reset token."
                };
                renderText("#data.message#"); 
                return;
            }
            
            // Validate password
            if (params.password != params.confirmPassword) {
                data = {
                    "success" = false,
                    "message" = "Passwords do not match."
                };
                renderText("#data.message#"); 
                return;
            }
            
            if (len(params.password) < 8) {
                data = {
                    "success" = false,
                    "message" = "Password must be at least 8 characters long."
                };
                renderText("#data.message#"); 
                return;
            }
            
            // Update password
            var user = model("User").findByKey(reset.userId);
            user.update(passwordHash=application.WHEELS.plugins.bcrypt.bCryptHashPW(params.password, application.WHEELS.plugins.bcrypt.bCryptGenSalt()));
            // Mark token as used
            reset.update(used=1);
            
            data = {
                "success" = true,
                "message" = "Password has been reset successfully. You can now login with your new password.",
                "redirectUrl" = urlFor(action="login")
            };
            renderText("#data.message#"); 
            
        } catch (any e) {
            model("Log").log(
                category = "wheels.auth",
                level = "ERROR",
                message = "Error updating password",
                details = {
                    "error_message": e.message,
                    "token": params.token
                }
            );
            
            data = {
                "success" = false,
                "message" = "An error occurred while resetting your password. Please try again."
            };
            renderText("#data.message#"); 
        }
    }

    private string function generateResetToken() {
        return hash(createUUID() & now(), "SHA-256");
    }

    private void function sendResetEmail(required string email, required string token) {
        var resetUrl = urlFor(action="resetPassword", token=token, onlyPath=false);
        var emailparams = {
            "content" = "We received a request to reset the password for your account associated with this email address.",
            "URl" = resetUrl,
            "Footer" = "If you did not request reset password, you can safely ignore this email."
        };
        var emailContent = renderView(template="/email", layout=false, returnAs="string", params=emailparams);
        cfheader(name="Content-Type" value="text/html; charset=UTF-8");
        cfmail( 
            to = "#arguments.email#", 
            from = "#application.env.mail_from#", 
            subject = "Reset Your Password", 
            server = "#application.env.smtp_host#", 
            port = "#application.env.smtp_port#", 
            username = "#application.env.smtp_username#", 
            password = "#application.env.smtp_password#", 
            type = "html"
        ) { 
            writeOutput(emailContent);
        };
    }
}