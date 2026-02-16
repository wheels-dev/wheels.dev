component extends="app.Controllers.Controller" {

    function config() {
        super.config();
        verifies(except="index,add,store,edit,delete,loadRoles,checkAdminAccess,checkRoleExistance", params="key", paramsTypes="integer");

        usesLayout(template="/admin/AdminController/layout");
        filters(through="checkAdminAccess");
    }

    function index(){
        roles = model("role").getAllRoles();
    }

    function add(){
        param name="id" default=0;
        role;
        if(id > 0) {
            role = model("role").findByKey(params.id);
            permissions = model("permission").findAll();
            activePermission = model("RolePermission").findAll(select="permissionId", where="roleId = #val(params.id)#");
            existingPermissionIds = [];
            for (row in activePermission) {
                arrayAppend(existingPermissionIds, row.permissionId);
            }
        }else {
            role = model("role");
            existingPermissionIds = [];
            permissions = model("permission").findAll();
        }
        return role;
    }

    function checkRoleExistance(){
        var checkExistingRole = model("Role").findAll(where="name = '#params.Name#'");
        if(checkExistingRole.recordcount != 0){
            renderText('<p class="fs-12 ms-2">A role already exist with this name! Role name must be unique.');
            return;
        }
        renderText("");
        return;
    }

    function store(){
        try {
            var checkExistingRole = model("Role").findAll(where="name = '#params.Name#'");
            if(checkExistingRole.recordcount != 0 && params.id == 0){
                redirectTo(action="index", error="A role already exist with name' #params.Name#'. Role name must be unique.");
                return;
            }

            var message = saveRole(params);

            redirectTo(action="index", success="#message#");
            return;
        } catch (any e) {
            // Handle error
            cfheader(statusCode=500);
            return;
        }
    }

    function delete() {
        try {
            role = model("role").findByKey(params.id);
            role.delete();
            renderText('');
            return;
        } catch (any e) {
            // Handle error
            cfheader(statusCode=500);
            return;
        }
    }
    private function saveRole(RoleData){
        try{
            if (RoleData.id > 0) {
                var Role = model("Role").findByKey(RoleData.id);
                if (isObject(Role)) {
                    // Edit the existing Role post
                    Role.name = RoleData.Name;
                    Role.description = RoleData.description;
                    Role.status = RoleData.status;
                    Role.save();

                    // Update role permissions
                    permissionList = [];
                    model("RolePermission").deleteAll(where="roleId = #val(RoleData.id)#");
                    for (fieldName in RoleData) {
                        if (left(fieldName, 11) == "permission-") {
                            // Extract the numeric part after the dash
                            permissionId = listLast(fieldName, "-");
                            arrayAppend(permissionList, permissionId);
                        }
                    }
                    for (permId in permissionList) {
                        model("RolePermission").create(
                            roleId = RoleData.id,
                            permissionId = permId
                        );
                    }

                    message = "Role updated successfully.";
                } else {
                    message = "Role not found for editing.";
                }
            } else {
                    permissionList = [];

                    var newRole = model("Role").new();
                    newRole.name = RoleData.Name;
                    newRole.description = RoleData.description;
                    newRole.status = RoleData.status;
                    newRole.save(reload=true);
        
                    roleId = newRole.id;
                    for (fieldName in RoleData) {
                        if (left(fieldName, 11) == "permission-") {
                            // Extract the numeric part after the dash
                            permissionId = listLast(fieldName, "-");
                            arrayAppend(permissionList, permissionId);
                        }
                    }
                    for (permId in permissionList) {
                        model("RolePermission").create(
                            roleId = roleId,
                            permissionId = permId
                        );
                    }
                    message = "Role created successfully.";
            }
            
        }catch (any e) {
            // Handle error
            message = "Error: something went wrong!";
        }
        return message;
    }
}
