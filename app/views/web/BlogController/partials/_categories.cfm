<cfscript>
    writeOutput('<option value="">Select Category</option>');
    for (var i = 1; i <= categories.recordCount; i++) {
        writeOutput('<option value="' & categories.name[i] & '">' & categories.name[i] & '</option>');
    }
</cfscript>