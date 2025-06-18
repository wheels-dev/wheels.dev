<cfoutput>
<cfset globalIndex = 1>

<cfscript>
function renderAccordion(items, parentId = "guidesAccordion") {
    for (item in items) {
        id = REReplace(item.title, "[^\w]", "", "all") & globalIndex;
        globalIndex++;

        if (structKeyExists(item, "children") and arrayLen(item.children)) {
            writeOutput('
                <div class="accordion-item bg-transparent border-0">
                    <div class="accordion-header section text-white" data-section="#id#">
                        <button class="accordion-button fs-14 fw-normal shadow-none bg--input p-2 rounded-3 text--secondary collapsed"
                                type="button"
                                data-section="#id#"
                                data-bs-toggle="collapse"
                                data-bs-target="##collapse#id#"
                                aria-expanded="false"
                                aria-controls="collapse#id#">
                            <input type="hidden" name="section" value="#id#">
                            #encodeForHTML(item.title)#
                        </button>
                    </div>
                    <div id="collapse#id#" class="accordion-collapse collapse" data-bs-parent="###parentId#">
                        <div class="accordion-body pb-0 space-y-3 pt-3 px-0 position-relative">
                            <div class="space-y-2 ps-4">
            ');

            renderAccordion(item.children, "collapse#id#");

            writeOutput('
                            </div>
                        </div>
                    </div>
                </div>
            ');
        } else if (structKeyExists(item, "path")) {
            writeOutput('
                <a href="#item.path#" class="category d-block" data-section="#parentId#" data-category="#id#">
                    <input type="hidden" name="section" value="#parentId#">
                    <input type="hidden" name="category" value="#id#">
                    <p class="fs-14 fw-normal cursor-pointer text--secondary">#encodeForHTML(item.title)#</p>
                </a>
            ');
        }
    }
}
</cfscript>

<div class="accordion space-y-3" id="guidesAccordion">
    <cfscript>
        renderAccordion(sidebar);
    </cfscript>
</div>
</cfoutput>
