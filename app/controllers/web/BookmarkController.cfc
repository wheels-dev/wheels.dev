component extends="app.Controllers.Controller" {

	function config() {
		super.config();
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
			where="userId = :userId AND blogId = :blogId",
			params={
				userId={value=val(session.userID), cfsqltype="cf_sql_integer"},
				blogId={value=val(params.blogId), cfsqltype="cf_sql_integer"}
			}
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
				where="userId = :userId AND blogId = :blogId",
				params={
					userId={value=val(session.userID), cfsqltype="cf_sql_integer"},
					blogId={value=val(params.blogId), cfsqltype="cf_sql_integer"}
				},
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
				where="userId = :userId",
				params={userId={value=val(session.userID), cfsqltype="cf_sql_integer"}},
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

		var whereClause = "userId = :userId";
		var queryParams = {userId={value=val(session.userID), cfsqltype="cf_sql_integer"}};
		if (StructKeyExists(params, "searchTerm") && params.searchTerm != "") {
			whereClause &= " AND Blog.title LIKE :searchTerm";
			queryParams.searchTerm = {value="%" & params.searchTerm & "%", cfsqltype="cf_sql_varchar"};
		}

		bookmarks = model("Bookmark").findAll(
			where=whereClause,
			params=queryParams,
			include="Blog",
			order="createdAt DESC",
			perPage=20,
			page=params.page
		);

		renderPartial("_list");
	}
}