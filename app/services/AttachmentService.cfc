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

    public struct function uploadFile(file) {
        var uploadPath = expandPath("/public/files");
        var filePath = uploadPath & file.serverFileName;

        // Ensure the upload directory exists
        if (!directoryExists(uploadPath)) {
            directoryCreate(uploadPath);
        }

        // Move the uploaded file to the upload directory
        fileWrite(filePath, file.fileContent);

        return {
            filePath: filePath,
            fileName: file.serverFileName
        };
    }
}
