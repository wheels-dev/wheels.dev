<cfscript>
    for (var i = 1; i <= categories.recordCount; i++) {
        writeOutput('<option value="' & categories.id[i] & '">' & categories.name[i] & '</option>');
    }
</cfscript>