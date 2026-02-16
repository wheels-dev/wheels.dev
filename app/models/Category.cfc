component extends="app.Models.Model" {
    function config() {
        table("categories");

        property(name="id", column="id", type="integer", required=true, primarykey=true);
        property(name="name", column="name", type="string", required=false, default="");
        property(name="parentId", column="parent_id", type="string", required=false, default="");
        property(name="description", column="description", type="text", required=false, default="");
        property(name="isActive", column="is_active", type="boolean", required=false, default="");
        property(name="createdAt", column="createdat", type="datetime", required=false, default="");
        property(name="updatedAt", column="updatedat", type="datetime", required=false, default="");
        property(name="deletedAt", column="deletedat", type="datetime", required=false, default="");

        hasMany(name="BlogCategory", foreignKey="categoryId");

        validatesPresenceOf(property="name");
        validatesUniquenessOf(property="name");
    }

    // fetch all blog_categories
    public function getAll(){
        var categories = findAll();
        return categories;
    }
}