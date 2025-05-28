/**
 * This is the parent controller file that all your controllers should extend.
 * You can add functions to this file to make them available in all your controllers.
 * Do not delete this file.
 *
 * NOTE: When extending this controller and implementing `config()` in the child controller, don't forget to call this
 * base controller's `config()` via `super.config()`, or else the call to `protectsFromForgery` below will be skipped.
 *
 * Example controller extending this one:
 *
 * component extends="Controller" {
 *   function config() {
 *     // Call parent config method
 *     super.config();
 *
 *     // Your own config code here.
 *     // ...
 *   }
 * }
 */
component extends="wheels.Controller" {

	function config() {
		protectsFromForgery();
	}

	/**
     * Check if user is logged In
     */
    function isLoggedInUser() {
        return (
            structKeyExists(session, "USERID") && 
            structKeyExists(session, "role") &&
            session.userid != ''
        );
    }

	/**
     * Check if current user is an admin
     */
    function isCurrentUserAdmin() {
        // Assumes session management is handled elsewhere
        return (
            structKeyExists(session, "USERID") && 
            structKeyExists(session, "role") && 
            session.role == "Admin"
        );
    }

    function checkAdminAccess() {
        // Ensure only admin users can access these methods
        if (!isCurrentUserAdmin()) {
            // Save the current URL in session
            saveRedirectUrl(cgi.script_name & "?" & cgi.query_string);
            // Redirect to login page
            redirectTo(controller="AuthController", action="login", route="auth-login");
            return false;
        }
        return true;
    }

    function checkRoleAccess(){
        var controller = lCase(listLast(request.wheels.params.controller, "."));
        var action = request.wheels.params.action;
        var accesspermission = model("RolePermission").findAll(
            select="roleId, permissionId, name, permissionName, permissionstatus, controller, permissiondescription", 
            include="Role, Permission", 
            where="name = '#session.role#' AND permissions.Name = '#action#' AND permissions.controller = '#controller#'"
            );
        if(accesspermission.recordCount == 0){
            getPageContext().getResponse().setHeader("HX-Redirect", "/error403");
            abort;
        }
        return true;
    }

    function f_getVersions(){
		versions=getAvailableVersions();
	}

    public function restrictAccess() {        
        // Check if the user is logged in
        if (application.wheels.environment EQ "development") {
            return true; // Skip check in test mode
        }
        saveRedirectUrl(cgi.path_info);
        if (!structKeyExists(session, "USERID") || !structKeyExists(session, "role")) {
            redirectTo(controller="AuthController", action="login", route="auth-login");
            return false;
        }

        // Allow only specific roles
        if (!listFindNoCase("Editor,Admin", session.role)) {
            // redirectTo(controller="HomeController", action="index");
            return false;
        }

        return true;
    }

    // Shared business logic across multiple controllers
    public function getBlogBySlug(required string slug) {
        return model("Blog").findOne(
            where="blog_posts.slug = '#arguments.slug#' AND status ='Approved' AND isPublished='true' ",
            include="User,PostStatus"
        );
    }

    function getTagsByBlogid(required numeric id) {
        return model("Tag").findAllByBlogId("#arguments.id#");
    }


    function getCategoriesByBlogid(required numeric id) {
        return model("BlogCategory").findAll(
            where = "blogId = #arguments.id#",
            include = "Blog,Category"
        );
    }

    function getAttachmentsByBlogid(required numeric id) {
      return model("Attachment").findAllByBlogId("#arguments.id#")
    }

    function saveRedirectUrl(url) {
        session.redirectAfterLogin = arguments.url;
    }

    public string function generateMetaDescription(required string htmlContent) {
        // Remove headings and non-paragraph wrappers
        var contentWithoutHeadings = reReplaceNoCase(arguments.htmlContent, "<h[1-6][^>]*>.*?</h[1-6]>", "", "all");
        
        // Extract only paragraph blocks
        var paragraphMatches = reMatchNoCase("<p[^>]*>(.*?)</p>", contentWithoutHeadings);
        var cleanText = "";
        
        for (var para in paragraphMatches) {
            // Strip inner tags from paragraph content
            var plainPara = trim(reReplace(para, "<[^>]*>", "", "all"));
            
            // Skip if the paragraph is too short or looks like a heading
            if (len(plainPara) GTE 40) {
                cleanText = plainPara;
                break;
            }
        }

        // Fallback: use stripped full content if no usable paragraph found
        if (cleanText == "") {
            cleanText = trim(reReplace(arguments.htmlContent, "<[^>]*>", "", "all"));
        }

        // Extract up to 2 sentences, avoiding decimals like 3.0 or 2.5
        var pattern = "[^.!?]+[.!?]";
        var pos = 1;
        var meta = "";
        var sentences = [];

        while (pos LTE len(cleanText)) {
            var found = reFind(pattern, cleanText, pos, true);
            if (!found.len[1]) break;

            var sentence = trim(mid(cleanText, found.pos[1], found.len[1]));

            // Skip sentence if it contains decimal numbers (e.g., 3.0)
            if (!reFind("\d+\.\d+", sentence)) {
                arrayAppend(sentences, sentence);
            }

            pos += found.len[1];

            // Stop after 2 sentences or if length looks good
            if (arrayLen(sentences) >= 2 || len(arrayToList(sentences, " ")) >= 160) break;
        }

        meta = arrayToList(sentences, " ");

        // Final fallback if no valid sentences
        if (len(meta) == 0) {
            meta = left(cleanText, 160);
        }

        return left(meta, 160);
    }

    public function autoLink(required string text, string class = "", string target = "_blank") {
        var result = text;

        // Step 1: Add class and target to existing anchor tags (if not present)
        result = reReplace(result, "<a(?![^>]*\bclass=)([^>]*?)>", "<a class='#arguments.class#'\1>", "all");
        result = reReplace(result, "<a(?![^>]*\btarget=)([^>]*?)>", "<a target='#arguments.target#'\1>", "all");

        // Step 2: Convert plain URLs (http/https) not already in anchor tags
        var anchors = reMatch("<a[^>]*>.*?</a>", result);
        var placeholders = [];
        var i = 1;

        for (a in anchors) {
            var placeholder = "%%ANCHOR_" & i & "%%";
            placeholders.append(placeholder);
            result = replace(result, a, placeholder, "all");
            i++;
        }

        // Replace raw URLs (http/https only)
        result = reReplace(result, "(https?://[^\s<]+)", "<a href='\1' class='#arguments.class#' target='#arguments.target#'>\1</a>", "all");

        // Restore original anchor tags
        for (j = 1; j LTE arrayLen(placeholders); j++) {
            result = replace(result, placeholders[j], anchors[j], "all");
        }

        return result;
    }

    public function getBaseUrl() {
        return application.env.application_host;
     }
}
