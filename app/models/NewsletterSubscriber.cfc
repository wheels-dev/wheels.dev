component extends="app.Models.Model" {
    function config() {
        table("newsletter_subscribers");

        // ID Property
        property(
            name="id", 
            column="id", 
            dataType="integer", 
            automaticValidations=false
        );

        // Email Property
        property(
            name="email", 
            column="email", 
            dataType="string", 
            label="Email", 
            required=true,
            validate="email"
        );

        // Status Property
        property(
            name="status", 
            column="status", 
            dataType="string", 
            label="Status", 
            defaultValue="active"
        );

        // Verification Token Property
        property(
            name="verificationToken", 
            column="verification_token", 
            dataType="string", 
            label="Verification Token"
        );

        // Timestamps
        property(
            name="createdAt", 
            column="created_at", 
            dataType="timestamp", 
            label="Created On"
        );

        property(
            name="updatedAt", 
            column="updated_at", 
            dataType="timestamp", 
            label="Last Updated"
        );

        // Validations
        validatesUniquenessOf(property="email");
    }

    // Generate verification token
    public function generateVerificationToken() {
        this.verificationToken = hash(createUUID());
        return this.verificationToken;
    }

    // Verify subscriber
    public function verify() {
        this.status = "active";
        this.verificationToken = "";
        return this.save();
    }

    // Unsubscribe
    public function unsubscribe() {
        this.status = "unsubscribed";
        return this.save();
    }
} 