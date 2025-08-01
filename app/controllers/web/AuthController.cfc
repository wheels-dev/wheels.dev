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
        // Input validation
        if (!len(trim(params.email)) || !len(trim(params.password))) {
            data = {
                "success" = false,
                "message" = "Email and password are required."
            };
            renderWith(data=data, hideDebugInformation=true, status=400, layout='/responseLayout');
            return;
        }
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
                // Check if it's a manual lock by admin
                var user = model("User").findOne(where="email='#params.email#'");
                var isManuallyLocked = !isNull(user) && user.locked;
                
                model("Log").log(
                    category = "wheels.auth",
                    level = "WARN",
                    message = "Account locked - " & (isManuallyLocked ? "manually locked by admin" : "too many failed attempts"),
                    details = {
                        "email": params.email,
                        "ip_address": cgi.REMOTE_ADDR,
                        "manual_lock": isManuallyLocked
                    }
                );
                
                var lockMessage = isManuallyLocked 
                    ? "Your account has been locked by an administrator. Please contact support for assistance."
                    : "Account locked due to multiple failed login attempts. Please contact our support team to unlock your account.";
                
                data = {
                    "success" = false,
                    "message" = lockMessage
                };
                renderWith(data=data, hideDebugInformation=true, status=400, layout='/responseLayout');
                return;
            }
            // Check if user exists first (regardless of status)
            var existingUser = model("User").findOne(where="email='#params.email#'", include="Role");
            
            // If user doesn't exist, send registration invitation
            if (!isObject(existingUser)) {
                model("Log").log(
                    category = "wheels.auth",
                    level = "INFO",
                    message = "Non-existent email attempted login - sending registration email",
                    details = {
                        "email": params.email,
                        "ip_address": cgi.REMOTE_ADDR
                    }
                );
                
                // Send registration invitation email
                if (sendRegistrationInvitationEmail(params.email)) {
                    data = {
                        "success" = false,
                        "message" = "No account found with this email. We've sent you a registration invitation. Please check your email to create your account."
                    };
                } else {
                    data = {
                        "success" = false,
                        "message" = "No account found with this email. Please register to create an account."
                    };
                }
                renderWith(data=data, hideDebugInformation=true, status=400, layout='/responseLayout');
                return;
            }
            
            // If user exists but is inactive, send verification email
            if (existingUser.status == false) {
                model("Log").log(
                    category = "wheels.auth",
                    level = "INFO",
                    message = "Inactive account attempted login - sending verification email",
                    details = {
                        "email": params.email,
                        "user_id": existingUser.id,
                        "ip_address": cgi.REMOTE_ADDR
                    }
                );
                
                // Send verification email for inactive account
                if (sendVerificationEmailForInactiveAccount(existingUser)) {
                    data = {
                        "success" = false,
                        "message" = "Your account is not verified. We've sent you a verification email. Please check your email and verify your account before logging in."
                    };
                } else {
                    data = {
                        "success" = false,
                        "message" = "Your account is not verified. Please check your email for verification instructions or contact support."
                    };
                }
                renderWith(data=data, hideDebugInformation=true, status=400, layout='/responseLayout');
                return;
            }
            
            // Now validate credentials for active user
            var user = false;
            try {
                user = validateCredentials(params.email, params.password);
            } catch (any e) {
                model("Log").log(
                    category = "wheels.auth",
                    level = "ERROR",
                    message = "Error during credential validation",
                    details = {
                        "error_message": e.message,
                        "error_detail": e.detail,
                        "email": params.email
                    }
                );
                data = {
                    "success" = false,
                    "message" = "A system error occurred. Please try again later."
                };
                renderWith(data=data, hideDebugInformation=true, status=500, layout='/responseLayout');
                return;
            }
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
                        "role": (isObject(user.role) ? user.role.name : "")
                    }
                );
                // Store user data in session
                session.userID = user.id;
                session.username = user.fullname;
                session.role = (isObject(user.role) ? user.role.name : "");
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
                // Return JSON error response with 400 status code
                data={
                    "success" = false,
                    "message" = "Invalid login credentials. " & (remainingAttempts > 0 ? "You have #remainingAttempts# attempt(s) remaining." : "Your account will be locked after the next failed attempt.")
                };
                renderWith(data=data, hideDebugInformation=true, status=400, layout='/responseLayout');
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
                "message" = "An unexpected error occurred during the login process. Please try again later."
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
                redirectUrl = urlFor(route="adminDashboard");
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
                if (structKeyExists(cookie, "remember_me")) {
                    var token = cookie.remember_me;
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
            // Input validation - handle both camelCase and lowercase field names
            var firstname = "";
            var lastname = "";
            
            if (structKeyExists(params, "firstName")) {
                firstname = params.firstName;
            } else if (structKeyExists(params, "firstname")) {
                firstname = params.firstname;
            }
            
            if (structKeyExists(params, "lastName")) {
                lastname = params.lastName;
            } else if (structKeyExists(params, "lastname")) {
                lastname = params.lastname;
            }
            
            if (!len(trim(firstname))) {
                renderText("<p style='color:red;'>First name is required.</p>");
                return;
            }
            if (!len(trim(lastname))) {
                renderText("<p style='color:red;'>Last name is required.</p>");
                return;
            }
            if (!structKeyExists(params, "email") || !len(trim(params.email))) {
                renderText("<p style='color:red;'>Email is required.</p>");
                return;
            }
            // Add invalid email format check
            if (!reFindNoCase("^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$", params.email)) {
                renderText("<p style='color:red;'>Please enter a valid email address.</p>");
                return;
            }
            if (!structKeyExists(params, "passwordHash") || !len(trim(params.passwordHash))) {
                renderText("<p style='color:red;'>Password is required.</p>");
                return;
            }
            // Check for duplicate email before calling saveUser
            var existingUser = model("User").findFirst(where="email = '#params.email#'");
            if (isObject(existingUser)) {
                renderText("<p style='color:red;'>An account with this email address already exists.</p>");
                return;
            }
            model("Log").log(
                category = "wheels.auth",
                level = "DEBUG",
                message = "New user registration attempt",
                details = {
                    "email": params.email
                }
            );
            
            // Create user data structure with correct field names
            var userData = {
                firstname: firstname,
                lastname: lastname,
                email: params.email,
                passwordHash: params.passwordHash,
                newsletter: structKeyExists(params, "newsletter") ? params.newsletter : false
            };
            
            var message = saveUser(userData);
            
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
                // Always return a user-friendly error for MAIL_FROM or other missing keys
                if (findNoCase("MAIL_FROM", message) || findNoCase("Error:", message) || findNoCase("NULL", message) || findNoCase("doesn't exist", message)) {
                    renderText("<p style='color:red;'>An error occurred while creating your account. Please check your input and try again.</p>");
                } else if (findNoCase("required", message)) {
                    renderText("<p style='color:red;'>#message#</p>");
                } else if (findNoCase("valid email", message)) {
                    renderText("<p style='color:red;'>#message#</p>");
                } else {
                    renderText("<p style='color:red;'>#message#</p>");
                }
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
            renderText("<p style='color:red;'>An unexpected error occurred. Please try again later.</p>");
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
        var user = model("User").findOne(where="email='#email#' AND status='True'", include="Role");
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
            // check required fields
            if (!structKeyExists(userData, "firstname") || !len(trim(userData.firstname))) {
                return "First name is required.";
            }
            if (!structKeyExists(userData, "lastname") || !len(trim(userData.lastname))) {
                return "Last name is required.";
            }
            if (!structKeyExists(userData, "email") || !len(trim(userData.email))) {
                return "Email is required.";
            }
            if (!reFindNoCase("^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$", userData.email)) {
                return "Please enter a valid email address.";
            }
            if (!structKeyExists(userData, "passwordHash") || !len(trim(userData.passwordHash))) {
                return "Password is required.";
            }
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
                        message = "Registration successful. Please check your email to verify your account.";
                    }else{
                        message = "Unable to send verification email. Please try again or contact support.";
                    }
                }else{
                    message = "Unable to create user account. Please try again or contact support.";
                }
            } else {
                message = "An account with this email address already exists.";
            }
        } catch (any e) {
            // Log internal error, but return generic message
            model("Log").log(
                category = "wheels.auth",
                level = "ERROR",
                message = "Exception in saveUser",
                details = {
                    "error_message": e.message,
                    "error_detail": e.detail
                }
            );
            message = "An error occurred while creating your account. Please try again later.";
        }
        return message;
    }

    private function sendVerificationEmail(required string email, required string token) {
        if (application.env.test_case EQ 'true') {
            // Skip email sending in test mode
            return true;
        }
        var user = model("User").findOne(where="email='#email#'");
        var emaildata = model("emailTemplate").findAll(where="title = '#trim("Sign Up Account Verification")#'");
        verifyUrl = urlFor(action="verify", onlyPath=false);
        verifyUrl = verifyUrl & "?token=" & token;
        var emailparams = {
            "name" = user.fullname,
            "buttonTitle" = emaildata.buttonTitle,
            "content" = emaildata.message,
            "welcomeMessage"= emaildata.welcomeMessage,
            "URl" = verifyUrl,
            "footerNote" = emaildata.footerNote,
            "footerGreetings" = emaildata.footerGreating,
            "closingRemark" = emaildata.closingRemark,
            "teamSignature" = emaildata.teamSignature
        };
        emailContent = renderView(template="/email", layout=false, returnAs="string", params=emailparams);
        
        if (isObject(user)){
            cfheader(name="Content-Type" value="text/html; charset=UTF-8");
            cfmail( 
                to = "#user.email#", 
                from = "#application.env.mail_from#", 
                subject = "#emaildata.subject#", 
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

    private function sendRegistrationInvitationEmail(required string email) {
        if (application.env.test_case EQ 'true') {
            // Skip email sending in test mode
            return true;
        }
        
        try {
            // Use the existing "Register Your Account" template
            var emaildata = model("emailTemplate").findAll(where="title = '#trim("Register Your Account")#'");
            if (emaildata.recordCount == 0) {
                // Fallback to sign up template if registration template doesn't exist
                emaildata = model("emailTemplate").findAll(where="title = '#trim("Sign Up Account Verification")#'");
            }
            
            var registerUrl = urlFor(action="register", onlyPath=false);
            var emailparams = {
                "name" = "there",
                "buttonTitle" = emaildata.buttonTitle,
                "content" = emaildata.message,
                "welcomeMessage" = emaildata.welcomeMessage,
                "URl" = registerUrl,
                "footerNote" = emaildata.footerNote,
                "footerGreetings" = emaildata.footerGreating,
                "closingRemark" = emaildata.closingRemark,
                "teamSignature" = emaildata.teamSignature
            };
            
            var emailContent = renderView(template="/email", layout=false, returnAs="string", params=emailparams);
            
            cfheader(name="Content-Type" value="text/html; charset=UTF-8");
            cfmail( 
                to = "#email#", 
                from = "#application.env.mail_from#", 
                subject = "#emaildata.subject#", 
                server = "#application.env.smtp_host#", 
                port = "#application.env.smtp_port#", 
                username = "#application.env.smtp_username#", 
                password = "#application.env.smtp_password#", 
                type = "html"
            ) { 
                writeOutput(emailContent);
            }
            
            return true;
        } catch (any e) {
            model("Log").log(
                category = "wheels.auth",
                level = "ERROR",
                message = "Failed to send registration invitation email",
                details = {
                    "email": email,
                    "error_message": e.message,
                    "error_detail": e.detail
                }
            );
            return false;
        }
    }

    private function sendVerificationEmailForInactiveAccount(required User user) {
        if (application.env.test_case EQ 'true') {
            // Skip email sending in test mode
            return true;
        }
        
        try {
            // Check if user already has a verification token
            var existingToken = model("UserToken").findOne(where="user_id='#user.id#' AND status='0'");
            
            if (!isObject(existingToken)) {
                // Generate a new verification token
                var verificationToken = Hash(createUUID());
                var newToken = model("UserToken").new();
                newToken.token = verificationToken;
                newToken.user_id = user.id;
                newToken.status = 0; // Not verified
                newToken.save();
            } else {
                var verificationToken = existingToken.token;
            }
            
            var emaildata = model("emailTemplate").findAll(where="title = '#trim("Sign Up Account Verification")#'");
            var verifyUrl = urlFor(action="verify", onlyPath=false);
            verifyUrl = verifyUrl & "?token=" & verificationToken;
            
            var emailparams = {
                "name" = user.fullname,
                "buttonTitle" = emaildata.buttonTitle,
                "content" = emaildata.message,
                "welcomeMessage" = emaildata.welcomeMessage,
                "URl" = verifyUrl,
                "footerNote" = emaildata.footerNote,
                "footerGreetings" = emaildata.footerGreating,
                "closingRemark" = emaildata.closingRemark,
                "teamSignature" = emaildata.teamSignature
            };
            
            var emailContent = renderView(template="/email", layout=false, returnAs="string", params=emailparams);
            
            cfheader(name="Content-Type" value="text/html; charset=UTF-8");
            cfmail( 
                to = "#user.email#", 
                from = "#application.env.mail_from#", 
                subject = "#emaildata.subject#", 
                server = "#application.env.smtp_host#", 
                port = "#application.env.smtp_port#", 
                username = "#application.env.smtp_username#", 
                password = "#application.env.smtp_password#", 
                type = "html"
            ) { 
                writeOutput(emailContent);
            }
            
            return true;
        } catch (any e) {
            model("Log").log(
                category = "wheels.auth",
                level = "ERROR",
                message = "Failed to send verification email for inactive account",
                details = {
                    "email": user.email,
                    "user_id": user.id,
                    "error_message": e.message,
                    "error_detail": e.detail
                }
            );
            return false;
        }
    }

    private function verifyToken(required string token) {
        var message="";
        var token = model("UserToken").findOne(where="token='#token#'");

        if (isObject(token)) {
            var user = model("User").findByKey(include="Role", key='#token.user_id#');
            if(isObject(user)){
                user.update(status=SetActive(), roleId=2); // Activate user, set editor role
                return user;
            }else{
                message="false";
            }
        } else {
            message = "false";
        }
        return message;
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
            rememberToken.userId = user.id;
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
                sendResetEmail(user.email, user.fullName, token);
                
                data = {
                    "success" = true,
                    "message" = "Password reset instructions have been sent to your email address."
                };
            } else {
                sendSignUpEmail(params.email);
                data = {
                    "success" = true,
                    "message" = "Password reset instructions have been sent to your email address."
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
                "message" = "An error occurred while processing your request. Please try again or contact our support team."
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
                    "message" = "Invalid or expired reset token. Please request a new password reset link."
                };
                renderText("#data.message#"); 
                return;
            }
            
            // Validate password
            if (params.password != params.confirmPassword) {
                data = {
                    "success" = false,
                    "message" = "The passwords you entered do not match. Please try again."
                };
                renderText("#data.message#"); 
                return;
            }
            
            if (len(params.password) < 8) {
                data = {
                    "success" = false,
                    "message" = "Password must be at least 8 characters long. Please choose a stronger password."
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
                "message" = "Your password has been successfully reset. You can now log in with your new password.",
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
                "message" = "An error occurred while resetting your password. Please try again or contact our support team."
            };
            renderText("#data.message#"); 
        }
    }

    private string function generateResetToken() {
        return hash(createUUID() & now(), "SHA-256");
    }

    private void function sendResetEmail(required string email, required string name, required string token) {
        if (application.env.test_case EQ 'true') {
            // Skip email sending in test mode
            return true;
        }
        try {
            model("Log").log(
                category = "wheels.auth",
                level = "INFO",
                message = "Sending password reset email",
                details = {
                    "email": email,
                    "token": token
                }
            );
            var resetUrl = urlFor(action="resetPassword", token=token, onlyPath=false);
            var emaildata = model("emailTemplate").findAll(where="title = '#trim("Reset Password")#'");
            var emailparams = {
                "name" = name,
                "buttonTitle" = emaildata.buttonTitle,
                "content" = emaildata.message,
                "welcomeMessage"= emaildata.welcomeMessage,
                "URl" = resetUrl,
                "footerNote" = emaildata.footerNote,
                "footerGreetings" = emaildata.footerGreating,
                "closingRemark" = emaildata.closingRemark,
                "teamSignature" = emaildata.teamSignature
            };
            var emailContent = renderView(template="/email", layout=false, returnAs="string", params=emailparams);
            cfheader(name="Content-Type" value="text/html; charset=UTF-8");
            cfmail( 
                to = "#arguments.email#", 
                from = "#application.env.mail_from#", 
                subject = "#emaildata.subject#", 
                server = "#application.env.smtp_host#", 
                port = "#application.env.smtp_port#", 
                username = "#application.env.smtp_username#", 
                password = "#application.env.smtp_password#", 
                type = "html"
            ) { 
                writeOutput(emailContent);
            };
            model("Log").log(
                category = "wheels.auth",
                level = "INFO",
                message = "Password reset email sent",
                details = {
                    "email": email
                }
            );
        } catch (any e) {
            model("Log").log(
                category = "wheels.auth",
                level = "ERROR",
                message = "Error sending password reset email",
                details = {
                    "email": email,
                    "token": token,
                    "error_message": e.message,
                    "error_detail": e.detail
                }
            );
            throw e;
        }
    }

    private void function sendSignUpEmail(required string email) {
        if (application.env.test_case EQ 'true') {
            // Skip email sending in test mode
            return true;
        }
        try {
            model("Log").log(
                category = "wheels.auth",
                level = "INFO",
                message = "Account not found sending signup reset email",
                details = {
                    "email": email
                }
            );
            var signUpUrl = urlFor(action="register", onlyPath=false);
            var emaildata = model("emailTemplate").findAll(where="title = '#trim("Register Your Account")#'");
            var emailparams = {
                "name" = "User",
                "buttonTitle" = emaildata.buttonTitle,
                "content" = emaildata.message,
                "welcomeMessage"= emaildata.welcomeMessage,
                "URl" = signUpUrl,
                "footerNote" = emaildata.footerNote,
                "footerGreetings" = emaildata.footerGreating,
                "closingRemark" = emaildata.closingRemark,
                "teamSignature" = emaildata.teamSignature
            };
            var emailContent = renderView(template="/email", layout=false, returnAs="string", params=emailparams);
            cfheader(name="Content-Type" value="text/html; charset=UTF-8");
            cfmail( 
                to = "#arguments.email#", 
                from = "#application.env.mail_from#", 
                subject = "#emaildata.subject#", 
                server = "#application.env.smtp_host#", 
                port = "#application.env.smtp_port#", 
                username = "#application.env.smtp_username#", 
                password = "#application.env.smtp_password#", 
                type = "html"
            ) { 
                writeOutput(emailContent);
            };
            model("Log").log(
                category = "wheels.auth",
                level = "INFO",
                message = "Sign up email sent",
                details = {
                    "email": email
                }
            );
        } catch (any e) {
            model("Log").log(
                category = "wheels.auth",
                level = "ERROR",
                message = "Error sending sign up email on account not found",
                details = {
                    "email": email,
                    "error_message": e.message,
                    "error_detail": e.detail
                }
            );
            throw e;
        }
    }
}