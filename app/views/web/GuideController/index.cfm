<main class="main-bg">
    <div class="modal fade" id="searchModal" tabindex="-1" aria-labelledby="searchModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="search-modal-header mt-2">
                    <div class="d-flex align-items-center rounded-3 mx-2 px-2 py-2 border gap-2 transition-all hover:border-primary">
                        <i class="bi bi-search"></i>
                        <input type="text" class="fs-14 flex-grow-1 outline-none bg-transparent input-autofill" hx-get="/search/guidesDocs" hx-trigger="keyup changed delay:900ms" hx-target=".modal-body" hx-swap="innerHTML" id="searchDocs" placeholder="Search content or ask a question." aria-label="searchDocs">
                    </div>
                </div>
                <div class="modal-body">
                    
                </div>
            </div>
        </div>
    </div>
    <div class="container py-5">
        <div class="row">
            <div class="col-lg-3 col-12 mb-lg-0 mb-5 order-lg-first order-last">
                <div class="bg-white p-3 rounded-18 no-scrollbar h-70vh overflow-y-auto">
                    <div class="search-trigger d-flex align-items-center gap-2 px-3 mb-3 py-2 border rounded-3 transition-all hover:border-primary cursor-pointer" id="searchTrigger">
                        <i class="bi bi-search text-muted"></i>
                        <span class="flex-grow-1 text-muted">Ask or search...</span>
                        <div class="shortcut-hint d-flex align-items-center gap-1">
                            <span class="key">Ctrl</span>
                            <span class="key">K</span>
                        </div>
                    </div>
                    <div class="accordion space-y-3" id="guidesAccordion">
                        <cfoutput>#includePartial("partials/sidebar")#</cfoutput>
                    </div>
                </div>
            </div>

            <div class="col-lg-9 col-12 order-lg-last order-first">
                <div id="main">
                    <cfoutput>
                        #includePartial("partials/docsContent")#
                    </cfoutput>
                </div>
                <div class="d-flex py-2 justify-content-center">
                    <div id="loader" style="display:none; width: 2rem; height: 2rem;" class="spinner-border text--primary" role="status">
                        <span class="visually-hidden">Loading...</span>
                    </div>
                </div>
            </div>
        </div>
    </div>
</main>
<script src="/js/guides.js"></script>