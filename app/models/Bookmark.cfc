component extends="app.Models.Model" {
	function config() {
		table("bookmarks");
		// Properties
		property(name="userId", column="user_id", dataType="string");
		property(name="blogId", column="blog_id", dataType="string");

		// Associations
		belongsTo("User");
		belongsTo("Blog");

		// Validations
		validatesPresenceOf("userId,blogId");
		validatesUniquenessOf(property="blogId", scope="userId");
	}
}