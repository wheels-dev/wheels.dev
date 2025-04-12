component extends="app.Models.Model" {
    function config() {
        table("blog_categories");

        property(name="id", column="id", type="integer", required=true, primarykey=true);
        property(name="categoryId", column="category_id", type="integer", required=false, default="");
        property(name="createdAt", column="createdat", type="datetime", required=false, default="");
        property(name="updatedAt", column="updatedat", type="datetime", required=false, default="");
        property(name="deletedAt", column="deletedat", type="datetime", required=false, default="");

        property(name="blogId", column="blog_id", type="integer", required=false);

        // Associations
        belongsTo(name="Blog", foreignKey="blogId"); 
        belongsTo(name="Category", foreignKey="categoryId");
    }

    // fetch all blog categories with category name
    public function getAll(){
        var categories = findAll(include="Category"); // include associated Category
        return categories;
    }
}