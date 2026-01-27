component extends="app.Controllers.Controller" {

	function config() {
		verifies(except="toggle,index", params="key", paramsTypes="integer", handler="index");
		filters(through="restrictAccess");
		usesLayout("/layout");
	}

	// POST /bookmark/toggle
	function toggle() {
		if (!StructKeyExists(session, "userID")) {
			renderWith(data="<div class='alert alert-danger'>Not logged in</div>", layout=false);
			return;
		}

		bookmark = model("Bookmark").findOne(
			where="userId=#session.userID# AND blogId=#params.blogId#"
		);

		if (IsObject(bookmark)) {
			// Remove bookmark (only from bookmarks page)
			bookmark.delete();
			renderWith(data="", layout=false);
		} else {
			// Add bookmark
			model("Bookmark").create(
				userId=session.userID,
				blogId=params.blogId
			);
			renderWith(data="<span class=""text-success fw-bold"">★ Bookmarked</span><script>if (typeof notifier !== 'undefined') notifier.show('Success!', 'Article bookmarked successfully.', '', '/img/ok-48.png', 3000);</script>", layout=false);
		}
	}

	// GET /bookmarks
	function index() {
		if (!StructKeyExists(session, "userID")) {
			redirectTo(route="auth-login");
			return;
		}

		if (!StructKeyExists(params, "page") || !IsNumeric(params.page)) {
			params.page = 1;
		}

		bookmarks = model("Bookmark")
			.findAll(
				where="userId=#session.userID#",
				include="Blog",
				order="createdAt DESC",
				perPage=20,
				page=params.page
			);
	}

	// GET /bookmarks/search
	function search() {
		if (!StructKeyExists(session, "userID")) {
			renderWith(text="<div class='alert alert-danger'>Not logged in</div>", format="html");
			return;
		}

		if (!StructKeyExists(params, "page") || !IsNumeric(params.page)) {
			params.page = 1;
		}

		where = "userId=#session.userID#";
		if (StructKeyExists(params, "searchTerm") && params.searchTerm != "") {
			where &= " AND Blog.title LIKE '%#params.searchTerm#%'";
		}

		bookmarks = model("Bookmark").findAll(
			where=where,
			include="Blog",
			order="createdAt DESC",
			perPage=20,
			page=params.page
		);

		renderPartial("_list");
	}
}