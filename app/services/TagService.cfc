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

    function saveTags(required struct blogData, blogId) {
        try {
            if (blogId > 0 && structKeyExists(blogData, "posttag")) {
                
                var tagArray = listToArray(blogData.posttag, ","); // Convert posttag string into an array
    
                // Remove existing tags if updating
                // variables.Tag.deleteWhere(where="blog_id = #blogId#");
    
                // Insert new tags
                for (var tagName in tagArray) {
                    var newTag = variables.Tag.new();
                    newTag.name = trim(tagName); // Trim spaces if any
                    newTag.blogId = blogId;
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
