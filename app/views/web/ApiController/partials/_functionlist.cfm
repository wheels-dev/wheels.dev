<cfscript>
writeOutput('<label>Quick Search</label>
<div class="form-group">
  <div class="btn-group w-100">
    <input name="doc-search" id="doc-search" placeholder="Type to filter..." type="text" class="form-control w-100 fs-14">
    <i id="searchclear" class="bi bi-x fs-18"></i>
  </div>
</div>
<p id="functionlistoutput">
  <a href="" class="docreset" hx-get="/api/#currentVersion#/functions" hx-trigger="click" hx-target="##main"hx-swap="innerHTML"
                        class="load-more-trigger mt-3"><i class="fa fa-eye"></i><p class="fs-14 cursor-pointer fw-normal text--iris">All</p></a>');

for (var func = 1; func <= arrayLen(docs.functions); func++) {
    var meta = docs.functions[func];
    var functionSlug = lcase(meta.slug);
    writeOutput("<a 
    href='javascript:void(0)' 
    class='functionlink' 
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
    <p class='fs-14 cursor-pointer fw-normal text--iris'>#meta.name#()</p>
  </a>");
}

</cfscript>
