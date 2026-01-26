component extends="Controller" {

	function config() {
		filters(through="requireLogin");
	}

	// GET /reading-history
	function index() {
		histories = model("ReadingHistory")
			.findAll(
				where="userId=#session.user.id#",
				include="Blog",
				order="lastReadAt DESC",
				perPage=20,
				page=params.page
			);

		bookmarks = model("Bookmark")
			.findAll(
				where="userId=#session.user.id#",
				include="Blog",
				order="createdAt DESC"
			);
	}

	// POST /reading-history/track (AJAX)
	function track() {
		history = model("ReadingHistory").findOne(
			where="userId=#session.user.id# AND blogId=#params.blogId#"
		);

		if (IsObject(history)) {
			history.update(lastReadAt=Now());
		} else {
			history = model("ReadingHistory").create(
				userId=session.user.id,
				blogId=params.blogId,
				lastReadAt=Now()
			);
		}

		renderWith(data={success=true}, format="json");
	}

	// POST /reading-history/complete (AJAX)
	function complete() {
		history = model("ReadingHistory").findOne(
			where="userId=#session.user.id# AND blogId=#params.blogId#"
		);

		if (IsObject(history)) {
			history.update(isCompleted=true);
		}

		renderWith(data={success=true}, format="json");
	}

	// DELETE /reading-history/clear
	function clear() {
		model("ReadingHistory").deleteAll(
			where="userId=#session.user.id#"
		);

		flashInsert(success="Reading history cleared");
		redirectTo(action="index");
	}
}