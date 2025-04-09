// function documentation
component extends="app.Controllers.Controller" {

    	function config() {
            super.config();
            verifies(only="index", get=true, params="version", paramsTypes="string", handler="missingParams");
            filters(through="f_getVersions", only="root,index,show,loadVersions");
            filters(through="isValidVersion", only="index,show");
            filters(through="getDocsByVersion", only="index,show");
            verifies(only="show", get=true, params="version,slug", paramsTypes="string,string", handler="missingParams");
            provides("html,json,xml,pdf");
        }

    // Function to load versions
    function loadVersions() {
        versions = model("Version").getAll();
        renderPartial(partial="partials/versions");
    }

	/**
	 * Version Selector
	 */
	function root(){
		redirectTo(route="docVersion", version=application.currentVersion);
	}

	/**
	 * Javascript Based Filterable Index
	 */
	function index(){
		request.pagetitle=params.version;
	}

	/**
	 * Function Permalink Style output
	 */
	function show(){
		// Find this function by slug
		docFunction=getFunctionFromDocs(docs, params.slug);
		if(structIsEmpty(docFunction)){
			redirectTo(route="docVersion", error="Unknown Function", version="#params.version#");
		}
		// Set pagetitle/meta data
		request.pagetitle=docFunction.name & "()" & ' | ' &  params.version;
		// If we're not displaying JSON, try for related functions by category/section
		// Pre 2.x this won't work well.
		paramVersion = replace(params.version, "v", "", "all");
		hasRelatedFunctions = (params.format == "html" && paramVersion >= 2.0)? true : false;
		relatedFunctions = hasRelatedFunctions? getRelatedFunctionsBySectionAndCategory(docs, docFunction.tags.section, docFunction.tags.category) : [];
		renderWith(data=docFunction);
	}

	private function getDocsByVersion(){
		// Get the Main JSON Docs
		docs=getDocJSON(params.version);
		if(structIsEmpty(docs)){
			redirectTo(route="root", error="Unknown Version");
		}

	}

	/**
	 * Missing Params
	 */
	private function missingParams(){
		//redirectTo(route="root", error="Missing Parameters");
	}

	/**
	* Look for primary version; if not in the available versions array, assume it might be a function definiton without
	* version number.
	**/
	function isValidVersion(){
		if(len(params.version) LT 2){
			redirectTo(route="root");
		}
		if(!arrayFind(getAvailableVersions(), right(params.version, len(params.version) - 1))){
			checkIsValidSlug(params);
		};
	}

	function checkIsValidSlug(params){
		// Version is used as a "catchall" due to '.' in the route;
		if(structKeyExists(params, "version")){
			local.isValidSlug=false;
			local.newslug=params.version;
			local.newslugArr=listToArray(params.version, '.');
			local.validScopes=["model","controller","migrator","mapper","deprecated"];
			local.validExt=["html","json","xml","pdf"];
			// Only try and redirect valid scopes
			if(
				arrayFind(local.validScopes, local.newslugArr[1])
				&& arrayFind(local.validExt, local.newslugArr[3])
			){
				redirectTo(route="docFunction", version=application.currentVersion, slug=local.newslug);
			}
		}
	}
}