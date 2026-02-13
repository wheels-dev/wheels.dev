component extends="app.Models.Model" {
    function config() {
        table("testimonials");

        // === Identification ===
        property(name="id", column="id", dataType="integer", automaticValidations=false);
        property(name="userId", column="user_id", dataType="integer", label="User ID", automaticValidations=true);

        // === Company & Branding ===
        property(name="companyName", column="company_name", dataType="string", label="Company Name", defaultValue="");
        property(name="logoPath", column="logo_path", dataType="string", label="Company Logo", defaultValue="");
        property(name="websiteUrl", column="website_url", dataType="string", label="Website URL", defaultValue="");
        property(name="socialMediaLinks", column="social_media_links", dataType="string", label="Social Media Links", defaultValue="");

        // === Testimonial Content ===
        property(name="testimonialText", column="testimonial_text", dataType="text", label="Testimonial Text", defaultValue="");
        property(name="title", column="title", dataType="text", label="Testimonial title", defaultValue="");
        property(name="experienceLevel", column="experience_level", dataType="string", label="Experience Level", defaultValue="Beginner");

        // === Rating & Approval ===
        property(name="rating", column="rating", dataType="integer", label="Rating", defaultValue=0);
        property(name="displayPermission", column="display_permission", dataType="boolean", label="Display on Website", defaultValue=true);
        property(name="isFeatured", column="is_featured", dataType="boolean", label="Mark as Featured", defaultValue=false);
        property(name="isApproved", column="is_approved", dataType="boolean", label="Approval Status", defaultValue=false);
        property(name="status", column="status", dataType="string", label="Moderation Status", defaultValue="Pending");

        // === Timestamps ===
        property(name="createdAt", column="createdat", dataType="timestamp", label="Created At");
        property(name="updatedAt", column="updatedat", dataType="timestamp", label="Last Updated");

        // === Relationships ===
        belongsTo(name="User", foreignKey="userId");

        // === Validations ===
        validatesPresenceOf(properties="companyName,experienceLevel,testimonialText,rating");
        validatesLengthOf(property="testimonialText", minimum=20, maximum=500, message="Testimonial text must be between 20 and 500 characters.");
        validatesNumericalityOf(property="rating", minimum=1, maximum=5, message="Rating must be between 1 and 5.");
    }
    
    // Get all approved testimonials
        public function getApprovedTestimonials(struct options = {}) {
        // Default options
        mergedOptions = {
            page = 1,
            perPage = 10,
            sortBy = "createdAt",
            sortOrder = "DESC",
            onlyFeatured = false
        };

        mergedOptions.append(options, true);

        conditions = "isApproved = 'true' AND displayPermission = 'true'";
        if (mergedOptions.onlyFeatured) {
            conditions &= " AND isFeatured = 'true'";
        }

        return model("Testimonial").findAll(
            where = conditions,
            order = "#mergedOptions.sortBy# #mergedOptions.sortOrder#",
            page = mergedOptions.page,
            perPage = mergedOptions.perPage,
            include = "User",
            cache = 1440
        );
    }
    
    // Format testimonial for display
    public function formatForDisplay() {
        user = this.user();

        return {
            id: this.id,
            companyName: this.companyName ?: "",
            logoPath: this.logoPath ?: "/img/default-logo.png",
            testimonialText: this.testimonialText,
            rating: this.rating,
            experienceLevel: this.experienceLevel,
            websiteUrl: this.websiteUrl ?: "",
            socialMediaLinks: this.socialMediaLinks ?: "",
            userFullName: isNull(user) ? "Anonymous" : user.fullName,
            userProfilePicture: isNull(user) ? "/img/default-user.png" : user.profilePicture,
            isFeatured: this.isFeatured,
            submittedOn: this.createdAt
        };
    }

}