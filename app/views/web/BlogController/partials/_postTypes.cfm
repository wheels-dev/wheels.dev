<cfscript>
    writeOutput('<option value="">Select Post Type</option>');
    for (var i = 1; i <= postTypes.recordCount; i++) {
        writeOutput('<option value="' & postTypes.id[i] & '">' & postTypes.name[i] & '</option>');
    }
</cfscript>