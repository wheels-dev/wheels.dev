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
		class: "org.postgresql.Driver",
		bundleName: "org.postgresql.jdbc",
		bundleVersion: "42.7.7",
		connectionString: "jdbc:postgresql://#this.env.wheelsdev_host#:#this.env.wheelsdev_port#/#this.env.wheelsdev_databasename#?sslmode=disable",
		username: "#this.env.wheelsdev_username#",
		password: "#this.env.wheelsdev_password#",
		clob: #not(!this.env.wheelsdev_clob)#,
		connectionLimit: #toNumeric(this.env.wheelsdev_connectionlimit)#,
		storage: #not(!this.env.wheelsdev_storage)#
	};
	this.cache.connections["contributors"] = {
		class: 'lucee.runtime.cache.ram.RamCache'
		, storage: true
		, custom: {
			"outOfMemory":"true",
			"timeToIdleSeconds":3600,"timeToLiveSeconds":3600}
		, default: 'object'
	};
	  this.mailservers =[ {
    host: '#this.env.smtp_host#'
    , port: #toNumeric(this.env.smtp_port)#
    , username: '#this.env.smtp_username#'
    , password: '#this.env.smtp_password#'
    , ssl: #not(!this.env.smtp_ssl)#
    , tls: #not(!this.env.smtp_tls)#
    , lifeTimespan: createTimeSpan(0,0,1,0)
    , idleTimespan: createTimeSpan(0,0,0,10)
  }];

	// CLI-Appends-Here
</cfscript>
