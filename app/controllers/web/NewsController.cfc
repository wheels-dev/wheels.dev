component extends="app.Controllers.Controller" {

    function config() {
        verifies(except="index", params="key", paramsTypes="integer");
        usesLayout("/layout");
    }

    public void function index() {
        try {
            releases = getGitHubReleases();
            blogs = getBlogs();
            // Merge blogs into releases
            for (var blog in blogs) {
                arrayAppend(releases, blog);
            }
            // Optional: sort by published_at (descending)
            arraySort(releases, function(a, b) {
                return compare(
                    parseDateTime(b.published_at),
                    parseDateTime(a.published_at)
                );
            });
        } catch (any e) {
            // Log the error
            model("Log").log(
                category = "wheels.news",
                level = "ERROR",
                message = "Failed to process news index: " & e.message,
                details = {
                    errorType = e.type,
                    errorDetail = e.detail,
                    stackTrace = e.stackTrace
                },
                userId = structKeyExists(params, "key") ? params.key : 0
            );
            // Set empty releases to avoid further errors
            releases = [];
        }
    }

    private array function getBlogs() {
        try {
            var blogQuery = model("Blog").findAll(
                select = "title, slug, content, postDate",
                where  = "statusid <> 1 AND status = 'Approved' AND isPublished = 'true'",
                order  = "createdAt DESC"
            );

            var blogsArray = [];

            for (var i = 1; i <= blogQuery.recordCount; i++) {
                // Convert to UTC
                var localDate = blogQuery.postDate[i];
                var utcDate = dateConvert("local2utc", localDate);

                // Format to ISO 8601: yyyy-mm-ddTHH:MM:SSZ
                var isoDate = dateFormat(utcDate, "yyyy-mm-dd") & "T" & timeFormat(utcDate, "HH:mm:ss") & "Z";
                <!--- Original HTML content --->
                htmlContent = blogQuery.content[i];

                <!--- 1. Strip HTML comments and tags --->
                plainText = reReplace(htmlContent, "<!--.*?-->", "", "all");
                plainText = reReplace(plainText, "<[^>]*>", "", "all");

                <!--- 3. Normalize whitespace --->
                plainText = replace(plainText, chr(10), " ", "all");
                plainText = trim(plainText);

                <!--- 4. Shorten to 200 characters safely --->
                if (len(plainText) GT 250){
                    shortBody = left(plainText, 250) & "...";
                }else{
                    shortBody = plainText;
                }

                arrayAppend(blogsArray, {
                    name         = blogQuery.title[i],
                    body         = shortBody,
                    published_at = isoDate,
                    html_url     = urlFor(route="blog-detail",slug=blogQuery.slug[i]),
                    isblog       = true,
                    assets       = [] // empty array
                });
            }

            return blogsArray;
        } catch (any e) {
            // Log the error
            model("Log").log(
                category = "wheels.news",
                level = "ERROR",
                message = "Failed to fetch or process blogs: " & e.message,
                details = {
                    errorType = e.type,
                    errorDetail = e.detail,
                    stackTrace = e.stackTrace
                },
                userId = structKeyExists(params, "key") ? params.key : 0
            );
            return [];
        }
    }

    private array function getGitHubReleases() {
        var cache = model("CachedRelease").findOne();
        var now = now();
        
        // Check if cache exists and is less than 24 hours old
        if (!isNull(cache) && cache && dateDiff("h", cache.lastUpdated, now) < 24) {
            model("Log").log(
                category="wheels.news",
                level="INFO",
                message="Using cached GitHub releases",
                details={lastUpdated=cache.lastUpdated}
            );
            return deserializeJSON(cache.data);
        }
        
        // Fetch fresh data
        var result = [];
        try {
            cfhttp(
                url="https://api.github.com/repos/wheels-dev/wheels/releases",
                method="GET",
                result="httpResult",
                timeout=30
            ) {
                cfhttpparam(type="header", name="User-Agent", value="Wheels-dev-App");
            }
            
            if (httpResult.status_code == 200) {
                result = deserializeJson(httpResult.fileContent);
                model("Log").log(
                    category="wheels.news",
                    level="INFO",
                    message="Successfully fetched GitHub releases",
                    details={count=arrayLen(result)}
                );
            } else {
                model("Log").log(
                    category="wheels.news",
                    level="ERROR",
                    message="Failed to fetch GitHub releases: HTTP #httpResult.status_code#",
                    details={statusCode=httpResult.status_code, response=httpResult.fileContent}
                );
                // Return cached data if available, even if old
                if (!isNull(cache)) {
                    return deserializeJSON(cache.data);
                }
            }
        } catch (any e) {
            model("Log").log(
                category="wheels.news",
                level="ERROR",
                message="Exception fetching GitHub releases: #e.message#",
                details={exception=e}
            );
            // Return cached data if available
            if (!isNull(cache)) {
                return deserializeJSON(cache.data);
            }
        }
        
        // Update cache
        if (isNull(cache) || !cache) {
            cache = model("CachedRelease").new();
        }
        cache.data = serializeJSON(result);
        cache.lastUpdated = now;
        cache.save();
        
        return result;
    }

    function convertMarkdownToHtml(string markdown) {
        var lines = listToArray(markdown, chr(10));
        var html = "";
        var insideList = false;
        var converted = false;

        for (var i = 1; i <= arrayLen(lines); i++) {
            var line = trim(lines[i]);

            // Heading
            if (left(line, 3) == "######") {
            if (insideList) {
                html &= "</ul>";
                insideList = false;
            }
            html &= "<h3>" & trim(replace(line, "######", "", "one")) & "</h3>";
            converted = true;
            }
            // PR list item
            else if (left(line, 5) == "- PR-") {
            if (!insideList) {
                html &= "<ul>";
                insideList = true;
            }

            var itemHtml = reReplace(line, "\[(.+?)\]\((.+?)\)", "<a href=""\2"">\1</a>", "all");
            html &= "<li>" & itemHtml & "</li>";
            converted = true;
            }
            // All other lines (ignore in conversion but count for returning original)
            else {
            html &= line & "<br>"; // Preserve other text as-is with basic line break
            }
        }

        if (insideList) {
            html &= "</ul>";
        }

        return converted ? html : markdown;
    }
}
