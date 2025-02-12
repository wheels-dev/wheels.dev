component {
    function getAllBlogs() {
        return model("app.model.Blog").findAll();
    }
    
    function getBlogById(required numeric id) {
        return model("app.model.Blog").findOne(where="id = #arguments.id#");
    }
}
