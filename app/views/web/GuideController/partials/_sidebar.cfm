<cfoutput>
<cfset globalIndex = 1>

<cfscript>
function renderAccordion(items, parentId = "guidesAccordion", breadcrumbTrail = "") {
    if (!isArray(breadcrumbTrail)) {
        breadcrumbTrail = [];
    }

    filepathExists = structKeyExists(url, "filePath") and len(trim(url.filePath)) > 0;

    for (item in items) {
        id = REReplace(item.title, "[^\w]", "", "all") & globalIndex;
        globalIndex++;

        isIntro = LCase(item.title) == "introduction";
        isGettingStarted = LCase(item.title) == "getting started";

        autoExpand = (isIntro or isGettingStarted) and not filepathExists;

        // Proper breadcrumb append
        currentTrail = duplicate(breadcrumbTrail);
        arrayAppend(currentTrail, item.title);
        breadcrumbPath = arrayToList(currentTrail, " > ");

        if (structKeyExists(item, "children") and arrayLen(item.children)) {
            hasPath = structKeyExists(item, "path") and len(trim(item.path));
            collapseId = "collapse" & id;

            showClass = autoExpand ? "show" : "";
            buttonCollapsed = autoExpand ? "" : "collapsed";
            ariaExpanded = autoExpand ? "true" : "false";

            writeOutput('
                <div class="accordion-item bg-transparent border-0">
                    <div class="accordion-header section text-white" data-section="#id#">
                        <button class="accordion-button fs-14 fw-normal shadow-none bg--input p-2 rounded-3 text--secondary #buttonCollapsed# #hasPath ? 'category' : ''#"
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
                                hx-push-url="true"
                                data-breadcrumb="#encodeForHTML(breadcrumbPath)#"
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

            // Recursive call with updated breadcrumbTrail
            renderAccordion(item.children, "collapse#id#", currentTrail);

            writeOutput('
                            </div>
                        </div>
                    </div>
                </div>
            ');
        } else if (structKeyExists(item, "path")) {
            if (!reFind("^https?://", item.path)) {
                writeOutput('
                    <a class="category text--secondary fw-normal d-block"
                       data-section="#parentId#"
                       hx-get="#item.path#"
                       hx-push-url="#item.path#"
                       hx-trigger="click"
                       hx-target="##main"
                       hx-swap="innerHTML"
                       data-category="#id#"
                       data-breadcrumb="#encodeForHTML(breadcrumbPath)#">
                        <p class="fs-14 cursor-pointer">#encodeForHTML(item.title)#</p>
                    </a>
                ');
            } else {
                writeOutput('
                    <a href="#item.path#" class="category text--secondary fw-normal d-block"
                       data-section="#parentId#"
                       data-category="#id#"
                       data-breadcrumb="#encodeForHTML(breadcrumbPath)#">
                        <p class="fs-14 cursor-pointer">#encodeForHTML(item.title)#</p>
                    </a>
                ');
            }
        }
    }
}

renderAccordion(sidebar);
</cfscript>
</cfoutput>
