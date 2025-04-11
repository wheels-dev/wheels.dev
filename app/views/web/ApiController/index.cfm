<main class="main-bg">
    <div class="container py-5">
        <div class="row">
            <div class="col-lg-4 col-12">
                <cfoutput>#includePartial("partials/versions")#</cfoutput>
            </div>
            <div class="col-lg-4 mt-lg-0 mt-3 offset-lg-4 col-12">
                <div class="d-flex api flex-wrap align-items-center justify-content-end gap-3">
                    <button
                        onclick="handleApiSection('All', this)"
                        class="active px-4 filter-button fs-16 py-2 d-flex align-items-center gap-2 rounded-3 border--iris bg-transparent text--secondary">
                        A-Z Functions<small>(<span class="functioncount"><cfoutput>#arraylen(docs.functions)#</cfoutput></span>)</small>
                        <svg class="d-none" width="16" height="16" viewBox="0 0 16 16" fill="none" xmlns="http://www.w3.org/2000/svg">
                            <path
                                d="M8 0C3.592 0 0 3.592 0 8C0 12.408 3.592 16 8 16C12.408 16 16 12.408 16 8C16 3.592 12.408 0 8 0ZM11.768 6.96797L7.76799 10.968C7.60799 11.12 7.408 11.2 7.2 11.2C6.992 11.2 6.79201 11.12 6.63201 10.968L4.23201 8.56797C3.92001 8.25597 3.92001 7.74403 4.23201 7.43203C4.54401 7.12003 5.05599 7.12003 5.36799 7.43203L7.2 9.27207L10.632 5.83203C10.944 5.52003 11.456 5.52003 11.768 5.83203C12.08 6.14403 12.08 6.65597 11.768 6.96797Z"
                                fill="white" />
                        </svg>
                    </button>
                    <button
                        onclick="handleApiSection('Sections', this)"
                        class="px-4 filter-button fs-16 py-2 d-flex align-items-center gap-2 rounded-3 border--iris bg-transparent text--secondary">
                        Sections
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
        <hr class="my-4">

        <div class="row justify-content-center justify-content-lg-between">
            <div class="mt-lg-0 mt-3 col-lg-9 col-12" id="main">
                  <cfoutput>
                    <cfloop from="1" to="#arraylen(docsChunk)#" index="func">
                        #includePartial("partials/definition")#
                    </cfloop>
                    <div
                        hx-get="/api/#currentVersion#/functions" 
                        hx-vals='{"start": "#startIndex + 4#", "limit": "#limitCount#", "version": "#currentVersion#"}' 
                        hx-trigger="revealed" 
                        hx-swap="afterend"
                        class="load-more-trigger mt-3">
                    </div>
                </cfoutput> 
            </div>
            <div id="functionsContainer" class="col-lg-3 col-12 order-lg-0 order-first">
                <div class="bg-white p-3 rounded-18 no-scrollbar h-70vh overflow-y-auto">
                    <div class="space-y-2 px-2" id="functionlist"> 
                        <cfoutput>#includePartial("partials/functionlist")#</cfoutput>
                    </div>
                </div>
            </div>
            <div id="sectionContainer" class="col-lg-3 col-12 d-none order-lg-0 order-first">
                <div class="bg-white p-3 rounded-18 no-scrollbar h-70vh overflow-y-auto" id="sections">
                    <cfoutput>#includePartial("partials/sections")#</cfoutput>                   
                </div>
            </div>
        </div>
    </div>
    <div class="d-flex mb-5 justify-content-center">
        <div id="loader" style="display:none; width: 4rem; height: 4rem;" class="spinner-border text-danger" role="status">
            <span class="visually-hidden">Loading...</span>
        </div>
    </div>
</main>
<script src="/javascripts/jquery.min.js"></script>
<script src="/javascripts/api.index.js"></script>