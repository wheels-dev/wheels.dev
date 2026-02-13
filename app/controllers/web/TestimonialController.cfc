// Testimonial controller
component extends="app.Controllers.Controller" {
    
    // Configuration function
    function config() {
        verifies(except="index,publicList,new,create,edit,update,check,error,clearPromptFlag", params="key", paramsTypes="integer", handler="error");
        filters(through="restrictAccess", only="new,create,edit,update");
        usesLayout("/layout");
    }
    
    /**
     * Show all published testimonials (public facing)
     */
    public void function publicList() {
        testimonials = model("Testimonial").findAll(
            where="isApproved = true",
            include="User",
            order="createdAt DESC"
        );
        
        renderPartial(partial="partials/testimonialsList");
    }
    
    /**
     * Check if user has submitted a testimonial (HTMX endpoint)
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
    public function new() {
        try {
            user = model("User").findByKey(GetSignedInUserId());
            if (user.hasSubmittedTestimonial()) {
                return;
            }

            testimonial = model("Testimonial").new();

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
    public function create() {
        try {
            var userId = GetSignedInUserId();
            var user = model("User").findByKey(userId);

            if (user.hasSubmittedTestimonial()) {
                model("Log").log(
                    category = "testimonials.create",
                    level = "INFO",
                    message = "Duplicate testimonial submission attempt",
                    details = { "ip_address": cgi.REMOTE_ADDR },
                    userId = userId
                );

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

            // Default logo path
            params.logoPath = "";

            // Handle logo upload
            if (structKeyExists(params, "logo") && isDefined("params.logo")) {
                var uploadResult = handleLogoUpload(params.logo);

                if (uploadResult.success) {
                    params.logoPath = uploadResult.path;
                } else {
                    throw(message=uploadResult.message);
                }
            }

            var response = saveTestimonial(params);

            model("Log").log(
                category = "testimonials.create",
                level = "INFO",
                message = "Testimonial created successfully",
                details = {
                    "ip_address": cgi.REMOTE_ADDR,
                    "testimonialId": response.testimonialId
                },
                userId = userId
            );

            if (isHtmx()) {
                renderText('
                    <strong>Thank you!</strong> We appreciate your kind words. Your testimonial will appear on the Wheels website once it has been reviewed.
                ');
            } else {
                renderText('
                    <strong>Thank you!</strong> We appreciate your kind words. Your testimonial will appear on the Wheels website once it has been reviewed.
                ');
            }

        } catch (any e) {
            model("Log").log(
                category = "testimonials.create",
                level = "ERROR",
                message = "Testimonial creation failed",
                details = {
                    "ip_address": cgi.REMOTE_ADDR,
                    "error": e.message
                },
                userId = GetSignedInUserId()
            );

            var msg = "There was a problem saving your testimonial: " & e.message;
            if (isHtmx()) {
                renderWith(data={ "success"=false, "message"=msg });
            } else {
                flashInsert(error=msg);
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

    function error() {
        // Add code to render the error page if needed
        renderPartial(partial="partials/_error");
    }
    
    // Helper functions
    
    /**
     * Handle logo upload
     */
    private struct function handleLogoUpload(file) {
        try {
            // Define target directory
            var uploadPath = expandPath("/images/");

            // Create the directory if it doesn't exist
            if (!DirectoryExists(uploadPath)) {
                DirectoryCreate(uploadPath, true);
            }

            // Upload the file and only allow image files
            var uploadedFile = fileUpload(
                destination   = uploadPath,
                nameConflict  = "makeUnique",  // Avoid overwriting
                fileField     = file,  // Name of the file input field
                accept        = "image/jpeg,image/png,image/gif,image/webp"
            );

            // Return success and path
            return {
                success = true,
                path = uploadedFile.serverFile
            };

        } catch (any e) {
            return {
                success = false,
                message = "Error uploading image: " & e.message
            };
        }
    }

    
    /**
     * Save new testimonial
     */
    private function saveTestimonial(required struct testimonialData) {
        var response = { "success": false, "message": "", "testimonialId": 0, "errors": {} };
        var userId = GetSignedInUserId();
        
        try {
            var newTestimonial = model("Testimonial").new();
            newTestimonial.testimonialText = testimonialData.testimonialText;
            newTestimonial.title = testimonialData.title;
            newTestimonial.companyName = testimonialData.companyName;
            newTestimonial.rating = testimonialData.rating ?: 5;
            newTestimonial.logoPath = testimonialData.logoPath;
            newTestimonial.experienceLevel = testimonialData.experienceLevel ?: "";
            newTestimonial.websiteUrl = testimonialData.websiteUrl ?: "";
            newTestimonial.socialMediaLinks = testimonialData.socialMediaLinks ?: "";
            newTestimonial.displayPermission = true;
            
            newTestimonial.userId = userId;
            newTestimonial.isApproved = false;
            newTestimonial.isFeatured = false;

            if (!newTestimonial.save()) {
                response.errors = newTestimonial.allErrors();
                response.message = "Please correct the following errors:";
                
                // Log validation errors
                model("Log").log(
                    category = "testimonials.create",
                    level = "WARN",
                    message = "Testimonial validation failed",
                    details = {
                        "ip_address": cgi.REMOTE_ADDR,
                        "validation_errors": response.errors,
                        "companyName": testimonialData.companyName ?: ""
                    },
                    userId = userId
                );
            } else {
                var user = model("User").findByKey(userId);
                user.markTestimonialSubmitted();

                response.testimonialId = newTestimonial.id;
                response.message = "Testimonial created successfully.";
                response.success = true;

                // Log successful testimonial creation
                model("Log").log(
                    category = "testimonials.create",
                    level = "INFO",
                    message = "Testimonial created successfully",
                    details = {
                        "ip_address": cgi.REMOTE_ADDR,
                        "testimonialId": response.testimonialId,
                        "companyName": testimonialData.companyName,
                        "rating": testimonialData.rating ?: 5
                    },
                    userId = userId
                );
            }

        } catch (any e) {
            response.message="Error: " & e.message;
            
            // Log error during testimonial creation
            model("Log").log(
                category = "testimonials.create",
                level = "ERROR",
                message = "Testimonial creation failed",
                details = {
                    "ip_address": cgi.REMOTE_ADDR,
                    "error_message": e.message,
                    "error_detail": e.detail,
                    "companyName": testimonialData.companyName ?: ""
                },
                userId = userId
            );
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
    * Helper method to check if the request was initiated by HTMX.
    */
    private boolean function isHtmx() {
        // HTMX requests include the HX-Request header
        return StructKeyExists(request.$wheelsheaders, "HX-REQUEST") && request.$wheelsheaders["HX-Request"];
    }
}