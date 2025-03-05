component {
    property name="User";

     function init(userModel) {
        variables.User = userModel; 
        return this;
    }    

    function validateCredentials(required string email, required string password) {
        var user = variables.User.findOne(where="email='#email#' AND password_hash='#hash(password)#'", include="Role");

        if (!isObject(user)) {
            return false; // User not found
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
                    user.name = userData.username;
                    user.email = userData.email;
                    user.password = hash(userData.password);
                    user.updatedAt = now();
                    user.updatedBy = application.wo.GetSignedInUserId();
                    user.save();
                    message = "User updated successfully.";
                } else {
                    message = "User not found for editing.";
                }
            } else {
                // Check if a user with the same name and email already exists
                var existingUser = variables.User.findFirst(
                    where="name = '#userData.username#' AND email = '#userData.email#'"
                );

                if (!isObject(existingUser)) {
                    // Create a new user
                    var newUser = variables.User.new();
                    newUser.name = userData.username;
                    newUser.email = userData.email;
                    newUser.password_hash = hash(userData.password);
                    newUser.roleid = application.wo.GetBloggerId(); //blogger role
                    newUser.status = application.wo.SetActive(); //active
                    newUser.createdAt = now();
                    newUser.updatedAt = now();
                    newUser.createdBy = application.wo.GetSignedInUserId();
                    newUser.save();

                    message = "User created successfully.";
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
}
