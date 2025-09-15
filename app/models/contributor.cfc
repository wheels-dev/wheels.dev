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

        // Last Name Property
        property(
            name="UserName", 
            column="user_name", 
            dataType="string", 
            label="User Name", 
            defaultValue=""
        );

        // Password Hash Property
        property(
            name="Description", 
            column="description", 
            dataType="text", 
            label="Description",
            defaultValue = ""
        );
        
        // Profile Picture Property
        property(
            name="Roles", 
            column="roles", 
            dataType="string", 
            label="Contributor Roles",
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