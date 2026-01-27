<cfoutput>
<cfif histories.recordCount>
    <div class="row gy-3">
        <cfloop query="histories">
            <div class="col-lg-4 col-md-6">
                <div class="p-4 bg-white rounded-5 shadow-sm">
                    <div>
                        <p class="fs-18 mb-3 text--secondary/70 fw-bold line-clamp-1">#histories.Blog.title#</p>
                        <div class="fs-16 mb-3 text--lightGray">
                            Last read: #dateTimeFormat(histories.lastReadAt, "mmm dd, yyyy")#
                        </div>
                    </div>
                    <div class="d-flex gap-2 justify-content-between align-items-center">
                        <cfif histories.isCompleted>
                            <span class="badge bg-success">✓ Completed</span>
                        <cfelse>
                            <span class="badge bg-warning">In Progress</span>
                        </cfif>
                        <a href="/blog/#histories.Blog.slug#"><button class="bg--primary text-nowrap fs-16 text-white rounded-2 px-3 py-1">Continue Reading</button></a>
                    </div>
                </div>
            </div>
        </cfloop>
    </div>
<cfelse>
    <p>No reading history yet. Start reading articles!</p>
</cfif>
</cfoutput>