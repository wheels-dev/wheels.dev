//  Login, Register UI
component extends="app.Controllers.Controller" {

    function config() {
        verifies(except="index,loadUsers,loadRoles,addEditUser,store,delete", params="key", paramsTypes="integer", handler="index");
        usesLayout("/layout");
    }

    // read user
    function index() {
    }
    
    // Function to load users for the users list
    function loadUsers() {
        // Fetch all users with their roles
        users = model("User").getAll();
        renderPartial(partial="partials/users");
    }
    
    // Function to load roles
    function loadRoles() {
        // Fetch all roles
        roles = model("Role").getAllRoles();
        renderPartial(partial="partials/roles");
    }
    
    // add or edit user
    function addEditUser() {
        param name="id" default=0;
        user;
        if(id > 0) {
            var userService = new app.services.UserService(model("User"));
            user = userService.findById(params.id);
        }else {
            user = model("User");
        }
        return user;
    }
    
    // save user
    function store() {

        // Save user logic here
        try {
            var userService = new app.services.UserService(model("User"));
            var message = userService.saveUser(params);
            redirectTo(action="index");
        } catch (any e) {
            // Handle error
            redirectTo(action="error", errorMessage="Failed to save user.");
        }
    }

    // Function to delete a user
    function delete() {
        try {
            var userService = new app.services.UserService(model("User"));
            var message = userService.softDelete(params.id);
            redirectTo(action="index", success="#message#");
        } catch (any e) {
            // Handle error
            redirectTo(action="index", errorMessage="Failed to delete user.");
        }
    }

    function approve(userId) {
        local.user = model("User").findByKey(arguments.userId);

        if (!isNull(local.user)) {
            local.user.update(
                isApproved = true, 
                approvedAt = now()
            );

            flashInsert(
                success = "User #local.user.email# has been approved."
            );
        }

        redirectTo(action="index");
    }

    function toggleStatus(userId) {
        local.user = model("User").findByKey(arguments.userId);

        if (!isNull(local.user)) {
            local.user.update(
                isActive = !local.user.isActive
            );

            local.status = local.user.isActive ? "activated" : "deactivated";
            flashInsert(
                success = "User #local.user.email# has been #local.status#."
            );
        }

        redirectTo(action="index");
    }

    private function checkAdminAccess() {
        if (!session.user.role.isAdmin) {
            flashInsert(error="Unauthorized access");
            redirectTo(controller="Admin", action="dashboard");
            return false;
        }
        return true;
    }
}