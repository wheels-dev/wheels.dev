<cfscript>
// Place functions here that should be available globally in your application.
public function GetSignedInUserId(){
    return structKeyExists(session, "userID") ? session.userID : 0
}

/**
 * Convert a local datetime to UTC using server's timezone offset
 * Accounts for DST by deriving the actual offset for the given datetime
 * @localTime The datetime to convert to UTC
 * @return The datetime in UTC
 */
public datetime function toUTC(required datetime localTime) {
    try {
        if (!isValid("date", arguments.localTime)) {
            return now();
        }

        // Create a Java calendar to properly handle DST for the given datetime
        var javaCalendar = createObject("java", "java.util.Calendar").getInstance();
        javaCalendar.setTime(arguments.localTime);

        // Get the timezone offset in milliseconds for this specific datetime (DST-aware)
        var timeZone = createObject("java", "java.util.TimeZone").getDefault();
        var offsetMs = timeZone.getOffset(javaCalendar.getTimeInMillis());
        var offsetSeconds = offsetMs / 1000;

        // Subtract offset to get UTC
        return dateAdd("s", -offsetSeconds, arguments.localTime);
    } catch (any e) {
        return now();
    }
}

/**
 * Safely convert a datetime string from a specific timezone to UTC
 * Expects ISO format string from JavaScript (already in UTC)
 * @dateTimeStr The datetime string to convert (expected to be ISO 8601 format from JavaScript)
 * @timeZone The timezone identifier - kept for compatibility but not used since JS sends UTC
 * @return The datetime in UTC, or current UTC time on error
 */
public datetime function toSafeUTC(required string dateTimeStr, string timeZone="") {
    try {
        var trimmedDateStr = trim(arguments.dateTimeStr);

        // Validate input
        if (len(trimmedDateStr) == 0) {
            return toUTC(now());
        }

        // JavaScript sends ISO 8601 strings (already in UTC), parse directly
        // ISO strings end with 'Z' or '+/-HH:mm' to indicate timezone
        var parsedDate = parseDateTime(trimmedDateStr);

        if (!isValid("date", parsedDate)) {
            return toUTC(now());
        }

        return parsedDate;
    } catch (any e) {
        // Fallback: return current UTC time
        return toUTC(now());
    }
}
public function GetUserRoleId(){
    return 3;
}
public function SetActive(){
    return 1;
}
public function SetInactive(){
    return 0;
}
public function Published(){
    return 1;
}

/**
 * Sort by Semvar
 */
array function sortBySemVar(required array versions){
	sv=createObject("component", "app.lib.semver.models.SemanticVersion");
	return arguments.versions.sort( function( a, b ) { return sv.compare( b, a ) } );
}

/**
 * Get a list of available documentation versions
 */
array function getAvailableVersions(string path=getDocJSONPathExpanded()){
	local.rv=[];
	local.versionFiles=directoryList(arguments.path, false, "name", "*.json");
	for(local.v in local.versionFiles){
		arrayAppend(local.rv, getVersionFromFileName(local.v));
	}
 	local.rv=sortBySemVar(local.rv);
	return local.rv;
}
/**
 * Get Path to JSON files
 */
string function getDocJSONPath(){
	local.rv=get("webPath") & "json/";
	return local.rv;
}
/**
 * Get JSON Doc
 */
struct function getDocJSON(required string version){
	local.path = getDocJSONPathExpanded() & arguments.version & ".json";
	if(fileExists(local.path)){
		return deserializeJSON(fileRead(path));
	} else {
		return {};
	}
}
/**
 * Get Absolute Path to JSON files
 */
string function getDocJSONPathExpanded(){
	return expandPath(getDocJSONPath());
}

/**
 * Gets Version from Filename
 */
string function getVersionFromFileName(required string versionString){
	local.rv=right(arguments.versionString, len(arguments.versionString) -1) ;
	local.rv=replaceNoCase(local.rv, ".json","", "one");
	return local.rv;
}
/**
 * Searches JSON array for single function
 */
struct function getFunctionFromDocs(required struct docs, required string functionSlug){
	local.match=arrayFind(docs.functions, function(struct){
		return (struct.slug == functionSlug);
	});
	if(!local.match){
		// Try for non-slugged version: assume controller + model
		local.match=arrayFind(docs.functions, function(struct){
			return (struct.slug == "controller." & functionSlug);
		});
	}

	if(!local.match){
		// Try for non-slugged version: assume controller + model
		local.match=arrayFind(docs.functions, function(struct){
			return (struct.slug == "model." & functionSlug);
		});
	}

	if(local.match){
		return docs.functions[local.match];
	} else {
		return {};
	}
}

any function getRelatedFunctionsBySection(required struct docs, required string section){
	local.match=arrayFilter(docs.functions, function(struct){
		return (struct.tags.section == section);
	});
	return local.match;
}

any function getRelatedFunctionsByCategory(required struct docs, required string category){
	local.match=arrayFilter(docs.functions, function(struct){
		return (struct.tags.category == category);
	});
	return local.match;
}

any function getRelatedFunctionsBySectionAndCategory(
	required struct docs,
	required string section,
	required string category
){
	local.match=arrayFilter(docs.functions, function(struct){
		return (struct.tags.section == section && struct.tags.category == category);
	});
	return local.match;
}

/**
 * Fetch current session user with Role, or return `false` if not valid
 */
private any function getCurrentUserWithRole() {
	if (!structKeyExists(session, "userID") || session.userID == 0) {
        return false;
    }
	var user = model("User").findByKey(key=session.userID, include="Role");
	if (!isObject(user) || !structKeyExists(user, "Role")) {
		return false;
	}
	return user;
}

/**
 * Check if a user can comment based on their role
 */
boolean function canUserComment() {
	var user = getCurrentUserWithRole();
	if (!isObject(user)) {
		return false;
	}
	var allowedRoles = ["admin", "editor", "commenter"];
	return arrayContains(allowedRoles, lcase(user.Role.name));
}

/**
 * Check if the current session user is admin
 */
boolean function isUserAdmin() {
	var user = getCurrentUserWithRole();
	if (!isObject(user)) {
		return false;
	}
	return lcase(user.Role.name) == "admin";
}

/**
 * Check if the current session user has editor or admin role
 */
boolean function hasEditorAccess() {
	var user = getCurrentUserWithRole();
	if (!isObject(user)) {
		return false;
	}
	var roleName = lcase(user.Role.name);
	return roleName == "editor" || roleName == "admin";
}

/**
 * Obfuscate an ID for security (encode)
 */
string function obfuscateId(required numeric id) {
	var salt = getSaltFromEnvironment();
	var encoded = hash(arguments.id & salt, "SHA-256");
	return left(encoded, 16); // Return first 16 characters for shorter URLs
}

/**
 * Deobfuscate an ID (decode)
 */
numeric function deobfuscateId(required string obfuscatedId) {
	var salt = getSaltFromEnvironment();
	var users = model("User").findAll();

	for (var i = 1; i <= users.recordCount; i++) {
		var encoded = hash(users.id[i] & salt, "SHA-256");
		var checkId = left(encoded, 16);
		if (checkId == arguments.obfuscatedId) {
			return users.id[i];
		}
	}

	return 0; // Return 0 if not found
}

/**
 * Get salt from environment variable with fallback
 */
private string function getSaltFromEnvironment() {
	// Try to get from application.env first (from .env file)
	if (structKeyExists(application, "env") && structKeyExists(application.env, "wheels_id_salt")) {
		return application.env.wheels_id_salt;
	}

	throw(type="ConfigurationError", message="wheels_id_salt environment variable is not configured");
}

</cfscript>
