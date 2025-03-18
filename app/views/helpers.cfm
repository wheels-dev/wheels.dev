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
</cfscript>