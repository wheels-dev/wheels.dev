component extends="wheels.migrator.Migration" hint="insert records" {

	function up() {
		transaction {
			try {
				// roles
				addRecord(table='Roles',name = "Admin");
				addRecord(table='Roles',name = "Blogger");
				addRecord(table='Roles',name = "User");

				// users
				addRecord(table="users", first_name="Peter", last_name="Amiri", email="peteramiri@gmail.com", password_hash="$2a$12$EIXHgw7eV9lB1d1wFYhFvOPtk7w3KQjJ0hWT3OQyOdL5g2vJYEF6C", profile_picture='', profile_url='', status=1, role_id=1);

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

				// post_types
				addRecord(table='post_types', name='Standard Post', description='Regular blog post with a title, content, and optional featured image.', is_active=1);
				addRecord(table='post_types', name='Video Post', description='Contains embedded videos from platforms like YouTube.', is_active=1);
				addRecord(table='post_types', name='Gallery Post', description='Displays multiple images in a gallery or slideshow format.', is_active=1);
				addRecord(table='post_types', name='Audio Post', description='Includes audio players for podcasts or music.', is_active=1);
				addRecord(table='post_types', name='Quote Post', description='Highlights a specific quote with proper attribution.', is_active=1);
				addRecord(table='post_types', name='Link Post', description='Focuses on sharing a link with a brief description.', is_active=1);
				addRecord(table='post_types', name='Status Post', description='Short, social media-style updates or announcements.', is_active=1);
				addRecord(table='post_types', name='Review Post', description='Reviews of products, services, or experiences with a rating system.', is_active=1);
				addRecord(table='post_types', name='Tutorial/How-to Post', description='Step-by-step guides or instructional content.', is_active=1);
				addRecord(table='post_types', name='News Post', description='Updates or news articles relevant to the audience.', is_active=1);
				addRecord(table='post_types', name='Interview Post', description='Q&A format featuring interviews with experts or influencers.', is_active=1);
				addRecord(table='post_types', name='Case Study Post', description='In-depth analysis or success stories.', is_active=1);
				addRecord(table='post_types', name='List Post', description='Lists of tips, resources, or best practices (e.g., "Top 10...").', is_active=1);
				addRecord(table='post_types', name='Event Post', description='Announcements or recaps of events, workshops, or webinars.', is_active=1);
				addRecord(table='post_types', name='Opinion Post', description='Editorial or opinion pieces.', is_active=1);

				// post_statuses
				addRecord(table='post_statuses', name='Draft', description='Post is saved but not published. Only visible to admins and authors.', is_active=1);
				addRecord(table='post_statuses', name='Posted', description='Post is live and visible to the public.', is_active=1);
				addRecord(table='post_statuses', name='Scheduled', description='Post is set to go live at a future date/time.', is_active=1);
				addRecord(table='post_statuses', name='Pending Review', description='Post is awaiting review and approval before publishing.', is_active=1);
				addRecord(table='post_statuses', name='Archived', description='Post is no longer public but saved for record-keeping.', is_active=1);
				addRecord(table='post_statuses', name='Private', description='Post is only visible to specific users (e.g., admins or logged-in users).', is_active=1);
				addRecord(table='post_statuses', name='Trash', description='Post is marked for deletion but can be restored or permanently deleted later.', is_active=1);

				// features
				addRecord(table="features", title="A Complete Package", description="A full framework with tonnes of functionality - once you've started, you'll wonder how you ever did CFML development before!", is_active=1);
				addRecord(table="features", title="RESTful Routing", description="Resource based routing for GET, POST, PUT, PATCH & DELETE", is_active=1);
				addRecord(table="features", title="Database Migrations", description="Built in database migration system even across different DBMS", is_active=1);
				addRecord(table="features", title="Automatic Documentation", description="Use our built in doc viewer which grows with your application with only minor markup required", is_active=1);
				addRecord(table="features", title="Hybrid Development", description="Switch in and out of Wheels conventions - it's your call; Need to use a bog standard query? Go ahead!", is_active=1);
				addRecord(table="features", title="Full Documentation", description="Lots of lovely documentation available with tutorials and a complete API reference", is_active=1);
				addRecord(table="features", title="Stay Relevant", description="CFWheels uses industry established concepts, such as MVC and ORM. These essential principles make being a polyglot a reality!", is_active=1);
				addRecord(table="features", title="A Helpful Community", description="Get in touch via our GitHub Discussions - we're newbie friendly and just want to help out.", is_active=1);

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
