component extends="app.Controllers.Controller" {

    // Configuration function
    function config() {
        super.config();
        verifies(except="index,loadGuideDocs,searchDocs,generateSearchBook,getSearchBook", params="key", paramsTypes="integer", handler="index");

        usesLayout("/layout");
    }

    function index(){
        try{
            param name="params.version" default="3.0.0";
            param name="params.filePath" default="";

            // Sanitize path traversal sequences
            params.version = reReplace(params.version, "\.\.[\\/]", "", "all");
            params.version = reReplace(params.version, "[^a-zA-Z0-9.\-]", "", "all");
            if (len(trim(params.filePath))) {
                params.filePath = reReplace(params.filePath, "\.\.[\\/]", "", "all");
                params.filePath = reReplace(params.filePath, "[^a-zA-Z0-9.\-/]", "", "all");
            }

            // Auto-generate search index if it doesn't exist
            ensureSearchIndexExists(params.version);

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
                    '(?i)(<img[^>]+src=["''])[^"''>]*?\.gitbook/assets/([^"''>]+)(["''])',
                    '\1/img/\2\3',
                    "all"
                );

                // Normalize path separators
                var normalizedPath = replace(filePath, "\", "/", "all");
                var relativePath = reReplace(normalizedPath, ".*?/guides/", "", "one");
                var guideDir = listDeleteAt(relativePath, listLen(relativePath, "/"), "/");
                var baseHref = "/#params.version#/guides/#guideDir#/";
                // Fix internal <a href=""> links (not starting with http or /)
                renderedContent = rereplace(
                    renderedContent,
                    '(<a[^>]+href=["''])(?!https?:|/)([^"''##]+?)(?:\.md)?(["''])',
                    '\1#baseHref#\2\3',
                    "all"
                );
                // Open external links in a new tab
                renderedContent = rereplace(
                    renderedContent,
                    '(<a\s[^>]*href=["'']https?://[^"''>]+)(["''])',
                    '\1" target="_blank"\2',
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
                redirectTo(route="home", error="Page not found.");
            }
        }catch(any e){
            redirectTo(route="home", error="Something went wrong.");
        }
    }

    public function loadGuideDocs(){
        try{
            param name="params.version" default="3.0.0";

            // Sanitize path traversal sequences
            params.version = reReplace(params.version, "\.\.[\\/]", "", "all");
            params.version = reReplace(params.version, "[^a-zA-Z0-9.\-]", "", "all");
            if (structKeyExists(params, "path") && len(trim(params.path))) {
                params.path = reReplace(params.path, "\.\.[\\/]", "", "all");
                params.path = reReplace(params.path, "[^a-zA-Z0-9.\-/]", "", "all");
            }

            // Auto-generate search index if it doesn't exist
            ensureSearchIndexExists(params.version);

            var filepath = params.path;
                file = expandPath("../docs/#params.version#/guides/#filepath#.md");
            if(fileExists(file)){
                var content = fileRead(file, "utf-8");
                renderedContent = markdownToHtml(content);
                renderedContent = rereplace(
                    renderedContent,
                    '(?i)(<img[^>]+src=["''])[^"''>]*?\.gitbook/assets/([^"''>]+)(["''])',
                    '\1/img/\2\3',
                    "all"
                );

                // Normalize path separators
                var normalizedPath = replace(file, "\", "/", "all");
                var relativePath = reReplace(normalizedPath, ".*?/guides/", "", "one"); 
                var guideDir = listDeleteAt(relativePath, listLen(relativePath, "/"), "/"); 
                var baseHref = "/#params.version#/guides/#guideDir#/";

                // Fix internal <a href=""> links (not starting with http or /)
                renderedContent = rereplace(
                    renderedContent,
                    '(<a[^>]+href=["''])(?!https?:|/)([^"''##]+?)(?:\.md)?(["''])',
                    '\1#baseHref#\2\3',
                    "all"
                );
                // Open external links in a new tab
                renderedContent = rereplace(
                    renderedContent,
                    '(<a\s[^>]*href=["'']https?://[^"''>]+)(["''])',
                    '\1" target="_blank"\2',
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
                if(isHtmx()){
                    renderedContent = "<p style='color:red;'>Page not found!</p>";
                    renderPartial(partial="partials/docsContent");
                }else{
                    redirectTo(route="load-Guides", error="Page not found.");
                }
            }
        }catch(any e){
            redirectTo(route="load-Guides", error="Something went wrong!");
        }
    }

    // Helper function to ensure search index exists
    private void function ensureSearchIndexExists(required string version) {
        var indexPath = expandPath("/files/#arguments.version#/guides/search_index.json");
        
        // Check if index already exists
        if (!fileExists(indexPath)) {
            // Generate the index silently in the background
            generateSearchIndexForVersion(arguments.version);
        } else {
            // Optionally check if index is stale (older than 24 hours)
            var fileInfo = getFileInfo(indexPath);
            var hoursSinceGenerated = dateDiff("h", fileInfo.lastModified, now());
            
            // Regenerate if older than 24 hours (optional - you can adjust or remove this)
            if (hoursSinceGenerated > 24) {
                generateSearchIndexForVersion(arguments.version);
            }
        }
    }

    // Simplified version of generateSearchBook for internal use
    private void function generateSearchIndexForVersion(required string version) {
        try {
            var docIndexPath = expandPath("/files");
            
            // Create base path if it doesn't exist
            if (!directoryExists(docIndexPath)) {
                directoryCreate(docIndexPath);
            }
            
            var docsPath = expandPath("../docs");
            var versionPath = docsPath & "/" & arguments.version;
            
            // Check if version directory exists
            if (!directoryExists(versionPath)) {
                return; // Silently exit if version doesn't exist
            }
            
            var guidesPath = versionPath & "/guides";
            
            // Check if guides directory exists
            if (!directoryExists(guidesPath)) {
                return; // Silently exit if no guides directory
            }
            
            var searchIndex = [];
            var mdFiles = directoryList(guidesPath, true, "path", "*.md");
            
            for (var file in mdFiles) {
                try {
                    var fileName = listLast(file, "\");
                    
                    // Skip SUMMARY.md and other system files
                    if (listFindNoCase("summary.md", lcase(fileName))) {
                        continue;
                    }
                    
                    // Read and validate file content
                    if (!fileExists(file)) {
                        continue;
                    }
                    
                    var mdText = fileRead(file, "utf-8");
                    if (len(trim(mdText)) == 0) {
                        continue;
                    }
                    
                    var html = markdownToHtml(mdText);
                    
                    // Enhanced HTML cleaning
                    html = reReplace(html, "<img\b[^>]*>", "", "all");
                    html = reReplace(html, "<script\b[^>]*>.*?</script>", "", "all");
                    html = reReplace(html, "<style\b[^>]*>.*?</style>", "", "all");
                    
                    // Extract title with better fallback logic
                    var title = extractTitle(html, fileName);
                    
                    // Create clean body text with better formatting
                    var cleanBody = createCleanBody(html);
                    
                    // Generate SEO-friendly URL
                    var relativeUrl = generateCleanUrl(file, docIndexPath, arguments.version);
                    
                    // Create search entry with additional metadata
                    var searchEntry = {
                        "title": trim(title),
                        "body": toBase64(html),
                        "plainText": left(cleanBody, 500), // First 500 chars for previews
                        "url": relativeUrl,
                        "version": arguments.version,
                        "fileName": fileName,
                        "lastModified": dateFormat(getFileInfo(file).lastModified, "yyyy-mm-dd HH:nn:ss")
                    };
                    
                    arrayAppend(searchIndex, searchEntry);
                    
                } catch (any fileError) {
                    // Silently continue on error
                    continue;
                }
            }
            
            // Only write index if we have content
            if (arrayLen(searchIndex) > 0) {
                // Create version directory if it doesn't exist
                var versionDir = docIndexPath & "/" & arguments.version;
                if (!directoryExists(versionDir)) {
                    directoryCreate(versionDir);
                }
                
                // Create guides directory if it doesn't exist  
                var guidesDir = versionDir & "/guides";
                if (!directoryExists(guidesDir)) {
                    directoryCreate(guidesDir);
                }
                
                var targetPath = docIndexPath & "/" & arguments.version & "/guides/search_index.json";

                fileWrite(targetPath, serializeJSON(searchIndex, true));
            }
            
        } catch (any e) {
            // Silently fail - don't interrupt the guide loading
            // Optionally, you could log this error
        }
    }

    // Keep the original generateSearchBook for manual/route-based generation
    public function generateSearchBook() {
        var startTime = getTickCount();
        var processedVersions = 0;
        var totalFiles = 0;
        var errors = [];
            verbose = false;
        
        try {
            docIndexPath = expandPath("/files");
            
            // Create base path if it doesn't exist
            if (!directoryExists(docIndexPath)) {
                directoryCreate(docIndexPath);
                if (verbose) {
                    renderText("Created base directory: #docIndexPath#<br>");
                }
            }
            
            if (verbose) {
                renderText("Starting search index generation for: #docIndexPath#<br>");
            }
            
            // Get only directories
            var docsPath = expandPath("../docs");
            versionFolders = getVersionDirectories(docsPath, verbose);

            for (versionPath in versionFolders) {
                try {
                    // Double-check that this is actually a directory
                    if (!directoryExists(versionPath)) {
                        if (verbose) {
                            renderText("Skipping non-directory: #versionPath#<br>");
                        }
                        continue;
                    }
                    
                    versionName = listLast(versionPath, "\");
                    guidesPath = versionPath & "/guides";
                    
                    // Create guides folder if it doesn't exist
                    if (!directoryExists(guidesPath)) {
                        directoryCreate(guidesPath);
                        if (verbose) {
                            renderText("Created guides directory for #versionName#: #guidesPath#<br>");
                        }
                    }

                    if (verbose) {
                        renderText("Processing version: #versionName#<br>");
                    }

                    searchIndex = [];
                    mdFiles = directoryList(guidesPath, true, "path", "*.md");
                    var versionFileCount = 0;

                    for (file in mdFiles) {
                        try {
                            fileName = listLast(file, "\");

                            // Skip SUMMARY.md and other system files
                            if (listFindNoCase("summary.md", lcase(fileName))) {
                                continue;
                            }

                            // Read and validate file content
                            if (!fileExists(file)) {
                                continue;
                            }
                            
                            mdText = fileRead(file, "utf-8");
                            if (len(trim(mdText)) == 0) {
                                if (verbose) {
                                    renderText("Skipping empty file: #fileName#<br>");
                                }
                                continue;
                            }

                            html = markdownToHtml(mdText);
                            
                            // Enhanced HTML cleaning
                            html = reReplace(html, "<img\b[^>]*>", "", "all");
                            html = reReplace(html, "<script\b[^>]*>.*?</script>", "", "all");
                            html = reReplace(html, "<style\b[^>]*>.*?</style>", "", "all");

                            // Extract title with better fallback logic
                            title = extractTitle(html, fileName);
                            
                            // Create clean body text with better formatting
                            cleanBody = createCleanBody(html);
                            
                            // Generate SEO-friendly URL
                            relativeUrl = generateCleanUrl(file, docIndexPath, versionName);
                            
                            // Create search entry with additional metadata
                            searchEntry = {
                                "title": trim(title),
                                "body": toBase64(html),
                                "plainText": left(cleanBody, 500), // First 500 chars for previews
                                "url": relativeUrl,
                                "version": versionName
                            };

                            arrayAppend(searchIndex, searchEntry);
                            versionFileCount++;
                            totalFiles++;

                        } catch (any fileError) {
                            arrayAppend(errors, {
                                "file": fileName,
                                "version": versionName,
                                "error": fileError.message
                            });
                            
                            if (verbose) {
                                renderText("Error processing #fileName#: #fileError.message#<br>");
                            }
                        }
                    }

                    // Only write index if we have content
                    if (arrayLen(searchIndex) > 0) {
                        
                        // Create version directory if it doesn't exist
                        versionDir = docIndexPath & "/" & versionName;
                        if (!directoryExists(versionDir)) {
                            directoryCreate(versionDir);
                        }

                        // Create guides directory if it doesn't exist  
                        guidesDir = versionDir & "/guides";
                        if (!directoryExists(guidesDir)) {
                            directoryCreate(guidesDir);
                        }

                        targetPath = docIndexPath & "/" & versionName & "/guides/search_index.json";
                        
                        fileWrite(targetPath, serializeJSON(searchIndex, true));
                        processedVersions++;
                        
                        if (verbose) {
                            renderText("✓ Generated index for #versionName# (#arrayLen(searchIndex)# documents)<br>");
                        }
                    } else {
                        if (verbose) {
                            renderText("⚠ No valid documents found for #versionName#<br>");
                        }
                    }

                } catch (any versionError) {
                    arrayAppend(errors, {
                        "version": versionName,
                        "error": versionError.message
                    });
                    
                    if (verbose) {
                        renderText("Error processing version #versionName#: #versionError.message#<br>");
                    }
                }
            }

            // Generate summary report
            var duration = (getTickCount() - startTime) / 1000;
            var summary = "Search index generation completed!<br>";
            summary &= "Processed #processedVersions# versions<br>";
            summary &= "Indexed #totalFiles# total files<br>";
            summary &= "Completed in #numberFormat(duration, '0.00')# seconds<br>";
            
            if (arrayLen(errors) > 0) {
                summary &= "<br>Errors encountered: #arrayLen(errors)#<br>";
                if (verbose) {
                    for (error in errors) {
                        summary &= "- #structKeyExists(error, 'file') ? error.file : error.version#: #error.error#<br>";
                    }
                }
            }
            
            renderText(summary);

        } catch (any e) {
            var errorMsg = "Error in generating search index";
            
            renderText(errorMsg);
        }
    }

    // Helper function to extract document title
    private function extractTitle(required string html, required string fileName) {
        // Try to find h1 tag
        var h1Match = reFind("<h1[^>]*>(.*?)</h1>", html, 1, true, "perl");
        if (arrayLen(h1Match.pos) >= 2 && h1Match.len[2] > 0) {
            var title = mid(html, h1Match.pos[2], h1Match.len[2]);
            title = reReplace(title, "<[^>]+>", "", "all"); // Strip any nested tags
            return trim(title);
        }
        
        // Fallback to filename without extension
        return replace(fileName, ".md", "", "one");
    }

    // Helper function to create clean body text
    private function createCleanBody(required string html) {
        // Remove code blocks first to avoid weird spacing
        var cleanHtml = reReplace(html, "<pre[^>]*>.*?</pre>", " [CODE_BLOCK] ", "all");
        cleanHtml = reReplace(cleanHtml, "<code[^>]*>.*?</code>", " [CODE] ", "all");
        
        // Strip all HTML tags
        var plainText = reReplace(cleanHtml, "<[^>]+>", " ", "all");
        
        // Clean up whitespace and special characters
        plainText = reReplace(plainText, "&[a-zA-Z0-9]+;", " ", "all"); // HTML entities
        plainText = reReplace(plainText, "\s+", " ", "all"); // Multiple spaces
        plainText = reReplace(plainText, "^\s+|\s+$", "", "all"); // Trim
        
        return plainText;
    }

    // Helper function to generate clean URLs
    private function generateCleanUrl(required string filePath, required string basePath, required string versionName) {
        var versionPosition = findNoCase(versionName, filePath);
        if (versionPosition > 0) {
            var relativePath = "/" & mid(filePath, versionPosition + len(versionName) + 1);
        } else {
            // Fallback to original logic if version not found in path
            var relativePath = "/guides";
        }
        
        // Version-specific URL handling
        if (versionName != "2.5.0") {
            relativePath = replace(relativePath, "getting-started", "readme", "all");
        }
        
        // Convert to web-friendly URL
        var relativeUrl = replace(relativePath, ".md", "", "one");
        relativeUrl = replace(relativeUrl, "\", "/", "all");
        
        // Clean up URL segments
        relativeUrl = reReplace(relativeUrl, "/+", "/", "all"); // Remove double slashes
        relativeUrl = reReplace(relativeUrl, "^|/$", "", "all"); // Remove trailing slashes
        
        return relativeUrl;
    }

    // Helper function to get only version directories (excludes files)
    private function getVersionDirectories(required string basePath, boolean verbose = false) {
        var versionFolders = [];
        
        try {
            if (!directoryExists(basePath)) {
                return versionFolders;
            }
            
            var allItems = directoryList(basePath, false, "query");
            
            for (var item in allItems) {
                if (item.type == "Dir") {
                    var fullPath = item.directory & "\" & item.name;
                    
                    // Additional validation - skip hidden folders and common non-version folders
                    var folderName = item.name;
                    if (!reFind("^\.", folderName) && // Skip hidden folders (starting with .)
                        !listFindNoCase("assets,images,css,js,static,temp,cache", folderName)) { // Skip common non-version folders
                        
                        arrayAppend(versionFolders, fullPath);
                        
                        if (verbose) {
                            renderText("Found version directory: #folderName#<br>");
                        }
                    }
                } else if (verbose && item.type == "File") {
                    renderText("Skipping file: #item.name#<br>");
                }
            }
            
        } catch (any e) {
            if (verbose) {
                renderText("Error scanning directories: #e.message#<br>");
            }
        }
        
        return versionFolders;
    }

    public function getSearchBook(){
        searchData = fileRead(expandPath("files/#params.version#/guides/search_index.json"));
        renderWith(data=searchData, hideDebugInformation=true, status=200, layout='/responseLayout');
    } 

    private function missingParams(){
		redirectTo(route="home");
	}

    private function summaryToJson(required string summaryPath, required string version) {
        var result = [];
        var currentSection = {};
        var stack = [];
        var lastItemAtLevel = {}; // Track last item at each indentation level

        var lines = fileRead(arguments.summaryPath).listToArray(chr(10));

        for (var i = 1; i <= arrayLen(lines); i++) {
            var rawLine = lines[i];
            var line = trim(rawLine);

            // Skip empty lines
            if (len(line) == 0) {
                continue;
            }

            // Normalize tabs to 2 spaces
            rawLine = replace(rawLine, chr(9), "  ", "all");
            
            // Calculate indentation level
            var indent = len(rawLine) - len(ltrim(rawLine));
            var level = int(indent / 2);

            // Match section headers like ## INTRODUCTION
            if (reFind("^##{1,6}\s+(.+)", line)) {
                var title = reReplace(line, "^##{1,6}\s+(.+)", "\1", "all");
                currentSection = {
                    "title": title,
                    "path": "", // Section headers don't have paths
                    "isSection": true,
                    "children": []
                };
                arrayAppend(result, currentSection);
                stack = [currentSection]; // Reset stack with current section
                lastItemAtLevel = {}; // Reset level tracking
                continue;
            }

            // Match markdown list items
            if (reFind("^\*\s+", line)) {
                var node = {};
                
                // Check if it's a link item: * [Title](path.md)
                if (reFind("\[([^\]]+)\]\(([^)]+)\)", line)) {
                    // Extract title and path from link
                    var title = reReplace(line, ".*\[([^\]]+)\]\([^)]+\).*", "\1", "all");
                    var path = reReplace(line, ".*\[[^\]]+\]\(([^)]+)\).*", "\1", "all");

                    // Convert relative path to full versioned path
                    if (!reFind("^https?://", path)) {
                        path = reReplace(path, "\.md$", "", "all");
                        path = "/#version#/guides/" & path;
                    }

                    node = {
                        "title": title,
                        "path": path,
                        "hasLink": true,
                        "children": []
                    };
                } else {
                    // It's a plain text item (like "Core Commands", "Database Operations")
                    var title = reReplace(line, "^\*\s+", "", "all");
                    node = {
                        "title": trim(title),
                        "path": "", // No path for non-link items
                        "hasLink": false,
                        "children": []
                    };
                }

                // Store this item at its level for potential children
                lastItemAtLevel[level] = node;

                // Find the parent based on indentation level
                if (level == 0) {
                    // Top level item under current section or root
                    if (!structIsEmpty(currentSection)) {
                        arrayAppend(currentSection.children, node);
                    } else {
                        arrayAppend(result, node);
                    }
                } else {
                    // Find parent at level - 1
                    var parentLevel = level - 1;
                    
                    // Look for parent in lastItemAtLevel
                    if (structKeyExists(lastItemAtLevel, parentLevel)) {
                        var parent = lastItemAtLevel[parentLevel];
                        arrayAppend(parent.children, node);
                    } else if (!structIsEmpty(currentSection)) {
                        // Fallback to current section if no parent found
                        arrayAppend(currentSection.children, node);
                    } else {
                        // Fallback to root
                        arrayAppend(result, node);
                    }
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