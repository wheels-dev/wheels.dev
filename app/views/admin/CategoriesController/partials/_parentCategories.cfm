<cfscript>
    writeOutput('<option value="">Select Category</option>');
    for (var i = 1; i <= categories.recordCount; i++) {
        var selected = (categories.id[i] == parentCategoryId) ? 'selected' : '';
        writeOutput('<option value="' & categories.id[i] & '" ' & selected & '>' & categories.name[i] & '</option>');
    }
</cfscript>