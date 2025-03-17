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
                    newUser.roleid = application.wo.GetBloggerId(); //blogger role
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
        var verifyUrl = "http://#cgi.http_host#/verify?token=#token#";
        if (isObject(user)){
            cfmail( to = "#user.email#", from = "#application.env.mail_from#", subject = "Verify Your Email", server="#application.env.mail_server#", port="#application.env.port#", username="#application.env.username#", password="#application.env.password#", type="html" ) 
            { 
                writeOutput("
                    <html>
                        <body>
                            <p>Thank you for signing up on Wheels!</p>
                            <p>Please click the link below to verify your account:</p>
                            <p><a href='#verifyUrl#'>Verify Your Account</a></p>
                            <p>If you did not sign up, please ignore this email.</p>
                        </body>
                    </html>
                ");
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
}
