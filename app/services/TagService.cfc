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

    function saveTags(required struct blogData, blogId){
        try{
            if (blogId > 0 && structKeyExists(blogData, "posttag")) {
                // Remove existing tags if updating
                // variables.Tag.deleteWhere(where="blog_id = #blogId#");

                // Insert new tags
                for (var tagName in blogData.posttag) {
                    var newTag = variables.Tag.new();
                    newTag.name = tagName;
                    newTag.blog_id = blogId; // Use blogId instead of blogData.id
                    newTag.createdAt = now();
                    newTag.updatedAt = now();
                    newTag.save();
                }
            }
        } catch (any e) {
            
            local.exception = e;
        }

    }

}
