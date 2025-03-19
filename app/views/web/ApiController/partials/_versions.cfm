<cfscript>
    param name="versions" default=[];
   writeOutput('
      <select name="versioncontrol" id="versioncontrol" class="form-control border-0 shadow-sm p-2 fs-16 bg-white">');

    for (var v = 1; v <= arrayLen(versions); v++) {
        var versionValue = versions[v];
        var selected = (replace(params.version, "v", "", "all") == versionValue) ? "selected" : "";
        writeOutput('<option value="#versionValue#" #selected#>#versionValue#</option>');
    }

    writeOutput('</select>');
</cfscript>