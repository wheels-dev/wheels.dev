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
        
        // Profile Picture Property
        property(
            name="profilePicture", 
            column="profile_picture", 
            dataType="string", 
            label="Profile Picture", 
            defaultValue="avatar-rounded.webp"
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

        // Locked Property (for admin-controlled lock/unlock)
        property(
            name="locked", 
            column="locked", 
            dataType="boolean", 
            label="Account Locked", 
            defaultValue=false
        );

        // Has Testimonial Property
        property(
            name="hasTestimonial",
            column="has_testimonial",
            dataType="boolean",
            label="Has Submitted Testimonial",
            defaultValue=false
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

        property(
            name="newsletter", 
            column="newsletter_subscription", 
            dataType="integer", 
            label="news letter subbscription",
            defaultValue=false
        );

        property(
            name="username", 
            column="username", 
            dataType="string", 
            label="Login username"
        );

        property(
            name="wpId", 
            column="wp_id", 
            dataType="integer", 
            label="WordPress ID"
        );
        
        property(name="website", column="website", dataType="string", default="");
        property(name="ip", column="ip", dataType="string", default="");
        
        // Relationships
        belongsTo(name="Role", foreignKey="roleId");
        
        // Testimonial Relationship - One user has one testimonial
        hasOne(name="Testimonial", foreignKey="userId");
    }

    // Fetch all users with their roles
    public function getAll(){
        var users = findAll(
            include = "Role",
            order = "createdAt DESC"
        );
        return users;
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
            profilePicture = this.profilePicture,
            hasTestimonial = this.hasTestimonial
        };
    }
    
    // Check if user has submitted a testimonial
    public function hasSubmittedTestimonial() {
        testimonial = model("Testimonial").findOne(where="userId=#this.id#");
        return IsObject(testimonial);
    }
    
    // Update testimonial status after submission
    public function markTestimonialSubmitted() {
        this.hasTestimonial = true;
        return this.save(validate=false);
    }
}