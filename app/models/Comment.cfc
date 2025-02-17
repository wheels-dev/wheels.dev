component extends="app.Models.Model" {
    function config(){
        table("comments");

        property(name="id", column="id", type="integer", required=true, primarykey=true);
        property(name="name", column="name", type="string", required=false, default="");
        property(name="content", column="content", type="text", required=false, default="");
        property(name="createdAt", column="createdat", type="datetime", required=false, default="");
        property(name="updatedAt", column="updatedat", type="datetime", required=false, default="");
        property(name="deletedAt", column="deletedat", type="datetime", required=false, default="");

        // Defining the foreign key
        property(name="blogId", column="blog_id", type="integer", required=false, foreignkey=true, references="Blog(id)");
        property(name="autherId", column="auther_id", type="integer", required=false, foreignkey=true, references="User(id)");
        property(name="updatedBy", column="updated_by", type="integer", required=false, foreignkey=true, references="User(id)");
        property(name="deletedBy", column="deleted_by", type="integer", required=false, foreignkey=true, references="User(id)");

    }
    
    // fetch all comments
    public function getAllComments(){
        var comments = findAll();
        return comments;
    }
}

