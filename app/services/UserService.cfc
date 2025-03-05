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
        return variables.User.findByKey(arguments.id);
    }

    /**
     * Save or update user
     * @data User data
     */
    function save(data) {
        // Determine if this is a new or existing user
        var user = structKeyExists(arguments.data, "id") && arguments.data.id > 0
            ? variables.User.findByKey(arguments.data.id)
            : variables.User.new();

        // Populate user properties
        user.name = arguments.data.name;
        user.email = arguments.data.email;
        
        // Handle role assignment
        if (structKeyExists(arguments.data, "roleId")) {
            user.roleId = arguments.data.roleId;
        }

        // Handle password update
        if (structKeyExists(arguments.data, "password") && len(trim(arguments.data.password))) {
            // Assuming a method exists to securely set password
            user.setPassword(arguments.data.password);
        }

        // Attempt to save
        if (user.save()) {
            return {
                success = true,
                user = user,
                message = "User saved successfully"
            };
        } else {
            return {
                success = false,
                errors = user.allErrors(),
                message = "Failed to save user"
            };
        }
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
            user.deletedAt = now();
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