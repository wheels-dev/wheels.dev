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
            where="blog_posts.slug = '#arguments.slug#' AND blog_posts.status = 'Approved' AND blog_posts.publishedAt IS NOT NULL AND blog_posts.publishedAt <= '#now()#'",
            include="User,PostStatus",
            cache=10
        );
    }

    function getTagsByBlogid(required numeric id) {
        return model("BlogTag").findAll(
            where="blogId = #arguments.id#",
            include="Tag",
            cache=10
        );
    }


    function getCategoriesByBlogid(required numeric id) {
        return model("BlogCategory").findAll(
            where = "blogId = #arguments.id#",
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

    // Shared helper function to update blog post
    function updateBlog(required struct params, required blogId) {
        response = { "success": false, "message": "", "blogId": blogId };

        try {
            // Find the blog by ID
            var blog = model("Blog").findByKey(blogId);

            if (!isObject(blog)) {
                response.message = "Blog post not found.";
                return response;
            }

            var slug = rereplace(lcase(params.title), "[^a-z0-9]", "-", "all");
            slug = rereplace(slug, "-+", "-", "all");
            params.slug = slug;

            if (structKeyExists(params, "isDraft") && params.isDraft eq 1) {
                params.statusId = 1;
            } else if (isUserAdmin()) {
                params.statusId = 2;
                params.status = "Approved";
                // Do NOT set publishedAt on update
            } else {
                params.statusId = 2;
            }

            var existingBlog = model("Blog").findFirst(
                where="title = '#params.title#' AND slug = '#params.slug#' AND id != #blogId#"
            );

            if (isObject(existingBlog)) {
                response.message = "Another blog post with the same title already exists.";
                return response;
            }

            blog.title    = params.title;
            blog.content  = params.content;
            blog.slug     = params.slug;
            blog.statusId = params.statusId;

            if (structKeyExists(params, "status")) {
                blog.status = params.status;
            }
            // Only update publishedAt if this is a creation, not update
            if (structKeyExists(params, "postTypeId")) {
                blog.postTypeId = params.postTypeId;
            }
            if (structKeyExists(params, "postCreatedDate") && len(trim(params.postCreatedDate))) {
                blog.postCreatedDate = params.postCreatedDate;
            }

            blog.updatedAt = now();
            blog.updatedBy = GetSignedInUserId();

            var saveResult = blog.update();

            if (!saveResult) {
                throw(
                    type    = "BlogSaveFailed",
                    message = "blog.update() returned false. Validation errors: #serializeJSON(blog.allErrors())#"
                );
            }

            response.success = true;
            response.message = "Blog post updated successfully.";

        } catch (any e) {
            model("Log").log(
                category = "wheels.blog",
                level    = "ERROR",
                message  = "[UPDATEBLOG] Error updating blog",
                details  = {
                    "blogId"       : blogId,
                    "errorMessage" : e.message,
                    "errorDetail"  : e.detail,
                    "errorType"    : e.type
                },
                userId = GetSignedInUserId()
            );
            rethrow;
        }

        return response;
    }

    function deleteBlogTags(required blogId) {
        try {
            if (!isEmpty(blogId)) {
                model("BlogTag").deleteAll(where="blogId = #arguments.blogId#");
            }
        } catch (any e) {
            model("Log").log(
                category = "wheels.blog",
                level    = "ERROR",
                message  = "[DELETEBLOGTAGS] Failed to delete blog tags",
                details  = {
                    "blogId"       : blogId,
                    "errorMessage" : e.message,
                    "errorDetail"  : e.detail,
                    "errorType"    : e.type
                },
                userId = GetSignedInUserId()
            );
            rethrow;
        }
    }


    function deleteBlogCategories(required blogId) {
        try {
            if (!isEmpty(blogId)) {
                model("BlogCategory").deleteAll(where="blogId = #arguments.blogId#");
            }
        } catch (any e) {
            model("Log").log(
                category = "wheels.blog",
                level    = "ERROR",
                message  = "[DELETEBLOGCATEGORIES] Failed to delete blog categories",
                details  = {
                    "blogId"       : blogId,
                    "errorMessage" : e.message,
                    "errorDetail"  : e.detail,
                    "errorType"    : e.type
                },
                userId = GetSignedInUserId()
            );
            rethrow;
        }
    }

    function saveTags(required struct blogData, blogId) {
        try {
            if (val(blogId) gt 0 && structKeyExists(blogData, "postTags")) {
                var tagArray = listToArray(blogData.postTags, ",");

                for (var tagName in tagArray) {
                    var trimmedTagName = trim(tagName);
                    if (len(trimmedTagName) == 0) continue;

                    // includeSoftDeletes=true — find tag even if it was soft-deleted
                    var existingTag = model("Tag").findOne(
                        where              = "name = '#trimmedTagName#'",
                        includeSoftDeletes = true
                    );

                    if (!isObject(existingTag)) {
                        // Tag never existed — create fresh
                        var newTag       = model("Tag").new();
                        newTag.name      = trimmedTagName;
                        newTag.createdAt = now();
                        newTag.updatedAt = now();

                        if (!newTag.save()) {
                            throw(
                                type    = "TagSaveFailed",
                                message = "Failed to save tag '#trimmedTagName#'. Errors: #serializeJSON(newTag.allErrors())#"
                            );
                        }
                        var tagId = newTag.id;

                    } else if (structKeyExists(existingTag, "deletedAt") && isDate(existingTag.deletedAt) && len(trim(existingTag.deletedAt))) {
                        // Tag exists but was soft-deleted — restore it
                        existingTag.deletedAt = "";
                        existingTag.updatedAt = now();

                        if (!existingTag.save()) {
                            throw(
                                type    = "TagRestoreFailed",
                                message = "Failed to restore tag '#trimmedTagName#'. Errors: #serializeJSON(existingTag.allErrors())#"
                            );
                        }
                        var tagId = existingTag.id;

                        model("Log").log(
                            category = "wheels.blog",
                            level    = "DEBUG",
                            message  = "[SAVETAGS] Restored soft-deleted tag",
                            details  = { "tagName": trimmedTagName, "tagId": tagId },
                            userId   = GetSignedInUserId()
                        );

                    } else {
                        // Tag exists and is active — just use it
                        var tagId = existingTag.id;
                    }

                    // includeSoftDeletes=true — restore blog-tag if soft-deleted
                    var existingBlogTag = model("BlogTag").findOne(
                        where              = "blogId = #blogId# AND tagId = #tagId#",
                        includeSoftDeletes = true
                    );

                    if (isObject(existingBlogTag)) {
                        // Restore soft-deleted blog-tag association
                        existingBlogTag.deletedAt = "";
                        existingBlogTag.updatedAt = now();

                        if (!existingBlogTag.save()) {
                            throw(
                                type    = "BlogTagRestoreFailed",
                                message = "Failed to restore blog-tag. blogId=#blogId#, tagId=#tagId#. Errors: #serializeJSON(existingBlogTag.allErrors())#"
                            );
                        }

                        model("Log").log(
                            category = "wheels.blog",
                            level    = "DEBUG",
                            message  = "[SAVETAGS] Restored soft-deleted blog-tag association",
                            details  = { "blogId": blogId, "tagId": tagId, "tagName": trimmedTagName },
                            userId   = GetSignedInUserId()
                        );

                    } else {
                        // Fresh insert
                        var blogTag       = model("BlogTag").new();
                        blogTag.blogId    = blogId;
                        blogTag.tagId     = tagId;
                        blogTag.createdAt = now();
                        blogTag.updatedAt = now();

                        if (!blogTag.save()) {
                            throw(
                                type    = "BlogTagSaveFailed",
                                message = "Failed to save blog-tag. blogId=#blogId#, tagId=#tagId#. Errors: #serializeJSON(blogTag.allErrors())#"
                            );
                        }

                        model("Log").log(
                            category = "wheels.blog",
                            level    = "DEBUG",
                            message  = "[SAVETAGS] Created new blog-tag association",
                            details  = { "blogId": blogId, "tagId": tagId, "tagName": trimmedTagName },
                            userId   = GetSignedInUserId()
                        );
                    }
                }
            }
        } catch (any e) {
            model("Log").log(
                category = "wheels.blog",
                level    = "ERROR",
                message  = "[SAVETAGS] Failed to save blog tags",
                details  = {
                    "blogId"       : blogId,
                    "errorMessage" : e.message,
                    "errorDetail"  : e.detail,
                    "errorType"    : e.type
                },
                userId = GetSignedInUserId()
            );
            rethrow;
        }
    }


    function saveCategories(required struct blogData, blogId) {
        try {
            if (val(blogId) gt 0 && structKeyExists(blogData, "categoryId")) {
                var categoryArray = listToArray(blogData.categoryId, ",");

                for (var categoryId in categoryArray) {
                    var trimmedCategoryId = trim(categoryId);
                    if (len(trimmedCategoryId) == 0) continue;

                    // includeSoftDeletes=true so we can see soft-deleted rows
                    // and restore them instead of inserting a duplicate
                    var existingBlogCategory = model("BlogCategory").findOne(
                        where              = "blogId = #blogId# AND categoryId = #trimmedCategoryId#",
                        includeSoftDeletes = true
                    );

                    if (isObject(existingBlogCategory)) {
                        // Row exists (soft-deleted) — restore it
                        existingBlogCategory.deletedAt = "";
                        existingBlogCategory.updatedAt = now();

                        if (!existingBlogCategory.save()) {
                            throw(
                                type    = "BlogCategoryRestoreFailed",
                                message = "Failed to restore blog-category. blogId=#blogId#, categoryId=#trimmedCategoryId#. Errors: #serializeJSON(existingBlogCategory.allErrors())#"
                            );
                        }

                        model("Log").log(
                            category = "wheels.blog",
                            level    = "DEBUG",
                            message  = "[SAVECATEGORIES] Restored soft-deleted blog-category association",
                            details  = { "blogId": blogId, "categoryId": trimmedCategoryId },
                            userId   = GetSignedInUserId()
                        );
                    } else {
                        // Row does not exist at all — insert fresh
                        var newCategory            = model("BlogCategory").new();
                        newCategory.blogId         = blogId;
                        newCategory.categoryId     = trimmedCategoryId;
                        newCategory.createdAt      = now();
                        newCategory.updatedAt      = now();

                        if (!newCategory.save()) {
                            throw(
                                type    = "BlogCategorySaveFailed",
                                message = "Failed to save blog-category. blogId=#blogId#, categoryId=#trimmedCategoryId#. Errors: #serializeJSON(newCategory.allErrors())#"
                            );
                        }

                        model("Log").log(
                            category = "wheels.blog",
                            level    = "DEBUG",
                            message  = "[SAVECATEGORIES] Created new blog-category association",
                            details  = { "blogId": blogId, "categoryId": trimmedCategoryId },
                            userId   = GetSignedInUserId()
                        );
                    }
                }
            }
        } catch (any e) {
            model("Log").log(
                category = "wheels.blog",
                level    = "ERROR",
                message  = "[SAVECATEGORIES] Failed to save blog categories",
                details  = {
                    "blogId"       : blogId,
                    "errorMessage" : e.message,
                    "errorDetail"  : e.detail,
                    "errorType"    : e.type
                },
                userId = GetSignedInUserId()
            );
            rethrow;
        }
    }

    /**
     * Extracts YouTube video ID from various YouTube URL formats
     * Supports: https://youtube.com/watch?v=xyz, https://youtu.be/xyz, https://www.youtube.com/embed/xyz
     */
    string function extractYouTubeId(required string url) {
        var id = "";
        // youtu.be format
        if (findNoCase("youtu.be/", arguments.url)) {
            id = listLast(arguments.url, "/");
            // Remove any query parameters
            if (findNoCase("?", id)) {
                id = listFirst(id, "?");
            }
        }
        // youtube.com/watch?v= format
        else if (findNoCase("youtube.com", arguments.url) && findNoCase("v=", arguments.url)) {
            var params = listLast(arguments.url, "?");
            var paramList = listToArray(params, "&");
            for (var param in paramList) {
                if (findNoCase("v=", param)) {
                    id = listLast(param, "=");
                    break;
                }
            }
        }
        // Already embed format
        else if (findNoCase("youtube.com/embed/", arguments.url)) {
            id = listLast(listFirst(arguments.url, "?"), "/");
        }
        return trim(id);
    }

    /**
     * Detects if a URL is embeddable and returns embed HTML
     * Supports: YouTube, Twitter
     */
    string function getEmbedHtml(required string url, string width="100%", string height="400") {
        var embedHtml = "";
        var youtubeId = "";
        var vimeoId = "";
        var trimmedUrl = trim(arguments.url);

        // YouTube
        if (findNoCase("youtube.com", trimmedUrl) || findNoCase("youtu.be", trimmedUrl)) {
            youtubeId = extractYouTubeId(trimmedUrl);
            if (len(youtubeId)) {
                embedHtml = '<iframe width="#arguments.width#" height="#arguments.height#" src="https://www.youtube.com/embed/#youtubeId#?rel=0" frameborder="0" allowfullscreen style="max-width: 100%; margin: 1rem 0; border-radius: 0.5rem;"></iframe>';
            }
        }
        // Twitter/X
        else if (findNoCase("twitter.com", trimmedUrl) || findNoCase("x.com", trimmedUrl)) {
            embedHtml = '<blockquote class="twitter-tweet" style="margin: 1rem 0;"><a href="#trimmedUrl#"></a></blockquote><script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>';
        }

        return embedHtml;
    }

    /**
     * Checks if a URL is embeddable
     */
    boolean function isEmbeddableUrl(required string url) {
        var embeddableDomains = ["youtube.com", "youtu.be", "twitter.com", "x.com"];
        var trimmedUrl = lcase(trim(arguments.url));

        for (var domain in embeddableDomains) {
            if (findNoCase(domain, trimmedUrl)) {
                return true;
            }
        }
        return false;
    }

    /**
     * Converts plain text URLs and embeddable links into HTML
     * For embeddable URLs (YouTube, Vimeo, etc.), creates embed iframes
     * For other URLs, creates anchor tags
     */
    string function embedAndAutoLink(required string content, string class="text--primary", string target="_blank") {
        var result = arguments.content;
        var urlPattern = "(https?://[^\s<""'`]+)";
        var matches = reMatch(urlPattern, result);

        // Remove duplicates
        var uniqueUrls = {};
        for (var match in matches) {
            var cleanUrl = trim(match);
            // Skip if it's already part of an href or src
            if (!findNoCase("href='#cleanUrl#", result) && !findNoCase('href="' & cleanUrl & '"', result) && !findNoCase("src='#cleanUrl#", result) && !findNoCase('src="' & cleanUrl & '"', result)) {
                uniqueUrls[cleanUrl] = cleanUrl;
            }
        }

        // Replace each unique URL
        for (var link in uniqueUrls) {
            if (isEmbeddableUrl(link)) {
                var embedCode = getEmbedHtml(link);
                if (len(embedCode)) {
                    result = replace(result, link, embedCode, "all");
                }
            } else {
                // Regular link
                var linkHtml = '<a href="' & link & '" class="' & arguments.class & '" target="' & arguments.target & '">' & link & '</a>';
                result = replace(result, link, linkHtml, "all");
            }
        }

        return result;
    }
}
