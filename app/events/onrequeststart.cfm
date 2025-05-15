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
</cfscript>
