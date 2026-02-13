<cfcomponent extends="wheels.migrator.Migration" hint="testimonials setting">
  <cffunction name="up">
  	<cfset hasError = false />
  	<cftransaction>
	    <cfscript>
	    	try{
				t = createTable(name='settings', force=false, id=true, primaryKey='id'); 
				t.boolean(columnNames='enable_testimonial', default=false, null=false);
				t.timestamps();
				t.create();

				execute("INSERT INTO settings (enable_testimonial, createdat, updatedat) VALUES (false, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)");
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
	    		dropTable('settings');
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