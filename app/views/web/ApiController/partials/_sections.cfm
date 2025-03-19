<cfscript>
if (structKeyExists(docs, "sections")) {
    writeOutput('<div class="accordion" id="guidesAccordion">');

    for (var s = 1; s <= arrayLen(docs.sections); s++) {
        var sectionName = docs.sections[s]["name"];
        var sectionId = $cssClassLink(sectionName);

        writeOutput('
            <div class="accordion-item bg-transparent border-0">
                <div class="accordion-header section pe-2 text-white">
                    <button class="accordion-button fs-14 fw-normal shadow-none p-2 rounded-3 text--iris" 
                        style="background-color: rgba(179, 179, 179, 0.12);" 
                        type="button" data-bs-toggle="collapse" data-bs-target="##' & sectionId & '" 
                        aria-expanded="false" aria-controls="' & sectionId & '">
                        ' & sectionName & '
                    </button>
                </div>
                <div id="' & sectionId & '" class="accordion-collapse collapse" data-bs-parent="##guidesAccordion">
                    <div class="accordion-body pb-0 space-y-3 pt-3 px-0 position-relative">
                        <div class="space-y-3 ps-4">');

        for (var ss = 1; ss <= arrayLen(docs.sections[s]["categories"]); ss++) {
            var categoryName = docs.sections[s]["categories"][ss];
            writeOutput('<p class="fs-14 fw-normal cursor-pointer text--iris">' & categoryName & '</p>');
        }

        writeOutput('</div>
                    </div>
                </div>
            </div>');
    }

    writeOutput('</div>'); // Closing accordion
}
</cfscript>