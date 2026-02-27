component extends="app.Models.Model" {
    function config() {
        table("tags");

        property(name="id", column="id", dataType = "integer", primarykey=true);
        property(name="name", column="name", dataType = "string", defaultValue = "");
        property(name="createdAt", column="createdat", dataType = "datetime", defaultValue = "");
        property(name="updatedAt", column="updatedat", dataType = "datetime", defaultValue = "");
        property(name="deletedAt", column="deletedat", dataType = "datetime", defaultValue = "");

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