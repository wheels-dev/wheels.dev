component extends="testbox.system.BaseSpec" {
    function beforeAll(){
        requestServer= application.env.application_host;
        authenticate = "#requestServer#/auth/authenticate";
        newTestimonial = "#requestServer#/testimonial/new";
        createTestimonial = "#requestServer#/testimonial/create";

        local.AssetPath = "/app/"
        application.wo.set(controllerPath = local.AssetPath & "controllers")
        application.wo.set(viewPath = local.AssetPath & "views")
        application.wo.set(modelPath = local.AssetPath & "models")

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
        local.AssetPath = "/tests/testbox/_assets/"
        application.wo.set(controllerPath = local.AssetPath & "controllers")
        application.wo.set(viewPath = local.AssetPath & "views")
        application.wo.set(modelPath = local.AssetPath & "models")
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
                // Assert
                expect(local.response.status_code).toBe(200);
                expect(local.response.error).toBe("false");
            });
        });
    }
}
