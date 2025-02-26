<cfoutput>
    <div class="row">
        <div class="col-4 border-end">
            <!-- Vertical Tabs Navigation -->
            <div class="nav flex-column nav-pills-primary" id="v-pills-tab" role="tablist" aria-orientation="vertical">
                <cfloop query= "guides">
                    <cfset preview_guides_tab = guides.tab>
                    <cfset guides.tab = Replace(guides.tab, " ", "-", "all")>
                    <button 
                        <cfif guides.tab eq 'INTRODUCTION'>
                            class="nav-link fs-18 text-white fw-bold rounded-2 active"
                        <cfelse>
                            class="nav-link fs-18 mt-3 text-white fw-bold rounded-2"
                        </cfif>
                        id="v-pills-#guides.tab#-tab" data-bs-toggle="pill" data-bs-target="##v-pills-#guides.tab#" type="button" role="tab"
                        aria-controls="v-pills-#guides.tab#" aria-selected="true">
                            #preview_guides_tab#
                    </button>
                </cfloop>
            </div>
        </div>
        <div class="col-8">
            <!-- Vertical Tabs Content -->
            <div class="tab-content" id="v-pills-tabContent">
                <cfloop query= "guides">
                <div 
                    <cfif guides.tab eq 'INTRODUCTION'>
                        class="tab-pane fade show active"
                    <cfelse>
                        class="tab-pane fade"
                    </cfif>
                    id="v-pills-#guides.tab#" role="tabpanel"
                    aria-labelledby="v-pills-#guides.tab#-tab">
                    <h3 class="fs-24 text--primary fw-semibold">#guides.title#</h3>
                    <p class="text-white fs-22">#guides.heading_2#</p>
                    <p class="fs-18 text-white">
                        #guides.content#
                    </p>
                    <div class="d-flex justify-content-end">
                        <button class="bg--primary fs-16 fw-semibold px-3 py-1 rounded text-white">Learn
                            more</button>
                    </div>
                </div>
                </cfloop>
            </div>
        </div>
    </div>
</cfoutput>
