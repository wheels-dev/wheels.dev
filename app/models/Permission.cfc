component extends="app.Models.Model" {
    function config() {
        table("permissions");

        property(name="id", column="id", type="integer", required=true, primarykey=true);
        property(name="name", column="name", type="string", required=false, default="");
        property(name="status", column="status", type="boolean", required=false, default="");
        property(name="createdAt", column="createdat", type="datetime", required=false, default="");
        property(name="updatedAt", column="updatedat", type="datetime", required=false, default="");
        property(name="deletedAt", column="deletedat", type="datetime", required=false, default="");

        // Defining the foreign key
        property(name="moduleId", column="module_id", type="integer", required=false, foreignkey=true, references="Module(id)");

        validatesPresenceOf(property="name");
        validatesUniquenessOf(property="name");
    }

    // fetch all permissions
    public function getAll(){
        var permissions = findAll();
        return permissions;
    }
}