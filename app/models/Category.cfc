component extends="app.Models.Model" {
    function config() {
        table("categories");

        property(name="id", column="id", dataType="string", primarykey=true);
        property(name="name", column="name", dataType="string", defaultValue="");
        property(name="parentId", column="parent_id", dataType="string", defaultValue="");
        property(name="description", column="description", dataType="text", defaultValue="");
        property(name="isActive", column="is_active", dataType="boolean", defaultValue="");
        
        property(name="createdAt", column="createdat", dataType="datetime", defaultValue="");
        property(name="updatedAt", column="updatedat", dataType="datetime", defaultValue="");
        property(name="deletedAt", column="deletedat", dataType="datetime", defaultValue="");

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