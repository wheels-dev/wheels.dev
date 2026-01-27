<cfoutput>
<cfif bookmarks.recordCount>
    <div class="row gy-3">
        <cfloop query="bookmarks">
            <div class="col-lg-4 col-md-6">
                <div class="p-4 bg-white rounded-5 shadow-sm">
                    <div>
                        <p class="fs-18 mb-3 text--secondary/70 fw-bold line-clamp-1">#bookmarks.Blog.title#</p>
                        <div class="fs-16 mb-3 text--lightGray">
                            Bookmarked: #dateTimeFormat(bookmarks.createdAt, "mmm dd, yyyy")#
                        </div>
                    </div>
                    <div class="d-flex gap-2 justify-content-end align-items-center">
                        <button hx-post="/bookmark/toggle" hx-vals='{"blogId": #bookmarks.blogId#}' hx-target="this" hx-swap="outerHTML"
                                class="bg--danger text-white fs-16 rounded-2 px-3 py-1">
                            Remove
                        </button>
                    </div>
                </div>
            </div>
        </cfloop>
    </div>
<cfelse>
    <p>No bookmarks yet. Bookmark articles to save them for later!</p>
</cfif>
</cfoutput>