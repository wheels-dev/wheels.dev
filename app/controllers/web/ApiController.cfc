// function documentation
component extends="app.Controllers.Controller" {

    	function config() {
			super.config();
			verifies(only="index", get=true, params="version", paramsTypes="string", handler="missingParams");
			verifies(only="show", get=true, params="version,slug", paramsTypes="string,string", handler="missingParams");
			verifies(only="loadMoreFunctions,loadFunctionBySlug,loadFunctionsBySection,loadFunctionsBySectionAndCategory", get=true, params="version", paramsTypes="string", handler="missingParams");

			filters(through="f_getVersions", only="root,index,show,loadVersions", except="loadMoreFunctions,loadFunctionBySlug,loadFunctionsBySection,loadFunctionsBySectionAndCategory");
			filters(through="isValidVersion", only="index,show", except="loadMoreFunctions,loadFunctionBySlug,loadFunctionsBySection,loadFunctionsBySectionAndCategory");
			filters(through="getDocsByVersion", only="index,show", except="loadMoreFunctions,loadFunctionBySlug,loadFunctionsBySection,loadFunctionsBySectionAndCategory");

			usesLayout(template="/Layout", except="loadMoreFunctions,loadFunctionBySlug,loadFunctionsBySection,loadFunctionsBySectionAndCategory"); 

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
		param name="params.start" default="0";
		param name="params.limit" default="5";
		// Get the Main JSON Docs
		docs=getDocJSON(params.version);
		if(structIsEmpty(docs)){
			redirectTo(route="root", error="Unknown Version");
		}
		startIndex = val(params.start) + 1; // ColdFusion is 1-based index
		limitCount = val(params.limit);
		currentVersion = params.version;

		docsChunk = arraySlice(docs.functions, startIndex, limitCount);
	}

	function loadMoreFunctions() {
		param name="params.version" default="";
		param name="params.start" default="0";
		param name="params.limit" default="5";

		docs = getDocJSON(params.version);
		if (structIsEmpty(docs)) {
			renderWith(statusCode=404, text="Unknown version");
			return;
		}

		startIndex = val(params.start) + 1;
		limitCount = val(params.limit);

		// Prevent overflow
		total = arrayLen(docs.functions);
		endIndex = min(startIndex + limitCount - 1, total);

		// Return empty if start is beyond total
		if (startIndex GT total) {
			renderPartial(partial="partials/moredefinition"); // or return empty safely
			return;
		}
		
		docsChunk = arraySlice(docs.functions, startIndex, endIndex - startIndex + 1);
		startIndex = startIndex;
		renderPartial(partial="partials/moredefinition"); // new partial
		return;
	}

	function loadFunctionBySlug() {
		param name="params.version" default="";
		param name="params.slug" default="";

		docs = getDocJSON(params.version);
		if (structIsEmpty(docs)) {
			renderWith(statusCode=404, text="Unknown version");
			return;
		}

		func = getFunctionFromDocs(docs, params.slug);

		if (structIsEmpty(func)) {
			renderWith(statusCode=404, text="Function not found");
			return;
		}

		// Wrap in array so the existing partial can loop over it
		docsChunk = [func];

		renderPartial(partial="partials/moredefinition"); // or your normal _definition loop
	}

	function loadFunctionsBySection() {
		param name="params.version" default="";
		param name="params.section" default="";
		
		docs = getDocJSON(params.version);
		if (structIsEmpty(docs)) {
			renderWith(statusCode=404, text="Version not found");
			return;
		}

		docsChunk = [];
		
		for (f = 1; f <= arrayLen(docs.functions); f++) {
			if (lcase(docs.functions[f].tags.sectionClass ?: "") EQ lcase(params.section)) {
				arrayAppend(docsChunk, docs.functions[f]);
			}
		}

		request.disablePagination = true;
		renderPartial(partial="partials/moredefinition");
	}

	function loadFunctionsBySectionAndCategory() {
		param name="params.version" default="";
		param name="params.section" default="";
		param name="params.category" default="";

		docs = getDocJSON(params.version);
		if (structIsEmpty(docs)) {
			renderWith(statusCode=404, text="Version not found");
			return;
		}

		docsChunk = [];

		for (f = 1; f <= arrayLen(docs.functions); f++) {
			if (
				lcase(docs.functions[f].tags.sectionClass ?: "") EQ lcase(params.section) AND
				lcase(docs.functions[f].tags.categoryClass ?: "") EQ lcase(params.category)
			) {
				arrayAppend(docsChunk, docs.functions[f]);
			}
		}
		request.disablePagination = true;
		renderPartial(partial="partials/moredefinition");
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