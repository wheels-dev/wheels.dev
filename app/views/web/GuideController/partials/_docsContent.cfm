<cfoutput>
    <div class="row p-3 rounded-18 bg-white scrollbar-overlay">
        <div class="docs-content col-lg-9">
            <div id="breadcrumb-nav" class="mb-2 text-uppercase fw-semibold small"></div>
            <div class="guides-docs-content">
                #renderedContent#
            </div>
        </div>
        <div class="right-sidebar d-none d-lg-block position-sticky fs-14 top-16 min-h-200 overflow-auto max-h-80vh col-lg-3 border-left">           
            <div>
                <ul class="toc-list list-unstyled">
                    <cfset firstActiveSet = false>
                    <cfloop array="#toc#" index="item">
                        <cfif NOT findNoCase("description", item.title)>
                            <cfset isActive = (!firstActiveSet)>
                            <cfset firstActiveSet = true>
                    
                            <li class="toc-item ps-#evaluate(item.level eq 3 ? '3' : '1')#">
                                <a href="###item.id#" data-id="#item.id#" class="toc-link font-montserrat py-2 d-block text-muted<cfif isActive> active</cfif>">
                                    #item.title#
                                </a>
                            </li>
                        </cfif>
                    </cfloop>                        
                </ul>
            </div>
        </div>
    </div>
</cfoutput>