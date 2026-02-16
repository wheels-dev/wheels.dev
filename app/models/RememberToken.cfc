component extends="app.Models.Model" {
    function config() {
        table("remember_tokens");

        // ID Property
        property(
            name="id", 
            column="id", 
            dataType="integer", 
            automaticValidations=false
        );

        // Token Property
        property(
            name="token", 
            column="token", 
            dataType="string", 
            label="Token", 
            limit=255
        );

        // User Agent
        property(
            name="userAgent", 
            column="user_agent", 
            dataType="string", 
            label="User Agent", 
            limit=255
        );

        // User ID Property
        property(
            name="userId", 
            column="user_id", 
            dataType="integer", 
            label="User ID"
        );

        // Expires At Property
        property(
            name="expiresAt", 
            column="expires_at", 
            dataType="datetime", 
            label="Expires At"
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
        belongsTo(name="User", foreignKey="userId");
    }

    // Create a new remember token
    public function createToken(required numeric userId) {
        var token = new();
        token.userId = arguments.userId;
        token.token = hash(createUUID() & arguments.userId & now());
        token.expiresAt = dateAdd("d", 30, now());
        return token.save();
    }

    // Find token by value
    public function findByToken(required string token) {
        return findOne(
            where="token = ? AND expires_at > ?", params=[arguments.token, now()]
        );
    }

    // Delete expired tokens
    public function deleteExpiredTokens() {
        return deleteAll(where="expires_at <= ?", params=[now()]);
    }
} 