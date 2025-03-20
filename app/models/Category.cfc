component extends="app.Models.Model" {
    function config() {
        table("categories");

        property(name="id", column="id", type="integer", required=true, primarykey=true);
        property(name="categoryId", column="category_id", type="integer", required=false, default="");
        property(name="createdAt", column="createdat", type="datetime", required=false, default="");
        property(name="updatedAt", column="updatedat", type="datetime", required=false, default="");
        property(name="deletedAt", column="deletedat", type="datetime", required=false, default="");

        // Defining the foreign key
        property(name="blogId", column="blog_id", type="integer", required=false, foreignkey=true, references="Blog(id)");

        // Define associations
        belongsTo(name="Blog", foreignKey="blogId"); 
        belongsTo(name="BlogCategory", foreignKey="categoryId"); 
    }

    // fetch all categories
    public function getAll(){
        var categories = findAll();
        return categories;
    }
}