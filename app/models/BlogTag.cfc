component extends="app.Models.Model" {
    function config() {
        table("blog_tags");

        property(name="id", column="id", dataType="string");
        property(name="tagId", column="tag_id", dataType="integer", defaultValue = "");
        property(name="createdAt", column="createdat", dataType="datetime", defaultValue = "");
        property(name="updatedAt", column="updatedat", dataType="datetime", defaultValue = "");
        property(name="deletedAt", column="deletedat", dataType="datetime", defaultValue = "");

        property(name="blogId", column="blog_id", dataType="integer");

        // Associations
        belongsTo(name="Blog", foreignKey="blogId"); 
        belongsTo(name="Tag", foreignKey="tagId");
    }

    // fetch all blog tags with tag name
    public function getAll(){
        var blogTags = findAll(include="Tag"); // include associated Tag
        return blogTags;
    }
}

