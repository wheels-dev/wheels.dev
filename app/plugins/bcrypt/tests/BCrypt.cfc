component extends="wheels.Test"  hint="Unit Tests" {
	function setup(){
		pw1="IAMATESTPASSWORD";
	}
	function teardown(){

	}
	function Test_Create_Salt(){
		salt=bCryptGenSalt();
		assert("len(salt) GT 10");
	}
	function Test_Hash_Password(){
		r=bCryptHashPW(pw1, bCryptGenSalt());
		assert("len(r) GT 20");
	}
	function Test_Compare_Password(){
		pw2=bCryptHashPW(pw1, bCryptGenSalt());
		r=bCryptCheckPW(pw1,pw2);
		assert("r EQ true");
	}
	function Test_Compare_Password_Fails(){
		pw2=bCryptHashPW("Wrong Password", bCryptGenSalt());
		r=bCryptCheckPW(pw1,pw2);
		assert("r EQ false");
	}
}
