component extends="testbox.system.BaseSpec" {
    function beforeAll(){
        requestServer= application.env.application_host;
        blogs = "#requestServer#/blog";
        search = "#requestServer#/blog/Search"

        local.AssetPath = "/app/"
        application.wo.set(controllerPath = local.AssetPath & "controllers")
        application.wo.set(viewPath = local.AssetPath & "views")
        application.wo.set(modelPath = local.AssetPath & "models")
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

                cfhttp(url = "#blogs#", method ="Get", result = "local.response");

                // Assert
                expect(response.status_code).toBe(200);
                expect(response.error).toBe("false");
            });

            it("it should return 200 status code for blog search filter", function(done) {
                var response = "";

                cfhttp(url = "#search#", method ="Get", result = "local.response"){
                    cfhttpparam(type="URL", name="searchTerm", value="");
                };

                // Assert
                expect(response.status_code).toBe(200);
                expect(response.error).toBe("false");
            });
        });
    }
}