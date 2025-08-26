component hint="bCrypt" output="false" mixin="global"
{
	public  function init() {
		this.version = "2.0";
		return this;
	}
	/**
	* BCrypt Hash Password
	*
	* [section: Plugins]
	* [category: bCrypt]
	*
	* @password The unencrypted password
	* @salt An instance of bCryptGenSalt()
	*/
	public function bCryptHashPW(password, salt){
		return $getBCrypt().hashpw(arguments.password, arguments.salt);
	}

	/**
	* BCrypt Generate Salt
	*
	* [section: Plugins]
	* [category: bCrypt]
	*
	* @complexity Gensalt's log_rounds parameter
	*/
	public function bCryptGenSalt(numeric complexity=10){
		return $getBCrypt().gensalt(arguments.complexity);
	}

	/**
	* Compare two passwords
	*
	* [section: Plugins]
	* [category: bCrypt]
	*
	* @candidate The unencrypted password
	* @hashed The hash to compare to
	*/
	public function bCryptCheckPW(candidate,hashed){
		return $getBCrypt().checkpw(arguments.candidate,arguments.hashed);
	}

	/**
	* Internal Function
	*/
	public function $getBCrypt(){
		return CreateObject( "java", "BCrypt" ).init();
	}
}


