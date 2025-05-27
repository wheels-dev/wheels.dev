<cfoutput>
    <cfif isFallback>
        <cfif isFallback>
            <div class="row mb-3">
                <div class="col-12">
                    <p class="fs-16 ms-2 fw-medium">Oops! looks like there's nothing here yet.</p>
                    <p class="fs-22 ms-2 mb-3 mt-3 fw-medium">Relative Posts</p>
                </div>
            </div>
        </cfif>
    </cfif>
    <div class="row mt-lg-0 mt-3 row-cols-lg-3 row-cols-1">
        <cfloop query="blogs">
            <cfset authorUrl = "/blog/author/#blogs.username#">
            <cfset blogUrl = "/blog/#blogs.slug#">
            <cfset authorHxGet = "/blog/list/author/#blogs.createdby#?page=1&perPage=6&infiniteScroll=true">
            <cfset formattedDate = dateformat(blogs.postDate, 'MMMM DD, YYYY')>
            <cfset profileImageTag = imageTag(
                source=blogs.profilePicture ?: '/default-avatar.png',
                style="width:2.5rem; height:2.5rem",
                class="bg-body-secondary rounded-5 flex-shrink-0",
                alt="Profile picture of #blogs.fullName#"
            )>
            
            <article class="pb-4 blog-item" data-blog-id="#blogs.id#">
                <div class="d-flex flex-column rounded-bottom-4 shadow-sm bg-white px-0 overflow-hidden justify-content-between">
                    
                    <!--- Blog Header Image with Title Overlay --->
                    <header class="blog-header">
                        <a href="#blogUrl#" class="text-decoration-none" aria-label="Read blog post: #htmlEditFormat(blogs.title)#">
                            <div class="default-blog rounded-top-4 position-relative">
                                <h2 class="blog-title-overlay h5 mb-0">#htmlEditFormat(blogs.title)#</h2>
                            </div>
                        </a>
                    </header>
                    
                    <!--- Blog Content --->
                    <div class="p-3 flex-grow-1 d-flex justify-content-between flex-column">
                        <div class="blog-content">
                            <a href="#blogUrl#" class="text-decoration-none">
                                <h3 class="fs-18 text-black fw-bold line-clamp-1 mb-0">#htmlEditFormat(blogs.title)#</h3>
                            </a>
                        </div>
                        
                        <!--- Author Information --->
                        <footer class="blog-meta d-flex align-items-center gap-2 mt-3">
                            <!--- Author Avatar --->
                            <button type="button" 
                                class="author-filter-btn border-0 bg-transparent p-0" 
                                hx-get="#authorHxGet#"
                                hx-target="##blogsContainer" 
                                hx-push-url="#authorUrl#"
                                hx-swap="innerHTML" 
                                hx-indicator="##loader-wrapper"
                                data-author-id="#blogs.createdby#" 
                                data-author-name="#htmlEditFormat(blogs.fullName)#"
                                aria-label="View posts by #htmlEditFormat(blogs.fullName)#">
                                #profileImageTag#
                            </button>
                            
                            <!--- Author Details --->
                            <div class="author-details">
                                <button type="button"
                                    class="author-filter-btn border-0 bg-transparent p-0 text-start"
                                    hx-get="#authorHxGet#"
                                    hx-target="##blogsContainer" 
                                    hx-push-url="#authorUrl#"
                                    hx-swap="innerHTML" 
                                    hx-indicator="##loader-wrapper"
                                    data-author-id="#blogs.createdby#" 
                                    data-author-name="#htmlEditFormat(blogs.fullName)#"
                                    aria-label="View posts by #htmlEditFormat(blogs.fullName)#">
                                    <p class="text--secondary fw-bold fs-14 m-0 author-name">
                                        #htmlEditFormat(blogs.fullName)#
                                    </p>
                                    <time class="text--lightGray fs-12 fw-medium" datetime="#dateformat(blogs.postDate, 'yyyy-mm-dd')#">
                                        #formattedDate#
                                    </time>
                                </button>
                            </div>
                        </footer>
                    </div>
                </div>
            </article>
            
            <!--- Author Info (only render once if needed) --->
            <cfif isDefined('author') AND blogs.currentRow EQ 1>
                <div id="blogAuthorInfo" style="display:none;"
                    data-author-id="#blogs.createdby#"
                    data-page="#page#"
                    data-author-name="#htmlEditFormat(blogs.fullName)#"
                    data-total-comments="#author.totalcomments#"
                    data-total-posts="#author.totalposts#"
                    data-profile-picture="#htmlEditFormat(imageTag(source=blogs.profilePicture ?: '/default-avatar.png', width='40', height='40', class='rounded-circle', alt=htmlEditFormat(blogs.fullName)))#">
                </div>
            </cfif>
        </cfloop>
    </div>
    
    <!--- Infinite Scroll Trigger --->
    <cfif isDefined("params.filterType") AND isDefined("params.filterValue")>
        <cfset encodedFilterType = params.filterType>
        <cfset encodedFilterValue = params.filterValue>
        <cfset blogUrl = "/blog/list/#encodedFilterType#/#encodedFilterValue#">
    <cfelse>
        <cfset blogUrl = "/blog/list">
    </cfif>

    <cfif isDefined('hasMore') AND hasMore>
        <div id="infiniteScrollTrigger"
            class="infinite-scroll-trigger w-100"
            data-page="#page#"
            hx-get="#blogUrl#?page=#page + 1#&perPage=#perPage#&infiniteScroll=true"
            hx-trigger="revealed"
            hx-target="##blogsContainer"
            hx-swap="beforeend"
            hx-indicator="##loader-wrapper"
            style="height: 1px;"
            aria-hidden="true">
            <span class="visually-hidden">Loading more posts...</span>
        </div>
    </cfif>
</cfoutput>