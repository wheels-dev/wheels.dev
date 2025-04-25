<cfscript>
	/*
		Use this file to set variables for the Application.cfc's "this" scope.

		Examples:
		this.name = "MyAppName";
		this.sessionTimeout = CreateTimeSpan(0,0,5,0);
	*/

	this.name = "wheels.dev";

	// Set the session timeout (based on inactivity days,hours,minutes,seconds)
	this.sessionManagement = true;
	this.sessionTimeout = CreateTimeSpan(0,2,0,0);
	this.sessioncookie  = {timeout=createTimeSpan(0,2,0,0)};
	this.sessionStorage = this.env.sessionStorage; 
	this.sessionCluster = this.env.sessionCluster;
  	
	this.bufferOutput = true;

  	// Set up all datasources.
  	// wheels-dev
	this.datasources["wheels.dev"] = {
		class: "com.microsoft.sqlserver.jdbc.SQLServerDriver", 
		bundleName: "org.lucee.mssql", 
		bundleVersion: "#this.env.wheelsdev_bundleversion#",
		connectionString: "jdbc:sqlserver://#this.env.wheelsdev_host#:#this.env.wheelsdev_port#;DATABASENAME=#this.env.wheelsdev_databasename#;trustServerCertificate=true;SelectMethod=direct",
		username: "#this.env.wheelsdev_username#",
		password: "encrypted:#this.env.wheelsdev_password#",
		
		// optional settings
		clob:#not(!this.env.wheelsdev_clob)#, // default: false
		connectionLimit:#toNumeric(this.env.wheelsdev_connectionlimit)#, // default:-1
		storage:#not(!this.env.wheelsdev_storage)# // default: false
	};

	this.mappings["/logbox"] = "app.lib.logbox";

	// CLI-Appends-Here
</cfscript>
