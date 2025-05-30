component extends="app.Controllers.Controller" {

    function config() {
        verifies(except="index", params="key", paramsTypes="integer");
        usesLayout("/layout");
    }

    public void function index() {
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
    }

    private array function getBlogs() {
        var blogQuery = model("Blog").findAll(
            select = "title, slug, content, postCreatedDate",
            where  = "statusid <> 1 AND status = 'Approved' AND isPublished = 'true'",
            order  = "createdAt DESC"
        );

        var blogsArray = [];

        for (var i = 1; i <= blogQuery.recordCount; i++) {
            // Convert to UTC
            var localDate = blogQuery.postCreatedDate[i];
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
    }

    private array function getGitHubReleases() {
        var result = [];

        try {
            // GitHub requires a User-Agent header or it may reject the request
            cfhttp(
                url="https://api.github.com/repos/wheels-dev/wheels/releases"
                method="GET"
                result="httpResult"){
                cfhttpparam(type="header" name="User-Agent" value="Wheels-dev-App")
            }

            if (httpResult.status_code == 200) {
                result = deserializeJson(httpResult.fileContent);
            }
        } catch (any e) {
            result = [];
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
