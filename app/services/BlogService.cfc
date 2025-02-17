component {
    property name="Blog"; // Inject the Blog model

     function init(blogModel) {
        variables.Blog = blogModel; // Store model
        return this;
    }

    function getAllBlogs() {
        return variables.Blog.findAll();
    }
    
    function getBlogById(required numeric id) {
        return model("app.model.Blog").findOne(where="id = #arguments.id#");
    }
}
