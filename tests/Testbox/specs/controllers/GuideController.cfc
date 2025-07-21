component extends="testbox.system.BaseSpec" {
    function beforeAll(){
        requestServer= application.env.application_host;
        guides = "#requestServer#/guides";
        guides2 = "#requestServer#/2.5.0/guides";
        guides3 = "#requestServer#/3.0.0/guides";

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
        describe("Guides Docs Page Accessibility Test", function() {
            it("it should return 200 status code", function(done) {
                var response = "";

                cfhttp(url = "#guides#", method ="Get", result = "local.response");
                // Assert
                expect(response.status_code).toBe(200);
            });
        });
        describe("Guides Docs Test for 3.0.0 version", function() {
            it("it should return 200 status code", function(done) {
                var response = "";

                cfhttp(url = "#guides3#", method ="Get", result = "local.response");
                // Assert
                expect(response.status_code).toBe(200);
            });
        });
        describe("Guides Docs Test for 2.5.0 version", function() {
            it("it should return 200 status code", function(done) {
                var response = "";

                cfhttp(url = "#guides2#", method ="Get", result = "local.response");
                // Assert
                expect(response.status_code).toBe(200);
            });
        });
    }
}
