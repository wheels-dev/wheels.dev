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
				// Use execute() because addRecord() calls get("adapterName") for timestamp columns which fails on CockroachDB
				execute("INSERT INTO contributor_roles (role_name, createdat, updatedat) VALUES ('Software Developer', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)");
				execute("INSERT INTO contributor_roles (role_name, createdat, updatedat) VALUES ('Maintainer', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)");
				execute("INSERT INTO contributor_roles (role_name, createdat, updatedat) VALUES ('Plugin/Extension Author', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)");
				execute("INSERT INTO contributor_roles (role_name, createdat, updatedat) VALUES ('Documentation Writer', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)");
				execute("INSERT INTO contributor_roles (role_name, createdat, updatedat) VALUES ('Quality Assurance Engineer', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)");
				execute("INSERT INTO contributor_roles (role_name, createdat, updatedat) VALUES ('UI/UX Developer', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)");
				execute("INSERT INTO contributor_roles (role_name, createdat, updatedat) VALUES ('DevOps Engineer', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)");
				execute("INSERT INTO contributor_roles (role_name, createdat, updatedat) VALUES ('Community Manager', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)");
				execute("INSERT INTO contributor_roles (role_name, createdat, updatedat) VALUES ('Issue Triager', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)");
				execute("INSERT INTO contributor_roles (role_name, createdat, updatedat) VALUES ('Project Manager', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)");
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
