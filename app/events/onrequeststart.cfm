<cfscript>
// Place code here that should be executed on the "onRequestStart" event.
if (structKeyExists(session, "userId") && session.userId neq "") {
    // Check if lastActivity is set
    if (structKeyExists(session, "lastActivity")) {
        var timeSinceLastActivity = dateDiff("n", session.lastActivity, now());
        
        // If idle for more than 30 minutes, log out
        if (timeSinceLastActivity >= 30) {
            structDelete(session, "userId");
            structDelete(session, "lastActivity");
            location(url="/login", addtoken=false);
            return false;
        }
    }
    
    // Update last activity timestamp
    session.lastActivity = now();
}
if (!structKeyExists(session, "userID") && structKeyExists(cookie, "remember_me")) {
    try {
        var rawToken = cookie.remember_me;
        var hashedToken = hash(rawToken, "SHA-256");

        // Look up remember-me record
        var record = model("RememberToken").findOne(
            where = "token = '#hashedToken#' AND expiresAt > '#NOW()#'"
        );

        if (isObject(record)) {
            var user = model("User").findByKey(record.userId);
            var user = model("User").findOne(where="id='#record.userId#'", include="Role");
            if (isObject(user)) {
                // Rebuild session
                session.userID = user.id;
                session.username = user.fullname;
                session.role = (isObject(user.role) ? user.role.name : "");
                session.profilePic = user.profilePicture;
                session.lastActivity = now();

                model("Log").log(
                    category = "wheels.auth",
                    level = "INFO",
                    message = "User auto-logged in via remember me cookie",
                    details = {
                        "user_id": user.id,
                        "email": user.email
                    }
                );
            }
        }
    } catch (any e) {
        model("Log").log(
            category = "wheels.auth",
            level = "ERROR",
            message = "Error during remember me auto-login",
            details = {
                "error_message": e.message,
                "error_detail": e.detail,
                "cookie_value": cookie.remember_me
            }
        );
    }
}
</cfscript>
