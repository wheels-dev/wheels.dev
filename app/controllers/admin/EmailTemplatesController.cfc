component extends="app.Controllers.Controller" {

    function config() {
        super.config();
        verifies(except="index,view,edit,save,checkAdminAccess,checkRoleExistance", params="key", paramsTypes="integer");

        usesLayout(template="/admin/AdminController/layout");
        filters(through="checkAdminAccess");
    }

    function index(){
        emails = model("emailTemplate").findAll();
    }

    function view(){
        email = model("emailTemplate").findAll(where="id = ?", params=[params.id]);
    }

    function edit(){
        email = model("emailTemplate").findAll(where="id = ?", params=[params.id]);
    }

    function save(){
        try{
            email = model("emailTemplate").findOne(where="id = ?", params=[params.id]);
            if(structKeyExists(params, "id")){
                if (not isNull(email)) {
                    // Edit the existing email post
                    email.subject = params.subject;
                    email.message = params.message;
                    email.welcomeMessage = params.welcomeMessage;
                    email.footerNote = params.footerNote;
                    email.footerGreating = params.footerGreating;
                    email.buttonTitle = params.buttonTitle;
                    email.closingRemark = params.closingRemark;
                    email.teamSignature = params.teamSignature;
                    email.updatedAt = now();
                    if (structKeyExists(params, "profilePicture") && isDefined("params.profilePicture")) {
                        email.profilePicture = params.profilePicture
                    }
                    email.save();
                    message = "Email content updated successfully.";
                } else {
                    message = "Email not found for editing.";
                }
                redirectto(route="adminEmail-templates", success=message);
                return;
            }else{
                message="Something went wrong email content not updated correctly!";
                redirectto(route="adminEmail-templates", error=message);
            }

        }catch(any e){
            // handle exception
            message="Something went wrong email content not updated correctly!";
            redirectto(action="adminEmail-templates", error=message);
        }
    }
}