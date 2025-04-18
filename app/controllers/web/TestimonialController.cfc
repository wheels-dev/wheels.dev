// Testimonial controller
component extends="app.Controllers.Controller" {
    
    // Configuration function
    function config() {
        verifies(except="index,publicList,new,create,edit,update,check,error", params="key", paramsTypes="integer", handler="error");
        // Apply filters for security
        filters(through="restrictAccess", only="new,create,edit,update,check");
        filters(through="requireAdmin", only="index,approve,feature,delete");
        usesLayout("/layout");
    }
    
    /**
     * Show all published testimonials (public facing)
     */
    public void function publicList() {
        testimonials = model("Testimonial").findAll(
            where="isApproved = 1",
            include="User",
            order="createdAt DESC"
        );
        
        renderPartial(partial="partials/testimonialsList");
    }
    
    /**
     * Check if user has submitted a testimonial (AJAX endpoint)
     */
    function check() {
        user = model("User").findByKey(GetSignedInUserId());
        hasTestimonial = user.hasSubmittedTestimonial();
        
        // Update the user record if testimonial exists but flag is not set
        if (hasTestimonial && !user.hasTestimonial) {
            user.markTestimonialSubmitted();
        }
        
        renderWith(data={"hasTestimonial"=hasTestimonial});
    }
    
    /**
     * Show the testimonial form
     */
    function new() {
        try {
            // Check if user already has a testimonial
            user = model("User").findByKey(GetSignedInUserId());
            if (user.hasSubmittedTestimonial()) {
                flashInsert(info="You have already submitted a testimonial. You can edit it below.");
                redirectTo(action="edit");
                return;
            }
            
            // Create a new testimonial object
            testimonial = model("Testimonial").new();
            
            // If this is an AJAX request, render without layout
            if (isHtmx()) {
                renderView(testimonial=testimonial, layout=false);
            } else {
                renderView(testimonial=testimonial);
            }
        } catch (any e) {
            redirectTo(action="error", errorMessage="Error preparing new testimonial form.");
        }
    }
    
    /**
     * Process form submission
     */
    function create() {
        try {
            // Check if user already has a testimonial
            user = model("User").findByKey(GetSignedInUserId());
            if (user.hasSubmittedTestimonial()) {
                if (isHtmx()) {
                    renderWith(data={
                        "success"=false, 
                        "message"="You have already submitted a testimonial. You can edit it instead."
                    });
                } else {
                    flashInsert(info="You have already submitted a testimonial. You can edit it instead.");
                    redirectTo(action="edit");
                }
                return;
            }
            
            // Setup params
            params.logoPath = "";
            
            // Handle logo upload if present
            if (structKeyExists(params, "logo") && isDefined("params.logo")) {
                var uploadResult = handleLogoUpload(params.logo);
                
                if (uploadResult.success) {
                    params.logoPath = uploadResult.path;
                } else {
                    throw(message=uploadResult.message);
                }
            }
            
            // Save the testimonial
            response = saveTestimonial(params);
            
            if (isHtmx()) {
                renderWith(data={
                    "success"=true, 
                    "message"="Thank you for your testimonial!"
                });
            } else {
                flashInsert(success="Thank you for your testimonial!");
                redirectTo(controller="home", action="index");
            }
            
        } catch (any e) {
            // Handle validation errors
            if (isHtmx()) {
                renderWith(data={
                    "success"=false, 
                    "message"="There was a problem saving your testimonial: " & e.message
                });
            } else {
                flashInsert(error="There was a problem saving your testimonial: " & e.message);
                redirectTo(action="new");
            }
        }
    }
    
    /**
     * Edit existing testimonial
     */
    function edit() {
        try {
            // Find the user's testimonial
            testimonial = model("Testimonial").findOne(where="userId=#GetSignedInUserId()#");
            
            if (!IsObject(testimonial)) {
                flashInsert(error="You haven't submitted a testimonial yet.");
                redirectTo(action="new");
                return;
            }
            
            // If this is an AJAX request, render without layout
            if (isHtmx()) {
                renderView(testimonial=testimonial, layout=false);
            } else {
                renderView(testimonial=testimonial);
            }
        } catch (any e) {
            redirectTo(action="error", errorMessage="Error loading testimonial for editing.");
        }
    }
    
    /**
     * Update existing testimonial
     */
    function update() {
        try {
            // Find the user's testimonial
            testimonial = model("Testimonial").findOne(where="userId=#GetSignedInUserId()#");
            
            if (!IsObject(testimonial)) {
                if (isHtmx()) {
                    renderWith(data={
                        "success"=false, 
                        "message"="You haven't submitted a testimonial yet."
                    });
                } else {
                    flashInsert(error="You haven't submitted a testimonial yet.");
                    redirectTo(action="new");
                }
                return;
            }
            
            // Handle logo upload if present
            if (structKeyExists(params, "logo") && isDefined("params.logo")) {
                var uploadResult = handleLogoUpload(params.logo);
                
                if (uploadResult.success) {
                    params.logoPath = uploadResult.path;
                } else {
                    throw(message=uploadResult.message);
                }
            }
            
            // Set approval status back to false when updating
            params.isApproved = false;
            
            // Update the testimonial
            response = updateTestimonial(params, testimonial.id);
            
            if (isHtmx()) {
                renderWith(data={
                    "success"=true, 
                    "message"="Your testimonial has been updated!"
                });
            } else {
                flashInsert(success="Your testimonial has been updated!");
                redirectTo(controller="home", action="index");
            }
        } catch (any e) {
            // Handle validation errors
            if (isHtmx()) {
                renderWith(data={
                    "success"=false, 
                    "message"="There was a problem updating your testimonial: " & e.message
                });
            } else {
                flashInsert(error="There was a problem updating your testimonial: " & e.message);
                redirectTo(action="edit");
            }
        }
    }
    
    /**
     * Admin: List all testimonials
     */
    function index() {
        try {
            // Get pagination parameters
            page = params.page ?: 1;
            perPage = params.perPage ?: 15;
            sort = params.sort ?: "createdAt";
            order = params.order ?: "DESC";
            
            // Get filter parameters
            filter = params.filter ?: "all";
            
            // Build where clause based on filter
            whereClause = "";
            switch(filter) {
                case "approved":
                    whereClause = "isApproved = 1";
                    break;
                case "pending":
                    whereClause = "isApproved = 0";
                    break;
                case "featured":
                    whereClause = "isFeatured = 1";
                    break;
                // default is all testimonials
            }
            
            // Get testimonials with pagination
            testimonials = model("Testimonial").findAll(
                where = len(whereClause) ? whereClause : "",
                include = "User",
                page = page,
                perPage = perPage,
                order = "#sort# #order#"
            );
            
            // Get pagination data
            pagination = model("Testimonial").findAll(
                where = len(whereClause) ? whereClause : "",
                perPage = perPage,
                page = page,
                returnAs = "query"
            );
            
            // Render view with data
            renderView(
                testimonials = testimonials,
                pagination = pagination,
                filter = filter
            );
        } catch (any e) {
            redirectTo(action="error", errorMessage="Error loading testimonials list.");
        }
    }
    
    /**
     * Admin: Approve a testimonial
     */
    function approve() {
        try {
            // Get the testimonial
            id = params.key;
            testimonial = model("Testimonial").findByKey(id);
            
            if (!IsObject(testimonial)) {
                if (isHtmx()) {
                    renderWith(data={
                        "success"=false, 
                        "message"="Testimonial not found."
                    });
                } else {
                    flashInsert(error="Testimonial not found.");
                    redirectTo(action="index");
                }
                return;
            }
            
            // Toggle approval status
            testimonial.isApproved = !testimonial.isApproved;
            
            // Save changes
            if (testimonial.save(validate=false)) {
                if (isHtmx()) {
                    renderWith(data={
                        "success"=true, 
                        "message"="Testimonial " & (testimonial.isApproved ? "approved" : "unapproved") & " successfully.",
                        "isApproved"=testimonial.isApproved
                    });
                } else {
                    flashInsert(success="Testimonial " & (testimonial.isApproved ? "approved" : "unapproved") & " successfully.");
                    redirectTo(action="index");
                }
            } else {
                throw(message="Failed to update testimonial status.");
            }
        } catch (any e) {
            if (isHtmx()) {
                renderWith(data={
                    "success"=false, 
                    "message"="Failed to update testimonial status: " & e.message
                });
            } else {
                flashInsert(error="Failed to update testimonial status: " & e.message);
                redirectTo(action="index");
            }
        }
    }
    
    /**
     * Admin: Feature a testimonial
     */
    function feature() {
        try {
            // Get the testimonial
            id = params.key;
            testimonial = model("Testimonial").findByKey(id);
            
            if (!IsObject(testimonial)) {
                if (isHtmx()) {
                    renderWith(data={
                        "success"=false, 
                        "message"="Testimonial not found."
                    });
                } else {
                    flashInsert(error="Testimonial not found.");
                    redirectTo(action="index");
                }
                return;
            }
            
            // Toggle featured status
            testimonial.isFeatured = !testimonial.isFeatured;
            
            // Save changes
            if (testimonial.save(validate=false)) {
                if (isHtmx()) {
                    renderWith(data={
                        "success"=true, 
                        "message"="Testimonial " & (testimonial.isFeatured ? "featured" : "unfeatured") & " successfully.",
                        "isFeatured"=testimonial.isFeatured
                    });
                } else {
                    flashInsert(success="Testimonial " & (testimonial.isFeatured ? "featured" : "unfeatured") & " successfully.");
                    redirectTo(action="index");
                }
            } else {
                throw(message="Failed to update testimonial feature status.");
            }
        } catch (any e) {
            if (isHtmx()) {
                renderWith(data={
                    "success"=false, 
                    "message"="Failed to update testimonial feature status: " & e.message
                });
            } else {
                flashInsert(error="Failed to update testimonial feature status: " & e.message);
                redirectTo(action="index");
            }
        }
    }
    
    /**
     * Admin: Delete a testimonial
     */
    function delete() {
        try {
            // Get the testimonial
            id = params.key;
            testimonial = model("Testimonial").findByKey(id);
            
            if (!IsObject(testimonial)) {
                if (isHtmx()) {
                    renderWith(data={
                        "success"=false, 
                        "message"="Testimonial not found."
                    });
                } else {
                    flashInsert(error="Testimonial not found.");
                    redirectTo(action="index");
                }
                return;
            }
            
            // Get the associated user
            user = testimonial.user();
            
            // Delete the testimonial
            if (testimonial.delete()) {
                // Update the user's has_testimonial flag
                user.hasTestimonial = false;
                user.save(validate=false);
                
                if (isHtmx()) {
                    renderWith(data={
                        "success"=true, 
                        "message"="Testimonial deleted successfully."
                    });
                } else {
                    flashInsert(success="Testimonial deleted successfully.");
                    redirectTo(action="index");
                }
            } else {
                throw(message="Failed to delete testimonial.");
            }
        } catch (any e) {
            if (isHtmx()) {
                renderWith(data={
                    "success"=false, 
                    "message"="Failed to delete testimonial: " & e.message
                });
            } else {
                flashInsert(error="Failed to delete testimonial: " & e.message);
                redirectTo(action="index");
            }
        }
    }

    function error() {
        // Add code to render the error page if needed
        renderPartial(partial="partials/_error");
    }
    
    // Helper functions
    
    /**
     * Handle logo upload
     */
    private struct function handleLogoUpload(required struct file) {
        try {
            // Define upload directory
            directory = expandPath("/images/testimonials/");
            
            // Create directory if it doesn't exist
            if (!DirectoryExists(directory)) {
                DirectoryCreate(directory, true);
            }
            
            // Validate file type
            allowedExtensions = "jpg,jpeg,png,gif,webp";
            extension = ListLast(file.name, ".");
            
            if (!ListFindNoCase(allowedExtensions, extension)) {
                return {
                    success = false,
                    message = "Only image files (JPG, PNG, GIF, WEBP) are allowed."
                };
            }
            
            // Generate a unique filename
            newFileName = CreateUUID() & "." & extension;
            filePath = directory & newFileName;
            
            // Move the uploaded file
            FileMove(file.serverDirectory & "/" & file.serverFile, filePath);
            
            return {
                success = true,
                path = "/images/testimonials/" & newFileName
            };
        } catch (any e) {
            return {
                success = false,
                message = "Error uploading logo: " & e.message
            };
        }
    }
    
    /**
     * Save new testimonial
     */
    private function saveTestimonial(required struct testimonialData) {
        var response = { "message": "", "testimonialId": 0 };
        
        try {
            // Create a new testimonial
            var newTestimonial = model("Testimonial").new();
            newTestimonial.content = testimonialData.content;
            newTestimonial.companyName = testimonialData.companyName;
            newTestimonial.personName = testimonialData.personName;
            newTestimonial.jobTitle = testimonialData.jobTitle;
            newTestimonial.rating = testimonialData.rating ?: 5;
            newTestimonial.logoPath = testimonialData.logoPath;
            newTestimonial.isApproved = false;
            newTestimonial.isFeatured = false;
            newTestimonial.userId = GetSignedInUserId();
            newTestimonial.createdAt = now();
            newTestimonial.updatedAt = now();
            
            if (!newTestimonial.save()) {
                throw(message=serializeJSON(newTestimonial.allErrors()));
            }
            
            // Mark user as having submitted a testimonial
            var user = model("User").findByKey(GetSignedInUserId());
            user.markTestimonialSubmitted();
            
            response.testimonialId = newTestimonial.id;
            response.message = "Testimonial created successfully.";
        } catch (any e) {
            throw(message="Error: " & e.message);
        }
        
        return response;
    }
    
    /**
     * Update existing testimonial
     */
    private function updateTestimonial(required struct testimonialData, required numeric id) {
        var response = { "message": "", "testimonialId": 0 };
        
        try {
            // Get existing testimonial
            var testimonial = model("Testimonial").findByKey(id);
            
            if (!IsObject(testimonial)) {
                throw(message="Testimonial not found.");
            }
            
            // Update the testimonial with the submitted data
            testimonial.content = testimonialData.content;
            testimonial.companyName = testimonialData.companyName;
            testimonial.personName = testimonialData.personName;
            testimonial.jobTitle = testimonialData.jobTitle;
            testimonial.rating = testimonialData.rating ?: testimonial.rating;
            
            if (structKeyExists(testimonialData, "logoPath") && len(testimonialData.logoPath)) {
                testimonial.logoPath = testimonialData.logoPath;
            }
            
            testimonial.isApproved = false; // Reset approval status on update
            testimonial.updatedAt = now();
            
            if (!testimonial.save()) {
                throw(message=serializeJSON(testimonial.allErrors()));
            }
            
            response.testimonialId = testimonial.id;
            response.message = "Testimonial updated successfully.";
        } catch (any e) {
            throw(message="Error: " & e.message);
        }
        
        return response;
    }
    
    /**
     * Helper method to get current user ID
     */
    private function GetSignedInUserId() {
        return session.user.id;
    }
    
    /**
     * Helper method to check if request is AJAX
     */
    private function isHtmx() {
        return StructKeyExists(cgi, "HTTP_X_REQUESTED_WITH") && 
               cgi.HTTP_X_REQUESTED_WITH == "XMLHttpRequest";
    }
    
    /**
     * Before filter: Check if user is logged in
     */
    private function restrictAccess() {
        if (!StructKeyExists(session, "user") || !StructKeyExists(session.user, "id")) {
            if (isHtmx()) {
                renderWith(data={
                    "success"=false, 
                    "message"="You must be logged in to access this feature."
                }, status=401);
                return false;
            } else {
                saveRedirectUrl(cgi.script_name & "?" & cgi.query_string);
                flashInsert(error="You must be logged in to access this page.");
                redirectTo(route="login");
                return false;
            }
        }
        return true;
    }
    
    /**
     * Before filter: Check if user is an admin
     */
    private function requireAdmin() {
        // First check if logged in
        if (!restrictAccess()) {
            return false;
        }
        
        // Check if user has admin role
        user = model("User").findByKey(session.user.id);
        role = user.role();
        
        if (!IsObject(role) || role.name != "Admin") {
            if (isHtmx()) {
                renderWith(data={
                    "success"=false, 
                    "message"="You don't have permission to perform this action."
                }, status=403);
                return false;
            } else {
                flashInsert(error="You don't have permission to access this page.");
                redirectTo(route="home");
                return false;
            }
        }
        return true;
    }
}