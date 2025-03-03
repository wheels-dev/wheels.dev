component extends="app.Models.Model" {
    function config(){
        table("users");

        property(name="id", column="id", type="integer", required=true, primarykey=true);
        property(name="name", column="name", type="string", required=false, default="");
        property(name="email", column="email", type="string", required=false, default="");
        property(name="passwordHash", column="passwordhash", type="string", required=false, default="");
        property(name="profilePicture", column="profile_picture", type="string", required=false, default="");
        property(name="profileUrl", column="profile_url", type="string", required=false, default="");
        property(name="status", column="status", type="boolean", required=false, default=true);
        property(name="createdAt", column="createdat", type="datetime", required=false, default="");
        property(name="updatedAt", column="updatedat", type="datetime", required=false, default="");
        property(name="deletedAt", column="deletedat", type="datetime", required=false, default="");

        // Defining the foreign key
        property(name="roleid", column="role_id", type="integer", required=false, foreignkey=true, references="Role(id)");
        
        belongsTo(name="Role", foreignKey="roleid");

    }

    // fetch all users
    public function getAllUsers(){
        var users = findAll();
        return users;
    }

}