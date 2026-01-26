component extends="Model" {
	function config() {
		// Properties
		property(name="userId", type="numeric");
		property(name="blogId", type="numeric");
		property(name="lastReadAt", type="datetime");
		property(name="isCompleted", type="boolean", defaultValue=false);

		// Associations
		belongsTo("User");
		belongsTo("Blog");

		// Validations
		validatesPresenceOf("userId,blogId");
	}
}