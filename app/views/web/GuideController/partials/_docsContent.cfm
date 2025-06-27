<cfoutput>
    <div class="row p-3 rounded-18 bg-white scrollbar-overlay">
        <div class="docs-content col-lg-9">
            <div id="breadcrumb-nav" class="mb-2 text-uppercase fw-semibold small"></div>
            <div class="guides-docs-content">
                #renderedContent#
            </div>
        </div>
        <div class="right-sidebar position-sticky top-16 h-80vh rounded-18 col-lg-3 p-2 border-left bg--input">           
            <div>
                <ul class="toc-list list-unstyled">
                    <cfloop array="#toc#" index="item">
                        <cfif NOT findNoCase("description", item.title)>
                            <li class="toc-item ps-#evaluate(item.level eq 3 ? '3' : '1')#">
                                <a href="###item.id#" data-id="#item.id#" class="toc-link py-2 d-block text-muted">
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