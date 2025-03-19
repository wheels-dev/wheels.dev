component {
    property name="Category"; // Inject the Category model

     function init(categoryModel) {
        variables.Category = categoryModel; // Store model
        return this;
    }

    function getAllCategories() {
        return variables.Category.findAll();
    }
    
    function getCategoriesByBlogid(required numeric id) {
        return variables.Category.findAll(include="Blog", where="blogid = #arguments.id#");
    }

    function saveCategories(required struct blogData, blogId) {
        try {
            if (blogId > 0 && structKeyExists(blogData, "categoryId")) {
                
                var categoryArray = listToArray(blogData.categoryId, ","); // Convert categoryId string into an array
    
                // Remove existing categories if updating
                // variables.Category.deleteWhere(where="blog_id = #blogId#");
    
                // Insert new categories
                for (var categoryName in categoryArray) {
                    var newCategory = variables.Category.new();
                    newCategory.name = trim(categoryName); // Trim spaces if any
                    newCategory.blogId = blogId;
                    newCategory.createdAt = now();
                    newCategory.updatedAt = now();
                    newCategory.save();
                }
            }
        } catch (any e) {
            writeDump(e); abort;
            local.exception = e;
        }
    }
}
