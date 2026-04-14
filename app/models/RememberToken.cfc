component extends="app.Models.Model" {

	function config() {
		table("remember_tokens");

		// ID Property
		property(name = "id", column = "id", dataType = "integer", automaticValidations = false);

		// Token Property
		property(name = "token", column = "token", dataType = "string", label = "Token", limit = 255);

		// User Agent
		property(name = "userAgent", column = "user_agent", dataType = "string", label = "User Agent", limit = 255);

		// User ID Property
		property(name = "userId", column = "user_id", dataType = "integer", label = "User ID");

		// Expires At Property
		property(name = "expiresAt", column = "expires_at", dataType = "datetime", label = "Expires At");

		// Timestamps
		property(name = "createdAt", column = "createdat", dataType = "timestamp", label = "Created At");

		property(name = "updatedAt", column = "updatedat", dataType = "timestamp", label = "Updated At");

		// Relationships
		belongsTo(name = "User", foreignKey = "userId");
	}

	// Create a new remember token
	public function createToken(required numeric userId) {
		var token = new ();
		token.userId = arguments.userId;
		token.token = Hash(CreateUUID() & arguments.userId & Now(), "SHA-256");
		token.expiresAt = DateAdd("d", 30, Now());
		return token.save();
	}

	// Find token by hashed value (caller must hash raw cookie value with SHA-256 first)
	public function findByToken(required string hashedToken) {
		return findOne(
			where="token = '#arguments.hashedToken#' AND expiresAt > '#dateTimeFormat(now(), "yyyy-MM-dd HH:nn:ss")#'"
		);
	}

	// Delete expired tokens
	public function deleteExpiredTokens() {
		return deleteAll(
			where="expiresAt <= '#dateTimeFormat(now(), "yyyy-MM-dd HH:nn:ss")#'"
		);
	}

}
