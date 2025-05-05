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
            name="verification_token", 
            column="verification_token", 
            dataType="string", 
            label="Verification Token"
        );

        // Timestamps
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

        // Validations
        validatesUniquenessOf(property="email");
    }

    // Generate verification token
    public function generateVerificationToken() {
        this.verification_token = hash(createUUID());
        return this.verification_token;
    }

    // Verify subscriber
    public function verify() {
        this.status = "active";
        this.verification_token = "";
        return this.save();
    }

    // Unsubscribe
    public function unsubscribe() {
        this.status = "unsubscribed";
        return this.save();
    }
} 