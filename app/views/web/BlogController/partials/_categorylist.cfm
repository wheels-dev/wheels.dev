<cfscript>
        for (var i = 1; i <= categorylist.recordCount; i++) {
        writeOutput('<p class="fs-14 border-bottom mb-0 py-2 cursor-pointer fw-normal text--iris" 
            hx-get="/blog/list" 
            hx-trigger="click" 
            hx-target="##blogsContainer" 
            hx-swap="innerHTML" 
            hx-vals=''{"category_id": "#categorylist.id[i]#"}''>' & categorylist.name[i] & '</p>');
    }
</cfscript>