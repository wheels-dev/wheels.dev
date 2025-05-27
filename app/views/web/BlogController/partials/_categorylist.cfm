<cfscript>
    for (var i = 1; i <= categorylist.recordCount; i++) {
        hasBorder = i NEQ categorylist.recordCount ? " border-bottom" : "";
        writeOutput('<p class="fs-14 #hasBorder# category-item mb-0 py-2 cursor-pointer fw-normal text--secondary" 
            hx-get="/blog/list/category/#categorylist.name[i]#" 
            hx-trigger="click" 
            hx-target="##blogsContainer" 
            hx-swap="innerHTML"
            onclick="setActive(this)" 
            >' & categorylist.name[i] & '</p>');
    }
</cfscript>