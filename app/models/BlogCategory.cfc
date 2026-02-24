component extends="app.Models.Model" {
    function config() {
        table("blog_categories");

        property(name="id", column="id", dataType="string");
        property(name="categoryId", column="category_id", dataType="integer", defaultValue = "");
        
        property(name="createdAt", column="createdat", dataType="datetime", defaultValue = "");
        property(name="updatedAt", column="updatedat", dataType="datetime", defaultValue = "");
        property(name="deletedAt", column="deletedat", dataType="datetime", defaultValue = "");

        property(name="blogId", column="blog_id", dataType="integer");

        // Associations
        belongsTo(name="Blog", foreignKey="blogId"); 
        belongsTo(name="Category", foreignKey="categoryId");

        validatesUniquenessOf(property="categoryId", scope="blogId"); // Ensure unique category per blog
    }

    // fetch all blog categories with category name
    public function getAll(){
        var categories = findAll(include="Category"); // include associated Category
        return categories;
    }
}