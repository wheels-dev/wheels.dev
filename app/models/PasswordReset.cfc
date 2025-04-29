component extends="app.Models.Model" {
    function config() {
        table("password_resets");

        property(name="id", column="id", type="integer", required=true, primarykey=true);
        property(name="token", column="token", type="string", required=true, default="");
        property(name="expiresAt", column="expires_at", type="datetime", required=true);
        property(name="used", column="used", type="boolean", required=true, default=false);
        property(name="createdAt", column="createdat", type="datetime", required=false, default="");
        property(name="updatedAt", column="updatedat", type="datetime", required=false, default="");
        property(name="deletedAt", column="deletedat", type="datetime", required=false, default="");
        property(name="user_id", column="user_id", type="integer", required=true, foreignkey=true, references="User(id)");
        
        belongsTo(name="User", foreignKey="user_id");
        validatesPresenceOf("token,expiresAt,user_id");
        validatesUniquenessOf("token");
    }

    // Find active reset token
    public function findActiveToken(required string token) {
        return findOne(
            where="token = '#arguments.token#' AND expires_at > '#now()#' AND used = 0"
        );
    }

    // Mark token as used
    public function markAsUsed(required numeric id) {
        var reset = findByKey(arguments.id);
        if (isObject(reset)) {
            reset.update(used=true);
            return true;
        }
        return false;
    }
} 