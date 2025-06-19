<cfoutput>
<cfset globalIndex = 1>

<cfscript>
function renderAccordion(items, parentId = "guidesAccordion") {
    for (item in items) {
        id = REReplace(item.title, "[^\w]", "", "all") & globalIndex;
        globalIndex++;

        isIntro = LCase(item.title) == "introduction";
        isGettingStarted = LCase(item.title) == "getting started";

        if (structKeyExists(item, "children") and arrayLen(item.children)) {
            hasPath = structKeyExists(item, "path") and len(trim(item.path));
            collapseId = "collapse" & id;

            showClass = (isIntro or isGettingStarted) ? "show" : "";
            buttonCollapsed = (isIntro or isGettingStarted) ? "" : "collapsed";
            ariaExpanded = (isIntro or isGettingStarted) ? "true" : "false";

            writeOutput('
                <div class="accordion-item bg-transparent border-0">
                    <div class="accordion-header section text-white" data-section="#id#">
                        <button class="accordion-button fs-14 fw-normal shadow-none bg--input p-2 rounded-3 text--secondary #buttonCollapsed#"
                                type="button"
                                data-section="#id#"
                                data-bs-toggle="collapse"
                                data-bs-target="##collapse#id#"
                                aria-expanded="#ariaExpanded#"
                                aria-controls="collapse#id#"
            ');

            if (hasPath) {
                writeOutput('
                                hx-get="#item.path#"
                                hx-trigger="click"
                                hx-target="##main"
                                hx-swap="innerHTML"
                ');
            }

            writeOutput('>
                            <input type="hidden" name="section" value="#id#">
                            #encodeForHTML(item.title)#
                        </button>
                    </div>
                    <div id="collapse#id#" class="accordion-collapse collapse #showClass#" data-bs-parent="###parentId#">
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
                <a href="javascript:void(0)" class="category text--secondary fw-normal d-block" data-section="#parentId#" hx-get="#item.path#" hx-trigger="click" hx-target="##main" hx-swap="innerHTML" data-category="#id#">
                    <p class="fs-14 cursor-pointer">#item.title#</p>
                </a>
            ');
        }
    }
}

renderAccordion(sidebar);
</cfscript>
</cfoutput>
