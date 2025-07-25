component extends="testbox.system.BaseSpec" {
    function beforeAll(){
        local.AssetPath = "/app/"
        application.wo.set(controllerPath = local.AssetPath & "controllers")
        application.wo.set(viewPath = local.AssetPath & "views")
        application.wo.set(modelPath = local.AssetPath & "models")
        requestServer = application.env.application_host;
        guideIndexUrl = requestServer & "/guides";
        guideFileUrl = requestServer & "/guides/3.0.0/introduction";
    }
    function afterAll(){
        // No test data to clean up
    }
    function run() {
        describe("GuideController", function() {
            it("should load guide index", function() {
                var response = "";
                cfhttp(url=guideIndexUrl, method="GET", result="local.response");
                expect(local.response.status_code).toBe(200);
            });
            it("should load specific guide file", function() {
                var response = "";
                cfhttp(url=guideFileUrl, method="GET", result="local.response");
                expect(local.response.status_code).toBe(200);
            });
            it("should handle not found guide file", function() {
                var response = "";
                cfhttp(url=requestServer & "/guides/3.0.0/doesnotexist", method="GET", result="local.response");
                expect(local.response.status_code).toBe(200);
                expect(local.response.filecontent).toContain("not found");
            });
        });
    }
}
