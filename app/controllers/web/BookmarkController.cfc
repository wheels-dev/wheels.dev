component extends="app.Controllers.Controller" {

	function config() {
		verifies(except="toggle,index", params="key", paramsTypes="integer", handler="index");
		filters(through="restrictAccess");
		usesLayout("/layout");
	}

	// POST /bookmark/toggle
	function toggle() {
		if (!StructKeyExists(session, "userId")) {
			renderWith(text="<div class='alert alert-danger'>Not logged in</div>", format="html");
			return;
		}

		bookmark = model("Bookmark").findOne(
			where="userId=#session.userId# AND blogId=#params.blogId#"
		);

		if (IsObject(bookmark)) {
			// Remove bookmark
			bookmark.delete();
			renderWith(text="<button onclick=""toggleBookmark(#params.blogId#, this)"" class=""bg--primary text-white fs-16 rounded-2 px-3 py-1"">Bookmark</button>", format="html");
		} else {
			// Add bookmark
			model("Bookmark").create(
				userId=session.userId,
				blogId=params.blogId
			);
			renderWith(text="<button onclick=""toggleBookmark(#params.blogId#, this)"" class=""bg--danger text-white fs-16 rounded-2 px-3 py-1"">Remove</button>", format="html");
		}
	}

	// GET /bookmarks
	function index() {
		if (!StructKeyExists(session, "userId")) {
			redirectTo(route="auth-login");
			return;
		}

		if (!StructKeyExists(params, "page") || !IsNumeric(params.page)) {
			params.page = 1;
		}

		bookmarks = model("Bookmark")
			.findAll(
				where="userId=#session.userId#",
				include="Blog",
				order="createdAt DESC",
				perPage=20,
				page=params.page
			);
	}

	// GET /bookmarks/search
	function search() {
		if (!StructKeyExists(session, "userId")) {
			renderWith(text="<div class='alert alert-danger'>Not logged in</div>", format="html");
			return;
		}

		if (!StructKeyExists(params, "page") || !IsNumeric(params.page)) {
			params.page = 1;
		}

		where = "userId=#session.userId#";
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