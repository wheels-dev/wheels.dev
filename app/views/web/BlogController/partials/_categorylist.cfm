<cfscript>
    for (var i = 1; i <= categorylist.recordCount; i++) {
        writeOutput('<p class="fs-14 border-bottom mb-0 py-2 cursor-pointer fw-normal text--iris">' & categorylist.name[i] & '</p>');
    }
</cfscript>