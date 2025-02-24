component extends="app.Models.Model" {
    function config() {
        table("categories");

        property(name="id", column="id", type="integer", required=true, primarykey=true);
        property(name="name", column="name", type="string", required=false, default="");
        property(name="categoryParentId", column="category_parent_id", type="string", required=false, default="");
        property(name="createdAt", column="createdat", type="datetime", required=false, default="");
        property(name="updatedAt", column="updatedat", type="datetime", required=false, default="");
        property(name="deletedAt", column="deletedat", type="datetime", required=false, default="");
    }

    // fetch all categories
    public function getAll(){
        var categories = findAll();
        return categories;
    }
}