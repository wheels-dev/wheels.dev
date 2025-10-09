<cfoutput>
    <cfloop from="1" to="#arraylen(docsChunk)#" index="func">
        <cfset meta = docsChunk[func]>
        <div id="#lcase(meta.name)#" class="p-3 functiondefinition <cfif func gt 1>mt-3</cfif> rounded-18 bg-white"
            data-section="#meta.tags.sectionClass#"
            data-category="#meta.tags.categoryClass#"
            data-function="#lcase(meta.slug)#">

             <div class="d-flex align-items-center gap-3">
                <h2 class="text--primary fs-24 fw-bold mb-0">#meta.name#()</h2>
                <div class="d-flex align-items-center gap-2">
                    <button 
                        class="permalinkBtn btn btn-outline-primary small-btn d-flex align-items-center justify-content-center rounded-pill px-3" 
                        data-bs-toggle="tooltip" 
                        data-bs-placement="bottom"
                        title="Copy Permalink"
                        data-link="/api/#params.version#/#meta.slug#.html"
                        data-bs-custom-class="small-tooltip">
                        <i class="fa fa-link me-1"></i> Permalink
                    </button>

                    <button 
                        class="jsonLinkBtn btn btn-outline-secondary small-btn d-flex align-items-center justify-content-center rounded-pill px-3" 
                        data-bs-toggle="tooltip" 
                        data-bs-placement="bottom"
                        title="Open JSON"
                        data-link="/api/#params.version#/#meta.slug#.json"
                        data-bs-custom-class="small-tooltip">
                        <i class="fa fa-code me-1"></i> JSON
                    </button>
                </div>
            </div>

            <div class="d-flex api-filter-buttons align-items-center my-3 gap-2 flex-wrap">
                <cfif len(meta.tags.section)>
                    <button class="filtersection bg--lightGray text--secondary rounded-4 fs-12 fw-normal px-4 py-2" hx-get="/api/#params.version#/functions/section"
                        hx-include="this"
                        hx-vals='{"section": "#meta.tags.sectionClass#"}'
                        hx-target="##main"
                        hx-swap="innerHTML">
                        <i class="bi bi-tags"></i> #meta.tags.section#
                    </button>
                </cfif>
                <cfif len(meta.tags.category)>
                    <button class="filtercategory bg--lightGray text--secondary rounded-4 fs-12 fw-normal px-4 py-2" hx-get="/api/#params.version#/functions/sectionCategory"
                        hx-include="this"
                        hx-vals='{"section": "#meta.tags.sectionClass#", "category": "#meta.tags.categoryClass#"}'
                        hx-target="##main"
                        hx-swap="innerHTML">
                        <i class="bi bi-tags"></i> #meta.tags.category#
                    </button>
                </cfif>
                <cfif structKeyExists(meta, "returnType") && len(meta.returnType)>
                    <button class="bg--lightGray text--secondary rounded-4 fs-12 fw-normal px-4 py-2">
                        <i class="bi bi-arrow-return-left"></i> #meta.returnType#
                    </button>
                </cfif>
                <cfif structKeyExists(meta, "availableIn") && arrayLen(meta.availableIn)>
                    <cfloop from="1" to="#arrayLen(meta.availableIn)#" index="a">
                        <button class="bg--lightGray text--secondary rounded-4 fs-12 fw-normal px-4 py-2">
                            <i class="bi bi-lightning-charge-fill"></i> #meta.availableIn[a]#
                        </button>
                    </cfloop>
                </cfif>
            </div>
            
            <p class="fs-14 fw-normal">#meta.hint#</p>
            
            <cfif isArray(meta.parameters) && arrayLen(meta.parameters)>
                <div class="mt-4 overflow-x-auto no-scrollbar">
                    <table class="table table-responsive">
                        <thead class="table--primary/10">
                            <tr>
                                <th class="important:text--primary px-lg-3 px-1 fs-14 fw-medium">Name</th>
                                <th class="important:text--primary px-lg-3 px-1 fs-14 fw-medium">Type</th>
                                <th class="important:text--primary px-lg-3 px-1 fs-14 fw-medium">Required</th>
                                <th class="important:text--primary px-lg-3 px-1 fs-14 fw-medium max-w-200">Default</th>
                                <th class="important:text--primary px-lg-3 px-1 fs-14 fw-medium">Description</th>
                            </tr>
                        </thead>
                        <tbody>
                            <cfloop from="1" to="#arrayLen(meta.parameters)#" index="p">
                                <cfset _param = meta.parameters[p]>
                                <cfif !left(_param.name, 1) EQ "$">
                                    <tr>
                                        <td class="text-black p-lg-3 p-1 fs-14 fw-normal">#_param.name#</td>
                                        <td class="text-black p-lg-3 p-1 fs-14 fw-normal">#_param.type#</td>
                                        <td class="text-black p-lg-3 p-1 fs-14 fw-normal">#YesNoFormat(_param.required)#</td>
                                        <td class="text-black p-lg-3 p-1 fs-14 fw-normal max-w-200">
                                            <cfif structKeyExists(application.wheels.functions, func) AND structKeyExists(application.wheels.functions[func], _param.name)>
                                                #application.wheels.functions[func][_param.name]#
                                            </cfif>
                                            <cfif structKeyExists(_param, "default")>#replace(_param.default, ",", ", ", "all")#</cfif>
                                        </td>
                                        <td class="text-black p-lg-3 p-1 fs-14 fw-normal">
                                            <cfif structKeyExists(_param, "hint")>#$backTickReplace(_param.hint)#</cfif>
                                        </td>
                                    </tr>
                                </cfif>
                            </cfloop>
                        </tbody>
                    </table>
                </div>
            </cfif>

            <cfif meta.extended.hasExtended>
                <div style="background-color: rgba(243, 243, 243, 1);"
                    class="p-4 rounded-18">
                    <div class="fs-14 fw-normal m-0 p-0">#meta.extended.docs#</div>
                    <div class="text-end">
                        <i class="bi bi-copy text--primary fs-5 cursor-pointer" onclick="copyToClipboard(this)"></i>
                        <span class="text-success fs-5 fw-bold d-none">Copied!</span>
                    </div>
                </div>
            </cfif>
        </div>
    </cfloop>
    <cfif arrayLen(docsChunk) GTE 5>
        <div 
            hx-get="/api/#params.version#/functions/sectionCategory" 
            hx-vals='{"start": "#startIndex + 4#", "limit": "5", "version": "#params.version#", "section": "#section#", "category": "#category#"}' 
            hx-trigger="revealed" 
            hx-swap="afterend"
            class="load-more-trigger mt-3">
        </div>
    </cfif>
</cfoutput>
