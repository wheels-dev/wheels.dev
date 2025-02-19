component {
    property name="Tag"; // Inject the Tag model

     function init(tagModel) {
        variables.Tag = tagModel; // Store model
        return this;
    }

    function getAllTags() {
        return variables.Tag.findAll();
    }
    
    function getTagsByBlogid(required numeric id) {
        return variables.Tag.findAll(include="Blog", where="blogid = #arguments.id#");
    }

}
