component extends="app.Controllers.Controller" {

    function config() {
        verifies(except="index", params="key", paramsTypes="integer");
        usesLayout("/layout");
    }

    public void function index() {
        releases = getGitHubReleases();
    }

    private array function getGitHubReleases() {
        var result = [];

        try {
            // GitHub requires a User-Agent header or it may reject the request
            cfhttp(
                url="https://api.github.com/repos/cfwheels/cfwheels/releases" 
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
