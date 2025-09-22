<cfcomponent extends="wheels.migrator.Migration" hint="update_contributors">
  <cffunction name="up">
  	<cfset hasError = false />
  	<cftransaction>
	    <cfscript>
	    	try{
	    		t = changeTable('contributors');
				t.string(columnNames="contributor_profile_api", default="", null=true, limit="255");
	    		t.string(columnNames="contributor_pic", default="", null=true, limit="255");
				t.integer(columnNames='contributions', null=true);
	   			t.change();
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
	    		removeColumn(table='contributors',columnName='contributor_profile_api');
	    		removeColumn(table='contributors',columnName='contributor_pic');
	    		removeColumn(table='contributors',columnName='contributions');
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