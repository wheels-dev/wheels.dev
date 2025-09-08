component extends="testbox.system.BaseSpec" {
    function beforeAll(){
        local.AssetPath = "/app/"
        application.wo.set(controllerPath = local.AssetPath & "controllers")
        application.wo.set(viewPath = local.AssetPath & "views")
        application.wo.set(modelPath = local.AssetPath & "models")
        requestServer = application.env.application_host;
        apiIndexUrl = requestServer & "/api";
    }
    function afterAll(){
        // No test data to clean up
    }
    function run() {
        describe("API Index", function() {
            it("should load API index for valid version", function() {
                // writeDump(apiIndexUrl); abort;
                var response = "";
                cfhttp(url=apiIndexUrl& "/v3.0.0", method="GET", result="local.response");
                expect(local.response.status_code).toBe(200);
                expect(local.response.filecontent).toContain("3.0.0");
            });
            it("should handle invalid version", function() {
                var response = "";
                cfhttp(url=apiIndexUrl & "/invalid", method="GET", result="local.response");
                expect(local.response.status_code).toBe(200);
            });
        });
    }
} 