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
        property(name="createdAt", column="createdat", type="datetime", required=false);
        property(name="updatedAt", column="updatedat", type="datetime", required=false);
        property(name="deletedAt", column="deletedat", type="datetime", required=false);
        property(name="publishedAt", column="published_at", type="datetime", required=false);

        property(
            name="postDate", 
            sql="COALESCE(post_created_date, blog_posts.createdat)", 
            label="Created At"
        );

        // Defining the foreign key
        property(name="statusId", column="status_id", type="integer", required=true, foreignkey=true, references="PostStatus(id)");
        property(name="postTypeId", column="post_type_id", type="integer", required=true, foreignkey=true, references="PostType(id)");
        property(name="createdBy", column="created_by", type="integer", required=true, foreignkey=true, references="User(id)");
        property(name="updatedBy", column="updated_by", type="integer", required=false, foreignkey=true, references="User(id)");
        property(name="deletedBy", column="deleted_by", type="integer", required=false, foreignkey=true, references="User(id)");

        // Define associations
        belongsTo(name="User", foreignKey="createdBy"); 
        belongsTo(name="PostStatus", foreignKey="statusId");
        belongsTo(name="PostType", foreignKey="postTypeId");
        hasMany(name="BlogCategory", foreignKey="blogId");
        hasmany(name="tag", foreignKey="blogId"); 
        hasMany("ReadingHistories");
        hasMany("Bookmarks"); 

    }

    // Fetch all latest blog posts with corresponding users
    public function getAll() {
        var blogs = findAll(where='statusid <> 1', include="User", order = "postDate DESC");
        return blogs;
    }
    
    // Fetch ten latest blog posts with corresponding users
    public function getTenLatest() {
        var blogs = findAll(
            where='statusid <> 1',
            include="User",
            maxRows=10,
            order="createdAt DESC",
            cache=10
        );
        return blogs;
    }

    /**
     * Computed property to get the correct post date.
     */
    public function getDisplayDate() {
        if (NOT isEmpty(this.postCreatedDate)) {
            return this.postCreatedDate;
        } else {
            return this.createdAt;
        }
    }
}