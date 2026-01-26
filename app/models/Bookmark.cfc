component extends="Model" {
	function config() {
		// Properties
		property(name="userId", type="numeric");
		property(name="blogId", type="numeric");

		// Associations
		belongsTo("User");
		belongsTo("Blog");

		// Validations
		validatesPresenceOf("userId,blogId");
		validatesUniquenessOf(property="blogId", scope="userId");
	}
}