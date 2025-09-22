<cfcomponent extends="wheels.migrator.Migration" hint="contributor_roles">
  <cffunction name="up">
  	<cfset hasError = false />
  	<cftransaction>
	    <cfscript>
	    	try{
				t = createTable(name='contributor_roles', force='false', id=true, primaryKey='id');
				t.string(columnNames='role_name', default='', null=true, limit='255');
				t.timestamps();
				t.create();
				addRecord(table='contributor_roles', role_name="Software Developer");
				addRecord(table='contributor_roles', role_name="Maintainer");
				addRecord(table='contributor_roles', role_name="Plugin/Extension Author");
				addRecord(table='contributor_roles', role_name="Documentation Writer");
				addRecord(table='contributor_roles', role_name="Quality Assurance Engineer");
				addRecord(table='contributor_roles', role_name="UI/UX Developer");
				addRecord(table='contributor_roles', role_name="DevOps Engineer");
				addRecord(table='contributor_roles', role_name="Community Manager");
				addRecord(table='contributor_roles', role_name="Issue Triager");
				addRecord(table='contributor_roles', role_name="Project Manager");
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
	    		dropTable('contributor_roles');
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