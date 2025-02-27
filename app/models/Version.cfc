component extends="app.Models.Model" {
    function config() {
        table("versions");

        property(name="id", column="id", type="integer", required=true, primarykey=true);
        property(name="name", column="name", type="string", required=false, default="");
        property(name="createdAt", column="createdat", type="datetime", required=false, default="");
        property(name="updatedAt", column="updatedat", type="datetime", required=false, default="");
        property(name="deletedAt", column="deletedat", type="datetime", required=false, default="");
    }

    // fetch all versions
    public function getAll(){
        var versions = findAll();
        return versions;
    }
}