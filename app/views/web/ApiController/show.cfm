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

                <cfif structKeyExists(params, "format") AND params.format EQ "json">
                    <!--- JSON Format: Show function name and formatted JSON --->
                    <div class="d-flex align-items-center gap-2 mb-4">
                        <h1 class="text--primary fs-24 fw-bold">#meta.name#()</h1>
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

                    <div class="mt-4">
                        <div class="bg-light border rounded-18">
                            <div class="p-4 position-relative json-container">
                                <pre class="mb-0 json-pre"><code class="language-json">#encodeForHTML(prettyPrintJSON(meta))#</code></pre>
                                <div class="text-end">
                                    <i class="bi bi-copy text--primary fs-5 cursor-pointer" onclick="copyToClipboard(this)"></i>
                                    <span class="text-success fs-5 fw-bold d-none">Copied!</span>
                                </div>
                            </div>
                        </div>
                    </div>
                <cfelse>
                    <!--- Your existing HTML format code remains exactly the same --->
                    <div class="d-flex align-items-center gap-2">
                        <h1 class="text--primary fs-24 fw-bold">#meta.name#()</h1>
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

                    <div class="d-flex api-filter-buttons align-items-center my-3 gap-2 flex-wrap">
                        <cfif len(meta.tags.section)>
                            <button class="bg--lightGray text--secondary rounded-4 fs-12 fw-normal px-4 py-2">
                                <i class="bi bi-tags"></i>
                                #meta.tags.section#
                            </button>
                        </cfif>
                        <cfif len(meta.tags.category)>
                            <button class="bg--lightGray text--secondary rounded-4 fs-12 fw-normal px-4 py-2">
                                <i class="bi bi-tags"></i>
                                #meta.tags.category#
                            </button>
                        </cfif>
                        <cfif structKeyExists(meta, "returnType") && len(meta.returnType)>
                            <button class="bg--lightGray text--secondary rounded-4 fs-12 fw-normal px-4 py-2">
                                <i class="bi bi-arrow-return-left"></i>
                                #meta.returnType#
                            </button>
                        </cfif>
                        <cfif structKeyExists(meta, "availableIn") && arrayLen(meta.availableIn)>
                            <cfloop from="1" to="#arrayLen(meta.availableIn)#" index="a">
                                <button class="bg--lightGray text--secondary rounded-4 fs-12 fw-normal px-4 py-2">
                                    <i class="bi bi-lightning-charge-fill"></i>
                                    #meta.availableIn[a]#
                                </button>
                            </cfloop>
                        </cfif>
                    </div>

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
                                <cfloop from="1" to="#arraylen(meta.parameters)#" index="p">
                                    <cfset _param = meta.parameters[p]>
                                    <cfif !left(_param.name, 1) EQ "$">
                                        <tr class="<cfif _param.required EQ 'Yes'>table-light</cfif>">
                                            <td class="text-black p-lg-3 p-1 fs-14 fw-normal">#_param.name#</td>
                                            <td class="text-black p-lg-3 p-1 fs-14 fw-normal">#_param.type#</td>
                                            <td class="text-black p-lg-3 p-1 fs-14 fw-normal">#YesNoFormat(_param.required)#</td>
                                            <td class="text-black p-lg-3 p-1 fs-14 fw-normal max-w-200">
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

                    <cfif meta.extended.hasExtended>
                        <div style="background-color: rgba(243, 243, 243, 1);" class="p-4 rounded-18">
                            <div class="fs-14 fw-normal m-0 p-0">#meta.extended.docs#</div>
                            <div class="text-end">
                                <i class="bi bi-copy text--primary fs-5 cursor-pointer" onclick="copyToClipboard(this)"></i>
                                <span class="text-success fs-5 fw-bold d-none">Copied!</span>
                            </div>
                        </div>
                    </cfif>

                </cfif>
            </div>
        </cfoutput>
    </div>
</main>
<script src="/js/api.index.js"></script>