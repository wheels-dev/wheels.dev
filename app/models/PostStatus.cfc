component extends="app.Models.Model" {
    function config() {
        table("post_statuses");

        property(name="id", column="id", type="integer", required=true, primarykey=true);
        property(name="name", column="name", type="string", required=false, default="");
        property(name="createdAt", column="createdat", type="datetime", required=false, default="");
        property(name="updatedAt", column="updatedat", type="datetime", required=false, default="");
        property(name="deletedAt", column="deletedat", type="datetime", required=false, default="");
    }

    // fetch all post statuses
    public function getAllPostStatuses(){
        var poststatuses = findAll();
        return poststatuses;
    }
}