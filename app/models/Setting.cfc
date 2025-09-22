component extends="app.Models.Model" {
    function config() {
        table("settings");

        property(name="id", column="id", type="integer", required=true, primarykey=true);
        property(name="enableTestimonial", column="enable_testimonial", type="boolean", required=false, default=false);
        property(name="slackInviteLink", column="slack_invite_link", type="string", required=false, default="");
        property(name="wheelsContributorLink", column="wheels_contributors_api_link", type="string", required=false, default="");
        property(name="createdAt", column="createdat", type="datetime", required=false, default="");
        property(name="updatedAt", column="updatedat", type="datetime", required=false, default="");
        property(name="deletedAt", column="deletedat", type="datetime", required=false, default="");
    }

    // fetch all tags
    public function getAll(){
        var settings = findAll();
        return settings;
    }
}