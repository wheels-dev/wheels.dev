component extends="testbox.system.BaseSpec" {
    function beforeAll(){
        requestServer= application.env.application_host;
        authenticate = "#requestServer#/auth/authenticate";
        blogs = "#requestServer#/blog";
        search = "#requestServer#/blog/Search";
        storeBlog = "#requestServer#/blog/store";

        // var Auth = "";
        // cfhttp(url = "#authenticate#", method ="POST", result = "local.Auth"){
        //     cfhttpparam(type="formField", name="email", value="test@pai.com");
        //     cfhttpparam(type="formField", name="password", value="test1234");
        // };

        // var cookies = Auth.responseHeader["set-cookie"];
        // var cookieParts = [];

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
    // function run() {
    //     describe("Blogs Functions Tests", function() {
    //         it("it should return 200 status code for blogs", function(done) {
    //             var response = "";

    //             cfhttp(url = "#blogs#", method ="Get", result = "local.response");

    //             // Assert
    //             expect(response.status_code).toBe(200);
    //             expect(response.error).toBe("false");
    //         });

    //         it("it should return 200 status code for blog search filter", function(done) {
    //             var response = "";

    //             cfhttp(url = "#search#", method ="Get", result = "local.response"){
    //                 cfhttpparam(type="URL", name="searchTerm", value="");
    //             };

    //             // Assert
    //             expect(response.status_code).toBe(200);
    //             expect(response.error).toBe("false");
    //         });

    //         it("it should return 200 status code after store the blog", function(done) {
    //             var response = "";
    //             cfhttp(url = "#storeBlog#", method ="POST", result = "local.response"){
    //                 cfhttpparam(type="formField", name="title", value="Test Blog");
    //                 cfhttpparam(type="formField", name="categoryId", value="1");
    //                 cfhttpparam(type="formField", name="posttypeId", value="1");
    //                 cfhttpparam(type="formField", name="posttags", value="Test");
    //                 cfhttpparam(type="formField", name="postCreatedDate", value="#dateformat(now(), "YYYY-MM-DD")#");
    //                 cfhttpparam(type="formField", name="content", value="Test Data");
    //                 cfhttpparam(type="formField", name="isDraft", value="0");
    //             };
    //             // Assert
    //             expect(response.status_code).toBe(200);
    //             expect(response.error).toBe("false");
    //         });
    //     });
    // }
}