component extends="app.Controllers.Controller" {

    function config() {
        super.config();
        verifies(except="index,add,store,edit,delete,loadCategories,checkAdminAccess", params="key", paramsTypes="integer");

        usesLayout(template="/admin/AdminController/layout");
        filters(through="checkAdminAccess");
    }

    function index(){
        categories = model("category").getAll();
    }

    function add(){
        param name="id" default=0;
        category;
        if(id > 0) {
            category = model("category").findByKey(params.id);
        }else {
            category = model("category");
        }
        return category;
    }

    function store(){
        try {
            var message = saveCategory(params);

            redirectTo(action="index", success="#message#");
        } catch (any e) {
            // Handle error
            redirectTo(action="error", error="Failed to save category.");
        }
    }

    function delete(){
        try {
            category = model("category").findByKey(params.id);
            category.delete();
            redirectTo(action="index", success="Category deleted successfully");
        } catch (any e) {
            // Handle error
            redirectTo(action="index", errorMessage="Failed to delete category.");
        }
    }
    function loadCategories(){
        categories = model("category").getAll();
        renderPartial(partial="partials/parentcategories");
    }
    
    private function saveCategory(categoryData){
        try{

            if (categoryData.id > 0) {
                var category = model("category").findByKey(categoryData.id);

                if (not isNull(category)) {
                    // Edit the existing category post
                    category.name = categoryData.Name;
                    category.description = categoryData.description;
                    category.isActive = categoryData.status;
                    category.parentId = categoryData.parentCategoryId;
                    category.updatedAt = now();
                    category.save();
                    message = "Category updated successfully.";
                } else {
                    message = "Category not found for editing.";
                }
            } else {
                    var newcategory = model("category").new();
                    newcategory.name = categoryData.Name;
                    newcategory.description = categoryData.description;
                    newcategory.isActive = categoryData.status;
                    newcategory.parentId = categoryData.parentCategoryId;
                    newcategory.createdAt = now();
                    newcategory.updatedAt = now();
                    newcategory.save();

                    message = "Category created successfully.";
            }
            
        }catch (any e) {
            // Handle error
            message = "Error: " & e.message;
        }
        return message;
    }
}