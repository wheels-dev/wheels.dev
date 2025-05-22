component extends="testbox.system.BaseSpec" {
    function beforeAll(){
        requestServer= application.env.application_host;
        authenticate = "#requestServer#/auth/authenticate";
        store = "#requestServer#/auth/store";
        logout = "#requestServer#/logout";
        forgetPassword = "#requestServer#/auth/forgot-password";
        resetPassword = "#requestServer#/auth/send-reset-link";
        
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
        describe("Authenticate Function Tests", function() {
            it("If pass empty form should return status code 401", function() {
                var response = "";

                cfhttp(url = "#authenticate#", method ="POST", result = "local.response");

                // Assert
                var data = deserializeJSON(response.filecontent);
                expect(response.status_code).toBe(401);
                expect(data.success).toBe("false");
            });

            it("If valid user it should return login success message.", function() {
                var response = "";

                cfhttp(url = "#authenticate#", method ="POST", result = "local.response"){
                    cfhttpparam(type="formField", name="email", value="testuser@pai.com");
                    cfhttpparam(type="formField", name="password", value="test1234");
                };

                // Assert
                var data = deserializeJSON(response.filecontent);
                expect(response.status_code).toBe(200);
                expect(data.success).tobe("true");
                expect(data.message).toBe("Login Successful!");
            });
        });

        describe("SignUp Function Tests", function() {
            it("if form is empty should return status code 500", function() {
                var response = "";

                cfhttp(url = "#store#", method ="POST", result = "local.response");

                // Assert
                expect(response.status_code).toBe(500);
            });

            it("If user registered should return success message.", function() {
                var response = "";

                cfhttp(url = "#store#", method ="POST", result = "local.response"){
                    cfhttpparam(type="formField", name="email", value="test@pai.com");
                    cfhttpparam(type="formField", name="passwordHash", value="test1234");
                    cfhttpparam(type="formField", name="firstname", value="test");
                    cfhttpparam(type="formField", name="lastname", value="user");
                };

                // Assert
                expect(response.status_code).toBe(200);
                expect(response.filecontent).toContain("Sign Up successfull. Please check your email to verify your account.");
            });

            it("If user registers with existing email should show error.", function() {
                var response = "";

                cfhttp(url = "#store#", method ="POST", result = "local.response"){
                    cfhttpparam(type="formField", name="email", value="test@pai.com");
                    cfhttpparam(type="formField", name="passwordHash", value="test1234");
                    cfhttpparam(type="formField", name="firstname", value="test");
                    cfhttpparam(type="formField", name="lastname", value="user");
                };

                // Assert
                expect(response.status_code).toBe(200);
                expect(response.filecontent).toContain("A user with the same email already exists.");
            });
        });

        describe("Logout Function Tests", function() {
            it("Should return status code 200", function() {
                var response = "";

                cfhttp(url = "#logout#", method ="GET", result = "local.response");

                // Assert
                expect(response.status_code).toBe(200);
            });
        });

        describe("Forget Password Function Tests", function() {
            it("It return 200 status code and forget password form", function() {
                var response = "";
                cfhttp(url = "#forgetPassword#", method = "Get", result = "local.response");

                // Assert
                expect(response.status_code).toBe(200);
                expect(response.error).toBe("false");
            });
            it("It return not account found and status 200", function() {
                var response = "";
                cfhttp(url = "#resetPassword#", method = "POST", result = "local.response");

                // Assert
                expect(response.status_code).toBe(200);
                expect(response.filecontent).toContain("No account found with that email address.");
                expect(response.error).toBe("false");
            });
            it("It should return Password reset instructions have been sent to your email and status 200", function() {
                var response = "";
                cfhttp(url = "#resetPassword#", method = "POST", result = "local.response"){
                    cfhttpparam(type="formField", name="email", value="test@pai.com");
                };

                // Assert
                expect(response.status_code).toBe(200);
                expect(response.filecontent).toContain("Password reset instructions have been sent to your email.");
                expect(response.error).toBe("false");
            });
        });
    }
}
