component extends="app.Models.Model" {
    function config() {
        table("testimonials");
        
        // ID Property
        property(
            name="id", 
            column="id", 
            dataType="integer", 
            automaticValidations=false
        );
        
        // User ID Property (Foreign Key)
        property(
            name="userId", 
            column="user_id", 
            dataType="integer", 
            label="User ID",
            automaticValidations=true
        );
        
        // Company Name Property
        property(
            name="companyName", 
            column="company_name", 
            dataType="string", 
            label="Company Name", 
            defaultValue=""
        );
        
        // Logo Path Property
        property(
            name="logoPath", 
            column="logo_path", 
            dataType="string", 
            label="Logo Path",
            defaultValue=""
        );
        
        // Experience Level Property
        property(
            name="experienceLevel", 
            column="experience_level", 
            dataType="string", 
            label="Experience Level",
            defaultValue="Beginner"
        );
        
        // Testimonial Text Property
        property(
            name="testimonialText", 
            column="testimonial_text", 
            dataType="text", 
            label="Testimonial Text",
            defaultValue=""
        );
        
        // Rating Property
        property(
            name="rating", 
            column="rating", 
            dataType="integer", 
            label="Rating",
            defaultValue=0
        );
        
        // Display Permission Property
        property(
            name="displayPermission", 
            column="display_permission", 
            dataType="boolean", 
            label="Display Permission",
            defaultValue=false
        );
        
        // Social Media Links Property
        property(
            name="socialMediaLinks", 
            column="social_media_links", 
            dataType="string", 
            label="Social Media Links",
            defaultValue=""
        );
        
        // Website URL Property
        property(
            name="websiteUrl", 
            column="website_url", 
            dataType="string", 
            label="Website URL",
            defaultValue=""
        );
        
        // Is Featured Property
        property(
            name="isFeatured", 
            column="is_featured", 
            dataType="boolean", 
            label="Is Featured",
            defaultValue=false
        );
        
        // Is Approved Property
        property(
            name="isApproved", 
            column="is_approved", 
            dataType="boolean", 
            label="Is Approved",
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
            name="status", 
            column="status", 
            dataType="string", 
            label="Approval Status",
            defaultValue="Pending"
        );

        // Relationships
        belongsTo(name="User", foreignKey="userId");
        
        // Validations
        validatesPresenceOf(properties="companyName,experienceLevel,testimonialText,rating");
        validatesLengthOf(property="testimonialText", minimum=20, maximum=500, message="Testimonial text must be between 20 and 500 characters.");
        validatesNumericalityOf(property="rating", minimum=1, maximum=5, message="Rating must be between 1 and 5.");
    }
    
    // Get all approved testimonials
    public function getApprovedTestimonials(struct options = {}) {
        // Default options
        local.defaultOptions = {
            page = 1,
            perPage = 10,
            sortBy = "createdAt",
            sortOrder = "DESC",
            onlyFeatured = false
        };
        
        // Merge provided options
        local.mergedOptions = structAppend(local.defaultOptions, arguments.options);
        
        // Build where clause
        local.whereClause = "isApproved = 1 AND displayPermission = 1";
        
        // Add featured filter if specified
        if (local.mergedOptions.onlyFeatured) {
            local.whereClause &= " AND isFeatured = 1";
        }
        
        // Find testimonials
        return findAll(
            where = local.whereClause,
            order = "#local.mergedOptions.sortBy# #local.mergedOptions.sortOrder#",
            page = local.mergedOptions.page,
            perPage = local.mergedOptions.perPage,
            include = "User"
        );
    }
    
    // Format testimonial for display
    public function formatForDisplay() {
        local.user = this.user();
        
        return {
            id = this.id,
            companyName = this.companyName,
            logoPath = this.logoPath,
            testimonialText = this.testimonialText,
            rating = this.rating,
            experienceLevel = this.experienceLevel,
            websiteUrl = this.websiteUrl,
            socialMediaLinks = this.socialMediaLinks,
            userFullName = local.user.fullName,
            userProfilePicture = local.user.profilePicture,
            isFeatured = this.isFeatured,
            submittedOn = this.createdAt
        };
    }
}