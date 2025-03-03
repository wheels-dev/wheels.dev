component {
    property name="User";

     function init(userModel) {
        variables.User = userModel; 
        return this;
    }    

    public any function validateCredentials(required string email, required string password) {
        
        var user = variables.User.findOne(where="email ='#email#' and password_hash = '#hash(password)#'", include="Role");

        if (!isObject(user)) {
            return false; // User not found
        }
        return user;
    }
}
