component extends="app.Models.Model" {
    function config() {
        table("users");

        // ID Property
        property(
            name="id", 
            column="id", 
            dataType="integer", 
            automaticValidations=false
        );

        // Name Property with custom label and column mapping
        property(
            name="firstName", 
            column="first_name", 
            dataType="string", 
            label="First Name", 
            defaultValue="", 
            automaticValidations=true
        );

        // Last Name Property
        property(
            name="lastName", 
            column="last_name", 
            dataType="string", 
            label="Last Name", 
            defaultValue=""
        );

        // Full Name Computed Property
        property(
            name="fullName", 
            sql="first_name + ' ' + last_name", 
            label="Full Name"
        );

        // Email Property with specific validation
        property(
            name="email", 
            column="email", 
            dataType="string", 
            label="Email Address", 
            defaultValue=""
        );

        // Password Hash Property
        property(
            name="passwordHash", 
            column="password_hash", 
            dataType="string", 
            label="Password", 
            select=false  // Exclude from default select statements
        );
        
        // Token
        property(
            name="token", 
            column="token", 
            dataType="string", 
            label="Token", 
            select=false  // Exclude from default select statements
        );

        // Profile Picture Property
        property(
            name="profilePicture", 
            column="profile_picture", 
            dataType="string", 
            label="Profile Picture", 
            defaultValue="/default-avatar.png"
        );

        // Profile URL Computed Property
        property(
            name="profileUrl", 
            column="profile_url", 
            type="string", 
            required=false, 
            default="",
            label="Profile URL"
        );

        // Status Property
        property(
            name="status", 
            column="status", 
            dataType="boolean", 
            label="Account Status", 
            defaultValue=true
        );

        // Timestamps with custom column names
        property(
            name="createdAt", 
            column="createdat", 
            dataType="timestamp", 
            label="Created On"
        );

        property(
            name="updatedAt", 
            column="updatedat", 
            dataType="timestamp", 
            label="Last Updated"
        );

        property(
            name="deletedAt", 
            column="deletedat", 
            dataType="timestamp", 
            label="Deletion Date"
        );

        // Role Relationship Property
        property(
            name="roleId", 
            column="role_id", 
            dataType="integer", 
            label="User Role"
        );

        // Relationships
        belongsTo(name="Role", foreignKey="roleId");
    }

    // Fetch users with custom property usage
    public function getAllUsers(struct options = {}) {
        // Default options
        local.defaultOptions = {
            page = 1,
            perPage = 20,
            sortBy = "createdAt",
            sortOrder = "DESC"
        };

        // Merge provided options
        local.mergedOptions = structAppend(local.defaultOptions, arguments.options);

        // Find all users with computed full name
        return findAll(
            select = "*, #fullName# AS displayName",
            order = "#local.mergedOptions.sortBy# #local.mergedOptions.sortOrder#",
            page = local.mergedOptions.page,
            perPage = local.mergedOptions.perPage,
            include = "Role"
        );
    }

    public function getUserProfile() {
        return {
            id = this.id,
            fullName = this.fullName,
            email = this.email,
            profileUrl = this.profileUrl,
            profilePicture = this.profilePicture
        };
    }
}