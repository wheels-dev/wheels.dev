component extends="app.Controllers.Controller" {

	function config() {
		super.config();
		verifies(except="index,track,complete,clear,search,list", params="key", paramsTypes="integer", handler="index");
		filters(through="restrictAccess");
		usesLayout("/layout");
	}

	// GET /reading-history
	function index() {
		if (!StructKeyExists(session, "userID")) {
			redirectTo(route="auth-login");
			return;
		}

		if (!StructKeyExists(params, "page") || !IsNumeric(params.page)) {
			params.page = 1;
		}

		histories = model("ReadingHistory")
			.findAll(
				where="userId = ?", params=[session.userID],
				include="Blog",
				order="lastReadAt DESC",
				perPage=20,
				page=params.page
			);

		bookmarks = model("Bookmark")
			.findAll(
				where="userId = ?", params=[session.userID],
				include="Blog",
				order="createdAt DESC"
			);
	}

	// POST /reading-history/track
	function track() {
		if (!StructKeyExists(session, "userID")) {
			data = {
				"success" = false,
				"message" = "Not logged in"
			};
			renderWith(data=data, layout="/responseLayout");
			return;
		}

		history = model("ReadingHistory").findOne(
			where="userId = ? AND blogId = ?", params=[session.userID, params.blogId]
		);

		if (IsObject(history)) {
			history.update(lastReadAt=Now());
		} else {
			history = model("ReadingHistory").create(
				userId=session.userID,
				blogId=params.blogId,
				lastReadAt=Now()
			);
		}

		data = {
			"success" = true,
			"message" = "Reading progress updated"
		};
		renderWith(data=data, layout="/responseLayout");
	}

	// POST /reading-history/complete
	function complete() {
		if (!StructKeyExists(session, "userID")) {
			data = {
				"success" = false,
				"message" = "Not logged in"
			};
			renderWith(data=data, layout="/responseLayout");
			return;
		}

		history = model("ReadingHistory").findOne(
			where="userId = ? AND blogId = ?", params=[session.userID, params.blogId]
		);

		if (IsObject(history)) {
			history.update(isCompleted=true);
		}

		data = {
			"success" = true,
			"message" = "Article marked as completed"
		};
		renderWith(data=data, layout="/responseLayout");
	}

	// DELETE /reading-history/clear
	function clear() {
		if (!StructKeyExists(session, "userID")) {
			redirectTo(route="auth-login");
			return;
		}

		model("ReadingHistory").deleteAll(
			where="userId = ?", params=[session.userID]
		);

		flashInsert(success="Reading history cleared");
		redirectTo(action="index");
	}

	// GET /reading-history/search
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

		histories = model("ReadingHistory").findAll(
			where=where, params=whereParams,
			include="Blog",
			order="lastReadAt DESC",
			perPage=20,
			page=params.page
		);

		renderPartial("_list", layout=false);
	}

	// GET /reading-history/list
	function list() {
		if (!StructKeyExists(session, "userID")) {
			renderWith(text="<div class='alert alert-danger'>Not logged in</div>", format="html");
			return;
		}

		if (!StructKeyExists(params, "page") || !IsNumeric(params.page)) {
			params.page = 1;
		}

		var whereParams = [session.userID];
		where = "userId = ?";
		if (StructKeyExists(params, "status")) {
			if (params.status == "completed") {
				where &= " AND isCompleted=1";
			} else if (params.status == "inprogress") {
				where &= " AND isCompleted=0";
			}
		}

		histories = model("ReadingHistory").findAll(
			where=where, params=whereParams,
			include="Blog",
			order="lastReadAt DESC",
			perPage=20,
			page=params.page
		);

		renderPartial("_list", layout=false);
	}
}