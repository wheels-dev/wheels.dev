//  Login, Register UI
component extends="app.Controllers.Controller" {

    function config() {
        verifies(except="index,create", params="key", paramsTypes="integer", handler="index");
        usesLayout("/layout");
    }

    function index() {
        // Fetch all users with their roles
        variables.users = model("User").findAll(
            include = "Role",
            order = "createdAt DESC"
        );
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