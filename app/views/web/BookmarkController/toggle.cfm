<cfoutput>
<cfset response = data>
<cfif response.success>
    <cfif response.bookmarked>
        <span class="text-success fw-bold">★ Bookmarked</span>
    <cfelseif response.removed>
        <!-- Empty response - card will be removed from DOM -->
    <cfelse>
        <button hx-post="/bookmark/toggle" hx-vals='{"blogId": #params.blogId#}' hx-target="this" hx-swap="outerHTML"
                class="btn btn-outline-primary">
            ☆ Bookmark
        </button>
    </cfif>
<cfelse>
    <div class="alert alert-danger mb-2 fs-12" role="alert">
        <i class="fas fa-exclamation-circle me-2"></i>
        #response.message#
    </div>
</cfif>
</cfoutput>
