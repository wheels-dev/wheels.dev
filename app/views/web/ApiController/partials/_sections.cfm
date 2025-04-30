<cfscript>
if (structKeyExists(docs, "sections")) {
    writeOutput('
    <div class="d-flex align-items-center mb-3 gap-3">
        <button class="fw-bold showFunctions text--secpndary bg-transparent outline-none" hx-get="/api/#currentVersion#/functions" hx-trigger="click" hx-target="##main" hx-swap="innerHTML">
            <span class="fs-14 cursor-pointer">All</span>
        </button>
        <button class="fw-bold showSections text--primary bg-transparent outline-none">
            <span class="fs-14 cursor-pointer">Sections</span>
        </button>
    </div>
    <div class="accordion space-y-3" id="guidesAccordion">');

    for (var s = 1; s <= arrayLen(docs.sections); s++) {
        var sectionName = docs.sections[s]["name"];
        var sectionId = $cssClassLink(sectionName);

        writeOutput('
            <div class="accordion-item bg-transparent border-0">
                <div class="accordion-header section text-white" data-section="' & sectionId & '">
                    <button class="accordion-button fs-14 fw-normal shadow-none bg--input p-2 rounded-3 text--secondary collapsed"
                        type="button"
                        data-section="#sectionId#"
                        type="button" data-bs-toggle="collapse" data-bs-target="##' & sectionId & '" 
                        aria-expanded="false" aria-controls="' & sectionId & '"
                        hx-get="/api/#params.version#/functions/section"
                        hx-include="this"
                        hx-target="##main"
                        hx-swap="innerHTML">
                        <input type="hidden" name="section" value="#sectionId#">
                        #sectionName#
                    </button>
                </div>
                <div id="' & sectionId & '" class="accordion-collapse collapse" data-bs-parent="##guidesAccordion">
                    <div class="accordion-body pb-0 space-y-3 pt-3 px-0 position-relative">
                        <div class="space-y-2 ps-4">');

        for (var ss = 1; ss <= arrayLen(docs.sections[s]["categories"]); ss++) {
            var categoryName = docs.sections[s]["categories"][ss];
            var categoryId = $cssClassLink(categoryName);
            writeOutput('
                <a href="javascript:void(0)" class="category d-block" data-section="' & sectionId & '" data-category="' & categoryId & '"
                hx-get="/api/#params.version#/functions/sectionCategory"
                hx-include="this"
                hx-target="##main"
                hx-swap="innerHTML">
                <input type="hidden" name="section" value="#sectionId#">
                <input type="hidden" name="category" value="#categoryId#">
                <p class="fs-14 fw-normal cursor-pointer text--secondary">#categoryName#</p>
                </a>
            ');
        }

        writeOutput('</div>
                    </div>
                </div>
            </div>');
    }

    // Adding "Uncategorized" section at the end
    writeOutput('
            <div class="accordion-item bg-transparent border-0">
                <div class="accordion-header section text-white" data-section="">
                    <button class="accordion-button fs-14 fw-normal shadow-none bg--input p-2 rounded-3 text--secondary collapsed"
                        type="button"
                        hx-get="/api/#params.version#/functions/section" hx-include="this" hx-target="##main" hx-swap="innerHTML">
                        <input type="hidden" name="section" value="">
                        Uncategorized
                    </button>
                </div>
            </div>
    ');

    writeOutput('</div>'); // Closing accordion
}
</cfscript>