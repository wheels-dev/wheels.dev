component extends="app.Models.Model" {
    function config() {
        table("user_tokens");

        property(name="id", column="id", type="integer", required=true, primarykey=true);
        property(name="token", column="token", type="string", required=false, default="");
        property(name="createdAt", column="createdat", type="datetime", required=false, default="");
        property(name="updatedAt", column="updatedat", type="datetime", required=false, default="");
        property(name="deletedAt", column="deletedat", type="datetime", required=false, default="");
        property(name="user_id", column="user_id", type="integer", required=true, foreignkey=true, references="User(id)");
        
        belongsTo(name="User", foreignKey="user_id");
    }

    // fetch all roles
    public function getAllToken(){
        var token = findAll();
        return token;
    }
}