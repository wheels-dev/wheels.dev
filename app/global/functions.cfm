<cfscript>
// Place functions here that should be available globally in your application.
public function GetSignedInUserId(){
    return session.USERID;
}
public function GetBloggerId(){
    return 2;
}
public function SetActive(){
    return 1;
}
public function SetInactive(){
    return 0;
}
</cfscript>
