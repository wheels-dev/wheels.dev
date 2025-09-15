component extends="app.Models.Model" {
    function config() {
        table("contributor_roles");

        // ID Property
        property(
            name="id", 
            column="id", 
            dataType="integer", 
            automaticValidations=false
        );
        
        // Profile Picture Property
        property(
            name="RoleName", 
            column="role_name", 
            dataType="string", 
            label="Role Name",
            defaultValue= ""
        );
    }
}