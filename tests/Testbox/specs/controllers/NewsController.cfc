component extends="testbox.system.BaseSpec" {
    function beforeAll(){
        requestServer= application.env.application_host;
        news = "#requestServer#/news";

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
        describe("News Page Accessibility Tests", function() {
            it("it should return 200 status code", function(done) {
                var response = "";

                cfhttp(url = "#news#", method ="Get", result = "local.response");
                // Assert
                expect(response.status_code).toBe(200);
                expect(response.error).toBe("false");
            });
        });
    }
}
