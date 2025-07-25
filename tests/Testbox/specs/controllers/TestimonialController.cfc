component extends="testbox.system.BaseSpec" {
    function beforeAll(){
        // Assert clean state before test
        var userModel = application.wo.model("User");
        var testUser = userModel.findOne(where="email='testuser@pai.com'");
        requestServer= application.env.application_host;
        authenticate = "#requestServer#/auth/authenticate";
        newTestimonial = "#requestServer#/testimonial/new";
        createTestimonial = "#requestServer#/testimonial/create";

        local.AssetPath = "/app/"
        application.wo.set(controllerPath = local.AssetPath & "controllers")
        application.wo.set(viewPath = local.AssetPath & "views")
        application.wo.set(modelPath = local.AssetPath & "models")
        var userModel = application.wo.model("User");
        var testUser = userModel.findOne(where="email='testuser@pai.com'");
        if (isObject(testUser)) {
            if (structKeyExists(testUser, "deletedAt") && len(testUser.deletedAt)) {
                testUser.deletedAt = "";
                testUser.isActive = true;
                testUser.save();
            }
        } else {
            testUser = userModel.new();
            testUser.email = "testuser@pai.com";
            testUser.passwordHash = application.WHEELS.plugins.bcrypt.bCryptHashPW("test1234", application.WHEELS.plugins.bcrypt.bCryptGenSalt());
            testUser.firstname = "Test";
            testUser.lastname = "User";
            testUser.roleId = 2;
            testUser.isActive = true;
            testUser.save();
        }
        // Patch: Set session for test context
        session.userID = testUser.id;
        session.username = "TestUser";

        var Auth;
        cfhttp(url = "#authenticate#", method ="POST", result = "local.Auth"){
            cfhttpparam(type="formField", name="email", value="testuser@pai.com");
            cfhttpparam(type="formField", name="password", value="test1234");
        };

        if (structKeyExists(local.Auth, "responseHeader")) {
            if (structKeyExists(local.Auth.responseHeader, "Set-Cookie")) {
                var cookieArray = local.Auth.responseHeader["Set-Cookie"];
                var cookieParts = [];

                for (cookies in cookieArray) {
                    // Split on semicolon and take only the key=value part
                    arrayAppend(cookieParts, listFirst(cookies, ";"));
                }

                // Join into a single cookie string
                authCookies = arrayToList(cookieParts, "; ");
            }
        }
    }

    function afterAll(){
        local.AssetPath = "/app/"
        application.wo.set(controllerPath = local.AssetPath & "controllers")
        application.wo.set(viewPath = local.AssetPath & "views")
        application.wo.set(modelPath = local.AssetPath & "models")
        var userModel = application.wo.model("User");
        var testUser = userModel.findOne(where="email='testuser@pai.com'");
        if (isObject(testUser)) {
            // Clean up related remember tokens
            var rememberTokenModel = application.wo.model("RememberToken");
            rememberTokenModel.deleteAll(where="userId=#testUser.id#");
            // Clean up related blog posts
            var blogModel = application.wo.model("Blog");
            blogModel.deleteAll(where="createdBy=#testUser.id#");
            // Clean up testimonials
            var testimonialModel = application.wo.model("Testimonial");
            testimonialModel.deleteAll(where="userId=#testUser.id#");
            // Now delete the user
            testUser.delete();
        }
        // Assert user is soft-deleted
        testUser = userModel.findOne(where="email='testuser@pai.com'", includeSoftDeletes=true);
        expect(isObject(testUser) && len(testUser.deletedAt)).toBeTrue("Test user should be soft-deleted after test");
    }
    function run() {
        describe("Tesimonial Form Accessibility Tests", function() {
            it("it should return 200 status code", function(done) {
                var response = "";

                cfhttp(url = "#newTestimonial#", method ="Get", result = "local.response"){
                    cfhttpparam(type="header", name="Cookie", value= "#authCookies#");
                };
                // Assert
                expect(local.response.status_code).toBe(200);
                expect(local.response.error).toBe("false");
            });
        });
        describe("Create Tesimonial Test", function() {
            it("it should return 200 status code", function(done) {
                var response = "";

                cfhttp(url = "#createTestimonial#", method ="POST", result = "local.response"){
                    cfhttpparam(type="header", name="Cookie", value= "#authCookies#");
                    cfhttpparam(type="formField", name="title", value="Testing testimonial");
                    cfhttpparam(type="formField", name="rating", value="1");
                    cfhttpparam(type="formField", name="experienceLevel", value="Advanced");
                    cfhttpparam(type="formField", name="logoPath", value="");
                    cfhttpparam(type="formField", name="content", value="This is a testing testimonial data.");
                    cfhttpparam(type="formField", name="companyName", value="Test company");

                };
                // writeDump(var=local.response, label="Response from create testimonial");
                // Assert
                expect(local.response.status_code).toBe(200);
                expect(local.response.error).toBe("false");
            });
        });
    }
}
