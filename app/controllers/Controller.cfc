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
            lCase(session.role) == "admin"
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
        var controller = listLast(request.wheels.params.controller, ".");
        var action = request.wheels.params.action;
        var accesspermission = model("RolePermission").findAll(
            select="roleId, permissionId, name, permissionName, permissionstatus, controller, permissiondescription",
            include="Role, Permission",
            where="name = '#session.role#' AND permissions.Name = '#action#' AND permissions.controller = '#controller#'"
            );
        if(accesspermission.recordCount == 0){
            if (structKeyExists(getHttpRequestData().headers, "HX-Request")) {
                getPageContext().getResponse().setHeader("HX-Redirect", "/error403");
                abort;
            } else {
                redirectTo(route="error403");
            }
        }
        return true;
    }

    function f_getVersions(){
		versions=getAvailableVersions();
	}

    public function restrictAccess() {
        // Check if the user is logged in
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
            where="blog_posts.slug = '#arguments.slug#' AND blog_posts.status = 'Approved' AND blog_posts.publishedAt IS NOT NULL",
            include="User,PostStatus",
            cache=10
        );
    }

    function getTagsByBlogid(required numeric id) {
        return model("Tag").findAllByBlogId(value="#arguments.id#", cache=10);
    }


    function getCategoriesByBlogid(required numeric id) {
        return model("BlogCategory").findAll(
            where = "blogId = #val(arguments.id)#",
            include = "Blog,Category",
            cache = 10
        );
    }

    function getAttachmentsByBlogid(required numeric id) {
      return model("Attachment").findAllByBlogId(value="#arguments.id#", cache=10);
    }

    public function getContributors(){
        var contributorsList = model("contributors").findAll(where="username!='dependabot[bot]'", cache=60);

        if(contributorsList.recordCount == 0){
            return [];
        }

        if(dateDiff("d", contributorsList.updatedAt, now()) >= 30){
            var contributorLink = model("setting").findAll(select="wheelsContributorLink");
            if(contributorLink.recordCount == 0 OR contributorLink.wheelsContributorLink == ""){
                return [];
            }
            var apiUrl = contributorLink.wheelsContributorLink;

            // GitHub requires a User-Agent header
            cfhttp(url="#apiUrl#", method="get", timeout=30, result="resp"){
                cfhttpparam(type="header", name="User-Agent", value="CFWheels-App");
            }
            if (listFirst(resp.statusCode, " ") EQ "200") {
                contributors = deserializeJson(resp.fileContent);

                // loop contributors and enrich with real name
                for (i=1; i <= arrayLen(contributors); i++) {
                    username = contributors[i].login;
                    userUrl = "https://api.github.com/users/" & username;

                    cfhttp(url=userUrl, method="get", timeout=30, result="userResp") {
                        cfhttpparam(type="header", name="User-Agent", value="CFWheels-App");
                    }

                    if (listFirst(userResp.statusCode, " ") EQ "200") {
                        userData = deserializeJson(userResp.fileContent);

                        // GitHub may return null if no name is set
                        if (structKeyExists(userData, "name") AND len(trim(userData.name))) {
                            contributors[i].name = userData.name;
                        } else {
                            contributors[i].name = contributors[i].login; // fallback if not set
                        }

                        // === Insert only if not exists ===
                        var existing = model("Contributor").findOneByUsername(username);

                        if (!isObject(existing)) {
                            var c = model("Contributor").new();
                            c.name        = contributors[i].name;
                            c.username    = contributors[i].login;
                            c.description = "";
                            c.roles       = "1";
                            c.profilePic  = userData.avatar_url;
                            c.contributions = contributors[i].contributions;
                            c.profileAPI  = userData.url;
                            c.LinkedInLink = "";
                            c.save();
                        }else{
                            var c = existing;
                            c.name        = contributors[i].name;
                            c.username    = contributors[i].login;
                            c.profilePic  = userData.avatar_url;
                            c.contributions = contributors[i].contributions;
                            c.profileAPI  = userData.url;
                            c.save();
                        }
                    }
                }
                contributors = model("contributors").findAll(where="username!='dependabot[bot]'");
            }else{
                contributors = contributorsList;
            }
        }else{
            contributors = contributorsList;
        }
        contributorsArray = [];
        // Preload all roles to avoid N+1 queries
        var rolesMap = {};
        for (r in model("contributor_role").findAll(cache=60)) {
            rolesMap[r.id] = r.rolename;
        }

        for (row in contributors) {
            var roleString = "";
            var roleIds = (!isNull(row.roles) AND len(trim(row.roles))) ? listToArray(row.roles, ",") : [];

            for (var j=1; j <= arrayLen(roleIds); j++) {
                var roleName = rolesMap[ roleIds[j] ] ?: ""; // safe lookup

                if (len(roleName)) {
                    if (j == 1) {
                        roleString &= roleName;
                    } else if (j == arrayLen(roleIds)) {
                        roleString &= " and " & roleName;
                    } else {
                        roleString &= ", " & roleName;
                    }
                }
            }

            contributor = {
                "name"        : row.name,
                "description" : row.description,
                "role"        : roleString,
                "profilePic"  : row.contributor_pic,
                "LinkedInLink": row.LinkedIn_Link
            };
            arrayAppend(contributorsArray, contributor);
        }
        return contributorsArray;
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

    public function getAvatarColorByLetter(required string letter){
        var colors = {
            A: "bg-danger", B: "bg-primary", C: "bg-success", D: "bg-warning", E: "bg-info",
            F: "bg-secondary", G: "bg-dark", H: "bg-danger", I: "bg-primary", J: "bg-success",
            K: "bg-warning", L: "bg-info", M: "bg-secondary", N: "bg-dark", O: "bg-danger",
            P: "bg-primary", Q: "bg-success", R: "bg-warning", S: "bg-info", T: "bg-secondary",
            U: "bg-dark", V: "bg-danger", W: "bg-primary", X: "bg-success", Y: "bg-warning", Z: "bg-info"
        };
        var l = ucase(trim(arguments.letter));
        if(len(l) EQ 1 AND reFind("^[A-Z]$", l)){
            return structFind(colors, l, "bg-body-secondary");
        }else{
            return "bg-body-secondary";
        }
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

    // ==================== Shared Email Helper ====================

    /**
     * Send an HTML email using the application's SMTP configuration.
     * Centralizes the cfmail pattern used across all controllers.
     *
     * @to Recipient email address
     * @subject Email subject line
     * @htmlContent Rendered HTML email body
     */
    function sendAppEmail(required string to, required string subject, required string htmlContent) {
        cfmail(
            to = arguments.to,
            from = application.env.mail_from,
            subject = arguments.subject,
            server = application.env.smtp_host,
            port = application.env.smtp_port,
            username = application.env.smtp_username,
            password = application.env.smtp_password,
            type = "html"
        ) {
            writeOutput(arguments.htmlContent);
        };
    }

    // ==================== Shared Blog Helper Functions ====================
    // Used by both web.BlogController and admin.AdminController

    function saveTags(required struct blogData, blogId) {
        try {
            if (blogId > 0 && structKeyExists(blogData, "postTags")) {

                var tagArray = listToArray(blogData.postTags, ","); // Convert postTags string into an array

                // Insert new tags
                for (var tagName in tagArray) {
                    var newTag = model("Tag").new();
                    newTag.name = trim(tagName); // Trim spaces if any
                    newTag.blogId = blogId;
                    newTag.createdAt = now();
                    newTag.updatedAt = now();
                    newTag.save();
                }
            }
        } catch (any e) {
            local.exception = e;
        }
    }

    // Function to delete tags associated with a blog post
    function deleteBlogTags(required numeric blogId) {
        try {
            if (blogId > 0) {
                // direct delete approach
                model("Tag").deleteAll(where="blogId = #val(arguments.blogId)#");

                return true;
            }
            return false;
        } catch (any e) {
            model("Log").log(
                category = "wheels.blog",
                level = "ERROR",
                message = "Failed to delete blog tags",
                details = {
                    "blog_id": blogId,
                    "error_message": e.message,
                    "error_detail": e.detail,
                    "error_type": e.type
                },
                userId = GetSignedInUserId()
            );
            return false;
        }
    }

    function saveCategories(required struct blogData, blogId) {
        try {
            if (blogId > 0 && structKeyExists(blogData, "categoryId")) {

                var categoryArray = listToArray(blogData.categoryId, ","); // Convert categoryId string into an array

                // Insert new categories
                for (var category_Id in categoryArray) {
                    var newCategory = model("BlogCategory").new();
                    newCategory.categoryId = category_Id;
                    newCategory.blogId = blogId;
                    newCategory.createdAt = now();
                    newCategory.updatedAt = now();
                    newCategory.save();
                }
            }
        } catch (any e) {
            model("Log").log(
                category = "wheels.blog.tags",
                level = "ERROR",
                message = "Failed to save blog tags for blogId: #blogId#",
                details = {
                    "blog_id": blogId,
                    "error_message": e.message,
                    "error_detail": e.detail,
                    "error_type": e.type
                },
                userId = GetSignedInUserId()
            );
        }
    }

    // Function to delete categories associated with a blog post
    function deleteBlogCategories(required numeric blogId) {
        try {
            if (blogId > 0) {
                // Find all category associations for this blog post
                model("BlogCategory").deleteAll(where="blogId = #val(arguments.blogId)#");

                return true;
            }
            return false;
        } catch (any e) {
            model("Log").log(
                category = "wheels.blog",
                level = "ERROR",
                message = "Failed to delete blog categories",
                details = {
                    "blog_id": blogId,
                    "error_message": e.message,
                    "error_detail": e.detail,
                    "error_type": e.type
                },
                userId = GetSignedInUserId()
            );
            return false;
        }
    }

    // Shared helper function to update blog post
    // Used by both web.BlogController and admin.AdminController
    function updateBlog(required struct params, required numeric blogId) {
        var response = { "success": false, "message": "", "blogId": blogId };

        try {
            // Find the blog by ID
            var blog = model("Blog").findByKey(blogId);

            if (!isObject(blog)) {
                response.message = "Blog post not found for updating.";
                return response;
            }

            // Generate slug
            var slug = rereplace(lcase(params.title), "[^a-z0-9]", "-", "all"); // Replace non-alphanumeric with "-"
            slug = rereplace(slug, "-+", "-", "all");
            params.slug = slug;

            // Set status based on isDraft flag and user role
            if (structKeyExists(params, "isDraft") && params.isDraft eq 1) {
                params.statusId = 1; // Draft
            } else if (isUserAdmin()) {
                // Auto-approve and publish for admin users
                params.statusId = 2;
                params.status = "Approved";
                params.publishedAt = now();
            } else {
                params.statusId = 2; // Under Review
            }

            // Check if a blog with the same title/slug exists (that isn't this one)
            var existingBlog = model("Blog").findFirst(
                where="title = '#params.title#' AND slug = '#params.slug#' AND id != #val(blogId)#"
            );

            if (isObject(existingBlog)) {
                response.message = "Another blog post with the same title already exists.";
                return response;
            }

            // Update the blog post
            blog.title = params.title;
            blog.content = params.content;
            blog.slug = params.slug;
            blog.statusId = params.statusId;

            // Set approval status fields for admin auto-approval
            if (structKeyExists(params, "status")) {
                blog.status = params.status;
            }
            if (structKeyExists(params, "publishedAt") && len(trim(params.publishedAt))) {
                blog.publishedAt = params.publishedAt;
            }

            // Only update these if they exist in params
            if (structKeyExists(params, "postTypeId")) {
                blog.postTypeId = params.postTypeId;
            }

            if (structKeyExists(params, "postCreatedDate") && len(trim(params.postCreatedDate))) {
                blog.postCreatedDate = params.postCreatedDate;
            }

            // Update tracking fields
            blog.updatedAt = now();
            blog.updatedBy = GetSignedInUserId();

            // Save the blog post
            blog.save();

            response.success = true;
            response.message = "Blog post updated successfully.";
        }
        catch (any e) {
            response.message = "Error updating blog: " & e.message;
            model("Log").log(
                category = "wheels.blog",
                level = "ERROR",
                message = "Error in updateBlog function",
                details = {
                    "blog_id": blogId,
                    "error_message": e.message,
                    "error_detail": e.detail,
                    "error_type": e.type
                },
                userId = GetSignedInUserId()
            );
        }

        return response;
    }
}
