<cfscript>
    writeOutput('<option value="">Select Role</option>');
    for (var i = 1; i <= roles.recordCount; i++) {
        writeOutput('<option value="' & roles.id[i] & '">' & roles.name[i] & '</option>');
    }
</cfscript>