<cfoutput query="guides">
    <div class="row">
        <div class="col-lg-3 col-12 p-3" style="background-color: rgba(6, 18, 31, 1);">
            <div class="accordion" id="guides#guides.tab#">
                <div class="accordion-item bg-transparent border-0">
                    <div class="accordion-header pe-2 text-white">
                        <button class="accordion-button fs-18 fw-bold shadow-none p-0 bg-transparent text-white"
                            type="button" data-bs-toggle="collapse" data-bs-target="##g-#guides.tab#"
                            aria-expanded="true" aria-controls="g-#guides.tab#">
                            #guides.tab#
                        </button>
                    </div>
                    <div id="g-#guides.tab#" class="accordion-collapse collapse show"
                        data-bs-parent="##guides#guides.tab#">
                        <div class="accordion-body space-y-3 pt-3 px-0">
                            <div class="accordion" id="guidesSub#guides.tab#">
                                <div class="accordion-item bg-transparent border-0">
                                    <div class="accordion-header rounded bg-white/10 ps-3 pe-2 py-2 text-white">
                                        <button
                                            class="accordion-button fs-14 fw-semibold shadow-none p-0 bg-transparent text-white"
                                            type="button" data-bs-toggle="collapse"
                                            data-bs-target="##g-#guides.tab#_title" aria-expanded="true"
                                            aria-controls="g-#guides.tab#_title">
                                            #guides.title#
                                        </button>
                                    </div>
                                    <div id="g-#guides.tab#_title" class="accordion-collapse collapse show" data-bs-parent="##guidesSub#guides.tab#">
                                        <div class="accordion-body ps-4">
                                            <div class="space-y-3">
                                                <p class="fs-14 fw-normal text-white">Running Local Develoment
                                                    Servers</p>
                                                <p class="fs-14 fw-normal text-white">Beginner Turtorial : Hello
                                                    World</p>
                                                <p class="fs-14 fw-normal text-white">Beginner Turtorial : Hello
                                                    Database</p>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="space-y-3 ps-3">
                                <p class="fs-14 fw-normal text-white">FrameWork and CFWheels</p>
                                <p class="fs-14 fw-normal text-white">Requirements</p>
                                <p class="fs-14 fw-normal text-white">Manual Installation</p>
                                <p class="fs-14 fw-normal text-white">Manual Installation</p>
                                <p class="fs-14 fw-normal text-white">Upgrading</p>
                                <p class="fs-14 fw-normal text-white">Screencasts</p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

        </div>
        <div class="col-lg-9 col-12">
            <div>
                <h1 class="fs-32 text--primary fw-bold">#guides.tab#</h1>
                <p class="fs-24 text-white pb-2 fw-semibold">#guides.title#</p>
                <p class="fs-24 text-white fw-medium">#guides.heading_2#</p>

                <div class="mt-3 space-y-3">
                    <p class="text--lightGray fs-18 fw-normal">
                        #guides.content#
                    </p>
                    
                </div>
            </div>
        </div>
    </div>
</cfoutput>