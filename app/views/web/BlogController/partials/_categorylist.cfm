<cfscript>
        for (var i = 1; i <= categorylist.recordCount; i++) {
        writeOutput('<p class="fs-14 border-bottom mb-0 py-2 cursor-pointer fw-normal text--primary" 
            hx-get="/blog/list/category/#categorylist.name[i]#" 
            hx-trigger="click" 
            hx-target="##blogsContainer" 
            hx-swap="innerHTML" 
            >' & categorylist.name[i] & '</p>');
    }
</cfscript>