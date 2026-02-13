component extends="wheels.migrator.Migration" hint="insert records" {

	function up() {
		transaction {
			try {
				//roles
				addRecord(table='Roles',name = "admin");
				addRecord(table='Roles',name = "editor");
				addRecord(table='Roles',name = "user");

				// users (use execute() because addRecord converts booleans to integers which CockroachDB rejects)
				execute("INSERT INTO users (first_name, last_name, email, password_hash, profile_picture, profile_url, status, role_id, createdat, updatedat) VALUES ('Peter', 'Amiri', 'petera@pai.com', '$2a$10$P27CV/m.aramHhIxJTmzzu4dxIGfNqHWzLgVGJJTLDpXymnt4jPZu', 'avatar-rounded.webp', '', true, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)");

				// categories
				addRecord(table='categories', name='CLI', parent_id='', description='Learn about command-line tools, tips, and tricks for enhancing your development workflow using the command line.');
				addRecord(table='categories', name='Community', parent_id='', description='Updates and stories from the community, including user spotlights, testimonials, and community-driven initiatives.');
				addRecord(table='categories', name='Contributions', parent_id='', description='Information on contributing to open-source projects, including guidelines, best practices, and featured contributors.');
				addRecord(table='categories', name='Documentation', parent_id='', description='Guides, updates, and tips on how to use and contribute to documentation effectively.');
				addRecord(table='categories', name='Events', parent_id='', description='Announcements and recaps of conferences, webinars, meetups, and other events related to development and technology.');
				addRecord(table='categories', name='Inspiration', parent_id='', description='Success stories, case studies, and creative ideas to inspire your next project or solution.');
				addRecord(table='categories', name='Plugin', parent_id='', description='Reviews, tutorials, and updates about plugins that extend the functionality of the platform or framework.');
				addRecord(table='categories', name='Releases', parent_id='', description='Detailed information on new releases, version updates, changelogs, and feature highlights.');
				addRecord(table='categories', name='Tips & Tricks', parent_id='', description='Quick and effective tips to enhance productivity and solve common development challenges.');
				addRecord(table='categories', name='Tutorials', parent_id='', description='Step-by-step guides and how-tos for beginners and advanced users alike, covering a wide range of topics.');
				addRecord(table='categories', name='Website', parent_id='', description='News, updates, and improvements related to the website, including UI/UX enhancements and new features.');

				// post_types (use execute() for boolean is_active column)
				execute("INSERT INTO post_types (name, description, is_active, createdat, updatedat) VALUES ('Standard Post', 'Regular blog post with a title, content, and optional featured image.', true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)");
				execute("INSERT INTO post_types (name, description, is_active, createdat, updatedat) VALUES ('Video Post', 'Contains embedded videos from platforms like YouTube.', true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)");
				execute("INSERT INTO post_types (name, description, is_active, createdat, updatedat) VALUES ('Gallery Post', 'Displays multiple images in a gallery or slideshow format.', true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)");
				execute("INSERT INTO post_types (name, description, is_active, createdat, updatedat) VALUES ('Audio Post', 'Includes audio players for podcasts or music.', true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)");
				execute("INSERT INTO post_types (name, description, is_active, createdat, updatedat) VALUES ('Quote Post', 'Highlights a specific quote with proper attribution.', true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)");
				execute("INSERT INTO post_types (name, description, is_active, createdat, updatedat) VALUES ('Link Post', 'Focuses on sharing a link with a brief description.', true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)");
				execute("INSERT INTO post_types (name, description, is_active, createdat, updatedat) VALUES ('Status Post', 'Short, social media-style updates or announcements.', true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)");
				execute("INSERT INTO post_types (name, description, is_active, createdat, updatedat) VALUES ('Review Post', 'Reviews of products, services, or experiences with a rating system.', true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)");
				execute("INSERT INTO post_types (name, description, is_active, createdat, updatedat) VALUES ('Tutorial/How-to Post', 'Step-by-step guides or instructional content.', true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)");
				execute("INSERT INTO post_types (name, description, is_active, createdat, updatedat) VALUES ('News Post', 'Updates or news articles relevant to the audience.', true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)");
				execute("INSERT INTO post_types (name, description, is_active, createdat, updatedat) VALUES ('Interview Post', 'Q&A format featuring interviews with experts or influencers.', true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)");
				execute("INSERT INTO post_types (name, description, is_active, createdat, updatedat) VALUES ('Case Study Post', 'In-depth analysis or success stories.', true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)");
				execute("INSERT INTO post_types (name, description, is_active, createdat, updatedat) VALUES ('List Post', 'Lists of tips, resources, or best practices (e.g., ''Top 10...'').', true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)");
				execute("INSERT INTO post_types (name, description, is_active, createdat, updatedat) VALUES ('Event Post', 'Announcements or recaps of events, workshops, or webinars.', true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)");
				execute("INSERT INTO post_types (name, description, is_active, createdat, updatedat) VALUES ('Opinion Post', 'Editorial or opinion pieces.', true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)");

				// post_statuses (use execute() for boolean is_active column)
				execute("INSERT INTO post_statuses (name, description, is_active, createdat, updatedat) VALUES ('Draft', 'Post is saved but not published. Only visible to admins and authors.', true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)");
				execute("INSERT INTO post_statuses (name, description, is_active, createdat, updatedat) VALUES ('Posted', 'Post is live and visible to the public.', true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)");
				execute("INSERT INTO post_statuses (name, description, is_active, createdat, updatedat) VALUES ('Scheduled', 'Post is set to go live at a future date/time.', true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)");
				execute("INSERT INTO post_statuses (name, description, is_active, createdat, updatedat) VALUES ('Pending Review', 'Post is awaiting review and approval before publishing.', true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)");
				execute("INSERT INTO post_statuses (name, description, is_active, createdat, updatedat) VALUES ('Archived', 'Post is no longer public but saved for record-keeping.', true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)");
				execute("INSERT INTO post_statuses (name, description, is_active, createdat, updatedat) VALUES ('Private', 'Post is only visible to specific users (e.g., admins or logged-in users).', true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)");
				execute("INSERT INTO post_statuses (name, description, is_active, createdat, updatedat) VALUES ('Trash', 'Post is marked for deletion but can be restored or permanently deleted later.', true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)");

				// features (use execute() for boolean is_active column)
				execute("INSERT INTO features (title, description, is_active, created_by, createdat, updatedat) VALUES ('A Complete Package', 'A full framework with tonnes of functionality - once you''ve started, you''ll wonder how you ever did CFML development before!', true, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)");
				execute("INSERT INTO features (title, description, is_active, created_by, createdat, updatedat) VALUES ('RESTful Routing', '<a href=''https://guides.cfwheels.org/cfwheels-guides/handling-requests-with-controllers/routing''>Resource based routing</a> for GET, POST, PUT, PATCH &amp; DELETE', true, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)");
				execute("INSERT INTO features (title, description, is_active, created_by, createdat, updatedat) VALUES ('Database Migrations', 'Built in <a href=''https://guides.cfwheels.org/cfwheels-guides/database-interaction-through-models/database-migrations''>database migration system</a> even across different DBMS', true, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)");
				execute("INSERT INTO features (title, description, is_active, created_by, createdat, updatedat) VALUES ('Automatic Documentation', 'Use our <a href=''https://guides.cfwheels.org/cfwheels-guides/working-with-cfwheels/documenting-your-code''>built in doc viewer</a> which grows with your application with only minor markup required', true, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)");
				execute("INSERT INTO features (title, description, is_active, created_by, createdat, updatedat) VALUES ('Hybrid Development', 'Switch in and out of Wheels conventions - it''s your call; Need to use a bog standard query? Go ahead!', true, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)");
				execute("INSERT INTO features (title, description, is_active, created_by, createdat, updatedat) VALUES ('Full Documentation', 'Lots of lovely <a href=''https://guides.cfwheels.org/'' title=''Documentation''>documentation</a> available with <a href=''https://guides.cfwheels.org/cfwheels-guides/introduction/readme/beginner-tutorial-hello-world''>tutorials</a> and a <a href=''https://api.cfwheels.org/''>complete API reference</a>', true, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)");
				execute("INSERT INTO features (title, description, is_active, created_by, createdat, updatedat) VALUES ('Stay Relevant', 'Wheels uses industry established concepts, such as <a href=''https://guides.cfwheels.org/cfwheels-guides/introduction/frameworks-and-cfwheels''>MVC</a> and <a href=''https://guides.cfwheels.org/cfwheels-guides/database-interaction-through-models/object-relational-mapping''>ORM</a>. These essential principles make being a polyglot a reality!', true, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)");
				execute("INSERT INTO features (title, description, is_active, created_by, createdat, updatedat) VALUES ('A Helpful Community', 'Get in touch via our <a href=''https://github.com/wheels-dev/wheels/discussions''>GitHub Discussions</a> - we''re newbie friendly and just want to help out.', true, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)");
				execute("INSERT INTO features (title, description, is_active, created_by, createdat, updatedat) VALUES ('Good Organization', 'Stop thinking about how to organize your code and deal with your business specific problems instead.', true, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)");

			} catch (any e) {
				local.exception = e;
			}

			if (StructKeyExists(local, "exception")) {
				transaction action="rollback";
				Throw(errorCode = "1", detail = local.exception.detail, message = local.exception.message, type = "any");
			} else {
				transaction action="commit";
			}
		}
	}

	function down() {
		transaction {
			try {
				// your code goes here
			} catch (any e) {
				local.exception = e;
			}

			if (StructKeyExists(local, "exception")) {
				transaction action="rollback";
				Throw(errorCode = "1", detail = local.exception.detail, message = local.exception.message, type = "any");
			} else {
				transaction action="commit";
			}
		}
	}

}
