<cfscript>
// Place functions here that should be available globally in your application.
public function GetSignedInUserId(){
    return session.USERID;
}
public function GetRoleId(){
    return 2;
}
public function SetActive(){
    return 1;
}
public function SetInactive(){
    return 0;
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
	local.rv=get("webPath") & get("filePath") & "/json/";
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
</cfscript>
