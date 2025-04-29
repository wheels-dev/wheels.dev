<cfscript>
  // Place helper functions here that should be available for use in all view pages of your application.
  /**
	* Turns "My Thing" into "mything"
	*
	* @str The String
	*/
	string function $cssClassLink(str){
		return trim(replace(lcase(str), " ", "", "all"));
	}
	/**
	* Formats the Main Hint
	*
	* @str The Hint String
	*/
	string function $hintOutput(str){
		local.rv="<p>" & $backTickReplace(arguments.str) & "</p>";
		return trim(local.rv);
	}
	/**
	* Searches for ``` in hint description output and formats
	*
	* @str The String to search
	*/
	string function $backTickReplace(str){
		return ReReplaceNoCase(arguments.str, '`(.*?)`', '<code>\1</code>', "ALL");
	}

	function generateCSRFToken() {
        if (!structKeyExists(session, "csrf_token")) {
            session.csrf_token = hash(createUUID() & now());
        }
        return session.csrf_token;
    }

    function verifyCSRFToken(required string token) {
        return structKeyExists(session, "csrf_token") && token == session.csrf_token;
    }
</cfscript>