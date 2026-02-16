component extends="app.Controllers.Controller" {

    function config() {
        super.config();
        verifies(except="index,addFeature,store", params="key", paramsTypes="integer", handler="index");
        usesLayout(template="/admin/AdminController/layout");
        filters(through="checkAdminAccess");
    }

    // List all features
    function index() {
        features = model("Feature").getAllFeatures();
    }

    // Add or edit feature
    function addFeature() {
        param name="id" default=0;
        feature;
        if (id > 0) {
            feature = findById(params.id);
        } else {
            feature = model("Feature");
        }
        return feature;
    }

    // Save feature (create or update)
    function store() {
        try {
            var message = saveFeature(params);
            flashInsert(success=message);
            redirectTo(route="adminFeature");
        } catch (any e) {
            flashInsert(error="Failed to save feature: " & e.message);
            redirectTo(route="adminFeature");
        }
    }

    // Delete feature (soft delete)
    function delete() {
        try {
            var message = softDelete(params.id);
            flashInsert(success=message.message);
            renderText('');
        } catch (any e) {
            flashInsert(error="Failed to delete feature: " & e.message);
            cfheader(statusCode=500);
        }
    }

    // Find feature by ID
    private function findById(id) {
        return model("Feature").findByKey(arguments.id);
    }

    // Save or update feature
    private function saveFeature(featureData) {
        var message = "";
        if (featureData.id > 0) {
            var feature = model("Feature").findByKey(featureData.id);
            if (isObject(feature)) {
                feature.title = featureData.title;
                feature.image = featureData.image;
                feature.description = featureData.description;
                feature.card_link = featureData.card_link;
                feature.updatedAt = now();
                feature.save();
                message = "Feature updated successfully.";
            } else {
                message = "Feature not found for editing.";
            }
        } else {
            var newFeature = model("Feature").new();
            newFeature.title = featureData.title;
            newFeature.image = featureData.image;
            newFeature.description = featureData.description;
            newFeature.card_link = featureData.card_link;
            newFeature.createdAt = now();
            newFeature.updatedAt = now();
            newFeature.save();
            message = "Feature created successfully.";
        }
        return message;
    }

    // Soft delete feature
    private function softDelete(id) {
        var feature = model("Feature").findByKey(arguments.id);
        if (isObject(feature)) {
            feature.deletedAt = now();
            feature.save();
            return { success = true, message = "Feature deleted successfully." };
        }
        return { success = false, message = "Feature not found." };
    }
}
