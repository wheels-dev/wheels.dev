component extends="app.Models.Model" {
    function config(){
        table("blog_posts");

        property(name="id", column="id", type="integer", required=true, primarykey=true);
        property(name="title", column="title", type="string", required=false, default="");
        property(name="slug", column="slug", type="string", required=false, default="" , unique=true);
        property(name="content", column="content", type="text", required=false, default="");
        property(name="excerpt", column="excerpt", type="string", required=false, default="");
        property(name="isCommentClosed", column="is_comment_closed", type="boolean", required=false, default=false);
        property(name="isDeleted", column="is_deleted", type="boolean", required=false, default=false);
        property(name="ispublished", column="is_published", type="boolean", required=false, default=false);
        property(name="createdAt", column="createdat", type="datetime", required=false, default="");
        property(name="updatedAt", column="updatedat", type="datetime", required=false, default="");
        property(name="deletedAt", column="deletedat", type="datetime", required=false, default="");
        property(name="publishedAt", column="published_at", type="datetime", required=false, default="");

        // Defining the foreign key
        property(name="statusId", column="status_id", type="integer", required=false, foreignkey=true, references="PostStatus(id)");
        property(name="categoryId", column="category_id", type="integer", required=false, foreignkey=true, references="Category(id)");
        property(name="postTypeId", column="post_type_id", type="integer", required=false, foreignkey=true, references="PostType(id)");
        property(name="createdBy", column="created_by", type="integer", required=false, foreignkey=true, references="User(id)");
        property(name="updatedBy", column="updated_by", type="integer", required=false, foreignkey=true, references="User(id)");
        property(name="deletedBy", column="deleted_by", type="integer", required=false, foreignkey=true, references="User(id)");
        // property(name="blogId", column="blog_id", type="integer", required=false, foreignkey=true, references="Tag(id)");

        // Define associations
        belongsTo(name="User", foreignKey="createdBy"); 
        belongsTo(name="Category", foreignKey="categoryId"); 
        belongsTo(name="PostStatus", foreignKey="statusId");

    }

    // Fetch all latest blog posts with corresponding users
    public function getAllBlogs() {
        var blogs = findAll(include="User", order="createdAt DESC");
        return blogs;
    }    
}