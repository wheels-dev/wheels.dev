// Admin Panel
component extends="app.Controllers.Controller" {

    function config() {
        verifies(except="index,dashboard,checkAdminAccess,blog,blogList,approve,reject,showBlog", params="key", paramsTypes="integer", handler="dashboard");

        usesLayout(template="/web/AdminController/layout");
        filters(through="checkAdminAccess");
    }

    function index() {
        redirectTo(action="dashboard");
    }

    function blog() {
        blogs = getAllBlogs();

    }

    function approve() {
        try {
            var message = blogApproval(params.id);
            header name="HX-Redirect" value="#urlFor(route='admin-blog')#";
        } catch (any e) {
            // Handle error
            renderText("Failed to approve blog.");
        }
    }
    function reject() {
        try {
            var message = blogReject(params.id);
            header name="HX-Redirect" value="#urlFor(route='admin-blog')#";
        } catch (any e) {
            // Handle error
            renderText("Failed to reject blog.");
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
    function dashboard() {
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
     * Internal Authorization Check
     */
    private function checkAdminAccess() {
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

    private function blogApproval(id){
        var blog = model("Blog").findByKey(id);
        var user = model("user").findByKey(blog.createdby);

        if (!isNull(blog)) {
            
            blog.status = "Approved"; //approved            
            if (blog.save()) {
                siteurl = "http://#cgi.http_host#/blog/#blog.slug#";
                emailContent = generateApprovalEmail(siteurl);
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

    private string function generateApprovalEmail(required string siteurl) {
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
                    <p>Thank you for writing a blog post. Your post has been approved and published on the Wheels website.</p>
                    <a href="' & siteurl & '" class="button">View Your Post</a>
                    <p class="footer">If you did not write blog, you can safely ignore this email.</p>
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