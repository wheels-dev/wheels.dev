<main class="main-bg">
    <div id="globalPageLoader" class="position-fixed top-0 start-0 w-100 h-100 d-flex align-items-center justify-content-center bg-white" style="z-index: 5;">
        <div class="spinner-border text--primary" role="status">
            <span class="visually-hidden">Loading...</span>
        </div>
    </div>
    <div>
        <cfoutput>#includePartial("partials/_searchModal")#</cfoutput>
    </div>
    <div <cfoutput>hx-get="/#params.version#/guides/search-book?format=json"</cfoutput> hx-trigger="load" hx-target="#searchIndexHolder" hx-swap="innerHTML"></div>
    <div id="searchIndexHolder" style="display: none;"></div>
    <div class="p-5">
        <div class="row">
            <div class="col-lg-3 col-12 mb-lg-0 mb-5 mt-3 mt-lg-0 order-lg-first order-last">
                <div class="bg-white p-3 rounded-18 position-sticky top-16 no-scrollbar h-80vh overflow-y-auto">
                    <div class="accordion space-y-3" id="guidesAccordion">
                        <cfoutput>#includePartial("partials/sidebar")#</cfoutput>
                    </div>
                </div>
            </div>

            <div class="col-lg-9 col-12 order-lg-last order-first">
                <div class="row">
                    <div class="col-lg-8">
                        <div class="search-trigger d-flex align-items-center gap-2 px-3 mb-3 py-2 border rounded-3 transition-all hover:border-primary cursor-pointer" id="searchTrigger">
                            <i class="bi bi-search text-muted"></i>
                            <span class="flex-grow-1 text-muted">Ask or search...</span>
                            <div class="shortcut-hint d-flex align-items-center gap-1">
                                <span class="key">Ctrl</span>
                                <span class="key">K</span>
                            </div>
                        </div>
                    </div>
                    <div class="col-lg-4">
                        <div class="select-version" id="select-version">
                            <select name="docs-version" id="docs-version" class="form-select px-3 mb-3 py-2 transition-all hover:border-primary cursor-pointer" aria-label="select-version">
                                <option <cfif params.version eq "3.0.0">selected </cfif> value="3.0.0">3.0.0</option>
                                <option <cfif params.version eq "2.5.0">selected </cfif> value="2.5.0">2.5.0</option>
                            </select>
                        </div>
                    </div>
                </div>
                <div id="main">
                    <cfoutput>
                        #includePartial("partials/docsContent")#
                    </cfoutput>
                </div>
            </div>
        </div>
    </div>
</main>
<script src="/js/guides.js"></script>