component extends="testbox.system.BaseSpec" {
    function beforeAll(){
        // Assert clean state before test
        local.AssetPath = "/app/"
        application.wo.set(controllerPath = local.AssetPath & "controllers")
        application.wo.set(viewPath = local.AssetPath & "views")
        application.wo.set(modelPath = local.AssetPath & "models")

        var userModel = application.wo.model("User");
        var users = userModel.deleteAll(where="email LIKE 'test%@pai.com'");
        // Clear login attempts for all test emails
        var loginAttemptModel = application.wo.model("LoginAttempt");
        loginAttemptModel.deleteAll(where="email='testuser@pai.com'");
        loginAttemptModel.deleteAll(where="email='nouser@pai.com'");
        loginAttemptModel.deleteAll(where="email='locktest@pai.com'");
        requestServer= application.env.application_host;
        authenticate = "#requestServer#/auth/authenticate";
        store = "#requestServer#/auth/store";
        logout = "#requestServer#/logout";
        forgetPassword = "#requestServer#/auth/forgot-password";
        resetPassword = "#requestServer#/auth/send-reset-link";
        
        var userModel = application.wo.model("User");
        var testUser = userModel.findOne(where="email='testuser@pai.com'", includeSoftDeletes=true);
        if (isObject(testUser)) {
            if (structKeyExists(testUser, "deletedAt") && len(testUser.deletedAt)) {
                testUser.deletedAt = "";
            }
            testUser.isActive = true;
            testUser.locked = false;
            if (structKeyExists(testUser, "failedAttempts")) testUser.failedAttempts = 0;
            testUser.save();
        }
    }

    function afterAll(){
        local.AssetPath = "/app/"
        application.wo.set(controllerPath = local.AssetPath & "controllers")
        application.wo.set(viewPath = local.AssetPath & "views")
        application.wo.set(modelPath = local.AssetPath & "models")
        // Clean up all test users created by signup tests
        var userModel = application.wo.model("User");
        var users = userModel.findAll(where="email LIKE 'test%@pai.com'", includeSoftDeletes=true);
        var rememberTokenModel = application.wo.model("RememberToken");
        var blogModel = application.wo.model("Blog");
        var testimonialModel = application.wo.model("Testimonial");
        for (var i=1; i <= users.recordCount(); i++) {
            rememberTokenModel.deleteAll(where="userId=#users.id[i]#");
            blogModel.deleteAll(where="createdBy=#users.id[i]#");
            testimonialModel.deleteAll(where="userId=#users.id[i]#");
        }
        // Now delete the users
        userModel.deleteAll(where="email LIKE 'test%@pai.com'");
        // Assert clean state after test
        var users = userModel.findAll(where="email LIKE 'test%@pai.com'");
        expect(users.recordCount()).toBe(0, "All test users should be deleted after test");
    }
    function run() {
        describe("Authenticate Function Tests", function() {
            beforeEach(function() {
                // Ensure user is not locked before each login test
                var userModel = application.wo.model("User");
                var testUser = userModel.findOne(where="email='testuser@pai.com'", includeSoftDeletes=true);
                if (isObject(testUser)) {
                    testUser.locked = false;
                    if (structKeyExists(testUser, "failedAttempts")) testUser.failedAttempts = 0;
                    testUser.isActive = true;
                    testUser.save();
                }
            });
            it("If pass empty form should return status code 400", function() {
                var response = "";

                cfhttp(url = "#authenticate#", method ="POST", result = "local.response");

                // Assert
                var data = deserializeJSON(response.filecontent);
                expect(response.status_code).toBe(400);
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
                expect(data.success).toBe("true");
                expect(data.message).toContain("Login Successful");
            });
            it("If invalid password should return status code 400", function() {
                var response = "";
                cfhttp(url = "#authenticate#", method ="POST", result = "local.response"){
                    cfhttpparam(type="formField", name="email", value="testuser@pai.com");
                    cfhttpparam(type="formField", name="password", value="wrongpassword");
                };
                var data = deserializeJSON(response.filecontent);
                expect(response.status_code).toBe(400);
                expect(data.success).toBe("false");
                expect(data.message).toContain("Invalid login credentials");
            });
            it("If non-existent user should return status code 400", function() {
                var response = "";
                cfhttp(url = "#authenticate#", method ="POST", result = "local.response"){
                    cfhttpparam(type="formField", name="email", value="nouser@pai.com");
                    cfhttpparam(type="formField", name="password", value="irrelevant");
                };
                var data = deserializeJSON(response.filecontent);
                expect(response.status_code).toBe(400);
                expect(data.success).toBe("false");
            });
            it("If inactive account should return status code 400", function() {
                // First create an inactive user for testing
                var userModel = application.wo.model("User");
                var inactiveUser = userModel.new();
                inactiveUser.email = "inactive@pai.com";
                inactiveUser.passwordHash = bCryptHashPW("test1234", bCryptGenSalt());
                inactiveUser.firstname = "Inactive";
                inactiveUser.lastname = "User";
                inactiveUser.status = false; // Set as inactive
                inactiveUser.roleId = 1; // Default role
                inactiveUser.save();
                
                var response = "";
                cfhttp(url = "#authenticate#", method ="POST", result = "local.response"){
                    cfhttpparam(type="formField", name="email", value="inactive@pai.com");
                    cfhttpparam(type="formField", name="password", value="test1234");
                };
                var data = deserializeJSON(response.filecontent);
                expect(response.status_code).toBe(400);
                expect(data.success).toBe("false");
                expect(data.message).toContain("not verified");
                
                // Clean up - delete the test user
                inactiveUser.delete();
            });
            // Simulate lockout: try 3 failed logins
            it("Should lock account after multiple failed attempts (existing user only)", function() {
                // Create a user to lock
                var userModel = application.wo.model("User");
                var lockUser = userModel.new();
                lockUser.email = "locktest@pai.com";
                lockUser.passwordHash = bCryptHashPW("wrongpass", bCryptGenSalt());
                lockUser.firstname = "Lock";
                lockUser.lastname = "Test";
                lockUser.status = true;
                lockUser.roleId = 3;
                lockUser.save();
                var response = "";
                for (var i=1; i<=4; i++) {
                    cfhttp(url = "#authenticate#", method ="POST", result = "local.response"){
                        cfhttpparam(type="formField", name="email", value="locktest@pai.com");
                        cfhttpparam(type="formField", name="password", value="@wrongpass");
                    };
                }
                var data = deserializeJSON(response.filecontent);
                expect(response.status_code).toBe(400); // Locked
                expect(data.success).toBe("false");
                expect(data.message).toContain("Account locked");
                // Clean up
                lockUser.delete();
            });
            it("Should support remember me functionality", function() {
                var response = "";
                cfhttp(url = "#authenticate#", method ="POST", result = "local.response"){
                    cfhttpparam(type="formField", name="email", value="testuser@pai.com");
                    cfhttpparam(type="formField", name="password", value="test1234");
                    cfhttpparam(type="formField", name="rememberMe", value="true");
                };
                var data = deserializeJSON(response.filecontent);
                expect(response.status_code).toBe(200);
                expect(data.success).toBe("true");

                var hasRememberCookie = false;
                var rememberToken = "";

                for (var i=1; i <= local.response.cookies.recordCount; i++) {
                    if (uCase(local.response.cookies.name[i]) == "REMEMBER_ME") {
                        hasRememberCookie = true;
                        rememberToken = local.response.cookies.value[i];
                        break;
                    }
                }

                expect(hasRememberCookie).toBeTrue("REMEMBER_ME cookie should be set");
            });
        });

        describe("SignUp Function Tests", function() {
            it("if form is empty should return status code 200", function() {
                var response = "";

                cfhttp(url = "#store#", method ="POST", result = "local.response");

                // Assert
                expect(response.status_code).toBe(200);
            });

            it("If user registered should return success message.", function() {
                var response = "";
                cfhttp(url = "#store#", method ="POST", result = "local.response"){
                    cfhttpparam(type="formField", name="firstname", value="test");
                    cfhttpparam(type="formField", name="lastname", value="user");
                    cfhttpparam(type="formField", name="email", value="test@pai.com");
                    cfhttpparam(type="formField", name="passwordHash", value="test1234");
                };
                // Assert
                expect(response.status_code).toBe(200);
                // In test mode, email is skipped, so do not assert on email message
                expect(response.filecontent).notToContain("Error");
            });

            it("If user registers with existing email should show error.", function() {
                var response = "";
                cfhttp(url = "#store#", method ="POST", result = "local.response"){
                    cfhttpparam(type="formField", name="firstname", value="test");
                    cfhttpparam(type="formField", name="lastname", value="user");
                    cfhttpparam(type="formField", name="email", value="petera@pai.com");
                    cfhttpparam(type="formField", name="passwordHash", value="test1234");
                };
                // Assert
                expect(response.status_code).toBe(200);
                expect(response.filecontent).toContain("An account with this email address already exists.");
            });
            it("If missing required fields should return error", function() {
                var response = "";
                cfhttp(url = "#store#", method ="POST", result = "local.response"){
                    cfhttpparam(type="formField", name="email", value="");
                    cfhttpparam(type="formField", name="passwordHash", value="");
                };
                expect(response.status_code).toBe(200);
                expect(response.filecontent).toContain("required");
            });
            it("If invalid email format should return error", function() {
                var response = "";
                cfhttp(url = "#store#", method ="POST", result = "local.response"){
                    cfhttpparam(type="formField", name="email", value="notanemail");
                    cfhttpparam(type="formField", name="passwordHash", value="test1234");
                    cfhttpparam(type="formField", name="firstname", value="test");
                    cfhttpparam(type="formField", name="lastname", value="user");
                };
                expect(response.status_code).toBe(200);
                expect(response.filecontent).toContain("valid email");
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
        });
    }
}
