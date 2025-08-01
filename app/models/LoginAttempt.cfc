component extends="app.Models.Model" {
    function config() {
        table("login_attempts");

        // ID Property
        property(
            name="id", 
            column="id", 
            dataType="integer", 
            automaticValidations=false
        );

        // IP Address Property
        property(
            name="ipAddress", 
            column="ip_address", 
            dataType="string", 
            label="IP Address", 
            limit=45
        );

        // Email Property
        property(
            name="email", 
            column="email", 
            dataType="string", 
            label="Email", 
            limit=255,
            allowBlank=true
        );

        // Timestamps
        property(
            name="createdAt", 
            column="createdat", 
            dataType="timestamp", 
            label="Created At"
        );

        property(
            name="updatedAt", 
            column="updatedat", 
            dataType="timestamp", 
            label="Updated At"
        );

        // Relationships
        belongsTo(name="User", foreignKey="user_id");
    }

    // Check if user is locked out (either by failed attempts or admin lock)
    public function isUserLocked(required string email) {
        // First check if user is manually locked by admin
        var user = model("User").findOne(where="email='#arguments.email#'");
        if (!isNull(user) && user.locked) {
            return true;
        }
        
        // Then check for automatic lock due to failed attempts
        var attempts = findAll(
            where="email='#arguments.email#'"
        );
        return attempts.recordCount >= 3;
    }

    // Get remaining attempts before lockout
    public function getRemainingAttempts(required string email) {
        var attempts = findAll(
            where="email='#arguments.email#'"
        );
        return 3 - attempts.recordCount;
    }

    // Record a failed login attempt
    public function recordFailedAttempt(required string email, required string ipAddress) {
        var attempt = new();
        attempt.email = arguments.email;
        attempt.ipAddress = arguments.ipAddress;
        return attempt.save();
    }

    // Clear failed attempts for a user
    public function clearFailedAttempts(required string email) {
        return deleteAll(where="email='#arguments.email#'");
    }
} 