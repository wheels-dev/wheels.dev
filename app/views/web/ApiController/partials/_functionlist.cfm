<cfscript>
writeOutput('
<div class="form-group mb-3">
  <div class="btn-group bg--input d-flex align-items-center px-3 py-2 rounded-3 border gap-2 w-100">
    <input name="doc-search" id="doc-search" placeholder="Type to filter..." type="text" class="fs-14 flex-grow-1 outline-none bg-transparent input-autofill">
    <i id="searchclear" class="bi bi-x fs-18"></i>
  </div>
</div>
<div class="d-flex align-items-center gap-3 mt-3">
  <a class="docreset load-more-trigger fw-bold text--primary" hx-get="/api/#currentVersion#/functions" hx-trigger="click" hx-target="##main" hx-swap="innerHTML">
    <span class="fs-14 cursor-pointer">All</span>
  </a>
  <button class="fw-bold showSections text--secondary bg-transparent outline-none">
    <span class="fs-14 cursor-pointer">Sections</span>
  </button>
</div>
');

for (var func = 1; func <= arrayLen(docs.functions); func++) {
    var meta = docs.functions[func];
    var functionSlug = lcase(meta.slug);
    writeOutput("<a 
    href='javascript:void(0)' 
    class='functionlink fw-normal text--secondary' 
    data-section='#meta.tags.sectionClass#' 
    data-category='#meta.tags.categoryClass#' 
    data-function='#functionSlug#'
    data-slug='#functionSlug#'
    data-version='#params.version#'
    hx-get='/api/#params.version#/function'
    hx-include='this'
    hx-target='##main'
    hx-swap='innerHTML'
  >
    <input type='hidden' name='slug' value='#functionSlug#'>
    <input type='hidden' name='version' value='#params.version#'>
    <p class='fs-14 cursor-pointer my-2'>#meta.name#()</p>
  </a>");
}

</cfscript>
