component extends="app.Models.Model" {
    function config() {
        table("modules");

        property(name="id", column="id", type="integer", required=true, primarykey=true);
        property(name="name", column="name", type="string", required=false, default="");
        property(name="description", column="description", type="text", required=false, default="");
        property(name="status", column="status", type="boolean", required=false, default="");
        property(name="createdAt", column="createdat", type="datetime", required=false, default="");
        property(name="updatedAt", column="updatedat", type="datetime", required=false, default="");
        property(name="deletedAt", column="deletedat", type="datetime", required=false, default="");
    }

    // fetch all modules
    public function getAll(){
        var modules = findAll();
        return modules;
    }
}