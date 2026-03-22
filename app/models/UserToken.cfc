component extends="app.Models.Model" {
    function config() {
        table("user_tokens");

        // Tell Wheels to treat the ID as a string, not an integer -- CockroachDB is storing INT8 (BIGINT), which is a 64-bit integer that ColdFusion cannot safely represent as a number.
        property(name="id", column="id", dataType ="string", primarykey=true);
        property(name="token", column="token", dataType ="string", defaultValue = "");
        property(name="createdAt", column="createdat", dataType ="datetime", defaultValue = "");
        property(name="updatedAt", column="updatedat", dataType ="datetime", defaultValue = "");
        property(name="deletedAt", column="deletedat", dataType ="datetime", defaultValue = "");
        property(name="user_id", column="user_id", dataType ="string");
        property(name="expiresAt", column="expires_at", dataType ="datetime", defaultValue = "");

        belongsTo(name="User", foreignKey="user_id");
    }

    // fetch all roles
    public function getAllToken(){
        var token = findAll();
        return token;
    }
}