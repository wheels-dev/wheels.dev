<cfscript>
    writeOutput('<option value="">Select Status</option>');
    for (var i = 1; i <= statuses.recordCount; i++) {
        writeOutput('<option value="' & statuses.id[i] & '">' & statuses.name[i] & '</option>');
    }
</cfscript>