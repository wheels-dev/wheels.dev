component extends="app.Models.Model" {
    function config(){
        table("blog_posts");

        property(name="id", column="id", type="integer", required=true, primaryKey=true);

        property(name="title", column="title", type="string", required=true, default="", limit=255);
        property(name="content", column="content", type="text", required=true, default="");
        property(name="slug", column="slug", type="string", required=true, default="", limit=255);
        property(name="coverImagePath", column="cover_image_path", type="string", required=false, default="", limit=100);
        property(name="status", column="status", type="string", required=false, default="");

        property(name="isCommentClosed", column="is_comment_closed", type="boolean", required=true, default=false);
        property(name="isPublished", column="is_published", type="boolean", required=true, default=false);

        property(name="postCreatedDate", column="post_created_date", type="datetime", required=false);
        property(name="createdAt", column="created_at", type="datetime", required=false);
        property(name="updatedAt", column="updated_at", type="datetime", required=false);
        property(name="deletedAt", column="deleted_at", type="datetime", required=false);
        property(name="publishedAt", column="published_at", type="datetime", required=false);


        // Defining the foreign key
        property(name="statusId", column="status_id", type="integer", required=true, foreignkey=true, references="PostStatus(id)");
        property(name="postTypeId", column="post_type_id", type="integer", required=true, foreignkey=true, references="PostType(id)");
        property(name="createdBy", column="created_by", type="integer", required=true, foreignkey=true, references="User(id)");
        property(name="updatedBy", column="updated_by", type="integer", required=false, foreignkey=true, references="User(id)");
        property(name="deletedBy", column="deleted_by", type="integer", required=false, foreignkey=true, references="User(id)");
        property(name="tagId", column="blog_id", type="integer", required=false, foreignkey=true, references="Tag(id)");

        // Define associations
        belongsTo(name="User", foreignKey="createdBy"); 
        belongsTo(name="PostStatus", foreignKey="statusId");
        belongsTo(name="PostType", foreignKey="postTypeId");

    }

    // Fetch all latest blog posts with corresponding users
    public function getAll() {
        var blogs = findAll(include="User", order="createdAt DESC");
        return blogs;
    }
}