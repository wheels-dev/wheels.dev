<cfoutput>
<div>
    <!-- Reading History Header -->
    <div class="w-100 h-300 h-sm-400 position-relative feature-blog">
        <div class="position-absolute mx-auto container start-0 end-0 bottom-50px">
            <h1 class="text-white fw-bold fs-36 pb-3 line-height-100">My Reading History</h1>
            <p class="text-white opacity-50 fs-18">Track your reading progress and continue where you left off.</p>
        </div>
    </div>
    <main class="main-bg">
        <div class="container">
            <!-- Tabs -->
            <div class="pt-5">
                <div class="row">
                    <div class="col-lg-4 col-12">
                        <input id="historySearchInput" placeholder="Search reading history..." type="text" hx-get="/reading-history/search?infiniteScroll=true" hx-trigger="keyup changed delay:500ms" hx-target="##historiesContainer" hx-swap="innerHTML" name="searchTerm" class="fs-14 flex-grow-1 form-control form-check-input-primary py-2 px-6 rounded-18" style="white-space:nowrap;overflow:hidden;text-overflow:ellipsis;width:100%;max-width:100%;">
                    </div>
                    <div class="col-lg-8 mt-lg-0 mt-3 col-12">
                        <div class="d-flex align-items-center justify-content-lg-end justify-content-start gap-3 flex-wrap">
                            <button onclick="handleHistoryFilter('All', this)" hx-swap="innerHTML"
                                hx-get="/reading-history/list" hx-push-url="/reading-history" hx-target="##historiesContainer"
                                class="active px-md-4 px-3 hover:bg--primary hover:text-white filter-button fs-16 py-2 d-flex align-items-center gap-2 rounded-3 border border--primary bg-transparent text--secondary">
                                All
                            </button>
                            <button onclick="handleHistoryFilter('Completed', this)"
                                class="px-md-4 px-3 hover:bg--primary hover:text-white filter-button fs-16 py-2 d-flex align-items-center gap-2 rounded-3 border border--primary bg-transparent text--secondary">
                                Completed
                            </button>
                            <button onclick="handleHistoryFilter('In Progress', this)"
                                class="px-md-4 px-3 hover:bg--primary hover:text-white filter-button fs-16 py-2 d-flex align-items-center gap-2 rounded-3 border border--primary bg-transparent text--secondary">
                                In Progress
                            </button>
                            #linkTo(route = "bookmarks", class="bg--primary text-white text-center py-2 fs-16 rounded-3 px-4", text = "Bookmarks")#
                        </div>
                    </div>
                </div>
            </div>

            <!-- Reading History List -->
            <div class="pt-4">
                <div id="historiesContainer">
                    <cfif histories.recordCount>
                        <div class="row gy-3">
                            <cfloop query="histories">
                                <div class="col-lg-4 col-md-6">
                                    <div class="p-4 bg-white rounded-5 shadow-sm">
                                        <div>
                                            <p class="fs-18 mb-3 text--secondary/70 fw-bold line-clamp-1">#histories.title#</p>
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
                                            <a href="/blog/#histories.slug#"><button class="bg--primary text-nowrap fs-16 text-white rounded-2 px-3 py-1">Continue Reading</button></a>
                                        </div>
                                    </div>
                                </div>
                            </cfloop>
                        </div>
                    <cfelse>
                        <p>No reading history yet. Start reading articles!</p>
                    </cfif>
                </div>
            </div>

            <!-- Clear History -->
            <form method="post" action="#urlFor(route='clearHistory')#" class="mt-4"
                  onsubmit="return confirm('Clear all reading history?')">
                <input type="hidden" name="_method" value="delete">
                <button type="submit" class="btn btn-sm btn-outline-danger">Clear History</button>
            </form>
        </div>
    </main>
</div>
<script>
function handleHistoryFilter(status, button) {
    // Remove active class from all buttons
    document.querySelectorAll('.filter-button').forEach(btn => {
        btn.classList.remove('active');
        btn.classList.remove('bg--primary');
        btn.classList.remove('text-white');
        btn.classList.add('bg-transparent');
        btn.classList.add('text--secondary');
    });

    // Add active class to clicked button
    button.classList.add('active');
    button.classList.add('bg--primary');
    button.classList.add('text-white');
    button.classList.remove('bg-transparent');
    button.classList.remove('text--secondary');
}
</script>
</cfoutput>