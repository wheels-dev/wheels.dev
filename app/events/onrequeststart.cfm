<cfscript>
// Place code here that should be executed on the "onRequestStart" event.
if (structKeyExists(session, "userID") && session.userID neq "") {
    // Check if lastActivity is set
    if (structKeyExists(session, "lastActivity")) {
        var timeSinceLastActivity = dateDiff("n", session.lastActivity, now());

        // If idle for more than 30 minutes, log out
        if (timeSinceLastActivity >= 30) {
            structClear(session);
            location(url="/login", addtoken=false);
            return false;
        }
    }

    // Update last activity timestamp
    session.lastActivity = now();
}
// support remember me functionalty
if (!structKeyExists(session, "userID") && structKeyExists(cookie, "remember_me")) {
    try {
        var rawToken = cookie.remember_me;
        var hashedToken = hash(rawToken, "SHA-256");

        // Look up remember-me record
        var record = model("RememberToken").findOne(
            where = "token = '#hashedToken#' AND expiresAt > '#dateTimeFormat(now(), "yyyy-MM-dd HH:nn:ss")#' AND userAgent = '#cgi.http_user_agent#'"
        );

        if (isObject(record)) {
            var user = model("User").findOne(where="id = #val(record.userId)#", include="Role");
            if (isObject(user)) {
                // Rebuild session
                session.userID = user.id;
                session.username = user.fullname;
                session.role = (isObject(user.role) ? user.role.name : "");
                session.profilePic = user.profilePicture;
                session.lastActivity = now();
                // rotate token
                var newToken = createUUID() & generateSecretKey("AES");
                var newHashedToken = hash(newToken, "SHA-256");
                var newRememberToken = model("RememberToken").new();
                newRememberToken.token = newHashedToken;
                newRememberToken.userAgent = cgi.http_user_agent;
                newRememberToken.userId = user.id;
                newRememberToken.expiresAt = dateAdd("d", 07, now());
                if (newRememberToken.save()) {
                    model("Log").log(
                        category = "wheels.auth",
                        level = "INFO",
                        message = "Remember me token rotate successfully",
                        details = {
                            "user_id": user.id
                        }
                    );
                    if (len(newToken)) {
                    cfcookie(
                        name="remember_me",
                        value=newToken,
                        expires="07",
                        secure="true",
                        httponly="true",
                        samesite="Strict"
                    );
                    record.delete(); // remove the old token
                }
                } else {
                    model("Log").log(
                        category = "wheels.auth",
                        level = "ERROR",
                        message = "Failed to rotate remember me token",
                        details = {
                            "user_id": user.id,
                            "errors": newRememberToken.allErrors()
                        }
                    );
                }
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
        }else{
            var record = model("RememberToken").findOne(
                where = "token = '#hashedToken#'",
                includeSoftDeletes = true
            );
            if(isObject(record)){
                // Suspicious activity
                if (record.userAgent NEQ cgi.http_user_agent) {
                    model("RememberToken").deleteAll(where="userId = #val(record.userId)#");

                    model("Log").log(
                        category = "wheels.auth",
                        level = "WARN",
                        message = "Suspicious remember-me usage: userAgent mismatch, all tokens revoked",
                        details = {
                            "user_id": record.userId,
                            "expected_agent": record.userAgent,
                            "actual_agent": cgi.http_user_agent
                        }
                    );
                }else{
                    // Expired attempt
                    model("RememberToken").deleteAll(where="userId = #val(record.userId)#");
                    model("Log").log(
                        category = "wheels.auth",
                        level = "WARN",
                        message = "Suspicious remember-me usage:  Some one use expire remember me token, all tokens revoked",
                        details = {
                            "user_id": record.userId,
                            "token": record.token
                        }
                    );
                }
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
