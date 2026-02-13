<!---
    |----------------------------------------------------------------------------------------------|
	| Parameter  | Required | Type    | Default | Description                                      |
    |----------------------------------------------------------------------------------------------|
	| name       | Yes      | string  |         | table name, in pluralized form                   |
	| force      | No       | boolean | false   | drop existing table of same name before creating |
	| id         | No       | boolean | true    | if false, defines a table with no primary key    |
	| primaryKey | No       | string  | id      | overrides default primary key name
    |----------------------------------------------------------------------------------------------|

    EXAMPLE:
      t = createTable(name='employees',force=false,id=true,primaryKey='empId');
      t.string(columnNames='name', default='', null=true, limit='255');
      t.text(columnNames='bio', default='', null=true);
      t.time(columnNames='lunchStarts', default='', null=true);
      t.datetime(columnNames='employmentStarted', default='', null=true);
      t.integer(columnNames='age', default='', null=true, limit='1');
      t.decimal(columnNames='hourlyWage', default='', null=true, precision='1', scale='2');
      t.date(columnNames='dateOfBirth', default='', null=true);
--->
<cfcomponent extends="wheels.migrator.Migration" hint="create email templates table">
  <cffunction name="up">
  	<cfset hasError = false />
  	<cftransaction>
	    <cfscript>
	    	try{
				t = createTable(name='email_templates', force=false, id=true, primaryKey='id');
				t.string(columnNames='title', default='', null=false, limit='255');
				t.string(columnNames='subject', default='', null=false, limit='255');
				t.string(columnNames='welcome_message', default='', null=true, limit='255');
				t.text(columnNames='message', default='', null=false);
				t.text(columnNames='footer_note', default='', null=true);
				t.string(columnNames='button_title', default='', null=true, limit='255');
				t.string(columnNames='footer_greatings', default='', null=true, limit='255');
				t.string(columnNames='closing_remarks', default='', null=true, limit='255');
				t.string(columnNames='team_signature', default='', null=true, limit='255');
				t.timestamps();
				t.create();

				// Use execute() because addRecord() calls get("adapterName") for timestamp columns which fails on CockroachDB
				execute("INSERT INTO email_templates (title, subject, welcome_message, message, footer_note, footer_greatings, button_title, closing_remarks, team_signature, createdat, updatedat) VALUES ('Reset Password', 'Reset Your Password', '', 'We received a request to reset the password for your account associated with this email address. If you made this request please click the button below to create a new password.', 'If you did not request reset password, you can safely ignore this email.', 'Thank you for being a part of the Wheels community.', 'Reset Password', 'Happy Reporting,', 'The Team Wheels', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)");

				execute("INSERT INTO email_templates (title, subject, welcome_message, message, footer_note, footer_greatings, button_title, closing_remarks, team_signature, createdat, updatedat) VALUES ('Sign Up Account Verification', 'Verify Your Account', 'Welcome to Wheels.dev!', 'Thank you for signing up. Please click the button below to verify your account and get started.', 'If you did not initiate this registration, feel free to disregard this email.', 'Thank you for becoming a part of the Wheels community.', 'Verify Your Account', 'Happy Reporting,', 'The Team Wheels', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)");

				execute("INSERT INTO email_templates (title, subject, welcome_message, message, footer_note, footer_greatings, button_title, closing_remarks, team_signature, createdat, updatedat) VALUES ('Register Your Account', 'No Account Found : Get Started with Wheels Today!', '', 'We noticed you tried to reset your password using this email address, but it looks like there''s no account associated with it. No worries &mdash; it happens! If you''re new to Wheels, we would love to have you on board. <br><br>Click below to create your free account and start building powerful ColdFusion applications with ease.', 'If you believe this is a mistake or you already have an account with a different email, feel free to try again or contact our support team for help.<br><br>If you did not request reset password, you can safely ignore this email.', '', 'Register here', 'Happy Reporting,', 'The Team Wheels', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)");

				execute("INSERT INTO email_templates (title, subject, welcome_message, message, footer_note, footer_greatings, button_title, closing_remarks, team_signature, createdat, updatedat) VALUES ('Publish Testimonial', 'Your testimonial has been approved and published.', '', 'Thank you for writing a testimonial. Your testimonial has been approved and published on the Wheels website.', 'If you did not submit this testimonial, feel free to disregard this email.', 'Thank you for being a part of the Wheels community.', 'View Your Testimonial', 'Happy Reporting,', 'The Team Wheels', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)");

				execute("INSERT INTO email_templates (title, subject, welcome_message, message, footer_note, footer_greatings, button_title, closing_remarks, team_signature, createdat, updatedat) VALUES ('Publish Blog', 'Your blog post has been published', '', 'We appreciate your contribution. Your blog post, is now live on the Wheels website.', 'If you have not published a blog post, feel free to disregard this email.', 'Thank you for being a part of the Wheels community.', 'View Your Post', 'Happy Reporting,', 'The Team Wheels', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)");

				execute("INSERT INTO email_templates (title, subject, welcome_message, message, footer_note, footer_greatings, button_title, closing_remarks, team_signature, createdat, updatedat) VALUES ('Publish comment', 'Your comment has been reviewed and published', '', 'Thank you for commenting on our blog post! Your comment is now live on the Wheels website.', 'If you did not submit this comment, feel free to disregard this email.', 'Thank you for being a part of the Wheels community.', 'View Your Post', 'Happy Reporting,', 'The Team Wheels', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)");

				execute("INSERT INTO email_templates (title, subject, welcome_message, message, footer_note, footer_greatings, button_title, closing_remarks, team_signature, createdat, updatedat) VALUES ('Reject blog', 'Blog Post Submission Update : Not Approved for Publication', '', 'Thank you for submitting your blog post. After review, it has not been approved for publication.', 'If you have not published a blog post, feel free to disregard this email.', 'Thank you for being a part of the Wheels community.', '', 'Happy Reporting,', 'The Team Wheels', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)");
	    	}
	    	catch (any ex){
	    		hasError = true;
		      	catchObject = ex;
	    	}

	    </cfscript>
	     <cfif hasError>
	    	<cftransaction action="rollback" />
	    	<cfthrow
			    detail = "#catchObject.detail#"
			    errorCode = "1"
			    message = "#catchObject.message#"
			    type = "Any">
	    <cfelse>
	    	<cftransaction action="commit" />
	    </cfif>
	 </cftransaction>
  </cffunction>
  <cffunction name="down">
  	<cfset hasError = false />
  	<cftransaction>
	    <cfscript>
	    	try{
	    		dropTable('email_templates');
	    	}
	    	catch (any ex){
	    		hasError = true;
		      	catchObject = ex;
	    	}

	    </cfscript>
	    <cfif hasError>
	    	<cftransaction action="rollback" />
	    	<cfthrow
			    detail = "#catchObject.detail#"
			    errorCode = "1"
			    message = "#catchObject.message#"
			    type = "Any">
	    <cfelse>
	    	<cftransaction action="commit" />
	    </cfif>
	 </cftransaction>
  </cffunction>
</cfcomponent>
