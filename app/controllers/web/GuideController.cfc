component extends="app.Controllers.Controller" {

    // Configuration function
    function config() {
        super.config();
		// verifies(only="index", get=true, params="version", paramsTypes="string");
        verifies(except="index,loadGuideDocs,searchDocs,generateSearchBook,getSearchBook", params="key", paramsTypes="integer", handler="index");

        usesLayout("/layout");
    }

    function index(){
        try{
            param name="params.version" default="3.0.0-snapshot";
            var readmePath = expandPath("../guides/README.md");
            var summaryPath = expandPath("../guides/SUMMARY.md");

            if (fileExists(readmePath)) {
                var content = fileRead(readmePath);
                renderedContent = markdownToHtml(content);
            } else {
                renderedContent = "<p>Page not found.</p>";
            }

            if(fileExists(summaryPath)){
                sidebar = summaryToJson(summaryPath);
            }else{
                redirectTo(route="home", error="Page not found.");
            }
        }catch(any e){
            redirectTo(route="home", error="Something went wrong.");
        }

    }

    public function loadGuideDocs(){
        try{
            var filepath = params.path;
                file = expandPath("../guides/#filepath#.md");
            if(fileExists(file)){
                var content = fileRead(file);
                renderedContent = markdownToHtml(content);
                renderPartial(partial="partials/docsContent");
            }else{
                redirectTo(route="load-Guides", error="Document not found.");
            }
        }catch(any e){
            redirectTo(route="load-Guides", error="Something went wrong!");
        }
    }

    public function generateSearchBook(){
        try{
            searchIndex = [];

            mdFiles = directoryList(expandPath("../guides"), true, "path", "*.md");

            for (file in mdFiles) {
                fileName = listLast(file, "/");

                // Skip SUMMARY.md
                if (lcase(fileName) == "summary.md") {
                    continue;
                }

                mdText = fileRead(file);
                html = markdownToHtml(mdText);

                // Extract first <h1> tag as title
                h1Match = reFind("<h1[^>]*>(.*?)</h1>", html, 1, true, "perl");
                title = (arrayLen(h1Match.pos) >= 2 && h1Match.len[2] > 0) ?
                    mid(html, h1Match.pos[2], h1Match.len[2]) :
                    "Untitled";

                // Strip HTML tags for search body content
                plainText = reReplace(html, "<[^>]+>", " ", "all");
                cleanBody = reReplace(plainText, "[^A-Za-z0-9 ]", " ", "all");

                // Adjust path: remove base and prepend /guides/
                relativePath = replace(file, "C:\Users\BJS-044\Desktop\wheels\wheels.dev\guides", "", "one");
                relativeUrl = "\guides" & replace(relativePath, ".md", "", "one");

                arrayAppend(searchIndex, {
                    "title": trim(title),
                    "body": trim(cleanBody),
                    "url": relativeUrl
                });
            }

            targetPath = expandPath("../guides/search_index.json");
            targetDir = getDirectoryFromPath(targetPath);

            // Now write the file
            fileWrite(targetPath, serializeJSON(searchIndex, true));
            renderText("Search indexes generated successfully!");

        }catch(any e){
            renderText("Error :" & e.message);
        }

    }

    public function getSearchBook(){
        searchData = fileRead(expandPath("../guides/search_index.json"));
        return deserializeJSON(searchData);
    } 

    public function searchDocs(){
        writeDump(params);abort;
    }

    private function missingParams(){
		redirectTo(route="home");
	}

    private function summaryToJson(required string summaryPath){
        var result = [];
        var currentSection = {};
        var stack = [];

        var lines = fileRead(arguments.summaryPath).listToArray(chr(10));

        for (var i = 1; i <= arrayLen(lines); i++) {
            var line = trim(lines[i]);

            // Match section headers like ## INTRODUCTION
            if (reFind("^##{2,6}\s+(.+)", line)) {
                var title = reReplace(line, "^##{2,6}\s+(.+)", "\1", "all");
                currentSection = {
                    "title": title,
                    "children": []
                };
                arrayAppend(result, currentSection);
                stack = []; // Reset stack for new section
                continue;
            }

            // Match markdown list items with links: * [Title](path.md)
            if (reFind("\*\s*\[([^\]]+)\]\(([^)]+)\)", line)) {
                var indent = len(lines[i]) - len(trim(lines[i]));

                var title = reReplace(line, ".*\[\[?([^\]]+)\]\]?\([^)]+\).*", "\1", "all");
                var path = reReplace(line, ".*\[[^\]]+\]\(([^)]+)\).*", "\1", "all");
                    if (!reFind("^https?://", path)) {
                        path = reReplace(path, "\.md$", "", "all");
                        path = "/guides/" & path;
                    }
                var node = {
                    "title": title,
                    "path": path,
                    "children": []
                };

                if (indent eq 0) {
                    // Direct child of current section
                    if (!structIsEmpty(currentSection)) {
                        arrayAppend(currentSection.children, node);
                        stack = [node];
                    } else {
                        // No section yet, add directly to result
                        arrayAppend(result, node);
                        stack = [node];
                    }
                } else {
                    // Find correct parent based on indentation level
                    var parentIndex = arrayLen(stack);
                    while (parentIndex > 0) {
                        if (indent > (parentIndex * 2)) {
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

                    arrayAppend(stack, node);
                }
            }
        }

        return result;
    }
}