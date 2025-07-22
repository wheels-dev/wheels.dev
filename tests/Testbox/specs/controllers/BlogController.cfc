component extends="testbox.system.BaseSpec" {
    function beforeAll(){
        requestServer= application.env.application_host;
        authenticate = "#requestServer#/auth/authenticate";
        blogs = "#requestServer#/blog";
        category = "#requestServer#/blog/list/category/Community";
        tag = "#requestServer#/blog/list/tag/CRUD";
        archive = "#requestServer#/blog/list/2025/03";
        search = "#requestServer#/blog/Search";
        storeBlog = "#requestServer#/blog/store";


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
        describe("Blogs Functions Tests", function() {
            it("it should return 200 status code for blogs", function(done) {
                var response = "";

                cfhttp(url = "#blogs#", method ="Get", result = "local.response"){
                    cfhttpparam(type="header", name="Cookie", value= "#authCookies#");
                };
                // Assert
                expect(local.response.status_code).toBe(200);
                expect(local.response.error).toBe("false");
            });

            it("it should return 200 status code for blog search filter", function(done) {
                var response = "";

                cfhttp(url = "#search#", method ="Get", result = "local.response"){
                    cfhttpparam(type="header", name="Cookie", value= "#authCookies#");
                    cfhttpparam(type="URL", name="searchTerm", value="");
                };

                // Assert
                expect(local.response.status_code).toBe(200);
                expect(local.response.error).toBe("false");
            });

            it("it should return 200 status code for blog category filter", function(done) {
                var responses = "";
                cfhttp(url = "#category#", method ="Get", result = "local.response"){
                    cfhttpparam(type="header", name="Cookie", value= "#authCookies#");
                };

                // Assert
                expect(local.response.status_code).toBe(200);
                expect(local.response.error).toBe("false");
            });

            it("it should return 200 status code for blog tag filter", function(done) {
                var response = "";

                cfhttp(url = "#tag#", method ="Get", result = "local.response"){
                    cfhttpparam(type="header", name="Cookie", value= "#authCookies#");
                };

                // Assert
                expect(local.response.status_code).toBe(200);
                expect(local.response.error).toBe("false");
            });

            it("it should return 200 status code for blog archive filter", function(done) {
                var response = "";

                cfhttp(url = "#archive#", method ="Get", result = "local.response"){
                    cfhttpparam(type="header", name="Cookie", value= "#authCookies#");
                };

                // Assert
                expect(local.response.status_code).toBe(200);
                expect(local.response.error).toBe("false");
            });
            it("it should return 200 status code after store the blog", function(done) {
                var response = "";
                cfhttp(url = "#storeBlog#", method ="POST", result = "local.response"){
                    cfhttpparam(type="header", name="Cookie", value= "#authCookies#");
                    cfhttpparam(type="formField", name="title", value="Test Blog");
                    cfhttpparam(type="formField", name="categoryId", value="1");
                    cfhttpparam(type="formField", name="posttypeId", value="1");
                    cfhttpparam(type="formField", name="posttags", value="Test");
                    cfhttpparam(type="formField", name="postCreatedDate", value="#dateformat(now(), "YYYY-MM-DD")#");
                    cfhttpparam(type="formField", name="content", value="Test Data");
                    cfhttpparam(type="formField", name="isDraft", value="0");
                };
                // Assert
                expect(local.response.status_code).toBe(200);
                expect(local.response.error).toBe("false");
            });
        });
    }
}