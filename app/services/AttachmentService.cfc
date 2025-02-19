component {
    property name="Attachment"; // Inject the Attachment model

     function init(attachmentModel) {
        variables.Attachment = attachmentModel; // Store model
        return this;
    }

    function getAllAttachments() {
        return variables.Attachment.findAll();
    }
    
    function getAttachmentsByBlogid(required numeric id) {
        return variables.Attachment.findAll(include="Blog", where="blogid = #arguments.id#");
    }

}
