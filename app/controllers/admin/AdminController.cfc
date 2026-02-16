// Admin Panel
component extends="app.Controllers.Controller" {

    function config() {
        verifies(except="index,dashboard,checkAdminAccess,blog,editBlog,deleteBlog,update,blogList,blogApprove,rejectBlog,showBlog,commentsPublish,unpublishComment,comments,blogBulkApprove,blogBulkReject,viewComments,publishblog,closeComments", params="key", paramsTypes="integer");
        usesLayout(template="/admin/AdminController/layout");
        filters(through="checkAdminAccess");
    }

    function index() {
        redirectTo(action="dashboard");
    }

    function blog() {
        blogs = getAllBlogs();

    }

    // Function to edit a blog post
    public void function editBlog() {
        try {
            // Get the blog post
            var blog = model("Blog").findByKey(key=params.id, include="User,PostStatus");
            
            // Check if blog exists
            if (!isObject(blog)) {
                throw("Blog not found", "BlogNotFound");
            }

            // Check if user has permission to edit this post
            if (session.role != "admin" && blog.userId != session.userID) {
                throw("You don't have permission to edit this post", "UnauthorizedAccess");
            }


            // Get categories and tags for the form
            var categories = model("Category").findAll(order="name ASC");
            var postTypes = model("PostType").findAll(order="name ASC");
            var blogCategories = model("BlogCategory").findAll(where="blogId = ?", params=[blog.id]);
            var blogTags = model("Tag").findAll(where="blogId = ?", params=[blog.id]);

            // Prepare data for the view
            var selectedCategories = [];
            for (var cat in blogCategories) {
                arrayAppend(selectedCategories, cat.categoryId);
            }

            var selectedTags = [];
            for (var tag in blogTags) {
                arrayAppend(selectedTags, tag.name);
            }

            // Set view variables
            blog.categories = selectedCategories;
            blog.tags = arrayToList(selectedTags, ",");
            
            // Render the edit form with the blog data
            renderView(template="editBlog", blog=blog, categories=categories, postTypes=postTypes, isEdit=true);
            
        } catch (any e) {
            // Log the error
            model("Log").log(
                category = "wheels.blog",
                level = "ERROR",
                message = "Error editing blog post: #e.message#",
                details = {
                    "error": e,
                    "blog_id": structKeyExists(params, "key") ? params.key : "",
                    "user_id": structKeyExists(session, "userID") ? session.userID : 0,
                    "ip_address": cgi.REMOTE_ADDR
                }
            );
            
            // Redirect with error message
        }
    }

    // Function to update an existing blog
    public void function update() {
        // Get request parameters
        var blogModel = model("Blog");
        var blogId = params.id;
        
        try {
            model("Log").log(
                category = "wheels.blog",
                level = "INFO",
                message = "Blog post update attempted",
                details = {
                    "blog_id": blogId,
                    "title": params.title,
                    "ip_address": cgi.REMOTE_ADDR
                },
                userId = structKeyExists(session, "userID") ? session.userID : 0
            );
            
            response = updateBlog(params, blogId);
            
            // Update relationships
            deleteBlogTags(blogId);
            deleteBlogCategories(blogId);
            
            // Handle tags which are passed as a comma-separated string in postTags
            if (structKeyExists(params, "postTags") && len(trim(params.postTags))) {
                params.tags = params.postTags;
                saveTags(params, blogId);
            }
            
            // Handle categories which are passed as selected values in categoryId
            if (structKeyExists(params, "categoryId") && len(trim(params.categoryId))) {
                saveCategories(params, blogId);
            }

            model("Log").log(
                category = "wheels.blog",
                level = "INFO",
                message = "Blog post updated successfully",
                details = {
                    "blog_id": blogId,
                    "title": params.title,
                    "ip_address": cgi.REMOTE_ADDR
                },
                userId = structKeyExists(session, "userID") ? session.userID : 0
            );

            redirectTo(route="adminBlog", success="Blog post updated successfully!");
        } catch (any e) {
            model("Log").log(
                category = "wheels.blog",
                level = "ERROR",
                message = "Failed to update blog post",
                details = {
                    "blog_id": blogId,
                    "error_message": e.message,
                    "error_detail": e.detail,
                    "error_type": e.type,
                    "title": params.title,
                    "ip_address": cgi.REMOTE_ADDR
                },
                userId = structKeyExists(session, "userID") ? session.userID : 0
            );
            // Handle error
            redirectTo(route="adminBlog", error="Failed to update blog post!");
        }
    }

    // updateBlog() is inherited from Controller.cfc

    // saveTags() is inherited from Controller.cfc
    // deleteBlogTags() is inherited from Controller.cfc
    // saveCategories() is inherited from Controller.cfc
    // deleteBlogCategories() is inherited from Controller.cfc

    function comments(){
        comments = model("comment").findAll(
            select="id,Content,isPublished,commentParentId,createdat,authorId,blogId,slug,FullName,title",
            include="User, Blog",
            order="createdAt DESC");
    }   

    function viewComments(){
        id = params.id;
        comments = model("comment").findbyKey( key="#id#",
            select="id,Content,isPublished,commentParentId,createdat,authorId,blogId,slug,FullName,title",
            include="User, Blog"
            );
        renderPartial(partial="partials/commentView");
    }  

    function blogApprove() {
        try {
            var message = blogApproval(params.id);
            renderText('<span class="badge bg-success">Approved</span>');
            return;
        } catch (any e) {
            // Handle error
            cfheader(statusCode=500);
            return;
        }
    }

    function rejectBlog() {
        try {
            var message = blogReject(params.id);
            renderText('<span class="badge bg-danger">Rejected</span>');
            return;
        } catch (any e) {
            // Handle error
            cfheader(statusCode=500);
            return;
        }
    }

    function blogBulkApprove(){
        try{
            for (blogId in params.selectedBlogIds) {
                var message = blogApproval(blogId);
            }
            success="Blogs are approved successfully!";
            blogs = getAllBlogs();
            renderPartial(partial="partials/blogs");
        } catch(e) {
            cfheader(statusCode=500);
            return;
        }
    }
    function deleteBlog() {

        var blog = model("Blog").findByKey(params.id);
        if (!isObject(blog)) {
        redirectTo(action="blog", errorMessage="Blog post not found.");
        }
        try {
            blog.statusId = 7;
            blog.is_deleted = 'true';
            blog.deletedAt = now();
            blog.deletedBy = GetSignedInUserId();
            blog.save();
            blog.delete()
            redirectTo(action="blog", success="Blog post moved to trash.");
        } catch (any e) {
            redirectTo(action="blog", errorMessage="Error trashing blog post.");
        }
    }

    function blogBulkReject(){
        try{
            for (blogId in params.selectedBlogIds) {
                var message = blogReject(blogId);
            }
            success="Blogs are rejected successfully!";
            blogs = getAllBlogs();
            renderPartial(partial="partials/blogs");
        } catch(e) {
            cfheader(statusCode=500);
            return;
        }
    }

    function publishblog(){
        try{
            var message = blogPublish(params);
            renderText("#message.message#");
        } catch(e) {
            cfheader(statusCode=500);
            return;
        }

    }

    function closeComments(){
        try{
            closeComment = false;
            if(structKeyExists(params, "closeComment-#params.id#")){
                closeComment = true;
            }
            var blog = model("Blog").findByKey(params.id);
            blog.isCommentClosed = closeComment;
            blog.save();
            if(closeComment){
                renderText("Blog comments section closed successfully!")
            }else{
                renderText("Blog comments section open successfully!")
            }
            return;
        } catch(e) {
            cfheader(statusCode=500);
            return;
        }
    }

    private function blogPublish(blogData){
        var publishDate = "";
        if(structKeyExists(blogData, "publishDate-#blogData.id#") && len(trim(blogData["publishDate-#blogData.id#"]))){
            publishDate = blogData["publishDate-#blogData.id#"];
        }

        var blog = model("Blog").findByKey(blogData.id);
        var user = model("user").findByKey(blog.createdby);

        if (!isNull(blog)) {
            if(blog.status == "Approved"){
                if(len(trim(publishDate))){
                    blog.publishedAt = parseDateTime(publishDate);
                } else {
                    blog.publishedAt = "";
                }
            }
            if (blog.save()) {
                if(len(trim(publishDate)) && blog.status == "Approved"){
                    var siteurl = urlFor(route="blog-detail",slug=blog.slug ,onlyPath=false);
                    var emaildata = model("emailTemplate").findAll(where="title = ?", params=["Publish Blog"]);
                    var emailparams = {
                        "name" = user.fullname,
                        "buttonTitle" = emaildata.buttonTitle,
                        "content" = emaildata.message,
                        "welcomeMessage"= emaildata.welcomeMessage,
                        "URl" = siteurl,
                        "footerNote" = emaildata.footerNote,
                        "footerGreetings" = emaildata.footerGreating,
                        "closingRemark" = emaildata.closingRemark,
                        "teamSignature" = emaildata.teamSignature,
                        "isSubscriber" = user.newsletter
                    };
                    emailContent = renderView(template="/email", layout=false, returnAs="string", params=emailparams);
                    cfheader(name="Content-Type" value="text/html; charset=UTF-8");
                    cfmail(
                        to = "#user.email#",
                        from = "#application.env.mail_from#",
                        subject = "#emaildata.subject#",
                        server = "#application.env.smtp_host#",
                        port = "#application.env.smtp_port#",
                        username = "#application.env.smtp_username#",
                        password = "#application.env.smtp_password#",
                        type = "html"
                    ) {
                        writeOutput(emailContent);
                    };
                    return {
                        success = true,
                        message = "Blog scheduled for publishing!"
                    };
                }else{
                    return {
                        success = true,
                        message = "Blog unpublished successfully!"
                    };
                }
            } else {
                return {
                    success = false,
                    errors = blog.allErrors(),
                    message = "Failed to update publish date!"
                };
            }
        }

        return {
            success = false,
            message = "Blog not found"
        };
    }

    function commentsPublish(){
        try{
            var message = publishComment(params.id);
            renderText('<span class="badge bg-success">Published</span>');
        }catch(any e){
            redirectTo(action="comments", error="Error: Comment not publish!");
            return;
        }
    }

    function unpublishComment(){
        try{
            var comment = model("comment").findbyKey(key="#id#");
            if(!isNull(comment)){
                comment.isPublished = false;
                if(comment.save()){
                    renderText('<span class="badge bg-danger">Hidden</span>');
                    return;
                }else{
                    redirectTo(action="comments", error="error: #comment.allErrors()#");
                    return;
                }
            }else{
                redirectTo(action="comments", error="Comment not found!");
            }
        }catch(any e){
            redirectTo(action="comments", error="error #e.message#");
            return;
        }
    }

    function showBlog() {
        try {
            blogModel = model("Blog");
            
            // Get the blog by its slug
            blog = getBlogBySlug(params.slug);
            
            // If no blog is found, throw an error to be caught
            if (!structKeyExists(blog, "id")) {
                throw("Blog not found");
            }

            // Get other necessary data
            tags = getTagsByBlogid(blog.id);
            categories = getCategoriesByBlogid(blog.id);
            attachments = getAttachmentsByBlogid(blog.id);
            
        } catch (any e) {
            // If an error occurs or blog not found, redirect to blog index
            redirectTo(action="blog");
            return;
        }
    }

    private function getBlogBySlug(required string slug) {
        return model("Blog").findOne(
            where="blog_posts.slug = ?", params=[arguments.slug],
            include="User,PostStatus"
        );
    }

    /**
     * Admin Dashboard
     */
    function dashboard(){
        // Basic counts
        totalBlogs = model("blog").count();
        totalTestimonials = model("testimonial").count();
        totalNewUser = model("user").count(where="createdat >= ?", params=[dateFormat(now(), "yyyy-mm-dd")]);
        totalUser = model("user").count();
        activeUsers = model("user").count(where="status = 'true'"); 
        
        // ==================== USER DATA ====================
        sevenDaysAgo = dateAdd("d", -6, now()); // 6 days ago = 7 days total
        
        // Get list of users from last 7 days (for display)
        last_seven_days_user = model("user").findAll(
            where="createdat >= ?", params=[dateFormat(sevenDaysAgo, "yyyy-mm-dd")],
            order="createdat DESC"
        );
        
        // Get actual user counts for chart
        userCounts = queryExecute("
            SELECT DATE(createdat) AS day, COUNT(*) AS usercount
            FROM users
            WHERE createdat >= :startDate
            AND deletedat IS NULL
            GROUP BY DATE(createdat)
            ORDER BY DATE(createdat) ASC
        ",
        {
            startDate: {value: dateFormat(sevenDaysAgo, "yyyy-mm-dd"), cfsqltype: "cf_sql_date"}
        },
        {datasource: application.env.datasource}
        );
        
        // Build complete 7-day series in ColdFusion
        userChartData = [];
        for (i = 0; i < 7; i++) {
            currentDay = dateAdd("d", i, sevenDaysAgo);
            dayString = dateFormat(currentDay, "yyyy-mm-dd");
            
            // Find count for this day (default to 0 if no data)
            dayCount = 0;
            for (row in userCounts) {
                if (dateFormat(row.day, "yyyy-mm-dd") == dayString) {
                    dayCount = row.usercount;
                    break;
                }
            }
            
            arrayAppend(userChartData, {
                "day": dayString,
                "usercount": dayCount
            });
        }
        userJsonData = serializeJSON(userChartData);
        
        // ==================== BLOG DATA ====================
        distinctCategories = model("BlogCategory").findAll(select="categoryId", DISTINCT=true);
        totalCategories = distinctCategories.recordcount;
        
        totalApprovedBlogs = model("blog").count(where="status = 'Approved'");
        rejectedBlogs = model("blog").count(where="status = 'Rejected'");
        waitingforApprovalBlogs = model("blog").count(where="status IS NULL");
        
        // Get actual blog counts for chart
        blogCounts = queryExecute("
            SELECT DATE(createdat) AS day, COUNT(*) AS blogcount
            FROM blog_posts
            WHERE createdat >= :startDate
            AND deletedat IS NULL
            GROUP BY DATE(createdat)
            ORDER BY DATE(createdat) ASC
        ",
        {
            startDate: {value: dateFormat(sevenDaysAgo, "yyyy-mm-dd"), cfsqltype: "cf_sql_date"}
        },
        {datasource: application.env.datasource}
        );
        
        // Build complete 7-day series
        blogChartData = [];
        for (i = 0; i < 7; i++) {
            currentDay = dateAdd("d", i, sevenDaysAgo);
            dayString = dateFormat(currentDay, "yyyy-mm-dd");
            
            dayCount = 0;
            for (row in blogCounts) {
                if (dateFormat(row.day, "yyyy-mm-dd") == dayString) {
                    dayCount = row.blogcount;
                    break;
                }
            }
            
            arrayAppend(blogChartData, {
                "day": dayString,
                "blogcount": dayCount
            });
        }
        blogJsonData = serializeJSON(blogChartData);
        
        // ==================== COMMENT DATA ====================
        totalComments = model("comment").count();
        totalPublishComments = model("comment").count(where="isPublished = 1");
        totalUnPublishComments = model("comment").count(where="isPublished = 0");
        
        // Get actual comment counts for chart
        commentCounts = queryExecute("
            SELECT DATE(published_at) AS day, COUNT(*) AS commentcount
            FROM comments
            WHERE published_at >= :startDate
            AND deletedat IS NULL
            AND is_published = true
            GROUP BY DATE(published_at)
            ORDER BY DATE(published_at) ASC
        ",
        {
            startDate: {value: dateFormat(sevenDaysAgo, "yyyy-mm-dd"), cfsqltype: "cf_sql_date"}
        },
        {datasource: application.env.datasource}
        );
        
        // Build complete 7-day series
        commentChartData = [];
        for (i = 0; i < 7; i++) {
            currentDay = dateAdd("d", i, sevenDaysAgo);
            dayString = dateFormat(currentDay, "yyyy-mm-dd");
            
            dayCount = 0;
            for (row in commentCounts) {
                if (dateFormat(row.day, "yyyy-mm-dd") == dayString) {
                    dayCount = row.commentcount;
                    break;
                }
            }
            
            arrayAppend(commentChartData, {
                "day": dayString,
                "commentcount": dayCount
            });
        }
        commentJsonData = serializeJSON(commentChartData);
    }

    /**
     * Utility method for consistent parameter handling
     */
    private function param(required string name, defaultValue="") {
        return structKeyExists(URL, name) 
            ? URL[name] 
            : (structKeyExists(form, name) ? form[name] : defaultValue);
    }

    public function getAllBlogs() {
        return model("Blog").findAll(
            include="User, PostStatus, PostType",
            order="createdAt DESC",
            options={
                sql="
                    SELECT 
                        blog_posts.id AS blogId, 
                        blog_posts.status AS blogStatus, 
                        blog_posts.title AS blogTitle, 
                        blog_posts.content AS blogContent, 
                        blog_posts.createdat AS createdDate,
                        users.fullName AS authorName, 
                        post_statuses.name AS postStatus,
                        post_types.name AS postTypeName 
                    FROM blog_posts 
                    INNER JOIN users ON users.id = blog_posts.userId
                    INNER JOIN post_statuses ON post_statuses.id = blog_posts.statusId
                    INNER JOIN post_types ON post_types.id = blog_posts.postTypeId"
            }
        );

    }

    function publishComment(id){
        var comment = model("comment").findbyKey(key="#id#", include="Blog");
        var user = model("user").findByKey(comment.authorId);
        if(!isNull(comment)){
            comment.isPublished = true;
            if(comment.save()){
                siteurl = urlFor(route="blog-detail",slug=comment.blog.slug ,onlyPath=false);
                var emaildata = model("emailTemplate").findAll(where="title = ?", params=["Publish comment"]);
                var emailparams = {
                    "name" = user.fullname,
                    "buttonTitle" = emaildata.buttonTitle,
                    "content" = emaildata.message,
                    "welcomeMessage"= emaildata.welcomeMessage,
                    "URl" = siteurl,
                    "footerNote" = emaildata.footerNote,
                    "footerGreetings" = emaildata.footerGreating,
                    "closingRemark" = emaildata.closingRemark,
                    "teamSignature" = emaildata.teamSignature,
                    "isSubscriber" = user.newsletter
                };
                emailContent = renderView(template="/email", layout=false, returnAs="string", params=emailparams);
                cfmail( 
                    to = "#user.email#", 
                    from = "#application.env.mail_from#", 
                    subject = "#emaildata.subject#", 
                    server = "#application.env.smtp_host#", 
                    port = "#application.env.smtp_port#", 
                    username = "#application.env.smtp_username#", 
                    password = "#application.env.smtp_password#", 
                    type = "html"
                ) { 
                    writeOutput(emailContent);
                };
                return {
                    success = true,
                    message = "Comment Published successfully!"
                }
            }else {
                return {
                    success = false,
                    errors = comment.allErrors(),
                    message = "Failed to publish comment!"
                };
            }
        }
        return {
            success = false,
            message = "comment not found!"
        };
    }

    private function blogApproval(id){
        var blog = model("Blog").findByKey(id);
        var user = model("user").findByKey(blog.createdby);

        if (!isNull(blog)) {
            
            blog.status = "Approved"; //approved            
            if (blog.save()) {
                return {
                    success = true,
                    message = "Blog approved successfully!"
                };
            } else {
                return {
                    success = false,
                    errors = blog.allErrors(),
                    message = "Failed to approve blog!"
                };
            }
        }
        
        return {
            success = false,
            message = "Blog not found"
        };
    }
    
    private function blogReject(id){
        var blog = model("Blog").findByKey(id);
        var user = model("user").findByKey(blog.createdby);

        if (!isNull(blog)) {
            
            blog.status = "Rejected"; //reject
            blog.publishedAt = "";
            if (blog.save()) {
                var emaildata = model("emailTemplate").findAll(where="title = ?", params=["Reject blog"]);
                var emailparams = {
                    "name" = user.fullname,
                    "buttonTitle" = emaildata.buttonTitle,
                    "content" = emaildata.message,
                    "welcomeMessage"= emaildata.welcomeMessage,
                    "URl" = "",
                    "footerNote" = emaildata.footerNote,
                    "footerGreetings" = emaildata.footerGreating,
                    "closingRemark" = emaildata.closingRemark,
                    "teamSignature" = emaildata.teamSignature,
                    "isSubscriber" = user.newsletter
                };
                emailContent = renderView(template="/email", layout=false, returnAs="string", params=emailparams);
                cfheader(name="Content-Type" value="text/html; charset=UTF-8");
                cfmail( 
                    to = "#user.email#", 
                    from = "#application.env.mail_from#", 
                    subject = "#emaildata.subject#", 
                    server = "#application.env.smtp_host#", 
                    port = "#application.env.smtp_port#", 
                    username = "#application.env.smtp_username#", 
                    password = "#application.env.smtp_password#", 
                    type = "html"
                ) { 
                    writeOutput(emailContent);
                };
                return {
                    success = true,
                    message = "Blog rejected successfully"
                };
            } else {
                return {
                    success = false,
                    errors = blog.allErrors(),
                    message = "Failed to reject blog!"
                };
            }
        }
        
        return {
            success = false,
            message = "Blog not found"
        };
    }

    public void function importData() {

        // 1) Load & parse JSON
        var raw   = fileRead( expandPath("files/posts.json") );
        var rss   = deserializeJSON(raw).rss;
        var chan  = rss.channel;

        // 2) Import Authors
        // ------------------
        // Map of WP‐login -> local Author.id
        var authorMap = importWpAuthors(chan.author);

        // 3) Import Posts
        // ----------------
        // Map of WP‐post_id -> local Post.id

        var postMap = importWpPosts(
            items = chan.item,
            authorMap = authorMap,
            defaultPostTypeId = 1, // Blog post type
            defaultStatusMap = {
                "draft": 1,    // Draft
                "publish": 2,  // Published
                "pending": 4,  // Pending
                "private": 6,  // Private
                "trash": 7     // Deleted/Trash
            }
        );

        // 4) Import Comments & Replies
        // ----------------------------
        // Map of WP‐comment_id -> local Comment.id
        
        var commentMap = importWpComments(chan.item, postMap, authorMap);
        
        // 5) Done!
        writeDump('Data imported!');
        abort;
    }

    /**
    * Import WordPress authors into the users table
    * @param authors The WordPress author data structure
    * @param roleId The default role ID to assign to imported users (optional)
    * @return struct A map of WordPress logins to user IDs
    */
    private struct function importWpAuthors(required array authors, numeric roleId=2) {
        authorMap = {};
        
        for (wpAuth in arguments.authors) {
            login = wpAuth.author_login.__cdata;
            firstName = wpAuth.author_first_name.__cdata;
            lastName = wpAuth.author_last_name.__cdata;
            displayName = wpAuth.author_display_name.__cdata;
            email = wpAuth.author_email.__cdata;
            wpId = wpAuth.author_id.__text;
            
            // Find existing user by email
            user = model("User").findOne(where="email = ?", params=[email]);
            
            if (!IsObject(user)) {
                // Create new user if not found
                user = model("User").create({
                    firstName = firstName,
                    lastName = lastName,
                    email = email,
                    roleId = arguments.roleId,
                    username = login,
                    wpId = wpId,
                    status = true,
                    newsletter = false
                });
                
                // Generate a password hash
                user.passwordHash = bCryptHashPW("wheels.dev@"&login, bCryptGenSalt());
                
                if (user.save(validate=false)) {
                    // Successfully created user
                    writeDump("Created new user from WordPress author: #displayName#");
                } else {
                    // Failed to create user
                    writeDump("Failed to create user for WordPress author: #displayName#");
                    writeDump("Errors: #serializeJSON(user.allErrors())#");
                }
            } else {
                // Update existing user with WordPress data
                user.firstName = firstName;
                user.lastName = lastName;
                user.username = login;
                user.wpId = wpId;
                
                if (user.save(validate=false)) {
                    // Successfully updated user
                    writeDump("Updated existing user from WordPress author: #displayName#");
                }
            }
            
            // Map WordPress login to internal user ID
            authorMap[login] = user.id;
        }
        
        return authorMap;
    }

    /**
    * Import WordPress posts into the blog_posts table with categories and tags
    * @param items The WordPress post items array
    * @param authorMap A mapping of WordPress author logins to local user IDs
    * @param defaultPostTypeId The default post type ID to assign (optional)
    * @param defaultStatusMap A mapping of WordPress status to local statusId (optional)
    * @param categoryMap A mapping of WordPress category names to local category IDs (optional)
    * @param tagMap A mapping of WordPress tag names to local tag IDs (optional)
    * @return struct A map of WordPress post IDs to local blog post IDs
    */
    public struct function importWpPosts(
        required array items,
        required struct authorMap,
        numeric defaultPostTypeId = 1,
        struct defaultStatusMap = {
            "draft": 1,    // Draft
            "publish": 2,  // Published
            "pending": 4,  // Pending
            "private": 6,  // Private
            "trash": 7     // Deleted/Trash
        },
        struct categoryMap = {},
        struct tagMap = {}
    ) {
        var postMap = {};
        
        for (var item in arguments.items) {
            var wpId = item.post_id.__text;
            var login = item.creator.__cdata; // Maps to author_login
            var title = item.title;
            
            // Handle content which can be either an object or an array
            var encoded = item.encoded;
            var content = isArray(encoded) ? encoded[1].__cdata : encoded.__cdata;
            
            var slug = item.post_name.__cdata;
            var wpStatus = item.status.__cdata;
            var publishedAt = parseDateTime(item.post_date.__cdata);
            var modifiedAt = parseDateTime(item.post_modified.__cdata);
            
            // Map WordPress status to local status ID
            var statusId = structKeyExists(arguments.defaultStatusMap, wpStatus) 
                ? arguments.defaultStatusMap[wpStatus] 
                : 1; // Default to Draft if not mapped
                
            // Determine if post is published based on WordPress status
            var isPublished = (wpStatus == "publish");
            
            // Get author ID from the mapping or use a default
            var authorId = structKeyExists(arguments.authorMap, login) 
                ? arguments.authorMap[login] 
                : 1; // Default to ID 1 if not found
            
            // Check if post already exists by WordPress ID
            var existingPost = model("Blog").findOne(where="title = ? AND slug = ?", params=[title, slug]);
            
            var blogPost = "";
            if (!isObject(existingPost)) {
                // Create new blog post
                blogPost = model("Blog").create({
                    title = title,
                    content = content,
                    slug = slug,
                    status = wpStatus,
                    isPublished = isPublished,
                    postCreatedDate = publishedAt,
                    updatedAt = modifiedAt,
                    publishedAt = isPublished ? publishedAt : "",
                    statusId = statusId,
                    postTypeId = arguments.defaultPostTypeId,
                    createdBy = authorId,
                    updatedBy = authorId,
                    isCommentClosed = false // Default setting for comments
                });
                
                if (blogPost.save(validate=false)) {
                    writeDump("Imported WordPress post: #wpId# - #title#");
                    postMap[wpId] = blogPost.id;
                    
                    // Process taxonomies (categories and tags)
                    processTaxonomies(item, blogPost.id, arguments.categoryMap, arguments.tagMap);
                } else {
                    writeDump("Failed to import WordPress post: #wpId# - #title#");
                    writeDump("Errors: #serializeJSON(blogPost.allErrors())#");
                }
            } else {
                // Update existing post
                existingPost.title = title;
                existingPost.content = content;
                existingPost.slug = slug;
                existingPost.status = wpStatus;
                existingPost.isPublished = isPublished;
                existingPost.postCreatedDate = publishedAt;
                existingPost.updatedAt = modifiedAt;
                existingPost.publishedAt = isPublished ? publishedAt : "";
                existingPost.statusId = statusId;
                existingPost.updatedBy = authorId;
                
                if (existingPost.save(validate=false)) {
                    writeDump("Updated WordPress post: #wpId# - #title#");
                    postMap[wpId] = existingPost.id;
                    
                    // Delete existing categories and tags for this post
                    model("BlogCategory").deleteAll(where="blogId = ?", params=[existingPost.id]);
                    model("Tag").deleteAll(where="blogId = ?", params=[existingPost.id]);
                    
                    // Process taxonomies (categories and tags)
                    processTaxonomies(item, existingPost.id, arguments.categoryMap, arguments.tagMap);
                } else {
                    writeDump("Failed to update WordPress post: #wpId# - #title#");
                }
            }
        }
        
        return postMap;
    }

    /**
    * Process WordPress taxonomies (categories and tags) for a post
    * @param wpPost The WordPress post item
    * @param blogId The local blog post ID
    * @param categoryMap A mapping of WordPress category names to local category IDs
    * @param tagMap A mapping of WordPress tag names to local tag IDs
    */
    private void function processTaxonomies(
        required struct wpPost,
        required numeric blogId,
        required struct categoryMap,
        required struct tagMap
    ) {
        try {
            // Check if categories/tags exist in the WordPress post
            if (structKeyExists(wpPost, "category")) {
                var wpCategories = [];
                var wpTags = [];
                
                // Handle single category/tag or multiple categories/tags
                if (isStruct(wpPost.category)) {
                    processTaxonomyItem(wpPost.category, wpCategories, wpTags);
                } else if (isArray(wpPost.category)) {
                    // Multiple categories/tags
                    for (var tax in wpPost.category) {
                        processTaxonomyItem(tax, wpCategories, wpTags);
                    }
                }
                
                // Process regular categories
                importCategories(wpCategories, arguments.blogId, arguments.categoryMap);
                
                // Process tags
                importTags(wpTags, arguments.blogId, arguments.tagMap);
            }
        } catch (any e) {
            writeDump("Error processing taxonomies: #e.message#");
        }
    }

    /**
    * Helper function to process a taxonomy item and sort it into categories or tags
    * @param taxItem The taxonomy item to process
    * @param wpCategories Array of WordPress categories to append to
    * @param wpTags Array of WordPress tags to append to
    */
    private void function processTaxonomyItem(
        required struct taxItem,
        required array wpCategories,
        required array wpTags
    ) {
        if (structKeyExists(taxItem, "__cdata")) {
            // Check if it's a tag or a category
            var domain = "";
            if (structKeyExists(taxItem, "_domain")) {
                domain = taxItem._domain;
            }
            
            // Add to appropriate array based on domain
            if (domain == "post_tag") {
                // It's a tag
                wpTags.append(taxItem.__cdata);
            } else {
                // It's a category (or default to category if domain is not specified)
                wpCategories.append(taxItem.__cdata);
            }
        }
    }

    /**
    * Import WordPress categories for a post
    * @param wpCategories Array of WordPress category names
    * @param blogId The local blog post ID
    * @param categoryMap A mapping of WordPress category names to local category IDs
    */
    private void function importCategories(
        required array wpCategories,
        required numeric blogId,
        required struct categoryMap
    ) {
        try {
            // Process each category
            for (var categoryName in arguments.wpCategories) {
                // Try to get the category ID from the mapping
                var categoryId = 0;
                
                if (structKeyExists(arguments.categoryMap, categoryName)) {
                    // Use existing mapping
                    categoryId = arguments.categoryMap[categoryName];
                } else {
                    // Look up category by name
                    var existingCategory = model("Category").findOne(where="name = ?", params=[categoryName]);
                    
                    if (isObject(existingCategory)) {
                        categoryId = existingCategory.id;
                        // Update the mapping for future use
                        arguments.categoryMap[categoryName] = categoryId;
                    } else {
                        // Create a new category
                        var newCategory = model("Category").create({
                            name = categoryName,
                            isActive = true,
                            createdAt = now(),
                            updatedAt = now()
                        });
                        
                        if (newCategory.save()) {
                            categoryId = newCategory.id;
                            // Update the mapping for future use
                            arguments.categoryMap[categoryName] = categoryId;
                            writeDump("Created new category: #categoryName# (#categoryId#)");
                        } else {
                            writeDump("Failed to create category: #categoryName#");
                        }
                    }
                }
                
                // Associate the category with the blog post
                if (categoryId > 0) {
                    var blogCategory = model("BlogCategory").new();
                    blogCategory.categoryId = categoryId;
                    blogCategory.blogId = arguments.blogId;
                    blogCategory.createdAt = now();
                    blogCategory.updatedAt = now();
                    
                    if (blogCategory.save()) {
                        writeDump("Associated category '#categoryName#' with blog ID #arguments.blogId#");
                    } else {
                        writeDump("Failed to associate category '#categoryName#' with blog ID #arguments.blogId#");
                    }
                }
            }
        } catch (any e) {
            writeDump("Error importing categories: #e.message#");
        }
    }

    /**
    * Import WordPress tags for a post
    * @param wpTags Array of WordPress tag names
    * @param blogId The local blog post ID
    * @param tagMap A mapping of WordPress tag names to local tag IDs
    */
    private void function importTags(
        required array wpTags,
        required numeric blogId,
        required struct tagMap
    ) {
        try {
            // Process each tag
            for (var tagName in arguments.wpTags) {
                // Create a new tag directly linked to the blog post
                var newTag = model("Tag").create({
                    name = tagName,
                    blogId = arguments.blogId,
                    createdAt = now(),
                    updatedAt = now()
                });
                
                if (newTag.save()) {
                    writeDump("Created tag '#tagName#' for blog ID #arguments.blogId#");
                    // Update the mapping for future reference
                    arguments.tagMap[tagName] = newTag.id;
                } else {
                    writeDump("Failed to create tag '#tagName#' for blog ID #arguments.blogId#");
                }
            }
        } catch (any e) {
            writeDump("Error importing tags: #e.message#");
        }
    }


    /**
    * Helper function to escape SQL strings
    */
    private string function escapeSQL(required string str) {
        return replace(arguments.str, "'", "''", "all");
    }

    /**
    * Import WordPress comments into the comments table
    * @param items The WordPress post items array containing comments
    * @param postMap A mapping of WordPress post IDs to local blog post IDs
    * @param authorMap A mapping of WordPress author emails to local user IDs
    * @return struct A map of WordPress comment IDs to local comment IDs
    */
    public struct function importWpComments(
        required array items,
        required struct postMap,
        required struct authorMap
    ) {
        var commentMap = {};
        var count = {
            processed: 0,
            imported: 0,
            skipped: 0,
            failed: 0,
            updated: 0,
            usersCreated: 0,
            anonymousComments: 0
        };
        
        // First pass: Import all comments and track their IDs
        for (var item in arguments.items) {
            // Skip if this item doesn't have a post_id
            if (!structKeyExists(item, "post_id") || !structKeyExists(item.post_id, "__text")) {
                continue;
            }
            
            var wpPostId = item.post_id.__text;
            count.processed++;
            
            // Skip if we don't have this post mapped
            if (!structKeyExists(arguments.postMap, wpPostId)) {
                writeDump("Skipping comments for unmapped post ID: #wpPostId#");
                count.skipped++;
                continue;
            }
            
            var localBlogId = arguments.postMap[wpPostId];
            
            // Check if this post has comments
            if (structKeyExists(item, "comment")) {
                var comments = isArray(item.comment) ? item.comment : [item.comment];
                
                for (var c in comments) {
                    try {
                        // Extract comment data safely using helper functions
                        var wpCommentId = c.comment_id.__text;
                        var parentWpId = c.comment_parent.__text;
                        var authorName = c.comment_author.__cdata;
                        var authorEmail = structKeyExists(c, "comment_author_email") && structKeyExists(c.comment_author_email, "__cdata") ? c.comment_author_email.__cdata : "";
                        var authorUrl = structKeyExists(c, "comment_author_url") && structKeyExists(c.comment_author_url, "__text") ? c.comment_author_url.__text : '';
                        var authorIp = structKeyExists(c, "comment_author_IP") && structKeyExists(c.comment_author_IP, "__cdata") ? c.comment_author_IP.__cdata : '';
                        var content = c.comment_content.__cdata;
                        var approved = c.comment_approved.__cdata;
                        var commentType = structKeyExists(c, "comment_type") && structKeyExists(c.comment_type, "__cdata") ? c.comment_type.__cdata : '';
                        var commentUserId = c.comment_user_id.__text;
                        
                        // Parse dates properly
                        var commentDate = "";
                        var commentDateStr = c.comment_date.__cdata;
                        if (len(trim(commentDateStr))) {
                            try {
                                commentDate = parseDateTime(commentDateStr);
                            } catch (any e) {
                                commentDate = now();
                                writeDump("Failed to parse date: #commentDateStr# for comment #wpCommentId#");
                            }
                        } else {
                            commentDate = now();
                        }
                        
                        // Check if this comment already exists in our system
                        var existingComment = model("Comment").findOne(where="wpId = ?", params=[wpCommentId]);
                        
                        // Try to find a user ID for this comment author
                        var userId = 0;
                        var user;
                        
                        // First check if we have this email in our authorMap
                        if (len(trim(authorEmail)) && structKeyExists(arguments.authorMap, authorEmail)) {
                            userId = arguments.authorMap[authorEmail];
                            user = model("User").findByKey(userId);
                        } else if (commentUserId != "0") {
                            // If WordPress specified a user ID, try to find that user
                            user = model("User").findOne(where="wpId = ?", params=[commentUserId]);
                            if (isObject(user)) {
                                userId = user.id;
                            }
                        } else if (len(trim(authorEmail))) {
                            // Try to find a user with this email
                            user = model("User").findOne(where="email = ?", params=[authorEmail]);
                            if (isObject(user)) {
                                userId = user.id;
                            }
                        }
                        
                        // If no user found and we have an email, create a new user with "commenter" role
                        if (!isObject(user) && len(trim(authorEmail))) {
                            // Get the commenter role ID (you'll need to adjust this to your role system)
                            var commenterRole = model("Role").findOne(where="name = ?", params=["commenter"]);
                            var commenterRoleId = isObject(commenterRole) ? commenterRole.id : 4; // Default to role ID 4 if not found

                            // Create names array by splitting author name
                            var names = listToArray(authorName, " ");
                            var firstName = arrayLen(names) >= 1 ? names[1] : "";
                            var lastName = arrayLen(names) >= 2 ? names[2] : "";

                            // Generate a username from the email
                            var username = listFirst(authorEmail, "@");
                            
                            // Check if username exists and append number if needed
                            var baseUsername = username;
                            var counter = 1;
                            while (model("User").exists(where="username = ?", params=[username])) {
                                username = baseUsername & counter;
                                counter++;
                            }

                            // Create the new user
                            user = model("User").create({
                                firstName = firstName,
                                lastName = lastName,
                                email = authorEmail,
                                username = username,
                                website = authorUrl,
                                ip = authorIp,
                                roleId = commenterRoleId,
                                passwordHash = hash(createUUID(), "SHA-256"), // Create a random password hash
                                status = true,
                                createdAt = commentDate,
                                updatedAt = commentDate
                            });
                            
                            if (user.save(validate=false)) {
                                userId = user.id;
                                // Update the authorMap for future reference
                                arguments.authorMap[authorEmail] = userId;
                                count.usersCreated++;
                                writeDump("Created new user for commenter: #authorEmail#");
                            } else {
                                writeDump("Failed to create user for: #authorEmail#, Errors: #serializeJSON(user.allErrors())#");
                            }
                        } 
                        // Handle case where there's no email but we still have an author name
                        else if (!isObject(user) && !len(trim(authorEmail)) && len(trim(authorName))) {
                            // Get the commenter role ID
                            var commenterRole = model("Role").findOne(where="name = ?", params=["commenter"]);
                            var commenterRoleId = isObject(commenterRole) ? commenterRole.id : 4; // Default to role ID 4 if not found

                            // Create names array by splitting author name
                            var names = listToArray(authorName, " ");
                            var firstName = arrayLen(names) >= 1 ? names[1] : "";
                            var lastName = arrayLen(names) >= 2 ? names[2] : "";

                            // Generate a unique username from the author name
                            var username = replaceNoCase(authorName, " ", "_", "all");
                            username = reReplace(username, "[^a-zA-Z0-9_]", "", "all");
                            if (!len(trim(username))) {
                                username = "anonymous_" & createUUID();
                            }

                            // Check if username exists and append number if needed
                            var baseUsername = username;
                            var counter = 1;
                            while (model("User").exists(where="username = ?", params=[username])) {
                                username = baseUsername & counter;
                                counter++;
                            }
                            
                            // Generate a placeholder email if needed
                            var placeholderEmail = username & "@example.com";
                            
                            // Create the new user
                            user = model("User").create({
                                firstName = firstName,
                                lastName = lastName,
                                email = placeholderEmail,
                                username = username,
                                website = authorUrl,
                                ip = authorIp,
                                roleId = commenterRoleId,
                                passwordHash = hash(createUUID(), "SHA-256"), // Create a random password hash
                                status = true,
                                createdAt = commentDate,
                                updatedAt = commentDate
                            });
                            
                            if (user.save(validate=false)) {
                                userId = user.id;
                                // Update the authorMap for future reference
                                arguments.authorMap[placeholderEmail] = userId;
                                count.usersCreated++;
                                count.anonymousComments++;
                                writeDump("Created new anonymous user for commenter: #authorName#");
                            } else {
                                writeDump("Failed to create anonymous user for: #authorName#, Errors: #serializeJSON(user.allErrors())#");
                            }
                        }
                        
                        // If we found an existing comment, update it
                        if (isObject(existingComment)) {
                            existingComment.content = content;
                            existingComment.authorId = userId > 0 ? userId : javaCast("null", "");
                            existingComment.isPublished = approved == "1";
                            existingComment.publishedAt = approved == "1" ? commentDate : javaCast("null", "");
                            
                            if (existingComment.save(validate=false)) {
                                commentMap[wpCommentId] = existingComment.id;
                                count.updated++;
                            } else {
                                writeDump("Failed to update comment ID: #wpCommentId#, Errors: #serializeJSON(existingComment.allErrors())#");
                                count.failed++;
                            }
                        } else {
                            // For now set parentId to 0 - we'll update in second pass
                            var newComment = model("Comment").create({
                                content = content,
                                commentParentId = '', // Temporary value, updated in second pass
                                blogId = localBlogId,
                                authorId = userId > 0 ? userId : javaCast("null", ""),
                                createdAt = commentDate,
                                publishedAt = approved == "1" ? commentDate : javaCast("null", ""),
                                updatedAt = commentDate,
                                isPublished = approved == "1" ? true : false,
                                isApproved = approved == "1" ? true : false,
                                isFlagged = false,
                                wpId = wpCommentId
                            });
                            
                            if (newComment.save(validate=false)) {
                                writeDump("Imported comment ID: #wpCommentId# for post: #wpPostId#");
                                commentMap[wpCommentId] = newComment.id;
                                count.imported++;
                            } else {
                                writeDump("Failed to import comment ID: #wpCommentId#, Errors: #serializeJSON(newComment.allErrors())#");
                                count.failed++;
                            }
                        }
                    } catch (any e) {
                        writeDump("Error processing comment: #e.message# #e.detail#");
                        count.failed++;
                    }
                }
            }
        }
        
        // Second pass: Update parent comment IDs now that we have all comments imported
        for (var item in arguments.items) {
            if (structKeyExists(item, "comment")) {
                var comments = isArray(item.comment) ? item.comment : [item.comment];
                
                for (var c in comments) {
                    try {
                        var wpCommentId = c.comment_id.__text;
                        var parentWpId = c.comment_parent.__text;
                        
                        // Skip if we don't have this comment mapped
                        if (!structKeyExists(commentMap, wpCommentId)) {
                            continue;
                        }
                        
                        var localCommentId = commentMap[wpCommentId];
                        
                        // Only update if this comment has a parent
                        if (parentWpId != "0" && structKeyExists(commentMap, parentWpId)) {
                            var localParentId = commentMap[parentWpId];
                            
                            // Find and update the comment
                            var comment = model("Comment").findByKey(localCommentId);
                            if (isObject(comment)) {
                                comment.commentParentId = localParentId;
                                
                                if (comment.save(validate=false)) {
                                    writeDump("Updated parent reference for comment ID: #localCommentId#");
                                } else {
                                    writeDump("Failed to update parent reference for comment ID: #localCommentId#");
                                }
                            }
                        }
                    } catch (any e) {
                        writeDump("Error updating comment parent: #e.message# #e.detail#");
                    }
                }
            }
        }
        
        writeDump("Comments import summary - Processed: #count.processed#, Imported: #count.imported#, Updated: #count.updated#, Skipped: #count.skipped#, Failed: #count.failed#, Users Created: #count.usersCreated#, Anonymous Comments: #count.anonymousComments#");
        
        return commentMap;
    }
}