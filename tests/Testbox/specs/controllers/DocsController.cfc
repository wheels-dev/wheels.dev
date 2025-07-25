component extends="testbox.system.BaseSpec" {
    function beforeAll(){
        local.AssetPath = "/app/"
        application.wo.set(controllerPath = local.AssetPath & "controllers")
        application.wo.set(viewPath = local.AssetPath & "views")
        application.wo.set(modelPath = local.AssetPath & "models")
        requestServer = application.env.application_host;
        docsIndexUrl = requestServer & "/docs";
    }
    function afterAll(){
        // No test data to clean up
    }
    function run() {
        describe("DocsController", function() {
            it("should load docs index", function() {
                var response = "";
                cfhttp(url=docsIndexUrl, method="GET", result="local.response");
                expect(local.response.status_code).toBe(200);
            });
        });
    }
} 