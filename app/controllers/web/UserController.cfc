//  Login, Register UI
component extends="app.Controllers.Controller" {

    function config() {
        verifies(except="index,loadUsers,loadRoles,addUser,store,delete,profile", params="key", paramsTypes="integer", handler="index");
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
    function adUser() {
        param name="id" default=0;
        user;
        if(id > 0) {
            user = findById(params.id);
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

            var message = saveUser(params);
            redirectTo(action="index");
        } catch (any e) {
            // Handle error
            redirectTo(action="error", errorMessage="Failed to save user.");
        }
    }

    // Function to delete a user
    function delete() {
        try {
            var message = softDelete(params.id);
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

    function profile(){
        param name="id" default=0;
        id = session.userId
        user;
        if(id > 0) {
            user = findById(id);
        }
        return user;
    }

    // Business Logic

    /**
     * Count total number of users
     */
    private function count() {
        return model("User").count();
    }

    /**
     * Count active users
     */
    private function countActive() {
        return model("User").count(where="status = 1");
    }

    /**
     * Count pending users
     */
    private function countPending() {
        return model("User").count(where="status = 0");
    }

    /**
     * Fetch recent users
     * @limit Number of users to retrieve
     */
    private function getRecent(limit = 5) {
        return model("User").findAll(
            order = "createdAt DESC",
            maxRows = arguments.limit,
            include = "Role"
        );
    }

    /**
     * Find user by ID
     * @id User identifier
     */
    private function findById(id) {
        return model("User").findAll(where="id='#arguments.id#'", returnAs="query");
    }

    /**
     * Save or update user
     * @data User data
     */
    private function saveUser(userData) {
        try{

            // Check if the user ID is greater than 0 (for editing an existing post)
            if (userData.id > 0) {
                var user = model("User").findByKey(userData.id);

                if (not isNull(user)) {
                    // Edit the existing user post
                    user.firstname = userData.firstName;
                    user.lastname = userData.lastName;
                    user.email = userData.email;
                    user.passwordHash = hash(userData.passwordHash);
                    user.status = application.wo.SetActive();
                    user.roleid = userData.roleid;
                    user.updatedAt = now();
                    if (structKeyExists(userData, "profilePicture") && isDefined("userData.profilePicture")) {
                        user.profilePicture = userData.profilePicture
                    }
                    user.save();
                    message = "User updated successfully.";
                } else {
                    message = "User not found for editing.";
                }
            } else {
                // Check if user with the same email already exists
                var existingUser = model("User").findFirst( where="email = '#userData.email#'");

                if (!isObject(existingUser)) {
                    // Create a new user
                    var newUser = model("User").new();
                    newUser.firstname = userData.firstName;
                    newUser.lastname = userData.lastName;
                    newUser.email = userData.email;
                    newUser.passwordHash = hash(userData.passwordHash);
                    newUser.status = application.wo.SetActive();
                    newUser.roleid = userData.roleid;
                    newUser.createdAt = now();
                    newUser.updatedAt = now();
                    newUser.save();

                    message = "User created successfully.";
                } else {
                    message = "A user with the same email already exists.";
                }
            }
            
        }catch (any e) {
            // Handle error
            message = "Error: " & e.message;
        }
        return message; 
    }

    /**
     * Search users with flexible filtering
     * @term Search term
     * @page Pagination page
     * @perPage Number of results per page
     */
    private function search(term = "", page = 1, perPage = 20) {
        // Build dynamic where clause
        var whereCondition = "1=1";
        
        if (len(trim(arguments.term))) {
            whereCondition &= " AND (name LIKE '%#arguments.term#%' OR email LIKE '%#arguments.term#%')";
        }

        return model("User").findAll(
            where = whereCondition,
            order = "createdAt DESC",
            page = arguments.page,
            perPage = arguments.perPage,
            include = "Role"
        );
    }

    /**
     * Soft delete a user
     * @id User identifier to delete
     */
    private function softDelete(id) {
        var user = model("User").findByKey(arguments.id);
        
        if (!isNull(user)) {
            user.deletedAt = createDateTime(
                year(now()),
                month(now()),
                day(now()),
                hour(now()),
                minute(now()),
                second(now())
            );
            user.status = false;
            
            if (user.save()) {
                return {
                    success = true,
                    message = "User soft deleted successfully"
                };
            } else {
                return {
                    success = false,
                    errors = user.allErrors(),
                    message = "Failed to soft delete user"
                };
            }
        }
        
        return {
            success = false,
            message = "User not found"
        };
    }
}