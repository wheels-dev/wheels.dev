component extends="app.Models.Model" {
    function config() {
        table("guides");

        property(name="id", column="id", type="integer", required=true, primarykey=true);
        property(name="tab", column="tab", type="string", required=false, default="");
        property(name="title", column="title", type="string", required=false, default="");
        property(name="subtitle", column="subtitle", type="string", required=false, default="");
        property(name="heading_1", column="heading_1", type="string", required=false, default="");
        property(name="heading_2", column="heading_2", type="string", required=false, default="");
        property(name="heading_url", column="heading_url", type="string", required=false, default="");
        property(name="content", column="content", type="text", required=false, default="");
        property(name="parentId", column="parent_id", type="string", required=false, default="");
        property(name="createdAt", column="createdat", type="datetime", required=false, default="");
        property(name="updatedAt", column="updatedat", type="datetime", required=false, default="");
        property(name="deletedAt", column="deletedat", type="datetime", required=false, default="");
    }

    // fetch all guides
    public function getAll(){
        var guides = findAll();
        return guides;
    }
}