//  Login, Register UI
component extends="app.Controllers.Controller" {

    function config() {
        verifies(except="index,loadUsers,loadRoles,addEditUser,store,delete,profile", params="key", paramsTypes="integer", handler="index");
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

            params.profilePicture = "";
            var uploadPath = expandPath("/files/"); // Define the upload directory

            if (!directoryExists(uploadPath)) {
                directoryCreate(uploadPath);
            }

            // Handle file upload
            if (structKeyExists(params, "profilePicture") && isDefined("params.profilePicture")) {
                var uploadedFile = fileUpload(uploadPath, "profilePicture");

                if (!structIsEmpty(uploadedFile) && structKeyExists(uploadedFile, "serverFile")) {
                    var originalFileName = uploadedFile.serverFile; // This is the uploaded file name
                    var fileExtension = listLast(originalFileName, "."); // Extract extension
                    var uniqueFileName = createUUID() & "." & fileExtension; // Generate unique name

                    // Rename file to unique name
                    var newFilePath = uploadPath & "/" & uniqueFileName;
                    fileMove(uploadedFile.serverDirectory & "/" & originalFileName, newFilePath);

                    // Store the relative file path
                    params.profilePicture = "/files/" & uniqueFileName;
                }
            }

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

    function profile(){
        param name="id" default=0;
        id = session.userId
        user;
        if(id > 0) {
            var userService = new app.services.UserService(model("User"));
            user = userService.findById(id);
        }
        return user;
    }
}