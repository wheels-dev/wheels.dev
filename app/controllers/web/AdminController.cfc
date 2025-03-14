// Admin Panel
component extends="app.Controllers.Controller" {
    // Service declarations
    property name="userService";
    property name="blogService";
    property name="roleService";

    // function init() {
    //     // Manual service initialization
    //     variables.userModel = model("User");
    //     variables.userService = new app.services.UserService(variables.userModel);

    //     variables.blogModel = model("Blog");
    //     variables.blogService = new app.services.BlogService(variables.blogModel);

    //     variables.roleModel = model("Role");
    //     variables.roleService = new app.services.RoleService(variables.roleModel);
    // }

    function config() {
        verifies( except="index,dashboard,checkAdminAccess,blog,BlogList,blogAction", params="key", paramsTypes="integer", handler="dashboard");

        usesLayout("/web/AdminController/layout");
        filters(through="checkAdminAccess");
    }

    function blog() {
    }
    
    function BlogList() {
        // Fetch all blogs
        blogService = new app.services.BlogService(model("Blog"));
        blogs = blogService.getAllBlogs();
        renderPartial(partial="partials/blogs");
    }

    function blogAction() {
        try {
            var blogService = new app.services.BlogService(model("Blog"));
            var message = blogService.ApproveorReject(params.id);
            redirectTo(action="blog", success="#message#");
        } catch (any e) {
            // Handle error
            redirectTo(action="blog", errorMessage="Failed to delete user.");
        }
    }

    /**
     * Admin Dashboard
     */
    function dashboard() {
        // Use services to fetch statistics
        var stats = {
            totalUsers = variables.userService.count(),
            activeUsers = variables.userService.countActive(),
            pendingUsers = variables.userService.countPending(),
            totalBlogs = variables.blogService.count(),
            publishedBlogs = variables.blogService.countPublished(),
            pendingBlogs = variables.blogService.countPending()
        };

        // Fetch recent activities using services
        var recentUsers = variables.userService.getRecent(5);
        var recentBlogs = variables.blogService.getRecent(5);

        // Set variables for view
        setVariable("stats", stats);
        setVariable("recentUsers", recentUsers);
        setVariable("recentBlogs", recentBlogs);
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
            flashInsert(error="Unauthorized Access");
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
}