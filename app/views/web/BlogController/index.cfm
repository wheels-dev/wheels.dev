<div>
    <!-- Blog filter -->
    <div class="w-100 h-300 h-sm-400 position-relative feature-blog">
        <div class="position-absolute mx-auto container start-0 end-0 bottom-50px">
            <p id="featureBlogHeading" class="text-white fs-18 pb-2">Featured</p>
            <h1 id="blogAuthorHeading" class="text-white fw-bold fs-36 pb-3 line-height-100 d-flex align-items-center flex-nowrap gap-2">Wheels The Fast & Fun CFML Framework!</h1>
            <p id="blogAuthorSubheading" class="text-white opacity-50 fs-18">Build apps quickly with an organized, Ruby on Rails-inspired
            structure. Get up and running in no time!</p>
        </div>
    </div>
    <main class="main-bg">
        <div class="container">
            <div class="pt-5">
                <div class="row">
                    <div class="col-lg-4 col-12">
                        <input id="blogSearchInput" placeholder="Search articles..." type="text" hx-get="/blog/Search?infiniteScroll=true" hx-trigger="keyup changed delay:500ms" hx-target="#blogsContainer" hx-swap="innerHTML" name="searchTerm" class="fs-14 flex-grow-1 form-control form-check-input-primary py-2 px-6 rounded-18" style="white-space:nowrap;overflow:hidden;text-overflow:ellipsis;width:100%;max-width:100%;">
                    </div>
                    <div class="col-lg-6 mt-lg-0 mt-3 offset-lg-2 col-12">
                        <div class="d-flex blogs align-items-center justify-content-lg-end justify-content-start gap-3 flex-wrap">

                            <cfif isEditor>
                                <cfoutput>
                                    <a href="#urlFor(route='blog-create')#"
                                        class="bg--primary text-white text-center d-none py-2 fs-16 rounded-3 col-4">Create New Article</a>
                                </cfoutput>
                            </cfif>

                            <button onclick="handleBlogFilter('All', this)" hx-swap="innerHTML"
                                hx-get="/blog/list" hx-push-url="/blog" hx-target="#blogsContainer"
                                class="active px-md-4 px-3 hover:bg--primary hover:text-white filter-button fs-16 py-2 d-flex align-items-center gap-2 rounded-3 border border--primary bg-transparent text--secondary">
                                All
                                <svg class="d-none" width="16" height="16" viewBox="0 0 16 16" fill="none"
                                    xmlns="http://www.w3.org/2000/svg">
                                    <path
                                        d="M8 0C3.592 0 0 3.592 0 8C0 12.408 3.592 16 8 16C12.408 16 16 12.408 16 8C16 3.592 12.408 0 8 0ZM11.768 6.96797L7.76799 10.968C7.60799 11.12 7.408 11.2 7.2 11.2C6.992 11.2 6.79201 11.12 6.63201 10.968L4.23201 8.56797C3.92001 8.25597 3.92001 7.74403 4.23201 7.43203C4.54401 7.12003 5.05599 7.12003 5.36799 7.43203L7.2 9.27207L10.632 5.83203C10.944 5.52003 11.456 5.52003 11.768 5.83203C12.08 6.14403 12.08 6.65597 11.768 6.96797Z"
                                        fill="white" />
                                </svg>
                            </button>
                            <button onclick="handleBlogFilter('Categories', this)"
                                class="px-md-4 px-3 hover:bg--primary hover:text-white filter-button fs-16 py-2 d-flex align-items-center gap-2 rounded-3 border border--primary bg-transparent text--secondary">
                                Categories
                                <svg class="d-none" width="16" height="16" viewBox="0 0 16 16" fill="none"
                                    xmlns="http://www.w3.org/2000/svg">
                                    <path
                                        d="M8 0C3.592 0 0 3.592 0 8C0 12.408 3.592 16 8 16C12.408 16 16 12.408 16 8C16 3.592 12.408 0 8 0ZM11.768 6.96797L7.76799 10.968C7.60799 11.12 7.408 11.2 7.2 11.2C6.992 11.2 6.79201 11.12 6.63201 10.968L4.23201 8.56797C3.92001 8.25597 3.92001 7.74403 4.23201 7.43203C4.54401 7.12003 5.05599 7.12003 5.36799 7.43203L7.2 9.27207L10.632 5.83203C10.944 5.52003 11.456 5.52003 11.768 5.83203C12.08 6.14403 12.08 6.65597 11.768 6.96797Z"
                                        fill="white" />
                                </svg>
                            </button>
                            <button onclick="handleBlogFilter('Archives', this)"
                                class="px-md-4 px-3 hover:bg--primary hover:text-white filter-button fs-16 py-2 d-flex align-items-center gap-2 rounded-3 border border--primary bg-transparent text--secondary">
                                Archives
                                <svg class="d-none" width="16" height="16" viewBox="0 0 16 16" fill="none"
                                    xmlns="http://www.w3.org/2000/svg">
                                    <path
                                        d="M8 0C3.592 0 0 3.592 0 8C0 12.408 3.592 16 8 16C12.408 16 16 12.408 16 8C16 3.592 12.408 0 8 0ZM11.768 6.96797L7.76799 10.968C7.60799 11.12 7.408 11.2 7.2 11.2C6.992 11.2 6.79201 11.12 6.63201 10.968L4.23201 8.56797C3.92001 8.25597 3.92001 7.74403 4.23201 7.43203C4.54401 7.12003 5.05599 7.12003 5.36799 7.43203L7.2 9.27207L10.632 5.83203C10.944 5.52003 11.456 5.52003 11.768 5.83203C12.08 6.14403 12.08 6.65597 11.768 6.96797Z"
                                        fill="white" />
                                </svg>
                            </button>
                        </div>
                    </div>
                </div>
            </div>
            <div class="pt-4">
                <div class="row justify-content-center justify-content-lg-between">
                    <cfoutput>
                        <!-- Detect if filtering via route (e.g. blog/year/month or blog/category/tag) -->
                        <cfif isDefined("params.filterType") and isDefined("params.filterValue")>
                            <cfset blogUrl="/blog/list/#params.filterType#/#params.filterValue#">
                            <cfelse>
                            <cfset blogUrl="/blog/list">
                        </cfif>
                        
                        <!-- wrapper that triggers the HTMX call -->
                        <div id="hxLoader" hx-get="#blogUrl#" hx-trigger="load" hx-target="##blogsContainer"
                            hx-swap="innerHTML" hx-indicator="##loader-wrapper">
                        </div>
                        <!-- blog list container -->
                        <div id="blogsContainer" class="col-lg-12 col-12 h-max">
                        </div>
                    </cfoutput>
                    <div id="filtersContainer" class="col-lg-2 order-lg-0 order-first col-12 p-lg-0 d-none">
                        <cfset startYear=2005>
                        <cfset startMonth=12>
                        <cfset currentYear=year(now())>
                        <cfset currentMonth=month(now())>
                        <cfset months=["January", "February" , "March" , "April" , "May" , "June" , "July" , "August" , "September" , "October" , "November" , "December" ]>

                        <div class="d-none bg-white mb-4 p-3 text-center rounded-18 no-scrollbar h-70vh overflow-y-auto" id="Archives">
                            <!-- Archives Button -->
                            <div class="accordion mb-4" id="archiveAccordion">
                                <cfoutput>
                                    <cfset isFirst = true>
                                    <cfloop index="year" from="#currentYear#" to="#startYear#" step="-1">
                                        <cfset monthLimit = (year EQ currentYear) ? currentMonth : 12>
                                        <cfset startLimit = (year EQ startYear) ? startMonth : 1>
                                        <cfset accordionId = "year#year#">
                                        
                                        <cfset showClass = isFirst ? "show" : "">
                                        <cfset collapsedClass = isFirst ? "" : "collapsed">
                                        <cfset ariaExpanded = isFirst ? "true" : "false">

                                        <div class="accordion-item bg-transparent border-0 mb-2">
                                            <h2 class="accordion-header section text-white" id="heading#accordionId#">
                                                <button class="accordion-button #collapsedClass# fs-14 fw-normal shadow-none bg--input p-2 rounded-3 text--secondary" type="button"
                                                    data-bs-toggle="collapse" data-bs-target="##collapse#accordionId#"
                                                    aria-expanded="#ariaExpanded#" aria-controls="collapse#accordionId#">
                                                    #year#
                                                </button>
                                            </h2>
                                            <div id="collapse#accordionId#" class="accordion-collapse collapse #showClass#" aria-labelledby="heading#accordionId#" data-bs-parent="##archiveAccordion">
                                                <div class="accordion-body px-4">
                                                    <cfloop index="month" from="#monthLimit#" to="#startLimit#" step="-1">
                                                        <cfset hasBorder = (month NEQ startLimit) ? " border-bottom" : "">
                                                        <p onclick="setActive(this)" hx-get="/blog/list/#year#/#NumberFormat(month, '00')#"
                                                        hx-target="##blogsContainer" hx-swap="innerHTML"
                                                        class="fs-14 py-2 cursor-pointer text--secondary #hasBorder# py-1 archive-item">
                                                            #months[month]# #year#
                                                        </p>
                                                    </cfloop>
                                                </div>
                                            </div>
                                        </div>

                                        <cfset isFirst = false> <!--- Only first item will be open --->
                                    </cfloop>
                                </cfoutput>
                            </div>
                        </div>
                        <div class="d-none bg-white mb-4 p-3 text-center rounded-18" id="Categories"
                            hx-get="/blog/Categories" hx-trigger="load" hx-target="#Categories"
                            hx-swap="innerHTML">
                        </div>
                    </div>
                    <div class="d-flex justify-content-center d-none" id="loader-wrapper">
                        <div style="width: 2rem; height: 2rem;" class="spinner-border my-5 text--primary" role="status">
                            <span class="visually-hidden">Loading...</span>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<script src="/js/blogs.js"></script>
