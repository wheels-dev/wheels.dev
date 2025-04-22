// Admin Panel
component extends="app.Controllers.Controller" {

    function config() {
        verifies(except="index,dashboard,checkAdminAccess,blog,BlogList,approve,reject,showBlog", params="key", paramsTypes="integer", handler="dashboard");

        usesLayout(template="/web/AdminController/layout", except="BlogList");
        filters(through="checkAdminAccess");
    }

    function index() {
        redirectTo(action="dashboard");
    }

    function blog() {
    }
    
    function BlogList() {
        // Fetch all blogs
        blogs = getAllBlogs();
        renderPartial(partial="partials/blogs");
    }

    function approve() {
        try {
            var message = Approve(params.id);
            redirectTo(action="blog", success="#message#");
        } catch (any e) {
            // Handle error
            redirectTo(action="blog", errorMessage="Failed to delete user.");
        }
    }
    function reject() {
        try {
            var message = Reject(params.id);
            redirectTo(action="blog", success="#message#");
        } catch (any e) {
            // Handle error
            redirectTo(action="blog", errorMessage="Failed to delete user.");
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

    private function Approve(id){
        var blog = model("Blog").findByKey(arguments.id);
        
        if (!isNull(blog)) {
            
            blog.status = "Approved"; //approved            
            if (blog.save()) {
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
    
    private function Reject(id){
        var blog = model("Blog").findByKey(arguments.id);
        
        if (!isNull(blog)) {
            
            blog.status = "Rejected"; //reject
            
            if (blog.save()) {
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
}