component extends="app.Controllers.Controller" {

    function config() {
        verifies(except="index,enableTestimonials,updateSlackInvite,checkAdminAccess,checkRoleExistance,contributors,syncContributors,editContributors,storeContributors,updateContributorApi", params="key", paramsTypes="integer");

        usesLayout(template="/admin/AdminController/layout");
        filters(through="checkAdminAccess");
    }

    function index(){
        settings = model("setting").findAll();
    }

    function enableTestimonials(){
        if(structKeyExists(params, "enableTestimonials")){
            model("setting").updateAll(enableTestimonial=true);
            message = "Testimonials enabled";
        }else{
            model("setting").updateAll(enableTestimonial=false);
            message = "Testimonials disabled";
        }
        renderText(message);
    }

    function updateContributorApi(){
        if(structKeyExists(params, "wheelsContributorLink")){
            model("setting").updateAll(wheelsContributorLink=params.wheelsContributorLink);
            message = "Wheels Contributor Github API link updated successfully";
        }else{
            message = "No Wheels Contributor Github API link provided";
        }
        renderText(message);
    }

    function updateSlackInvite(){
        if(structKeyExists(params, "slackInviteLink")){
            model("setting").updateAll(slackInviteLink=params.slackInviteLink);
            message = "Slack invite link updated successfully";
        }else{
            message = "No Slack invite link provided";
        }
        renderText(message);
    }

    function contributors(){
        contributors = model("contributor").getAll();
        if(contributors.recordCount == 0){
            syncContributors();
            contributors = model("contributor").getAll();
        }
    }

    function syncContributors() {
        try {
            var contributorLink = model("setting").findAll(select="wheelsContributorLink");
            if (contributorLink.recordCount == 0 OR contributorLink.wheelsContributorLink == "") {
                redirectTo(route="adminget-contributors", text="Contributor API not found! Failed to sync contributors.");
            }
            var apiUrl = contributorLink.wheelsContributorLink;

            // Main GitHub contributors API
            cfhttp(url=apiUrl, method="get", timeout=30, result="resp") {
                cfhttpparam(type="header", name="User-Agent", value="CFWheels-App");
            }

            if (listFirst(resp.statusCode, " ") EQ "200" AND isJSON(resp.fileContent)) {
                var contributors = deserializeJson(resp.fileContent);

                for (i=1; i <= arrayLen(contributors); i++) {
                    var username   = contributors[i].login;
                    var userUrl    = "https://api.github.com/users/" & username;
                    var name       = username; // fallback
                    var avatarUrl  = "";
                    var apiUrlUser = "";
                    var contributions = contributors[i].contributions ?: 0;

                    // Per-user API call
                    cfhttp(url=userUrl, method="get", timeout=30, result="userResp") {
                        cfhttpparam(type="header", name="User-Agent", value="CFWheels-App");
                    }

                    // If user call fails → redirect immediately
                    if (listFirst(userResp.statusCode, " ") NEQ "200" OR !isJSON(userResp.fileContent)) {
                        redirectTo(route="adminget-contributors", text="GitHub API rate limit exceeded. Try again later.");
                    }

                    var userData = deserializeJson(userResp.fileContent);

                    if (structKeyExists(userData, "name") AND len(trim(userData.name))) {
                        name = userData.name;
                    }
                    avatarUrl    = userData.avatar_url ?: "";
                    apiUrlUser   = userData.url ?: "";

                    // Upsert contributor
                    var existing = model("Contributor").findOneByUsername(username);
                    if (!isObject(existing)) {
                        var c = model("Contributor").new();
                        c.name          = name;
                        c.username      = username;
                        c.description   = "";
                        c.roles         = "1"; // default role
                        c.contributor_pic = avatarUrl;
                        c.contributions  = contributions;
                        c.contributor_profile_api = apiUrlUser;
                        c.save();
                    } else {
                        existing.name        = name;
                        existing.contributor_pic = avatarUrl;
                        existing.contributions   = contributions;
                        existing.contributor_profile_api = apiUrlUser;
                        existing.save();
                    }
                }
            }

            redirectTo(route="adminget-contributors", text="Contributors synced successfully.");
        } catch (any e) {
            renderText("Error while syncing contributors");
        }
    }


    function editContributors(){
        contributor = model("contributor").findOnebyId(params.id);
        roles = model("contributor_role").findAll();
    }

    function storeContributors() {
        // get params safely
        var contributorId = params.id ?: "";
        var contributor   = model("Contributor").findOneById(contributorId);

        // if not found, create new
        if (!isObject(contributor)) {
            contributor = model("Contributor").new();
        }
        // assign simple fields
        contributor.name        = params.name ?: "";
        contributor.username    = params.username ?: "";
        contributor.description = params.description ?: "";

        // handle roles array → comma-separated string
        if (isArray(params.roles)) {
            contributor.roles = arrayToList(params.roles, ",");
        } else if (isSimpleValue(params.roles)) {
            // single value case
            contributor.roles = params.roles;
        } else {
            contributor.roles = "";
        }

        // save to DB
        contributor.save();
        redirectTo(action = "contributors", success="Contributor update successfully!")
        
    }

    private boolean function isHtmx() {
        // HTMX requests include the HX-Request header
        return StructKeyExists(request.$wheelsheaders, "HX-REQUEST") && request.$wheelsheaders["HX-Request"];
    }
}