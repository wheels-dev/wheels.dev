component extends="app.Models.Model" {
    function config() {
        table("tags");

        property(name="id", column="id", type="integer", required=true, primarykey=true);
        property(name="name", column="name", type="string", required=false, default="");
        property(name="createdAt", column="createdat", type="datetime", required=false, default="");
        property(name="updatedAt", column="updatedat", type="datetime", required=false, default="");
        property(name="deletedAt", column="deletedat", type="datetime", required=false, default="");

        // Defining the foreign key
        property(name="blogId", column="blog_id", type="integer", required=false, foreignkey=true, references="Blog(id)");

    }

    // fetch all tags
    public function getAllTags(){
        var tags = findAll();
        return tags;
    }
}