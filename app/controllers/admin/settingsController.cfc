component extends="app.Controllers.Controller" {

    function config() {
        verifies(except="index,enableTestimonials,updateSlackInvite,checkAdminAccess,checkRoleExistance,contributors,syncContributors,editContributors,storeContributors", params="key", paramsTypes="integer");

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

    function syncContributors (){
        try{
            var apiUrl = "https://api.github.com/repos/wheels-dev/wheels/contributors?per_page=50";
            var cacheKey = "github_contributors";
            // GitHub requires a User-Agent header
            cfhttp(url="#apiUrl#", method="get", timeout=30, result="resp"){
                cfhttpparam(type="header", name="User-Agent", value="CFWheels-App");
            }
            
            contributors = deserializeJson(resp.fileContent);
            if (listFirst(resp.statusCode, " ") EQ "200") {
                contributors = deserializeJson(resp.fileContent);

                // loop contributors and enrich with real name
                for (i=1; i <= arrayLen(contributors); i++) {
                    username = contributors[i].login;
                    userUrl = "https://api.github.com/users/" & username;

                    cfhttp(url=userUrl, method="get", timeout=30, result="userResp") {
                        cfhttpparam(type="header", name="User-Agent", value="CFWheels-App");
                    }

                    if (listFirst(userResp.statusCode, " ") EQ "200") {
                        userData = deserializeJson(userResp.fileContent);

                        // GitHub may return null if no name is set
                        if (structKeyExists(userData, "name") AND len(trim(userData.name))) {
                            contributors[i].name = userData.name;
                        } else {
                            contributors[i].name = contributors[i].login; // fallback if not set
                        }
                    } else {
                        contributors[i].name = ""; // fallback if user API call fails
                    }

                    // === Insert only if not exists ===
                    var existing = model("Contributor").findOneByUsername(username);

                    if (!isObject(existing)) {
                        var c = model("Contributor").new();
                        c.name        = contributors[i].name;
                        c.username    = contributors[i].login;
                        c.description = "";
                        c.roles       = "1";
                        c.save();
                    }
                }
            } else {
                contributors = []; // empty array if main API fails
            }
            cachePut(cacheKey, contributors, 3600);
            redirectTo(route="adminget-contributors", text="Contributors sync successfully.");
        }catch(any e){
            renderText("Error! while sync the contributors detail.");
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