// Admin Panel
component extends="app.Controllers.Controller" {

    function config() {
        verifies(except="index,dashboard,checkAdminAccess,blog,blogList,approve,reject,showBlog,publish,unpublish,comments", params="key", paramsTypes="integer");

        usesLayout(template="/admin/AdminController/layout");
        filters(through="checkAdminAccess");
    }

    function index() {
        redirectTo(action="dashboard");
    }

    function blog() {
        blogs = getAllBlogs();

    }

    function comments(){
        comments = model("comment").findAll(
            select="id,Content,isPublished,commentParentId,createdat,authorId,blogId,slug,FullName,title",
            include="User, Blog"
            );
    }   

    function approve() {
        try {
            var message = blogApproval(params.id);
            redirectTo(action="blog", success="Blog reject successfully!");
            return;
        } catch (any e) {
            // Handle error
            redirectTo(action="blog", error="error #e.message#");
            return;
        }
    }
    function reject() {
        try {
            var message = blogReject(params.id);
            redirectTo(action="blog", success="Blog reject successfully!");
            return;
        } catch (any e) {
            // Handle error
            redirectTo(action="blog", error="error #e.message#");
            return;
        }
    }

    function publish(){
        try{
            var message = publishComment(params.id);
            redirectTo(action="comments", success="Comment publish successfully!");
        }catch(any e){
            redirectTo(action="comments", error="error #e.message#");
            return;
        }
    }

    function unpublish(){
        try{
            var comment = model("comment").findbyKey(key="#id#");
            if(!isNull(comment)){
                comment.isPublished = false;
                if(comment.save()){
                    redirectTo(action="comments", success="Comment hide successfully!");
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

    /**
     * Admin Dashboard
     */
    function dashboard(){
        totalBlogs = model("blog").count();
        totalTestimonials = model("testimonial").count();
        totalNewUser = model("user").count(where="createdat >= '#dateFormat(now(), "yyyy-mm-dd")#'");
        totalUser = model("user").count();
        activeUsers = model("user").count(where="status = 'true'"); 

        sevenDaysAgo = dateAdd("d", -7, now());
        last_seven_days_user = model("user").findAll(
        where="createdat >= '#sevenDaysAgo#'",
        order="createdat DESC");

        last_7Days_Users = queryExecute("
            WITH DateSeries AS (
                SELECT FORMAT(DATEADD(DAY, number, :startDate), 'yyyy-MM-dd') AS day
                FROM master.dbo.spt_values 
                WHERE type = 'P' AND number BETWEEN 0 AND 6
            )
            SELECT 
                ds.day, 
                COUNT(u.createdat) AS usercount
            FROM DateSeries ds
            LEFT JOIN users u 
                ON FORMAT(u.createdat, 'yyyy-MM-dd') = ds.day 
                AND u.deletedat IS NULL
            GROUP BY ds.day
            ORDER BY ds.day ASC
        ", 
        {
            startDate: dateFormat(now() - 6, "yyyy-MM-dd")
        }, 
        {datasource="wheels.dev"}
        );

        userChartData = []; // Save chart data from query

        for (i = 1; i <= last_7Days_Users.recordCount; i++) {
            arrayAppend(userChartData, { 
                "day": last_7Days_Users.day[i], 
                "usercount": last_7Days_Users.usercount[i] 
            });
        }
        userJsonData = serializeJSON(userChartData);

        distinctCategories = model("BlogCategory").findAll(select="categoryId", DISTINCT=true);
        totalCategories = distinctCategories.recordcount;

        totalBlogs = model("blog").count();
        totalApprovedBlogs = model("blog").count(where="status = 'Approved'");
        rejectedBlogs = model("blog").count(where="status = 'Rejected'");
        waitingforApprovalBlogs = model("blog").count(where="status = ''");


        last_7Days_Blogs = queryExecute("
            WITH DateSeries AS (
                SELECT FORMAT(DATEADD(DAY, number, :startDate), 'yyyy-MM-dd') AS day
                FROM master.dbo.spt_values 
                WHERE type = 'P' AND number BETWEEN 0 AND 6
            )
            SELECT 
                ds.day, 
                COUNT(b.createdat) AS blogcount
            FROM DateSeries ds
            LEFT JOIN blog_posts b 
                ON FORMAT(b.createdat, 'yyyy-MM-dd') = ds.day 
                AND b.deletedat IS NULL
            GROUP BY ds.day
            ORDER BY ds.day ASC
        ", 
        {
            startDate: dateFormat(now() - 6, "yyyy-MM-dd")
        }, 
        {datasource="wheels.dev"} // Replace with your actual datasource name
        );

        // Prepare data for chart
        blogChartData = [];
        for (i = 1; i <= last_7Days_Blogs.recordCount; i++) {
            arrayAppend(blogChartData, { 
                "day": last_7Days_Blogs.day[i], 
                "blogcount": last_7Days_Blogs.blogcount[i] 
            });
        }
        blogJsonData = serializeJSON(blogChartData);

        totalComments = model("comment").count();
        totalPublishComments = model("comment").count(where="isPublished ='true'");
        totalUnPublishComments = model("comment").count(where="isPublished ='false'");

        last_7Days_Comments = queryExecute("
            WITH DateSeries AS (
                SELECT FORMAT(DATEADD(DAY, number, :startDate), 'yyyy-MM-dd') AS day
                FROM master.dbo.spt_values 
                WHERE type = 'P' AND number BETWEEN 0 AND 6
            )
            SELECT 
                ds.day, 
                COUNT(c.published_at) AS commentcount
            FROM DateSeries ds
            LEFT JOIN comments c 
                ON FORMAT(c.published_at, 'yyyy-MM-dd') = ds.day 
                AND c.deletedat IS NULL
                AND c.is_published = 1
            GROUP BY ds.day
            ORDER BY ds.day ASC
        ", 
        {
            startDate: dateFormat(now() - 6, "yyyy-MM-dd")
        }, 
        {datasource="wheels.dev"} // Replace this with your actual datasource or remove if using app.cfm connection string
        );

        // Prepare data for chart
        commentChartData = [];
        for (i = 1; i <= last_7Days_Comments.recordCount; i++) {
            arrayAppend(commentChartData, { 
                "day": last_7Days_Comments.day[i], 
                "commentcount": last_7Days_Comments.commentcount[i] 
            });
        }
        commentJsonData = serializeJSON(commentChartData);

    }

    /**
     * User Management
     */
    function users() {
        // Get pagination and search parameters
        var page = param("page", 1);
        var perPage = param("perPage", 20);
        var searchTerm = param("search", "");

        // Use service method for fetching users
        var users = variables.userService.search(
            term = searchTerm,
            page = page,
            perPage = perPage
        );

        // Set variables for view
        setVariable("users", users);
        setVariable("page", page);
        setVariable("searchTerm", searchTerm);
    }

    /**
     * User Create/Edit Form
     */
    function userForm() {
        var userId = param("key", 0);
        
        // Use service to get user or create new
        var user = userId > 0 
            ? variables.userService.findById(userId)
            : variables.userModel.new();

        // Fetch available roles
        var roles = variables.roleService.findAll();

        // Set variables for view
        setVariable("user", user);
        setVariable("roles", roles);
    }

    /**
     * Save User
     */
    function saveUser() {
        // Validate input
        if (!structKeyExists(form, "email") || !structKeyExists(form, "name")) {
            flashInsert(error="Missing required fields");
            redirectTo(action="userForm");
            return;
        }

        // Use service to save user
        var result = variables.userService.save(form);

        if (result.success) {
            flashInsert(success="User saved successfully");
            redirectTo(action="users");
        } else {
            flashInsert(error=result.message);
            redirectTo(action="userForm");
        }
    }

    /**
     * Blog Management
     */
    function blogs() {
        var page = param("page", 1);
        var perPage = param("perPage", 20);
        var status = param("status", "all");

        // Use service to fetch blogs
        var blogs = variables.blogService.search(
            status = status,
            page = page,
            perPage = perPage
        );

        setVariable("blogs", blogs);
        setVariable("page", page);
        setVariable("status", status);
    }

    /**
     * Update Blog Status
     */
    function updateBlogStatus() {
        var blogId = param("key", 0);
        var newStatus = param("status", "");

        // Use service to update blog status
        var result = variables.blogService.updateStatus(
            blogId = blogId, 
            status = newStatus
        );

        if (result.success) {
            flashInsert(success="Blog status updated successfully");
        } else {
            flashInsert(error="Error updating blog status");
        }

        redirectTo(action="blogs");
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
                var siteurl = "http://#cgi.http_host#/blog/#comment.blog.slug#";
                var message = "Thanks for commenting on our blog post. Your comment is now live on the Wheels site.";
                var footer = "If you did not write comment, you can safely ignore this email.";
                emailContent = generateApprovalEmail(siteurl, message, footer);
                cfmail( 
                    to = "#user.email#", 
                    from = "#application.env.mail_from#", 
                    subject = "Your comment post has been published", 
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
                var siteurl = "http://#cgi.http_host#/blog/#blog.slug#";
                var message = "Thank you for writing a blog post. Your post has been approved and published on the Wheels website.";
                var footer = "If you did not write blog, you can safely ignore this email.";
                var emailContent = generateApprovalEmail(siteurl, message, footer);
                cfheader(name="Content-Type" value="text/html; charset=UTF-8");
                cfmail( 
                    to = "#user.email#", 
                    from = "#application.env.mail_from#", 
                    subject = "Your blog post has been approved and published", 
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
                    message = "blog status approved successfully"
                };
            } else {
                return {
                    success = false,
                    errors = blog.allErrors(),
                    message = "Failed to approve blog status"
                };
            }
        }
        
        return {
            success = false,
            message = "blog not found"
        };
    }
    
    private function blogReject(id){
        var blog = model("Blog").findByKey(id);
        var user = model("user").findByKey(blog.createdby);

        if (!isNull(blog)) {
            
            blog.status = "Rejected"; //reject
            
            if (blog.save()) {
                siteurl = "http://#cgi.http_host#/blog/#blog.slug#";
                emailContent = generateRejectEmail(siteurl);
                cfheader(name="Content-Type" value="text/html; charset=UTF-8");
                cfmail( 
                    to = "#user.email#", 
                    from = "#application.env.mail_from#", 
                    subject = "Your blog post has been Rejected to publish", 
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
                    message = "blog status rejected successfully"
                };
            } else {
                return {
                    success = false,
                    errors = blog.allErrors(),
                    message = "Failed to reject blog status"
                };
            }
        }
        
        return {
            success = false,
            message = "blog not found"
        };
    }

    private string function generateApprovalEmail(required string siteurl, required string message, required string footer) {
        return '
            <!DOCTYPE html>
            <html>
            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Approve blog post</title>
                <style>
                    body {
                        font-family: Arial, sans-serif;
                        background-color: ##f4f4f4;
                        margin: 0;
                        padding: 0;
                    }
                    .container {
                        max-width: 600px;
                        margin: 40px auto;
                        background: ##ffffff;
                        padding: 20px;
                        border-radius: 8px;
                        box-shadow: 0px 4px 10px rgba(0, 0, 0, 0.1);
                        text-align: center;
                    }
                    .logo {
                        width: 120px;
                        margin-bottom: 20px;
                    }
                    h1 {
                        color: ##333;
                        font-size: 24px;
                    }
                    p {
                        color: ##666;
                        font-size: 16px;
                        line-height: 1.5;
                    }
                    .button {
                        display: inline-block;
                        background-color: ##007BFF;
                        color: ##ffffff;
                        text-decoration: none;
                        font-size: 18px;
                        padding: 12px 20px;
                        border-radius: 6px;
                        margin-top: 20px;
                    }
                    .footer {
                        margin-top: 30px;
                        font-size: 14px;
                        color: ##999;
                    }
                </style>
            </head>
            <body>

                <div class="container">
                    <img src="https://avatars.githubusercontent.com/u/159224?s=200&v=4" alt="Bootstrap" width="260">
                    <h1>Welcome to Wheels.dev!</h1>
                    <p>'&message&'</p>
                    <a href="' & siteurl & '" class="button">View Your Post</a>
                    <p class="footer">'&footer&'</p>
                </div>

            </body>
            </html>
        ';
    }

    private string function generateRejectEmail(required string siteurl) {
        return '
            <!DOCTYPE html>
            <html>
            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Reject blog post</title>
                <style>
                    body {
                        font-family: Arial, sans-serif;
                        background-color: ##f4f4f4;
                        margin: 0;
                        padding: 0;
                    }
                    .container {
                        max-width: 600px;
                        margin: 40px auto;
                        background: ##ffffff;
                        padding: 20px;
                        border-radius: 8px;
                        box-shadow: 0px 4px 10px rgba(0, 0, 0, 0.1);
                        text-align: center;
                    }
                    .logo {
                        width: 120px;
                        margin-bottom: 20px;
                    }
                    h1 {
                        color: ##333;
                        font-size: 24px;
                    }
                    p {
                        color: ##666;
                        font-size: 16px;
                        line-height: 1.5;
                    }
                    .button {
                        display: inline-block;
                        background-color: ##007BFF;
                        color: ##ffffff;
                        text-decoration: none;
                        font-size: 18px;
                        padding: 12px 20px;
                        border-radius: 6px;
                        margin-top: 20px;
                    }
                    .footer {
                        margin-top: 30px;
                        font-size: 14px;
                        color: ##999;
                    }
                </style>
            </head>
            <body>

                <div class="container">
                    <img src="https://avatars.githubusercontent.com/u/159224?s=200&v=4" alt="Bootstrap" width="260">
                    <h1>Welcome to Wheels.dev!</h1>
                    <p>Thank you for writing a blog post. Your post has been rejected and not published on the Wheels website.</p>
                    <p class="footer">If you did not write post, you can safely ignore this email.</p>
                </div>

            </body>
            </html>
        ';
    }
}