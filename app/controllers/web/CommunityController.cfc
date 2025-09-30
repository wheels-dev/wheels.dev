component extends="app.Controllers.Controller" {

    function config() {
        verifies(except="index", params="key", paramsTypes="integer");
        usesLayout("/layout");
    }

    function index() {
        // Get settings for the community page
        settings = model("setting").findAll();
        contributors = getContributors();
    }

    private function getContributors(){
        var contributorsList = model("contributors").findAll(where="username!='dependabot[bot]'");

        if(contributorsList.recordCount == 0){
            return [];
        }

        if(dateDiff("d", contributorsList.updatedAt, now()) >= 30){
            var contributorLink = model("setting").findAll(select="wheelsContributorLink");
            if(contributorLink.recordCount == 0 OR contributorLink.wheelsContributorLink == ""){
                return [];
            }
            var apiUrl = contributorLink.wheelsContributorLink;
            
            // GitHub requires a User-Agent header
            cfhttp(url="#apiUrl#", method="get", timeout=30, result="resp"){
                cfhttpparam(type="header", name="User-Agent", value="CFWheels-App");
            }
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

                        // === Insert only if not exists ===
                        var existing = model("Contributor").findOneByUsername(username);

                        if (!isObject(existing)) {
                            var c = model("Contributor").new();
                            c.name        = contributors[i].name;
                            c.username    = contributors[i].login;
                            c.description = "";
                            c.roles       = "1";
                            c.profilePic  = userData.avatar_url;
                            c.contributions = contributors[i].contributions;
                            c.profileAPI  = userData.url;
                            c.LinkedInLink = "";
                            c.save();
                        }else{
                            var c = existing;
                            c.name        = contributors[i].name;
                            c.username    = contributors[i].login;
                            c.profilePic  = userData.avatar_url;
                            c.contributions = contributors[i].contributions;
                            c.profileAPI  = userData.url;
                            c.save();
                        }
                    }
                }
                contributors = model("contributors").findAll(where="username!='dependabot[bot]'");
            }else{
                contributors = contributorsList;
            }
        }else{
            contributors = contributorsList;
        }
        contributorsArray = [];
        // Preload all roles to avoid N+1 queries
        var rolesMap = {};
        for (r in model("contributor_role").findAll()) {
            rolesMap[r.id] = r.rolename;
        }

        for (row in contributors) {
            var roleString = "";
            var roleIds = (!isNull(row.roles) AND len(trim(row.roles))) ? listToArray(row.roles, ",") : [];

            for (var j=1; j <= arrayLen(roleIds); j++) {
                var roleName = rolesMap[ roleIds[j] ] ?: ""; // safe lookup

                if (len(roleName)) {
                    if (j == 1) {
                        roleString &= roleName;
                    } else if (j == arrayLen(roleIds)) {
                        roleString &= " and " & roleName;
                    } else {
                        roleString &= ", " & roleName;
                    }
                }
            }

            contributor = {
                "name"        : row.name,
                "description" : row.description,
                "role"        : roleString,
                "profilePic"  : row.contributor_pic,
                "LinkedInLink": row.LinkedIn_Link
            };
            arrayAppend(contributorsArray, contributor);
        }
        return contributorsArray;
    }
}