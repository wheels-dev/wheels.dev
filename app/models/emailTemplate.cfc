component extends="app.Models.Model" {
    function config() {
        table("email_templates");

        property(name="id", column="id", type="integer", required=true, primarykey=true);
        property(name="title", column="title", type="string", required=true, default="");
        property(name="subject", column="subject", type="string", required=true, default="");
        property(name="welcomeMessage", column="welcome_message", type="string", required=false, default="");
        property(name="message", column="message", type="string", required=true, default="");
        property(name="footerNote", column="footer_note", type="string", required=false, default="");
        property(name="buttonTitle", column="button_title", type="string", required=false, default="");
        property(name="footerGreating", column="footer_greatings", type="string", required=false, default="");
        property(name="closingRemark", column="closing_remarks", type="string", required=false, default="");
        property(name="teamSignature", column="team_signature", type="string", required=false, default="");
        property(name="createdAt", column="createdat", type="datetime", required=false, default="");
        property(name="updatedAt", column="updatedat", type="datetime", required=false, default="");
        property(name="deletedAt", column="deletedat", type="datetime", required=false, default="");
    }
}