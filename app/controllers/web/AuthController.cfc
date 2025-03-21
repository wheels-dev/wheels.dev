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
            user = validateCredentials(params.email, params.passwordHash);

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

    function register() {}

    function store() {
        param name="params.email" default="";
        param name="params.passwordHash" default="";
        
        try{
            // save user logic
            var message = saveUser(params);
            renderText("<p style='color:red;'>#message#</p>");
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
                session.role = user.roleId;

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
                
            // Check if the user ID is greater than 0 (for editing an existing user)
            if (StructKeyExists(userData, "id") and userData.id > 0) {
                var user = model("User").findById(userData.id);

                if (not isNull(user)) {
                    // Edit the existing user
                    user.first_name = userData.firstname;
                    user.last_name = userData.lastname;
                    user.email = userData.email;
                    user.password_hash = application.WHEELS.plugins.bcrypt.bCryptHashPW(userData.passwordHash, application.WHEELS.plugins.bcrypt.bCryptGenSalt());
                    user.updatedAt = now();
                    user.updatedBy = GetSignedInUserId();
                    user.save();
                    message = "User updated successfully.";
                } else {
                    message = "User not found for editing.";
                }
            } else {
                // Check if a user with the same email already exists
                var existingUser = model("User").findFirst( where="email = '#userData.email#'");

                if (!isObject(existingUser)) {
                    // Create a new user
                    var newUser = model("User").new();
                    newUser.firstname = userData.firstname;
                    newUser.lastname = userData.lastname;
                    newUser.email = userData.email;
                    newUser.passwordhash = application.WHEELS.plugins.bcrypt.bCryptHashPW(userData.passwordHash, application.WHEELS.plugins.bcrypt.bCryptGenSalt());
                    newUser.roleid = GetRoleId(); //blogger role
                    newUser.status = SetActive(); // temporary active

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
                    message = "A user with the same name and email already exists.";
                }
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
                #emailContent#
            }
            return true;
        }
        return false;
    }

    private function verifyToken(required string token) {
        var message="";
        var token = model("UserToken").findOne(where="token='#token#'");

        if (isObject(token)) {
            var user = model("User").findByKey(token.user_id);
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