component extends="app.Models.Model" {
    function config() {
        table("tags");

        property(name="id", column="id", type="integer", primarykey=true);
        property(name="name", column="name", type="string", defaultValue = "");
        property(name="createdAt", column="createdat", type="datetime", defaultValue = "");
        property(name="updatedAt", column="updatedat", type="datetime", defaultValue = "");
        property(name="deletedAt", column="deletedat", type="datetime", defaultValue = "");

        hasMany(name="BlogTag", foreignKey="tagId");

        validatesPresenceOf(property="name");
        validatesUniquenessOf(property="name");
    }

    // fetch all tags
    public function getAll(){
        var tags = findAll();
        return tags;
    }
}