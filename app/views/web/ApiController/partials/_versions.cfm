<cfscript>
    writeOutput('<option value="">Select Version</option>');
    for (var i = 1; i <= versions.recordCount; i++) {
        writeOutput('<option value="' & versions.id[i] & '">' & versions.name[i] & '</option>');
    }
</cfscript>