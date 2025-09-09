component extends="testbox.system.BaseSpec" {
    function beforeAll(){
        local.AssetPath = "/app/"
        application.wo.set(controllerPath = local.AssetPath & "controllers")
        application.wo.set(viewPath = local.AssetPath & "views")
        application.wo.set(modelPath = local.AssetPath & "models")
        requestServer = application.env.application_host;
        newsUrl = requestServer & "/news";
    }
    function afterAll(){
        // No test data to clean up
    }
    function run() {
        describe("NewsController", function() {
            it("should load news page", function() {
                var response = "";
                cfhttp(url=newsUrl, method="GET", result="local.response");
                expect(local.response.status_code).toBe(200);
            });
        });
    }
}
