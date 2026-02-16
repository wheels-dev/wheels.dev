component extends="app.Models.Model" {
    function config() {
        table("features");
        

        property(name="id", column="id", type="integer", required=true, primarykey=true);
        property(name="title", column="title", type="string", required=false, default="");
        property(name="image", column="image", type="string", required=false, default="");
        property(name="card_link", column="card_link", type="string", required=false, default="");
        property(name="description", column="description", type="text", required=false, default="");
        property(name="createdAt", column="createdat", type="datetime", required=false, default="");
        property(name="updatedAt", column="updatedat", type="datetime", required=false, default="");
        property(name="deletedAt", column="deletedat", type="datetime", required=false, default="");

        validatesPresenceOf(property="title");
    }

    //get all features
    public function getAllFeatures(){
        var features = findAll();
        return features;
    }
}