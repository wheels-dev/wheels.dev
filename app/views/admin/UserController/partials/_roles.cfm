<cfscript>
    writeOutput('<option value="">Select Role</option>');
    for (var i = 1; i <= roles.recordCount; i++) {
        var selected = (roles.id[i] == roleId) ? 'selected' : '';
        writeOutput('<option value="' & roles.id[i] & '" ' & selected & '>' & roles.name[i] & '</option>');
    }
</cfscript>