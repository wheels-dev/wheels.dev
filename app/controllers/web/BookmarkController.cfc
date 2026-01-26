component extends="Controller" {

	function config() {
		filters(through="requireLogin");
	}

	// POST /bookmark/toggle (AJAX)
	function toggle() {
		bookmark = model("Bookmark").findOne(
			where="userId=#session.user.id# AND blogId=#params.blogId#"
		);

		if (IsObject(bookmark)) {
			// Remove bookmark
			bookmark.delete();
			renderWith(data={bookmarked=false}, format="json");
		} else {
			// Add bookmark
			model("Bookmark").create(
				userId=session.user.id,
				blogId=params.blogId
			);
			renderWith(data={bookmarked=true}, format="json");
		}
	}

	// GET /bookmarks
	function index() {
		bookmarks = model("Bookmark")
			.findAll(
				where="userId=#session.user.id#",
				include="Blog",
				order="createdAt DESC",
				perPage=20,
				page=params.page
			);
	}
}