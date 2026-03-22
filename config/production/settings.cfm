<cfscript>
// Use this file to configure specific settings for the "production" environment.
// A variable set in this file will override the one in "app/config/settings.cfm".

// Disable auto-migration in production — run migrations explicitly in deploy pipeline
set(autoMigrateDatabase=false);

// Example:
// set(errorEmailAddress="someone@somewhere.com");
</cfscript>
