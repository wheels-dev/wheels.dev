component extends="wheels.migrator.Migration" hint="Fix post_statuses and post_types to use explicit sequential IDs for CockroachDB compatibility" {

	function up() {
		transaction {
			try {
				// CockroachDB unique_rowid() assigned large random IDs to post_statuses and post_types,
				// but blogStatuses() hardcodes {DRAFT=1, POSTED=2, ...} and blog approval sets statusId
				// to these small integers. Fix by re-inserting with explicit IDs that match the code.
				//
				// blog_posts.status_id already contains values 1-7 (set by blogStatuses()),
				// so we just need the post_statuses table to have matching rows.

				// -- post_statuses: delete old rows and re-insert with explicit IDs --
				execute("DELETE FROM post_statuses");
				execute("INSERT INTO post_statuses (id, name, description, is_active, createdat, updatedat) VALUES (1, 'Draft', 'Post is saved but not published. Only visible to admins and authors.', true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)");
				execute("INSERT INTO post_statuses (id, name, description, is_active, createdat, updatedat) VALUES (2, 'Posted', 'Post is live and visible to the public.', true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)");
				execute("INSERT INTO post_statuses (id, name, description, is_active, createdat, updatedat) VALUES (3, 'Scheduled', 'Post is set to go live at a future date/time.', true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)");
				execute("INSERT INTO post_statuses (id, name, description, is_active, createdat, updatedat) VALUES (4, 'Pending Review', 'Post is awaiting review and approval before publishing.', true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)");
				execute("INSERT INTO post_statuses (id, name, description, is_active, createdat, updatedat) VALUES (5, 'Archived', 'Post is no longer public but saved for record-keeping.', true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)");
				execute("INSERT INTO post_statuses (id, name, description, is_active, createdat, updatedat) VALUES (6, 'Private', 'Post is only visible to specific users (e.g., admins or logged-in users).', true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)");
				execute("INSERT INTO post_statuses (id, name, description, is_active, createdat, updatedat) VALUES (7, 'Trash', 'Post is marked for deletion but can be restored or permanently deleted later.', true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)");

				// -- post_types: delete old rows and re-insert with explicit IDs --
				execute("DELETE FROM post_types");
				execute("INSERT INTO post_types (id, name, description, is_active, createdat, updatedat) VALUES (1, 'Standard Post', 'Regular blog post with a title, content, and optional featured image.', true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)");
				execute("INSERT INTO post_types (id, name, description, is_active, createdat, updatedat) VALUES (2, 'Video Post', 'Contains embedded videos from platforms like YouTube.', true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)");
				execute("INSERT INTO post_types (id, name, description, is_active, createdat, updatedat) VALUES (3, 'Gallery Post', 'Displays multiple images in a gallery or slideshow format.', true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)");
				execute("INSERT INTO post_types (id, name, description, is_active, createdat, updatedat) VALUES (4, 'Audio Post', 'Includes audio players for podcasts or music.', true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)");
				execute("INSERT INTO post_types (id, name, description, is_active, createdat, updatedat) VALUES (5, 'Quote Post', 'Highlights a specific quote with proper attribution.', true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)");
				execute("INSERT INTO post_types (id, name, description, is_active, createdat, updatedat) VALUES (6, 'Link Post', 'Focuses on sharing a link with a brief description.', true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)");
				execute("INSERT INTO post_types (id, name, description, is_active, createdat, updatedat) VALUES (7, 'Status Post', 'Short, social media-style updates or announcements.', true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)");
				execute("INSERT INTO post_types (id, name, description, is_active, createdat, updatedat) VALUES (8, 'Review Post', 'Reviews of products, services, or experiences with a rating system.', true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)");
				execute("INSERT INTO post_types (id, name, description, is_active, createdat, updatedat) VALUES (9, 'Tutorial/How-to Post', 'Step-by-step guides or instructional content.', true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)");
				execute("INSERT INTO post_types (id, name, description, is_active, createdat, updatedat) VALUES (10, 'News Post', 'Updates or news articles relevant to the audience.', true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)");
				execute("INSERT INTO post_types (id, name, description, is_active, createdat, updatedat) VALUES (11, 'Interview Post', 'Q&A format featuring interviews with experts or influencers.', true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)");
				execute("INSERT INTO post_types (id, name, description, is_active, createdat, updatedat) VALUES (12, 'Case Study Post', 'In-depth analysis or success stories.', true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)");
				execute("INSERT INTO post_types (id, name, description, is_active, createdat, updatedat) VALUES (13, 'List Post', 'Lists of tips, resources, or best practices (e.g., ''Top 10...'').', true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)");
				execute("INSERT INTO post_types (id, name, description, is_active, createdat, updatedat) VALUES (14, 'Event Post', 'Announcements or recaps of events, workshops, or webinars.', true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)");
				execute("INSERT INTO post_types (id, name, description, is_active, createdat, updatedat) VALUES (15, 'Opinion Post', 'Editorial or opinion pieces.', true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)");

			} catch (any e) {
				local.exception = e;
			}

			if (StructKeyExists(local, "exception")) {
				transaction action="rollback";
				throw(errorCode="1", detail=local.exception.detail, message=local.exception.message, type="any");
			} else {
				transaction action="commit";
			}
		}
	}

	function down() {
		// No-op: the old CockroachDB-generated IDs are unrecoverable
	}

}
