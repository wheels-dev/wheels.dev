<main class="main-bg">
    <div class="container py-5">
        <cfoutput>
            #linkTo(route="docVersion", class="py-2 px-3 bg-white shadow-sm rounded-3", version=params.version, encode="attributes", text="<i class='bi bi-arrow-left'></i> <span class='fs-14 text--secondary'>Back</span>")#
        </cfoutput>

        <cfoutput>
            <cfset meta=docFunction>
            <div class="p-3 mt-3 rounded-18 bg-white" id="#lcase(meta.name)#"
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
                            <li class="dropdown-item fs-14 cursor-pointer">#linkTo(route="docFunction", encode="attributes", version=params.version, slug=meta.slug, format="html", text="Permalink")#</li>
                            <li class="dropdown-item fs-14 cursor-pointer">#linkTo(route="docFunction", encode="attributes", version=params.version, slug=meta.slug, format="json", text="JSON")#</li>
                        </ul>
                    </div>
                </div>
                <div>
                    <div class="d-flex api-filter-buttons align-items-center my-3 gap-2 flex-wrap">
                        <cfif len(meta.tags.section)>
                            <button class="text--lightGray border d-flex align-items-center gap-2 rounded-4 fs-14 fw-normal px-3 py-2 bg-transparent">
                                <i class="bi bi-tags"></i>
                                #meta.tags.section#
                            </button>
                        </cfif>
                        <cfif len(meta.tags.category)>
                            <button class="text--lightGray border d-flex align-items-center gap-2 rounded-4 fs-14 fw-normal px-3 py-2 bg-transparent">
                                <i class="bi bi-tags"></i>
                                #meta.tags.category#
                            </button>
                        </cfif>
                        <cfif structKeyExists(meta, "returnType") && len(meta.returnType)>
                            <button class="text--lightGray border d-flex align-items-center gap-2 rounded-4 fs-14 fw-normal px-3 py-2 bg-transparent">
                                <i class="bi bi-arrow-return-left"></i>
                                #meta.returnType#
                            </button>
                        </cfif>
                        <cfif structKeyExists(meta, "availableIn") && arrayLen(meta.availableIn)>
                            <cfloop from="1" to="#arrayLen(meta.availableIn)#" index="a">
                                <button class="text--lightGray border d-flex align-items-center gap-2 rounded-4 fs-14 fw-normal px-3 py-2 bg-transparent">
                                    <i class="bi bi-bolt"></i>
                                    #meta.availableIn[a]#
                                </button>
                            </cfloop>
                        </cfif>
                    </div>
                </div>
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
                            <cfloop from="1" to="#arraylen(meta.parameters)#" index="p">
                                <cfset _param=meta.parameters[p]>
                                <cfif !left(_param.name, 1) EQ "$">
                                    <tr class="<cfif _param.required EQ 'Yes'>table-light</cfif>">
                                        <td class="text-black p-lg-3 p-1 fs-14 fw-normal">#_param.name#</td>
                                        <td class="text-black p-lg-3 p-1 fs-14 fw-normal">#_param.type#</td>
                                        <td class="text-black p-lg-3 p-1 fs-14 fw-normal">#YesNoFormat(_param.required)#</td>
                                        <td class="text-black p-lg-3 p-1 fs-14 fw-normal">
                                            <cfif structkeyExists(_param, "default")>#_param.default#</cfif>
                                        </td>
                                        <td class="text-black p-lg-3 p-1 fs-14 fw-normal">
                                            <cfif structkeyExists(_param, "hint")>#$backTickReplace(_param.hint)#</cfif>
                                        </td>
                                    </tr>
                                </cfif>
                            </cfloop>
                        </tbody>
                    </table>
                </div>
            </div>
        </cfoutput>
    </div>
</main>