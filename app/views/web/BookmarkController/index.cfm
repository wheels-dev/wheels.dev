<cfoutput>
<div>
    <!-- Bookmarks Header -->
    <div class="w-100 h-300 h-sm-400 position-relative feature-blog">
        <div class="position-absolute mx-auto container start-0 end-0 bottom-50px">
            <h1 class="text-white fw-bold fs-36 pb-3 line-height-100">My Bookmarks</h1>
            <p class="text-white opacity-50 fs-18">Save and organize articles you've bookmarked for easy access.</p>
        </div>
    </div>
    <main class="main-bg">
        <div class="container">
            <!-- Tabs -->
            <div class="pt-5">
                <div class="row">
                    <div class="col-lg-6 col-12">
                    </div>
                    <div class="col-lg-6 mt-lg-0 mt-3 col-12">
                        <div class="d-flex align-items-center justify-content-lg-end justify-content-start gap-3 flex-wrap">
                            #linkTo(route = "readingHistory", class="bg--primary text-white text-center py-2 fs-16 rounded-3 px-4", text = "Recent")#
                        </div>
                    </div>
                </div>
            </div>

            <!-- Bookmarks List -->
            <div class="pt-4">
                <div id="bookmarksContainer">
                    <cfif bookmarks.recordCount>
                        <div class="row gy-3">
                            <cfloop query="bookmarks">
                                <div class="col-lg-4 col-md-6">
                                    <a href="/blog/#bookmarks.slug#" class="text-decoration-none">
                                        <div class="p-4 bg-white rounded-5 shadow-sm h-100 d-flex flex-column">
                                            <div class="flex-grow-1">
                                                <p class="fs-18 mb-3 text--secondary/70 fw-bold line-clamp-1">#bookmarks.title#</p>
                                                <div class="fs-16 mb-3 text--lightGray">
                                                    Bookmarked: #dateTimeFormat(bookmarks.createdAt, "mmm dd, yyyy")#
                                                </div>
                                            </div>
                                            <div class="d-flex gap-2 justify-content-end align-items-center">
                                                <button hx-post="/bookmark/toggle" hx-vals='{"blogId": #bookmarks.blogId#}' hx-target="closest .col-lg-4" hx-swap="outerHTML"
                                                        class="btn btn-outline-danger fs-16 rounded-2 px-3 py-1"
                                                        onclick="event.preventDefault(); event.stopPropagation();">
                                                    Remove
                                                </button>
                                            </div>
                                        </div>
                                    </a>
                                </div>
                            </cfloop>
                        </div>
                    <cfelse>
                        <p>No bookmarks yet. Bookmark articles to save them for later!</p>
                    </cfif>
                </div>
            </div>
        </div>
    </main>
</div>
</cfoutput>