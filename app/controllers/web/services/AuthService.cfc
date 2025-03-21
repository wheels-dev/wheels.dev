component {
    property name="User";
    property name="tokenModel";

     function init(userModel, tokenModel) {
        variables.User = userModel;
        variables.tokenModel = tokenModel; 
        return this;
    }    

    function validateCredentials(required string email, required string passwordHash) {
        var user = variables.User.findOne(where="email='#email#'", include="Role");
        if (!isObject(user)) {
            return false; // User not found
        }
        if(!application.WHEELS.plugins.bcrypt.bCryptCheckPW(passwordHash,user.passwordHash)){
            return false;
        }
        return user;
    }
    
    function saveUser(required struct userData) {        
        var message = "";

        // writeDump(application); abort;
        try {
                
            // Check if the user ID is greater than 0 (for editing an existing user)
            if (StructKeyExists(userData, "id") and userData.id > 0) {
                var user = variables.User.findById(userData.id);

                if (not isNull(user)) {
                    // Edit the existing user
                    user.first_name = userData.firstname;
                    user.last_name = userData.lastname;
                    user.email = userData.email;
                    user.password_hash = application.WHEELS.plugins.bcrypt.bCryptHashPW(userData.passwordHash, application.WHEELS.plugins.bcrypt.bCryptGenSalt());
                    user.updatedAt = now();
                    user.updatedBy = application.wo.GetSignedInUserId();
                    user.save();
                    message = "User updated successfully.";
                } else {
                    message = "User not found for editing.";
                }
            } else {
                // Check if a user with the same email already exists
                var existingUser = variables.User.findFirst( where="email = '#userData.email#'");

                if (!isObject(existingUser)) {
                    // Create a new user
                    var newUser = variables.User.new();
                    newUser.firstname = userData.firstname;
                    newUser.lastname = userData.lastname;
                    newUser.email = userData.email;
                    newUser.passwordhash = application.WHEELS.plugins.bcrypt.bCryptHashPW(userData.passwordHash, application.WHEELS.plugins.bcrypt.bCryptGenSalt());
                    newUser.roleid = application.wo.GetRoleId(); //blogger role
                    newUser.status = application.wo.SetInactive(); //inactive

                    if(newUser.save()){
                        // Generate a unique verification token
                        var verificationToken = Hash(createUUID());

                        // Save token to the user_tokens table
                        var newToken = variables.tokenModel.new();
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

    function sendVerificationEmail(required string email, required string token) {
        var user = variables.User.findOne(where="email='#email#'");
        verifyUrl = "http://#cgi.http_host#/verify?token=#token#";
        emailContent = generateVerifyEmail(verifyUrl);
        
        if (isObject(user)){
            cfmail( to = "#user.email#", from = "#application.env.mail_from#", subject = "Verify Your Email", server="#application.env.smtp_host#", port="#application.env.smtp_port#", username="#application.env.smtp_username#", password="#application.env.smtp_password#", type="html" ) 
            { 
                #emailContent#
            }
            return true;
        }
        return false;
    }

    function verifyToken(required string token) {
        var message="";
        var token = variables.tokenModel.findOne(where="token='#token#'");

        if (isObject(token)) {
            var user = variables.User.findByKey(token.user_id);
            if(isObject(user)){
                user.update(status=application.wo.SetActive()); // Activate user
                return user;
            }else{
                message="false";
            }
        } else {
            message = "false";
        }
        return message;
    }

    public function getDump(){
        // writeDump(application); 
        writeDump(application.wheels.controllers); 
        abort;
    }

    public string function generateVerifyEmail(required string verifyUrl) {
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
