component extends="app.Models.Model"{
	function config() {
		table("reading_histories");
		// Properties
		property(name="userId", column="user_id", dataType="string");
		property(name="blogId", column="blog_id", dataType="string");
		property(name="lastReadAt", column="last_read_at", dataType="datetime");
		property(name="isCompleted", column="is_completed", dataType="boolean", defaultValue=false);

		// Associations
		belongsTo("User");
		belongsTo("Blog");

		// Validations
		validatesPresenceOf("userId,blogId");
	}
}