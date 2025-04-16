<cfoutput>
    <cfloop from="1" to="#arraylen(docsChunk)#" index="func">
        <cfset meta = docsChunk[func]>
        <div id="#lcase(meta.name)#" class="p-3 functiondefinition <cfif func gt 1>mt-3</cfif> rounded-18 bg-white"
            data-section="#meta.tags.sectionClass#"
            data-category="#meta.tags.categoryClass#"
            data-function="#lcase(meta.slug)#">

            <div class="d-flex align-items-center gap-2">
                <h1 class="text--primary fs-24 fw-bold">#meta.name#()</h1>
                <div class="dropdown">
                    <button class="dropdown-toggle outline-none border-0 no-dropdown-arrow text-center bg-transparent"
                        type="button" data-bs-toggle="dropdown" aria-expanded="false">
                        <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5"
                            stroke="currentColor" width="25" height="25" class="text--lightGray">
                            <path stroke-linecap="round" stroke-linejoin="round" d="m19.5 8.25-7.5 7.5-7.5-7.5" />
                        </svg>
                    </button>
                    <ul class="dropdown-menu">
                        <li class="dropdown-item fs-14 cursor-pointer">#linkTo(route="docFunction", version=params.version, slug=meta.slug, format="html", text="Permalink")#</li>
                        <li class="dropdown-item fs-14 cursor-pointer">#linkTo(route="docFunction", version=params.version, slug=meta.slug, format="json", text="JSON")#</li>
                    </ul>
                </div>
            </div>

            <div class="d-flex api-filter-buttons align-items-center my-3 gap-2 flex-wrap">
                <cfif len(meta.tags.section)>
                    <button class="filtersection btn btn-light text--lightGray border rounded-4 fs-14 fw-normal px-3 py-2 " hx-get="/api/#params.version#/functions/section"
                        hx-include="this"
                        hx-vals='{"section": "#meta.tags.sectionClass#"}'
                        hx-target="##main"
                        hx-swap="innerHTML">
                        <i class="bi bi-tags"></i> #meta.tags.section#
                    </button>
                </cfif>
                <cfif len(meta.tags.category)>
                    <button class="filtercategory btn btn-light text--lightGray border rounded-4 fs-14 fw-normal px-3 py-2 " hx-get="/api/#params.version#/functions/sectionCategory"
                        hx-include="this"
                        hx-vals='{"section": "#meta.tags.sectionClass#", "category": "#meta.tags.categoryClass#"}'
                        hx-target="##main"
                        hx-swap="innerHTML">
                        <i class="bi bi-tags"></i> #meta.tags.category#
                    </button>
                </cfif>
                <cfif structKeyExists(meta, "returnType") && len(meta.returnType)>
                    <button class=" btn btn-light text--lightGray border rounded-4 fs-14 fw-normal px-3 py-2 ">
                        <i class="bi bi-arrow-return-left"></i> #meta.returnType#
                    </button>
                </cfif>
                <cfif structKeyExists(meta, "availableIn") && arrayLen(meta.availableIn)>
                    <cfloop from="1" to="#arrayLen(meta.availableIn)#" index="a">
                        <button class=" btn btn-light text--lightGray border rounded-4 fs-14 fw-normal px-3 py-2 ">
                            <i class="bi bi-lightning-charge-fill"></i> #meta.availableIn[a]#
                        </button>
                    </cfloop>
                </cfif>
            </div>
            
            <p class="fs-14 fw-normal">#meta.hint#</p>
            
            <cfif isArray(meta.parameters) && arrayLen(meta.parameters)>
                <div class="mt-4 overflow-x-auto no-scrollbar">
                    <table class="table table-responsive">
                        <thead class="table--primary">
                            <tr>
                                <th class="text-white px-lg-3 px-1 fs-14 fw-semibold">Name</th>
                                <th class="text-white px-lg-3 px-1 fs-14 fw-semibold">Type</th>
                                <th class="text-white px-lg-3 px-1 fs-14 fw-semibold">Required</th>
                                <th class="text-white px-lg-3 px-1 fs-14 fw-semibold">Default</th>
                                <th class="text-white px-lg-3 px-1 fs-14 fw-semibold">Description</th>
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
                                        <td class="text-black p-lg-3 p-1 fs-14 fw-normal">
                                            <cfif structKeyExists(application.wheels.functions, func) AND structKeyExists(application.wheels.functions[func], _param.name)>
                                                #application.wheels.functions[func][_param.name]#
                                            </cfif>
                                            <cfif structKeyExists(_param, "default")>#_param.default#</cfif>
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
                <div style="background-color: rgba(243, 243, 243, 1); border: 2px rgba(179, 179, 179, 0.6) solid;"
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
