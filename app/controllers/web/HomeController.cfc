// Home controller
component extends="app.Controllers.Controller" {

    function config() {
        verifies(except="index,create,loadFeatures,loadBlogs,loadGuides,loadTestimonials,sitemap,downloads", params="key", paramsTypes="integer", handler="index");
        usesLayout("/layout");
    }

    function index() {
        // Check if user is logged in and has not submitted testimonial
       showTestimonialPopup = false;
        if (structKeyExists(session, "userID")) {
            var user = model("User").findbyKey(session.userID);
            if (isStruct(user) && structKeyExists(user, "hasSubmittedTestimonial") && !user.hasSubmittedTestimonial()) {
                showTestimonialPopup = true;
            }
        }
        
        // Load featured testimonials for the homepage
        testimonials = model("Testimonial").getApprovedTestimonials(
            onlyFeatured = true,
            perPage = 10
        );

        // Contributors cached in application scope (rebuilds every 24h)
        if (!structKeyExists(application, "contributorsCache") || !structKeyExists(application, "contributorsCacheTime") || dateDiff("h", application.contributorsCacheTime, now()) >= 24) {
            application.contributorsCache = getContributors();
            application.contributorsCacheTime = now();
        }
        contributors = application.contributorsCache;
        settings = model("Setting").findAll(cache=60);
        blogs = model('Blog').getTenLatest(); // Get blog list
        features = getAllFeatures();
        renderView();
    }
    
    private function getContributors(){
        var contributorsList = model("contributors").findAll(where="username!='dependabot[bot]'", cache=60);

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
        for (r in model("contributor_role").findAll(cache=60)) {
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
    // Function to load features
    function loadFeatures() {
        try {
            features = getAllFeatures();
            renderPartial(partial="partials/features");
        } catch (any e) {
            renderPartial(partial="partials/error", message="Failed to load features.");
        }
    }

    // Function to load blogs
    function loadBlogs() {
        try {
            blogs = model("Blog").getTenLatest();
            renderPartial(partial="partials/blogs");
        } catch (any e) {
            renderPartial(partial="partials/error", message="Failed to load blogs.");
        }
    }
    
    // Function to load guides
    function loadGuides() {
        try {
            renderPartial(partial="partials/guides");
        } catch (any e) {
            renderPartial(partial="partials/error", message="Failed to load guides.");
        }
    }
    
    // Function to load testimonials
    function loadTestimonials() {
        try {
            testimonials = model("Testimonial").getApprovedTestimonials(
                onlyFeatured = false,
                perPage = 6
            );
            renderPartial(partial="partials/testimonials", testimonials=testimonials);
        } catch (any e) {
            renderPartial(partial="partials/error", message="Failed to load testimonials.");
        }
    }

        // Get all features
    function getAllFeatures() {
        var featuresQuery = model("Feature").findAll(cache=60);
        var svgIcons = getAllSvgIcons();
        var columnList = listToArray(featuresQuery.columnList);
        var totalIcons = arrayLen(svgIcons);

        // Check if the IMAGE column exists
        var hasImageColumn = arrayFindNoCase(columnList, "IMAGE");

        if (hasImageColumn) {
            // Update the IMAGE column in the same order
            for (var i = 1; i <= featuresQuery.recordCount; i++) {
                featuresQuery.IMAGE[i] = svgIcons[((i - 1) MOD totalIcons) + 1];
            }
        }
        return featuresQuery;
    }

    // Get all feature's icons
    private function getAllSvgIcons() {
        var svgIcons = [
            '<svg width="37" height="34" viewBox="0 0 37 34" fill="none" xmlns="http://www.w3.org/2000/svg"><path d="M18.063 5.35858C13.4356 4.45069 8.50347 6.38426 5.00102 10.6559C4.7621 10.9471 4.78801 11.3634 5.06136 11.6253L8.69516 15.1069C11.1313 11.3084 14.3125 7.99802 18.063 5.35858Z" fill="##FEDC5A" /><path d="M21.7714 27.4172L25.4784 30.837C25.7558 31.0929 26.1967 31.1171 26.5051 30.8935C31.0575 27.5931 33.107 22.9414 32.1004 18.5864C29.3014 22.1126 25.795 25.1104 21.7714 27.4172Z" fill="##FEDC5A" /><path fill-rule="evenodd" clip-rule="evenodd" d="M36.1129 0.497156C36.3311 0.48545 36.5438 0.564557 36.6948 0.713556C36.8478 0.857634 36.9291 1.056 36.9183 1.25961C35.7293 20.9643 17.4709 27.7932 17.2857 27.8603C17.1982 27.892 17.1053 27.9082 17.0116 27.9079C16.8085 27.9078 16.6138 27.8318 16.4702 27.6965L8.04814 19.7618C7.83535 19.5616 7.76676 19.2624 7.87281 18.9972C7.94325 18.8227 15.102 1.53083 36.1129 0.497156ZM18.5436 14.9238C18.5436 16.5174 19.9147 17.8092 21.6061 17.8092C23.2976 17.8092 24.6687 16.5174 24.6687 14.9238C24.6687 13.3303 23.2976 12.0385 21.6061 12.0385C19.9147 12.0385 18.5436 13.3303 18.5436 14.9238Z" fill="##FEDC5A" /><path d="M10.0212 26.2524C8.11302 24.6824 5.02356 24.6824 3.11535 26.2524C1.35999 27.6992 0.918098 32.5339 0.871711 33.0808C0.856594 33.2665 0.93561 33.4489 1.0899 33.5847C1.24418 33.7204 1.45989 33.7972 1.68551 33.7968L1.74003 33.7968C2.40328 33.7593 8.26669 33.3942 10.0212 31.9481C11.9264 30.3745 11.9264 27.826 10.0212 26.2524Z" fill="##FEDC5A" /></svg>',
            '<svg width="32" height="36" viewBox="0 0 32 36" fill="none" xmlns="http://www.w3.org/2000/svg"><path d="M12.4571 20.6429H0.787724C0.358291 20.6429 0.00976562 20.2994 0.00976562 19.8762V1.4738C0.00976562 1.05054 0.358291 0.707031 0.787724 0.707031H12.4571C12.8865 0.707031 13.2351 1.05054 13.2351 1.4738V19.8762C13.2351 20.2994 12.8865 20.6429 12.4571 20.6429Z" fill="##F04037" /><path d="M12.4571 35.5949H0.787724C0.358291 35.5949 0.00976562 35.236 0.00976562 34.7939V25.1819C0.00976562 24.7398 0.358291 24.3809 0.787724 24.3809H12.4571C12.8865 24.3809 13.2351 24.7398 13.2351 25.1819V34.7939C13.2351 35.236 12.8865 35.5949 12.4571 35.5949Z" fill="##F04037" /><path d="M30.9724 11.921H19.3031C18.8736 11.921 18.5251 11.5621 18.5251 11.12V1.50803C18.5251 1.06588 18.8736 0.707031 19.3031 0.707031H30.9724C31.4019 0.707031 31.7504 1.06588 31.7504 1.50803V11.12C31.7504 11.5621 31.4019 11.921 30.9724 11.921Z" fill="##F04037" /><path d="M30.9722 35.5949H19.3029C18.8734 35.5949 18.5249 35.2514 18.5249 34.8281V16.4257C18.5249 16.0025 18.8734 15.659 19.3029 15.659H30.9722C31.4017 15.659 31.7502 16.0025 31.7502 16.4257V34.8281C31.7502 35.2514 31.4017 35.5949 30.9722 35.5949Z" fill="##F04037" /></svg>',
            '<svg width="46" height="36" viewBox="0 0 46 36" fill="none" xmlns="http://www.w3.org/2000/svg"><path d="M23.9227 35.5949H2.97385C1.39616 35.5949 0.117188 34.3617 0.117188 32.8406V3.46133C0.117187 1.94017 1.39616 0.707031 2.97385 0.707031H23.9227V2.54323H2.97385C2.44795 2.54323 2.02163 2.95428 2.02163 3.46133V32.8406C2.02163 33.3476 2.44795 33.7587 2.97385 33.7587H23.9227V35.5949Z" fill="##5454D4" /><path fill-rule="evenodd" clip-rule="evenodd" d="M26.5679 0.707031H42.1598C43.7744 0.707031 45.0833 1.94017 45.0833 3.46133V32.8406C45.0833 34.3617 43.7744 35.5949 42.1598 35.5949H26.5679V0.707031ZM32.4151 26.4139H39.2365C39.7747 26.4139 40.211 26.0028 40.211 25.4958C40.211 24.9887 39.7747 24.5777 39.2365 24.5777H32.4151C31.8769 24.5777 31.4406 24.9887 31.4406 25.4958C31.4406 26.0028 31.8769 26.4139 32.4151 26.4139ZM39.2365 19.069H32.4151C31.8769 19.069 31.4406 18.658 31.4406 18.1509C31.4406 17.6439 31.8769 17.2328 32.4151 17.2328H39.2365C39.7747 17.2328 40.211 17.6439 40.211 18.1509C40.211 18.658 39.7747 19.069 39.2365 19.069ZM32.4151 11.7242H39.2365C39.7747 11.7242 40.211 11.3132 40.211 10.8061C40.211 10.2991 39.7747 9.88802 39.2365 9.88802H32.4151C31.8769 9.88802 31.4406 10.2991 31.4406 10.8061C31.4406 11.3132 31.8769 11.7242 32.4151 11.7242Z" fill="##5454D4" /></svg>',
            '<svg width="39" height="43" viewBox="0 0 39 43" fill="none" xmlns="http://www.w3.org/2000/svg"><path d="M27.8364 0.931152H11.2231C3.95483 0.931152 0.839844 5.08447 0.839844 11.3144V32.081C0.839844 38.311 3.95483 42.4643 11.2231 42.4643H27.8364C35.1047 42.4643 38.2197 38.311 38.2197 32.081V11.3144C38.2197 5.08447 35.1047 0.931152 27.8364 0.931152ZM11.2231 22.2169H19.5298C20.3812 22.2169 21.0873 22.923 21.0873 23.7744C21.0873 24.6258 20.3812 25.3319 19.5298 25.3319H11.2231C10.3717 25.3319 9.66564 24.6258 9.66564 23.7744C9.66564 22.923 10.3717 22.2169 11.2231 22.2169ZM27.8364 33.6385H11.2231C10.3717 33.6385 9.66564 32.9324 9.66564 32.081C9.66564 31.2296 10.3717 30.5235 11.2231 30.5235H27.8364C28.6878 30.5235 29.3939 31.2296 29.3939 32.081C29.3939 32.9324 28.6878 33.6385 27.8364 33.6385ZM33.028 15.9869H28.8747C25.7182 15.9869 23.1639 13.4326 23.1639 10.2761V6.12279C23.1639 5.27137 23.87 4.5653 24.7214 4.5653C25.5728 4.5653 26.2789 5.27137 26.2789 6.12279V10.2761C26.2789 11.709 27.4418 12.8719 28.8747 12.8719H33.028C33.8795 12.8719 34.5855 13.578 34.5855 14.4294C34.5855 15.2809 33.8795 15.9869 33.028 15.9869Z" fill="##5454D4" /></svg>',
            '<svg width="39" height="38" viewBox="0 0 39 38" fill="none" xmlns="http://www.w3.org/2000/svg"><path d="M0.749191 18.8651C0.749191 15.4047 0.735162 11.9396 0.753867 8.4792C0.777249 4.42957 3.49415 1.14685 7.45493 0.351883C7.94593 0.253682 8.45097 0.211596 8.95132 0.211596C15.933 0.202243 22.9099 0.183539 29.8915 0.211596C33.9178 0.225625 37.1865 2.97058 37.9674 6.92201C38.075 7.47848 38.1077 8.05366 38.1077 8.62416C38.1171 15.4655 38.1171 22.3115 38.1124 29.1529C38.1077 33.3054 35.4423 36.5975 31.4254 37.4158C30.939 37.514 30.4293 37.5608 29.929 37.5608C22.938 37.5701 15.9423 37.5935 8.95132 37.5561C4.93911 37.5374 1.69379 34.8065 0.903507 30.8691C0.786601 30.2892 0.763219 29.6813 0.758543 29.0874C0.744514 25.6831 0.749191 22.2741 0.749191 18.8651ZM21.5211 11.3224C20.9365 11.3224 20.4596 11.6965 20.2445 12.3371C19.211 15.4328 18.1776 18.5331 17.1441 21.6288C16.8027 22.6576 16.4473 23.6817 16.1153 24.7151C15.9049 25.3698 16.1855 26.0151 16.756 26.305C17.3078 26.5856 17.9858 26.4453 18.3599 25.9403C18.5002 25.7486 18.5937 25.5148 18.6686 25.2856C19.7675 21.9982 20.8617 18.7061 21.9606 15.4141C22.2178 14.6425 22.4891 13.8756 22.7322 13.0993C23.0221 12.1921 22.4189 11.3224 21.5211 11.3224ZM10.8359 18.8838C11.9348 17.7896 12.9963 16.7421 14.0484 15.6806C14.6096 15.1148 14.6143 14.3105 14.0905 13.7914C13.5621 13.2723 12.7671 13.2911 12.2013 13.8569C10.8452 15.2083 9.48909 16.5597 8.13766 17.9205C7.54378 18.5191 7.54845 19.2626 8.14233 19.8705C8.73154 20.4691 9.3301 21.063 9.92866 21.6569C10.7049 22.4331 11.4765 23.2187 12.2621 23.9856C12.683 24.3971 13.2675 24.4766 13.7679 24.2241C14.2589 23.9763 14.5628 23.4666 14.4506 22.9101C14.3851 22.6015 14.2027 22.2741 13.983 22.045C12.9635 20.9835 11.9114 19.9594 10.8359 18.8838ZM28.0164 18.8792C27.8901 19.0101 27.8013 19.1083 27.7031 19.2065C26.7444 20.1698 25.7811 21.1238 24.8225 22.0917C24.2613 22.6622 24.2426 23.4525 24.7664 23.981C25.2854 24.5047 26.0898 24.4953 26.6556 23.9342C28.0164 22.5874 29.3678 21.2313 30.7192 19.8752C31.3272 19.2626 31.3178 18.5238 30.7005 17.8972C30.1862 17.3734 29.6624 16.859 29.148 16.34C28.3016 15.4936 27.4693 14.6378 26.6088 13.8101C25.884 13.1087 24.7196 13.4033 24.4484 14.3479C24.2941 14.8763 24.4484 15.3299 24.8412 15.718C25.8934 16.7515 26.9362 17.799 28.0164 18.8792Z" fill="##FEDC5A"/></svg>',
            '<svg width="46" height="21" viewBox="0 0 46 21" fill="none" xmlns="http://www.w3.org/2000/svg"><path d="M36.4369 4.29427C33.2384 4.29427 27.907 7.92712 22.2638 11.7738C17.3087 15.1515 11.6919 18.9798 9.06625 18.9798C5.29399 18.9798 2.2236 16.0969 2.2236 12.5549C2.2236 9.01293 5.29399 6.12997 9.06625 6.12997C9.72706 6.12997 10.6215 6.36586 11.6938 6.79816L9.23438 11.0212C9.05061 11.3351 9.07994 11.7206 9.30672 12.0079C9.49245 12.2447 9.78571 12.3787 10.0917 12.3787C10.1572 12.3787 10.2256 12.3723 10.2921 12.3594L19.0409 10.6421C19.3185 10.587 19.558 10.4227 19.6958 10.1887C19.8337 9.95464 19.8561 9.67654 19.7574 9.42688L16.6362 1.48015C16.5032 1.14238 16.1728 0.908329 15.7906 0.882629C15.4153 0.853258 15.0448 1.04233 14.862 1.35807L12.6323 5.18734C11.2178 4.60267 10.0184 4.29427 9.06625 4.29427C4.21481 4.29427 0.268555 7.99963 0.268555 12.5549C0.268555 17.1102 4.21481 20.8155 9.06625 20.8155C12.3263 20.8155 17.7115 17.1451 23.4124 13.2598C28.3146 9.91793 33.8728 6.12997 36.4369 6.12997C40.2091 6.12997 43.2795 9.01293 43.2795 12.5549C43.2795 16.0969 40.2091 18.9798 36.4369 18.9798C34.8885 18.9798 32.0752 17.7307 28.515 15.4617C28.0693 15.1754 27.4613 15.2873 27.1572 15.7059C26.8532 16.1253 26.9705 16.6962 27.4173 16.9808C31.4095 19.5251 34.4447 20.8155 36.4369 20.8155C41.2883 20.8155 45.2346 17.1102 45.2346 12.5549C45.2346 7.99963 41.2883 4.29427 36.4369 4.29427Z" fill="##5454D4" /></svg>',
            '<svg width="39" height="38" viewBox="0 0 39 38" fill="none" xmlns="http://www.w3.org/2000/svg"><path d="M6.47793 29.2181C2.36642 28.2201 0.412581 24.6568 0.742907 21.4238C1.04512 18.5211 2.99896 15.8926 6.44981 15.0633C6.45684 14.9016 6.4709 14.7259 6.4709 14.5572C6.4709 12.3152 6.48495 10.0662 6.46387 7.8242C6.45684 7.14949 6.78717 6.72077 7.34239 6.43964C7.5181 6.34828 7.743 6.33422 7.94682 6.33422C10.1748 6.32719 12.4027 6.32719 14.6377 6.32719C14.8134 6.32719 14.9961 6.32719 15.214 6.32719C15.6568 4.35929 16.704 2.82012 18.3767 1.72372C19.7823 0.80302 21.3356 0.423497 22.9872 0.592174C25.4681 0.845189 28.413 2.49682 29.3477 6.30611C29.5094 6.31314 29.6851 6.32719 29.8608 6.32719C32.1028 6.32719 34.3518 6.33422 36.5938 6.32016C37.2685 6.31314 37.6902 6.65049 37.9784 7.20572C38.0486 7.34628 38.0768 7.52199 38.0838 7.67661C38.0908 10.5793 38.0908 13.4819 38.0838 16.3846C38.0838 17.2279 37.4723 17.7972 36.6289 17.8183C34.5275 17.8745 32.8267 19.3294 32.4261 21.3605C31.9903 23.5744 33.5436 25.964 35.905 26.3435C36.1862 26.3857 36.4673 26.449 36.7484 26.4279C37.3388 26.3787 38.1119 27.1939 38.1049 27.7984C38.0768 30.687 38.0978 33.5756 38.0908 36.4641C38.0908 37.3356 37.4864 37.933 36.6219 37.933C27.0635 37.933 17.4982 37.933 7.93979 37.933C7.08235 37.933 6.48495 37.3216 6.48495 36.4571C6.48495 34.2151 6.48495 31.9661 6.48495 29.7241C6.47792 29.5554 6.47793 29.3797 6.47793 29.2181Z" fill="##FEDC5A" /></svg>',
            '<svg width="41" height="36" viewBox="0 0 41 36" fill="none" xmlns="http://www.w3.org/2000/svg"><path fill-rule="evenodd" clip-rule="evenodd" d="M35.8418 0.685791H4.79111C2.40933 0.685791 0.478516 2.54527 0.478516 4.83906V23.1134C0.478516 24.215 0.932877 25.2714 1.74165 26.0502C2.55041 26.8291 3.64734 27.2667 4.79111 27.2667H13.0023L19.6437 35.2617C19.8074 35.4589 20.0552 35.5736 20.3173 35.5736C20.5794 35.5736 20.8273 35.4589 20.9909 35.2617L27.6306 27.2667H35.8418C38.2236 27.2667 40.1544 25.4072 40.1544 23.1134V4.83906C40.1544 2.54527 38.2236 0.685791 35.8418 0.685791ZM22.1349 18.1298H10.5628C10.1063 18.1298 9.73619 17.8509 9.73619 17.5068C9.73619 17.1628 10.1063 16.8839 10.5628 16.8839H22.1349C22.5914 16.8839 22.9615 17.1628 22.9615 17.5068C22.9615 17.8509 22.5914 18.1298 22.1349 18.1298ZM10.6009 10.6538H31.3545C31.832 10.6538 32.2192 10.3748 32.2192 10.0308C32.2192 9.6867 31.832 9.40777 31.3545 9.40777H10.6009C10.1233 9.40777 9.73619 9.6867 9.73619 10.0308C9.73619 10.3748 10.1233 10.6538 10.6009 10.6538Z" fill="##F04037" /></svg>',
            '<svg width="38" height="38" viewBox="0 0 38 38" fill="none" xmlns="http://www.w3.org/2000/svg"><path d="M38.0052 6.09267C38.0052 14.8518 38.0052 23.611 38.0052 32.3701C37.9856 32.4092 37.9563 32.4581 37.9367 32.4972C37.7314 33.1718 37.3208 33.6801 36.6756 33.9831C36.0598 34.2764 35.4439 34.5697 34.828 34.8727C33.2834 35.6255 31.7291 36.3685 30.1845 37.1212C29.7543 37.3265 29.3242 37.5318 28.8941 37.7273C27.9263 38.177 26.802 37.8348 26.2644 37.2287C25.8049 36.7106 25.3357 36.2023 24.8664 35.6841C24.2897 35.0585 23.7129 34.4231 23.1361 33.7974C22.8428 33.4748 22.5398 33.1522 22.2465 32.8296C21.6306 32.1453 21.0147 31.4512 20.3891 30.7669C20.1154 30.4638 19.8319 30.1608 19.5484 29.848C18.7565 28.9584 17.9647 28.0688 17.1631 27.1792C16.5863 26.534 15.99 25.9083 15.4132 25.2631C15.0906 24.9014 14.7778 24.5299 14.4454 24.1682C14.2401 23.9434 14.025 23.7381 13.8099 23.5132C13.2918 23.9434 12.7933 24.3442 12.2947 24.7548C11.5908 25.3315 10.8772 25.9083 10.1733 26.4851C9.38149 27.1303 8.58965 27.7853 7.80758 28.4305C7.28946 28.8606 6.79089 29.3005 6.27277 29.7209C6.0577 29.8968 5.84263 30.0826 5.59824 30.2097C5.11922 30.4541 4.63043 30.3856 4.15141 30.1803C3.29114 29.8089 2.43086 29.4276 1.56081 29.0855C0.974264 28.8606 0.505023 28.2056 0.514798 27.5604C0.544126 25.8399 0.524575 24.1193 0.524575 22.3988C0.524575 18.5666 0.53435 14.7345 0.514798 10.9024C0.514798 10.2963 0.984041 9.62175 1.52171 9.42623C1.73678 9.34802 1.95185 9.25027 2.16692 9.16228C2.89033 8.86901 3.60397 8.54641 4.33715 8.28246C4.93348 8.06739 5.51026 8.12604 6.00882 8.56596C6.39008 8.88856 6.78111 9.20138 7.16237 9.51421C8.19861 10.3647 9.22508 11.225 10.2613 12.0755C11.1998 12.8478 12.1383 13.6201 13.0865 14.3924C13.3309 14.5879 13.5753 14.7736 13.8197 14.9691C14.0641 14.7345 14.289 14.5292 14.4943 14.3044C15.2959 13.4148 16.0877 12.5252 16.8796 11.6356C17.4563 10.9904 18.0527 10.3647 18.6294 9.71951C18.8836 9.44578 19.1378 9.16228 19.392 8.87878C20.1642 8.01851 20.9268 7.14846 21.6991 6.28818C22.3052 5.62343 22.921 4.95867 23.5271 4.29391C23.7618 4.02996 23.9964 3.76602 24.2408 3.51185C24.9251 2.74933 25.5898 1.97704 26.3035 1.24385C26.9682 0.569319 27.7894 0.393353 28.6888 0.696404C29.0016 0.803938 29.2949 0.9408 29.5979 1.08744C30.8199 1.67399 32.0419 2.25076 33.2541 2.84709C34.3979 3.40431 35.5319 3.96154 36.6756 4.51876C37.1742 4.76315 37.5457 5.12486 37.7803 5.6332C37.8585 5.80917 37.9367 5.94603 38.0052 6.09267ZM19.0107 19.2705C22.2269 21.91 25.4041 24.5104 28.6301 27.1596C28.6301 21.9589 28.6301 16.8168 28.6301 11.6747C28.6301 11.6062 28.6008 11.5378 28.5812 11.4107C25.3748 14.0404 22.2172 16.6408 19.0107 19.2705ZM5.26586 14.0111C5.18765 14.6563 5.21698 24.2073 5.28541 24.4615C5.64712 24.1584 9.80185 19.5051 9.95826 19.2118C8.41368 17.5011 6.85932 15.7805 5.26586 14.0111Z" fill="##5454D4" /></svg>'
        ];
        return svgIcons;
    }

    private struct function getGuidesContent() {
        var allowedItems = [
            "/guides/introduction",
            "/guides/command-line-tools",
            "/guides/working-with-cfwheels",
            "/guides/handling-requests-with-controllers",
            "/guides/displaying-views-to-users",
            "/guides/database-interaction-through-models",
            "/guides/plugins"
        ];
        
        var guidesStruct = {};

        for (var item in allowedItems) {
            var absolutePath = "../.." & item;

            // If it's a directory, get the first file only
            if (directoryExists(absolutePath)) {
                var fileList = directoryList(absolutePath, false, "query", "*.md");
                if (fileList.recordcount > 0) {
                    var firstFile = fileList.name[1];
                    var filePath = "./.." & item & "/" & firstFile;
                    guidesStruct[item] = readFileContent(filePath);
                }
            }
        }

        return guidesStruct;
    }

    private array function getSpecificFiles() {
        var allowedItems = [
            "/guides/introduction",
            "/guides/command-line-tools",
            "/guides/working-with-cfwheels",
            "/guides/handling-requests-with-controllers",
            "/guides/displaying-views-to-users",
            "/guides/database-interaction-through-models",
            "/guides/plugins"
        ];
        var filesArray = [];

        for (var item in allowedItems) {
            var absolutePath = "../.." & item;

            // If it's a file (contains an extension)
            if (reFind("\.\w+$", item)) {
                if (fileExists(absolutePath)) {
                    arrayAppend(filesArray, item);
                }
            } 
            // If it's a directory (no extension)
            else if (directoryExists(absolutePath)) {
                var fileList = directoryList(absolutePath, false, "query");
                for (var i = 1; i <= fileList.recordcount; i++) {
                    arrayAppend(filesArray, "./.." & item & "/" & fileList.name[i]);
                }
            }
        }

        return filesArray;
    }

    private string function readFileContent(string filePath) {
        var absolutePath = ExpandPath(filePath);
        if (fileExists(absolutePath)) {
            return fileRead(absolutePath);
        } else {
            return "File not found: " & absolutePath;
        }
    }

    function sitemap() {
        try {
            model("Log").log(
                category = "wheels.seo",
                level = "DEBUG",
                message = "Generating sitemap.xml",
                details = {
                    "ip_address": cgi.REMOTE_ADDR
                }
            );
            
            // Get all public URLs that should be in sitemap
            urls = [];
            
            // Add static pages
            arrayAppend(urls, {
                loc: getBaseUrl(),
                lastmod: dateFormat(now(), "yyyy-mm-dd"),
                changefreq: "daily",
                priority: "1.0"
            });
            
            // Add blog posts
            var blogPosts = model("Blog").findAll(where="statusid <> 1 AND status = 'Approved' AND isPublished = 'true'");
            for (var post in blogPosts) {
                arrayAppend(urls, {
                    loc: getBaseUrl() & "/blog/" & post.slug,
                    lastmod: dateFormat(post.updatedAt, "yyyy-mm-dd"),
                    changefreq: "weekly",
                    priority: "0.8"
                });
            }
            
            // Add blog author pages
            var authors = model("Blog").findAll(
                select="username",
                include="User",
                distinct="true",
                where="statusid <> 1 AND status = 'Approved' AND isPublished = 'true' AND createdBy IS NOT NULL"
            );
            for (var author in authors) {
                arrayAppend(urls, {
                    loc: getBaseUrl() & "/blog/author/" & author.username,
                    lastmod: dateFormat(now(), "yyyy-mm-dd"),
                    changefreq: "weekly",
                    priority: "0.7"
                });
            }
            
            // Add blog categories
            var blogCategories = model("BlogCategory").getAll();
            var distinctCategories = {};
            for (var i=1; i LTE blogCategories.recordCount; i++) {
                var categoryName = blogCategories.name[i];
                if (!structKeyExists(distinctCategories, categoryName)) {
                    distinctCategories[categoryName] = true;
                }
            }
            for (var categoryName in structKeyArray(distinctCategories)) {
                var sanitizedCategoryName = replace(categoryName, ".", "-", "all");
                sanitizedCategoryName = replace(sanitizedCategoryName, " ", "-", "all");
                arrayAppend(urls, {
                    loc: getBaseUrl() & "/blog/category/" & sanitizedCategoryName,
                    lastmod: dateFormat(now(), "yyyy-mm-dd"),
                    changefreq: "weekly",
                    priority: "0.7"
                });
            }
            
            // Add blog tags
            var tags = model("Tag").getAll();
            var distinctTags = {};
            for (var tag in tags) {
                var tagName = replace(tag.name, ".", "-", "all");
                tagName = replace(tagName, " ", "-", "all");
                distinctTags[tagName] = true;
            }
            for (var tagName in structKeyArray(distinctTags)) {
                arrayAppend(urls, {
                    loc: getBaseUrl() & "/blog/tag/" & tagName,
                    lastmod: dateFormat(now(), "yyyy-mm-dd"),
                    changefreq: "weekly",
                    priority: "0.7"
                });
            }
            // Add guide pages from /docs/*/guides/summary.md
            var docsPath = expandPath("../docs");
            var allEntries = directoryList(docsPath, false, "name");
            var docVersions = [];

            for (var entry in allEntries) {
                if (directoryExists(docsPath & "/" & entry)) {
                    arrayAppend(docVersions, entry);
                }
            }
            for (version in docVersions) {
                var summaryFilePath = docsPath & "/" & version & "/guides/summary.md";
                if (fileExists(summaryFilePath)) {
                    var summaryData = summaryToJson(summaryFilePath, version);
                    function collectGuideUrls(nodes) {
                        for (var node in nodes) {
                            if (structKeyExists(node, "path")) {
                                if (!reFind("^https?://", node.path)) {
                                    var loc = replace(node.path, "#version#", version, "all");
                                    arrayAppend(urls, {
                                        loc: getBaseUrl() & loc,
                                        lastmod: dateFormat(now(), "yyyy-mm-dd"),
                                        changefreq: "weekly",
                                        priority: "0.7"
                                    });
                                }
                            }
                            if (arrayLen(node.children)) {
                                collectGuideUrls(node.children);
                            }
                        }
                    }

                    collectGuideUrls(summaryData);
                }
            }
            // Add other public pages
            var publicPages = [
                "/blog",
                "/docs",
                "/community",
                "/news",
                "/downloads",
                "/api/v3.0.0",
                "/api/v2.5.0",
                "/api/v2.4.0",
                "/api/v2.3.0",
                "/api/v2.2.0",
                "/api/v2.1.0",
                "/api/v2.0.0",
                "/api/v1.4.5",
                "/login",
                "/register",
                "/verify",
                "/api",
                "/blog/feed",
                "/comment/feed",
                "/guides"
            ];
            
            for (var page in publicPages) {
                arrayAppend(urls, {
                    loc: getBaseUrl() & page,
                    lastmod: dateFormat(now(), "yyyy-mm-dd"),
                    changefreq: "weekly",
                    priority: "0.7"
                });
            }
            
            // Generate XML
            var xml = '<?xml version="1.0" encoding="UTF-8"?>
<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">';
            
            for (var link in urls) {
                xml &= '
    <url>
        <loc>#link.loc#</loc>
        <lastmod>#link.lastmod#</lastmod>
        <changefreq>#link.changefreq#</changefreq>
        <priority>#link.priority#</priority>
    </url>';
            }
            
            xml &= '
</urlset>';

            var sitemapPath = expandPath("/sitemap/sitemap.xml");
            model("Log").log(
                category = "wheels.seo",
                level = "DEBUG", 
                message = "Attempting to write sitemap",
                details = {
                    "resolved_path": sitemapPath,
                    "directory_exists": directoryExists(getDirectoryFromPath(sitemapPath)),
                    "current_template_path": getCurrentTemplatePath()
                }
            );

            
            // Save the sitemap to the public directory
            fileWrite(sitemapPath, xml);
            
            // Log success
            model("Log").log(
                category = "wheels.seo",
                level = "INFO",
                message = "Sitemap generated successfully",
                details = {
                    "urls_count": arrayLen(urls),
                    "generated_at": now()
                }
            );
            
            // Show success message with link to sitemap
            renderText(text="Sitemap generated successfully! <a href='/sitemap.xml'>View Sitemap</a>");
            
        } catch (any e) {
            model("Log").log(
                category = "wheels.seo",
                level = "ERROR",
                message = "Failed to generate sitemap.xml",
                details = {
                    "error_message": e.message,
                    "error_detail": e.detail,
                    "ip_address": cgi.REMOTE_ADDR
                }
            );
            // Show error message
            renderText(text="Failed to generate sitemap. Please try again later.");
        }
    }
    
    function downloads() {
        // redirectTo(url="https://github.com/wheels-dev/wheels/releases", statusCode=301);
    }

    private string function getBaseUrl() {
       return application.env.application_host;
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
}