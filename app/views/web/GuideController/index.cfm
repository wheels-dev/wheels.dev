<main class="main-bg">
    <div class="container py-5">
        <div class="row">
            <div class="col-lg-3 col-12 mb-lg-0 mb-5 order-lg-first order-last">
                <div class="bg-white p-3 rounded-18 no-scrollbar h-70vh overflow-y-auto">
                    <div class="accordion space-y-3" id="guidesAccordion">
                        <cfoutput>#includePartial("partials/sidebar")#</cfoutput>
                    </div>
                </div>
            </div>

            <div class="col-lg-9 col-12 order-lg-last order-first">
                <div class="mt-3" id="main">
                    <div class="p-3 rounded-18 bg-white">
                        <cfoutput>
                            #renderedContent#
                        </cfoutput> 
                    </div>
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