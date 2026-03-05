<cfcomponent extends="wheels.migrator.Migration" hint="add approve blog email template">
  <cffunction name="up">
  	<cfset hasError = false />
  	<cftransaction>
	    <cfscript>
	    	try{
				execute("INSERT INTO email_templates (title, subject, welcome_message, message, footer_note, footer_greatings, button_title, closing_remarks, team_signature, createdat, updatedat) VALUES ('Approve Blog', 'Your blog post has been approved', '', 'Great news! Your blog post has been reviewed and approved. An admin will set the publish date shortly.', 'If you have not submitted a blog post, feel free to disregard this email.', 'Thank you for being a part of the Wheels community.', '', 'Happy Reporting,', 'The Team Wheels', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)");
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
	    		execute("DELETE FROM email_templates WHERE title = 'Approve Blog'");
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
