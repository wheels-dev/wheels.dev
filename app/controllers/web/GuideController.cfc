component extends="app.Controllers.Controller" {

    // Configuration function
    function config() {
        super.config();
        verifies(except="index,loadGuideDocs,searchDocs,generateSearchBook,getSearchBook", params="key", paramsTypes="integer", handler="index");

        usesLayout("/layout");
    }

    function index(){
        try{
            param name="params.version" default="3.0.0-snapshot";
            param name="params.filePath" default="";
            var filePath = (len(trim(params.filepath)) > 0)
            ? expandPath("../docs/#params.version#/guides/#params.filepath#.md")
            : expandPath("../docs/#params.version#/guides/README.md");
            var summaryPath = expandPath("../docs/#params.version#/guides/SUMMARY.md");

            if (fileExists(filePath)) {
                var content = fileRead(filePath, "utf-8");
                renderedContent = markdownToHtml(content);
                // Replace GitBook asset paths in <img> tags
                renderedContent = rereplace(
                    renderedContent,
                    '(<img[^>]+src=["'']?)(\.?/)?\.gitbook/assets/([^"''>]+)(["'']?)',
                    '\1/img/\3\4',
                    "all"
                );

                // Normalize path separators
                var normalizedPath = replace(filePath, "\", "/", "all");
                var relativePath = reReplace(normalizedPath, ".*?/guides/", "", "one");
                var guideDir = listDeleteAt(relativePath, listLen(relativePath, "/"), "/");
                var baseHref = "/docs/#params.version#/guides/#guideDir#/";

                // Fix internal <a href=""> links (not starting with http or /)
                renderedContent = rereplace(
                    renderedContent,
                    '(<a[^>]+href=["''])(?!https?:|/)([^"''##]+?)(?:\.md)?(["''])',
                    '\1#baseHref#\2\3',
                    "all"
                );

                var processed = extractHeadingsWithIds(renderedContent);
                renderedContent = processed.renderedContent;
                toc = processed.toc;

            } else {
                renderedContent = "<p>Page not found.</p>";
            }

            if(fileExists(summaryPath)){
                sidebar = summaryToJson(summaryPath, params.version);
            }else{
                writeDump("inner");abort;
                redirectTo(route="home", error="Page not found.");
            }
        }catch(any e){
            writeDump(e);abort;
            redirectTo(route="home", error="Something went wrong.");
        }
    }

    public function loadGuideDocs(){
        try{
            param name="params.version" default="3.0.0-snapshot";
            var filepath = params.path;
                file = expandPath("../docs/#params.version#/guides/#filepath#.md");
            if(fileExists(file)){
                var content = fileRead(file, "utf-8");
                renderedContent = markdownToHtml(content);
                renderedContent = rereplace(
                    renderedContent,
                    '(<img[^>]+src=["'']?)(\.?/)?\.gitbook/assets/([^"''>]+)(["'']?)',
                    '\1/img/\3\4',
                    "all"
                );

                // Normalize path separators
                var normalizedPath = replace(file, "\", "/", "all");
                var relativePath = reReplace(normalizedPath, ".*?/guides/", "", "one"); 
                var guideDir = listDeleteAt(relativePath, listLen(relativePath, "/"), "/"); 
                var baseHref = "/docs/#params.version#/guides/#guideDir#/";

                // Fix internal <a href=""> links (not starting with http or /)
                renderedContent = rereplace(
                    renderedContent,
                    '(<a[^>]+href=["''])(?!https?:|/)([^"''##]+?)(?:\.md)?(["''])',
                    '\1#baseHref#\2\3',
                    "all"
                );

                var processed = extractHeadingsWithIds(renderedContent);
                renderedContent = processed.renderedContent;
                toc = processed.toc;

                if(isHtmx()){
                    renderPartial(partial="partials/docsContent");
                }else{
                    redirectTo(route="load-Guides", params="filePath=#params.path#&version=#params.version#");
                }
            }else{
                redirectTo(route="load-Guides", error="Page not found.");
            }
        }catch(any e){
            writeDump(e);abort;
            redirectTo(route="load-Guides", error="Something went wrong!");
        }
    }

    public function generateSearchBook(){
        try {
            baseDocsPath = expandPath("../docs");
            versionFolders = directoryList(baseDocsPath, false, "path");

            for (versionPath in versionFolders) {
                versionName = listLast(versionPath, "\");
                
                guidesPath = versionPath & "/guides";
                if (!directoryExists(guidesPath)) {
                    continue;
                }

                searchIndex = [];
                mdFiles = directoryList(guidesPath, true, "path", "*.md");

                for (file in mdFiles) {
                    fileName = listLast(file, "/");

                    // Skip SUMMARY.md
                    if (lcase(fileName) == "summary.md") {
                        continue;
                    }

                    mdText = fileRead(file);
                    html = markdownToHtml(mdText);

                    // Extract first <h1> as title
                    h1Match = reFind("<h1[^>]*>(.*?)</h1>", html, 1, true, "perl");
                    title = (arrayLen(h1Match.pos) >= 2 && h1Match.len[2] > 0) ?
                        mid(html, h1Match.pos[2], h1Match.len[2]) :
                        "Untitled";

                    // Strip HTML tags for body
                    plainText = reReplace(html, "<[^>]+>", " ", "all");
                    cleanBody = reReplace(plainText, "[^A-Za-z0-9 ]", " ", "all");

                    // Create relative URL path
                    relativePath = replace(file, baseDocsPath, "", "one");
                    if(versionName != "2.5.0"){
                        relativePath = replace(relativePath, "getting-started", "readme", "all");
                    }
                    relativeUrl = replace(relativePath, ".md", "", "one");

                    arrayAppend(searchIndex, {
                        "title": trim(title),
                        "body": trim(cleanBody),
                        "url": replace(relativeUrl, "\", "/", "all") // ensure URL is web-friendly
                    });
                }

                // Write JSON to version folder
                targetPath = versionPath & "/guides/search_index.json";
                fileWrite(targetPath, serializeJSON(searchIndex, true));
            }

            renderText("Search indexes generated for all versions successfully!");
        }
        catch (any e) {
            renderText("Error: " & e.message & " at " & e.tagContext[1].template & ":" & e.tagContext[1].line);
        }
    }

    public function getSearchBook(){
        searchData = fileRead(expandPath("../docs/#params.version#/guides/search_index.json"));
        return deserializeJSON(searchData);
    } 

    private function missingParams(){
		redirectTo(route="home");
	}

    private function summaryToJson(required string summaryPath, required string version) {
        var result = [];
        var currentSection = {};
        var stack = [];

        var lines = fileRead(arguments.summaryPath).listToArray(chr(10));

        for (var i = 1; i <= arrayLen(lines); i++) {
            var rawLine = lines[i];
            var line = trim(rawLine);

            // Normalize tabs to 2 spaces
            rawLine = replace(rawLine, chr(9), "  ", "all");

            // Match section headers like ## INTRODUCTION
            if (reFind("^##{2,6}\s+(.+)", line)) {
                var title = reReplace(line, "^##{2,6}\s+(.+)", "\1", "all");
                currentSection = {
                    "title": title,
                    "children": []
                };
                arrayAppend(result, currentSection);
                stack = []; // Reset nesting stack
                continue;
            }

            // Match markdown list items with links: * [Title](path.md)
            if (reFind("\*\s*\[([^\]]+)\]\(([^)]+)\)", line)) {
                // Option 1: Indent by space count (assume 2 spaces per level)
                var indent = len(rawLine) - len(trim(rawLine));
                var level = int(indent / 2);

                // Extract title and path
                var title = reReplace(line, ".*\[\[?([^\]]+)\]\]?\([^)]+\).*", "\1", "all");
                var path = reReplace(line, ".*\[[^\]]+\]\(([^)]+)\).*", "\1", "all");

                // Convert relative path to full versioned path
                if (!reFind("^https?://", path)) {
                    path = reReplace(path, "\.md$", "", "all");
                    path = "/#version#/guides/" & path;
                }

                var node = {
                    "title": title,
                    "path": path,
                    "children": []
                };

                if (level eq 0) {
                    // Direct child of section
                    if (!structIsEmpty(currentSection)) {
                        arrayAppend(currentSection.children, node);
                    } else {
                        arrayAppend(result, node);
                    }
                    stack = [node]; // Reset stack
                } else {
                    // Find correct parent based on nesting level
                    var parentIndex = arrayLen(stack);
                    while (parentIndex > 0) {
                        if (level > (parentIndex - 1)) {
                            break;
                        }
                        arrayDeleteAt(stack, parentIndex);
                        parentIndex--;
                    }

                    if (parentIndex > 0) {
                        arrayAppend(stack[parentIndex].children, node);
                    } else if (!structIsEmpty(currentSection)) {
                        arrayAppend(currentSection.children, node);
                    } else {
                        arrayAppend(result, node);
                    }

                    arrayAppend(stack, node); // Push to stack for next children
                }
            }
        }

        return result;
    }

    // Helper method to check if the request was initiated by HTMX.
    private boolean function isHtmx() {
        // HTMX requests include the HX-Request header
        return StructKeyExists(request.$wheelsheaders, "HX-REQUEST") && request.$wheelsheaders["HX-Request"];
    }

    function extractHeadingsWithIds(required string htmlContent) {
        var result = {
            renderedContent = arguments.htmlContent,
            toc = []
        };

        var headingPattern = "<h([23])>(.*?)</h\1>";
        var matches = reMatchNoCase(headingPattern, result.renderedContent);
        var fullMatch = "";
        var level = "";
        var title = "";
        var id = "";
        var replacement = "";

        for (var i = 1; i <= arrayLen(matches); i++) {
            fullMatch = matches[i];
            level = reFindNoCase("<h([23])>", fullMatch, 1, true).match[2];
            title = rereplace(fullMatch, "</?h[23]>", "", "all");
            id = rereplace(lcase(title), "[^a-z0-9]+", "-", "all");

            // Only include in TOC if title doesn't contain "description"
            if (!findNoCase("description", title)) {
                arrayAppend(result.toc, {
                    level: level,
                    title: trim(title),
                    id: id
                });
            }

            replacement = "<h#level# id=""#id#"">#title#</h#level#>";
            result.renderedContent = replace(result.renderedContent, fullMatch, replacement, "one");
        }

        return result;
    }

}