component extends="app.Models.Model" {
    function config() {
        table("contributors");

        // ID Property
        property(
            name="id", 
            column="id", 
            dataType="integer", 
            automaticValidations=false
        );

        // Name Property with custom label and column mapping
        property(
            name="Name", 
            column="name", 
            dataType="string", 
            label="Name", 
            defaultValue="", 
            automaticValidations=true
        );

        // User Name Property
        property(
            name="UserName", 
            column="user_name", 
            dataType="string", 
            label="User Name", 
            defaultValue=""
        );

        // Description Hash Property
        property(
            name="Description", 
            column="description", 
            dataType="text", 
            label="Description",
            defaultValue = ""
        );
        
        // Profile Picture Property
        property(
            name="profilePic", 
            column="contributor_pic", 
            dataType="string", 
            label="Contributor Profile Pic",
            defaultValue= ""
        );

        property(
            name="profileAPI", 
            column="contributor_profile_api", 
            dataType="string", 
            label="Profile Url",
            defaultValue= ""
        );

        property(
            name="contributions", 
            column="contributions", 
            dataType="string", 
            label="contributions",
            defaultValue= ""
        );

        property(
            name="Roles", 
            column="roles", 
            dataType="string", 
            label="Contributor Roles",
            defaultValue= ""
        );

        property(
            name="LinkedInLink", 
            column="linkedIn_link", 
            dataType="string", 
            label="Contributor Linked in profile link",
            defaultValue= ""
        );

        // Timestamps with custom column names
        property(
            name="createdAt", 
            column="createdat", 
            dataType="timestamp", 
            label="Created On"
        );

        property(
            name="updatedAt", 
            column="updatedat", 
            dataType="timestamp", 
            label="Last Updated"
        );

        property(
            name="deletedAt", 
            column="deletedat", 
            dataType="timestamp", 
            label="Deletion Date"
        );
    }

    // Fetch all contributors
    public function getAll(){
        var contributors = findAll();
        return contributors;
    }
}