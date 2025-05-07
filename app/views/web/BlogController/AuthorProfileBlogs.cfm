<cfoutput>
    <div class="m-5 p-5 bg-white rounded-5 shadow">
        <div class="bg--primary rounded-20 text-white text-center py-4">
            #imageTag(source='#author.profilePicture#', width="100", height="100", class="rounded-circle border border-white", alt="profile-picture")#
            <div class="text-white d-flex justify-content-center gap-4 mt-2 align-items-center">
                <div>
                    <h1 class="fs-24 fw-bold">#author.fullName# </h1>
                </div>
                <div class="fs-16 mb-1">
                    <span> <i class="bi bi-envelope-at-fill fs-16"></i> #author.email#</span>
                </div>
            </div>
        </div>
          
        <div class="container my-4">
            <div class="row text-center justify-content-around  mb-4">
                <div class="col-sm-3 card rounded-5 p-2"><strong>#blogs.recordCount#</strong>Blog Posts Published</div>
                <div class="col-sm-3 card rounded-5 p-2"><strong>#comments.recordCount#</strong>Comments Written</div>
            </div>
            <div class="row">
                <cfloop query="blogs">
                    <div class="col-6 my-2 p-1 d-flex flex-column overflow-hidden justify-content-between">
                        <div class="flex-grow-1 rounded-4 shadow-sm px-4 py-4 border d-flex justify-content-between flex-column">
                            <div class="d-flex align-items-center gap-2 mt-1">
                                <a href="javascript:void(0)" hx-trigger="click" hx-post="/blog/author-profile" hx-vals='{"author": "#blogs.createdby#"}' hx-target="body" hx-swap="innerHTML">
                                    #imageTag(source='#author.profilePicture#', style="width:2.5rem; height:2.5rem",
                                    class="bg-body-secondary rounded-5 flex-shrink-0", alt="profile-picture")#
                                </a>
                                <div>
                                    <p class="text--secondary fw-bold fs-14 m-0">#author.fullname#</p>
                                    <p class="text--lightGray fs-12 fw-medium" hx-trigger="click" hx-get="/blog/list/#DateFormat(blogs.postDate, "yyyy")#/#DateFormat(blogs.postDate, "mm")#" hx-target="##blogsContainer" hx-swap="innerHTML" style="cursor: pointer;">
                                        #dateformat(blogs.postDate, 'MMMM DD, YYYY')#
                                    </p>
                                </div>
                            </div>
                            <a href="/blog/#slug#">
                                <p class="fs-18 text-black fw-bold line-clamp-1 mt-2 ms-4">#blogs.title#</p>
                            </a>
                            <cfset totalComments = model("comment").count(where="authorId = '#blogs.createdBy#' AND blogId='#blogs.id#' AND isPublished='1'")>
                            <div class="mt-1 ms-1">
                                <span><i class="bi bi-chat-dots"></i></span><span class="ms-2">#totalComments# Comments</span>
                            </div>
                        </div>
                    </div>
                </cfloop>
            </div>
        </div>
    </div>
</cfoutput>