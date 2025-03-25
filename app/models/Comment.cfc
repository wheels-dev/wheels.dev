component extends="app.Models.Model" {
    function config(){
        table("comments");

        property(name="id", column="id", type="integer", required=true, primarykey=true);
        property(name="content", column="content", type="text", required=false, default="");
        property(name="commentParentId", column="comment_parent_id", type="integer", required=false, default="");
        property(name="createdAt", column="createdat", type="datetime", required=false, default="");
        property(name="publishedAt", column="published_at", type="datetime", required=false, default="");
        property(name="updatedAt", column="updatedat", type="datetime", required=false, default="");
        property(name="deletedAt", column="deletedat", type="datetime", required=false, default="");

        property(name="isPublished", column="is_published", type="boolean", required=true, default=false);
        property(name="isDeleted", column="is_deleted", type="boolean", required=true, default=false);


        // Defining the foreign key
        property(name="commentParentId", column="comment_parent_id", type="integer", required=false, foreignkey=true, references="Comment(id)");
        property(name="blogId", column="blog_id", type="integer", required=false, foreignkey=true, references="Blog(id)");
        property(name="authorId", column="author_id", type="integer", required=false, foreignkey=true, references="User(id)");
        property(name="updatedBy", column="updated_by", type="integer", required=false, foreignkey=true, references="User(id)");
        property(name="deletedBy", column="deleted_by", type="integer", required=false, foreignkey=true, references="User(id)");

        // Define associations
        belongsTo(name="User", foreignKey="authorId"); 
        belongsTo(name="Blog", foreignKey="blogId"); 
        belongsTo(name="Comment", foreignKey="commentParentId"); 
    }
    
    // fetch all comments
    public function getAllComments(){
        var comments = findAll(where='isPublished = 1', include="User");
        return comments;
    }
}

