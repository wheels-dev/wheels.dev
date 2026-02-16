component extends="app.Controllers.Controller" {

    function config() {
        super.config();
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
                where  = "statusid <> 1 AND status = 'Approved' AND published_at IS NOT NULL AND published_at <= current_timestamp",
                order  = "createdAt DESC",
                cache  = 10
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
        var nowTs = now();
        var result = [];

        // 1. Try cache FIRST (only if object)
        if (isObject(cache)) {
            if (
                isJSON(cache.data)
                && dateDiff("h", cache.lastUpdated, nowTs) < 24
            ) {
                model("Log").log(
                    category="wheels.news",
                    level="INFO",
                    message="Using cached GitHub releases",
                    details={lastUpdated=cache.lastUpdated, cacheAge=dateDiff("h", cache.lastUpdated, nowTs) & " hours"}
                );
                return deserializeJSON(cache.data);
            } else if (!isJSON(cache.data)) {
                cache = false;
            }
        }

        // 2. Fetch fresh data
        try {
            cfhttp(
                url="https://api.github.com/repos/wheels-dev/wheels/releases",
                method="GET",
                result="httpResult",
                timeout=30
            ) {
                cfhttpparam(type="header", name="User-Agent", value="Wheels-dev-App");
            }

            if (httpResult.status_code == 200 && isJSON(httpResult.fileContent)) {
                result = deserializeJSON(httpResult.fileContent);
            } else {
                model("Log").log(
                    category="wheels.news",
                    level="ERROR",
                    message="GitHub API returned invalid response: Status #httpResult.status_code#, JSON valid: #isJSON(httpResult.fileContent)#",
                    details={statusCode=httpResult.status_code, response=httpResult.fileContent}
                );
                if (isObject(cache) && isJSON(cache.data)) {
                    return deserializeJSON(cache.data);
                }
            }
        } catch (any e) {
            model("Log").log(
                category="wheels.news",
                level="ERROR",
                message="Exception fetching GitHub releases: #e.message#",
                details={exception=e, url="https://api.github.com/repos/wheels-dev/wheels/releases"}
            );
            if (isObject(cache) && isJSON(cache.data)) {
                return deserializeJSON(cache.data);
            }
            return [];
        }

        // 3. Save cache only if we have fresh data
        if (arrayLen(result) > 0) {
            if (!isObject(cache)) {
                cache = model("CachedRelease").new();
            }
            cache.data = serializeJSON(result);
            cache.lastUpdated = nowTs;
            cache.save();
            model("Log").log(
                category="wheels.news",
                level="INFO",
                message="Cached fresh GitHub releases",
                details={count=arrayLen(result)}
            );
        }

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
