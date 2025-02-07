<cfscript>
	/*
		Use this file to set variables for the Application.cfc's "this" scope.

		Examples:
		this.name = "MyAppName";
		this.sessionTimeout = CreateTimeSpan(0,0,5,0);
	*/

	this.name = "wheels.dev";
  	
	this.bufferOutput = true;

  	// Set up all datasources.
  	// wheels-dev
	this.datasources["wheels.dev"] = {
    	class: "com.microsoft.sqlserver.jdbc.SQLServerDriver", 
      bundleName: "org.lucee.mssql", 
      bundleVersion: "12.6.3.jre11",
      connectionString: "jdbc:sqlserver://localhost:1433;DATABASENAME=wheels_dev;trustServerCertificate=true;SelectMethod=direct",
      username: "root",
      password: "encrypted:0dd5bce6050ab7d8e9eb6ec04067660cdce83facfa6a6d51",
      
      // optional settings
      connectionLimit:-1, // default:-1
      liveTimeout:15, // default: -1; unit: minutes
      validate:false, // default: false
  };

	// CLI-Appends-Here
</cfscript>
