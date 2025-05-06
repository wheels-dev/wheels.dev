component extends="app.Models.Model" {
    function config() {
        table("role_permissions");

        property(name="id", column="id", type="integer", required=true, primarykey=true);
        property(name="permissionId", column="permission_id", type="integer", required=false);
        property(name="roleId", column="role_id", type="integer", required=false);
        property(name="createdAt", column="createdat", type="datetime", required=false, default="");
        property(name="updatedAt", column="updatedat", type="datetime", required=false, default="");
        property(name="deletedAt", column="deletedat", type="datetime", required=false, default="");

        // Defining the foreign key
        property(name="roleId", column="role_id", type="integer", required=false, foreignkey=true, references="Role(id)");
        property(name="permissionId", column="permission_id", type="integer", required=false, foreignkey=true, references="Permission(id)");
        belongsTo(name="Role", foreignKey="roleId");
        belongsTo(name="permission", foreignKey="permissionId");

    }

    // fetch all rolepermissions
    public function getAll(){
        var rolepermissions = findAll();
        return rolepermissions;
    }
}