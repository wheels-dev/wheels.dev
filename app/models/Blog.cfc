component extends="app.Models.Model" {
    function config(){
        table("blog_posts");

        property(name="id", column="id", dataType="string");

        property(name="title", column="title", dataType="string", defaultValue = "");
        property(name="content", column="content", dataType="text", defaultValue = "");
        property(name="slug", column="slug", dataType="string", defaultValue = "");
        property(name="coverImagePath", column="cover_image_path", dataType="string", defaultValue="");
        property(name="status", column="status", dataType="string", defaultValue = "");

        property(name="isCommentClosed", column="is_comment_closed", dataType="boolean", defaultValue=false);
        property(name="isPublished", column="is_published", dataType="boolean", defaultValue=false);

        property(name="postCreatedDate", column="post_created_date", dataType="datetime");
        property(name="createdAt", column="createdat", dataType="datetime");
        property(name="updatedAt", column="updatedat", dataType="datetime");
        property(name="deletedAt", column="deletedat", dataType="datetime");
        property(name="publishedAt", column="published_at", dataType="datetime");

        property(
            name="postDate",
            sql="blog_posts.published_at",
            label="Published At"
        );

        // Defining the foreign key
        property(name="statusId", column="status_id", dataType="integer", foreignkey=true, references="PostStatus(id)");
        property(name="postTypeId", column="post_type_id", dataType="integer", foreignkey=true, references="PostType(id)");
        property(name="createdBy", column="created_by", dataType="integer", foreignkey=true, references="User(id)");
        property(name="updatedBy", column="updated_by", dataType="integer", foreignkey=true, references="User(id)");
        property(name="deletedBy", column="deleted_by", dataType="integer", foreignkey=true, references="User(id)");

        // Define associations
        belongsTo(name="User", foreignKey="createdBy"); 
        belongsTo(name="PostStatus", foreignKey="statusId");
        belongsTo(name="PostType", foreignKey="postTypeId");
        hasMany(name="BlogCategory", foreignKey="blogId");
        hasMany(name="BlogTag", foreignKey="blogId");
        hasMany("ReadingHistories");
        hasMany("Bookmarks");

        validatesPresenceOf(properties="title,content");
        validatesUniquenessOf(property="slug");
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
            order="publishedAt DESC",
            cache=10
        );
        return blogs;
    }

    /**
     * Computed property to get the correct post date.
     */
    public function getDisplayDate() {
        return this.publishedAt;
    }
}