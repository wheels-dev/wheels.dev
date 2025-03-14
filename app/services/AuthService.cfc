component {
    property name="User";

     function init(userModel) {
        variables.User = userModel; 
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

                userData.token = createUUID();

                if (!isObject(existingUser)) {
                    // Create a new user
                    var newUser = variables.User.new();
                    newUser.firstname = userData.firstname;
                    newUser.lastname = userData.lastname;
                    newUser.email = userData.email;
                    newUser.passwordhash = application.WHEELS.plugins.bcrypt.bCryptHashPW(userData.passwordHash, application.WHEELS.plugins.bcrypt.bCryptGenSalt());
                    // newUser.token = userData.token;
                    newUser.roleid = application.wo.GetBloggerId(); //blogger role
                    newUser.status = application.wo.SetInactive(); //inactive
                    if(newUser.save()){
                        message = "User created successfully.";
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
        var user = variables.User.findOne(where="email='#email#' AND token = '#token#'");
        var verifyUrl = "https://yourwebsite.com/users/verify?token=#user.token#";

        sendEmail(
            from="service@yourwebsite.com",
            to=user.email,
            template="emailtemplate",
            subject="Verify Your Email",
            recipientName=user.name,
            verifyUrl=verifyUrl
        );
        return user;
    }

    function verifyToken(required string token) {
        var message="";
        var user = model("User").findOne(where="token='#params.token#'");
    
        if (!isNull(user)) {
            user.update(status=application.wo.SetActive(), token=""); // Activate user
            message = "true";
        } else {
            message = "false";
        }
        return message;
    }
}
