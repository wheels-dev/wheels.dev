component extends="app.Controllers.Controller" {

	function config() {
		verifies(except="toggle,index", params="key", paramsTypes="integer", handler="index");
		filters(through="restrictAccess");
		usesLayout("/layout");
	}

	// POST /bookmark/toggle
	function toggle() {
		if (!StructKeyExists(session, "userID")) {
			data = {
				"success" = false,
				"message" = "Not logged in"
			};
			renderWith(data=data, layout="/responseLayout");
			return;
		}

		// Find bookmark
		bookmark = model("Bookmark").findOne(
			where="userId = ? AND blogId = ?", params=[session.userID, params.blogId]
		);

		if (IsObject(bookmark)) {
			// Active bookmark exists - soft delete it
			bookmark.delete();
			data = {
				"success" = true,
				"message" = "Bookmark removed",
				"bookmarked" = false,
				"removed" = true
			};
		} else {
			// Check if a soft-deleted bookmark exists
			deletedBookmark = model("Bookmark").findOne(
				where="userId = ? AND blogId = ?", params=[session.userID, params.blogId],
				includeSoftDeletes=true
			);

			if (IsObject(deletedBookmark)) {
				// Reactivate the deleted bookmark
				deletedBookmark.update(deletedAt="", updatedAt=Now());
				data = {
					"success" = true,
					"message" = "Article bookmarked successfully",
					"bookmarked" = true,
					"removed" = false
				};
			} else {
				// Create new bookmark
				model("Bookmark").create(
					userId=session.userID,
					blogId=params.blogId
				);
				data = {
					"success" = true,
					"message" = "Article bookmarked successfully",
					"bookmarked" = true,
					"removed" = false
				};
			}
		}
		renderWith(data=data, layout="/responseLayout");
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
				where="userId = ?", params=[session.userID],
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

		var whereParams = [session.userID];
		where = "userId = ?";
		if (StructKeyExists(params, "searchTerm") && params.searchTerm != "") {
			where &= " AND Blog.title LIKE ?";
			arrayAppend(whereParams, "%#params.searchTerm#%");
		}

		bookmarks = model("Bookmark").findAll(
			where=where, params=whereParams,
			include="Blog",
			order="createdAt DESC",
			perPage=20,
			page=params.page
		);

		renderPartial("_list");
	}
}