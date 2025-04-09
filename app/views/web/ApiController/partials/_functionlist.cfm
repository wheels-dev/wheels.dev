<cfscript>
writeOutput('<label>Quick Search</label>
<div class="form-group">
  <div class="btn-group">
    <input name="doc-search" id="doc-search" placeholder="Type to filter..." type="text" class="form-control">
    <i id="searchclear" class="bi bi-x fs-18"></i>
  </div>
</div>
<p id="functionlistoutput">
  <a href="" class="docreset"><i class="fa fa-eye"></i><p class="fs-14 cursor-pointer fw-normal text--iris">All</p></a>');

for (var func = 1; func <= arrayLen(docs.functions); func++) {
    var meta = docs.functions[func];
    writeOutput('<a href="" class="functionlink" data-section="#meta.tags.sectionClass#" data-category="#meta.tags.categoryClass#" data-function="#lcase(meta.slug)#">
	<p class="fs-14 cursor-pointer fw-normal text--iris">#meta.name#()</p>
	</a>');
}

writeOutput('</p>');

</cfscript>
