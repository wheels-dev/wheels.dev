component extends="app.Models.Model" {
    function config(){
        table("attachments");

        property(name="id", column="id", type="integer", required=true, primarykey=true);
        property(name="path", column="path", type="string", required=false, default="");
        property(name="content", column="content", type="text", required=false, default="");
        property(name="createdAt", column="createdat", type="datetime", required=false, default="");
        property(name="updatedAt", column="updatedat", type="datetime", required=false, default="");
        property(name="deletedAt", column="deletedat", type="datetime", required=false, default="");

        // Defining the foreign key
        property(name="blogId", column="blog_id", type="integer", required=false, foreignkey=true, references="Blog(id)");
        property(name="commentId", column="comment_id", type="integer", required=false, foreignkey=true, references="Comment(id)");
        
    }

    // fetch all attachments
    public function getAllAttachments(){
        var attachments = findAll();
        return attachments;
    }
}