component {
    property name="User";

    function init(userModel) {
        variables.User = arguments.userModel; 
        return this;
    }

    /**
     * Count total number of users
     */
    function count() {
        return variables.User.count();
    }

    /**
     * Count active users
     */
    function countActive() {
        return variables.User.count(where="status = 1");
    }

    /**
     * Count pending users
     */
    function countPending() {
        return variables.User.count(where="status = 0");
    }

    /**
     * Fetch recent users
     * @limit Number of users to retrieve
     */
    function getRecent(limit = 5) {
        return variables.User.findAll(
            order = "createdAt DESC",
            maxRows = arguments.limit,
            include = "Role"
        );
    }

    /**
     * Find user by ID
     * @id User identifier
     */
    function findById(id) {
        return variables.User.findAll(where="id='#arguments.id#'", returnAs="query");
    }

    /**
     * Save or update user
     * @data User data
     */
    function saveUser(userData) {
        try{

            // Check if the user ID is greater than 0 (for editing an existing post)
            if (userData.id > 0) {
                var user = findById(userData.id);

                if (not isNull(user)) {
                    // Edit the existing user post
                    user.firstname = userData.firstName;
                    user.lastname = userData.lastName;
                    user.email = userData.email;
                    user.passwordHash = hash(userData.passwordHash);
                    user.status = application.wo.SetActive();
                    user.roleid = userData.roleid;
                    user.updatedAt = now();
                    user.save();
                    message = "User updated successfully.";
                } else {
                    message = "User not found for editing.";
                }
            } else {
                // Check if user with the same email already exists
                var existingUser = variables.User.findFirst( where="email = '#userData.email#'");

                if (!isObject(existingUser)) {
                    // Create a new user
                    var newUser = variables.User.new();
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
    function search(term = "", page = 1, perPage = 20) {
        // Build dynamic where clause
        var whereCondition = "1=1";
        
        if (len(trim(arguments.term))) {
            whereCondition &= " AND (name LIKE '%#arguments.term#%' OR email LIKE '%#arguments.term#%')";
        }

        return variables.User.findAll(
            where = whereCondition,
            order = "createdAt DESC",
            page = arguments.page,
            perPage = arguments.perPage,
            include = "Role"
        );
    }

    /**
     * Check if current user is an admin
     */
    function isCurrentUserAdmin() {
        // Assumes session management is handled elsewhere
        return (
            structKeyExists(session, "user") && 
            structKeyExists(session.user, "role") && 
            session.user.role.name == "Administrator"
        );
    }

    /**
     * Soft delete a user
     * @id User identifier to delete
     */
    function softDelete(id) {
        var user = variables.User.findByKey(arguments.id);
        
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