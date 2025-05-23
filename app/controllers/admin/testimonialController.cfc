component extends="app.Controllers.Controller" {

    function config() {
        verifies(except="testimonials,testimonialDetails,delete,approve,reject,checkAdminAccess,featuredTestimonial", params="key", paramsTypes="integer");
        usesLayout(template="/layout", except="testimonials,store,delete,approve,reject,checkAdminAccess");
        usesLayout(template="/admin/AdminController/layout", except="approve,reject");
        filters(through="checkAdminAccess");
    }

    function testimonials(){
        Testimonial = model("Testimonial").findAll(include = "User");
    }

    function testimonialdetails(){
        Testimonial = model("Testimonial").findAll(where="id = '#params.id#'", include = "User");
    }

    function approve() {
        try {
            var message = testimonialApproval(params.id);
            renderText('<span class="badge bg-success">Approved</span>');
            return;
        } catch (any e) {
            // Handle error
            renderText("Failed to approve testimonials.");
        }
    }

    function reject() {
        try {
            var message = testimonialReject(params.id);
            renderText('<span class="badge bg-danger">Rejected</span>');
        } catch (any e) {
            // Handle error
            renderText("Failed to reject testimonials.");
        }
    }
    
    /**
     * Feature a testimonial
     */
    function feature() {
        try {
            // Get the testimonial
            testimonial = model("Testimonial").findByKey(params.key);
            
            if (!IsObject(testimonial)) {
                throw(message="Testimonial not found.");
            }
            
            // Set featured status to true
            testimonial.isFeatured = true;
            
            // Save changes
            if (testimonial.save(validate=false)) {
                model("Log").log(
                    category = "wheels.testimonial",
                    level = "INFO",
                    message = "Testimonial featured",
                    details = {
                        "testimonial_id": testimonial.id,
                        "admin_id": session.userID
                    }
                );
                
                flashInsert(success="Testimonial featured successfully.");
                redirectTo(action="index");
            } else {
                throw(message="Failed to feature testimonial.");
            }
        } catch (any e) {
            model("Log").log(
                category = "wheels.testimonial",
                level = "ERROR",
                message = "Failed to feature testimonial",
                details = {
                    "error_message": e.message,
                    "testimonial_id": params.key
                }
            );
            
            flashInsert(error="Failed to feature testimonial: " & e.message);
            redirectTo(action="index");
        }
    }
    
    /**
     * Unfeature a testimonial
     */
    function unfeature() {
        try {
            // Get the testimonial
            testimonial = model("Testimonial").findByKey(params.key);
            
            if (!IsObject(testimonial)) {
                throw(message="Testimonial not found.");
            }
            
            // Set featured status to false
            testimonial.isFeatured = false;
            
            // Save changes
            if (testimonial.save(validate=false)) {
                model("Log").log(
                    category = "wheels.testimonial",
                    level = "INFO",
                    message = "Testimonial unfeatured",
                    details = {
                        "testimonial_id": testimonial.id,
                        "admin_id": session.userID
                    }
                );
                
                flashInsert(success="Testimonial unfeatured successfully.");
                redirectTo(action="index");
            } else {
                throw(message="Failed to unfeature testimonial.");
            }
        } catch (any e) {
            model("Log").log(
                category = "wheels.testimonial",
                level = "ERROR",
                message = "Failed to unfeature testimonial",
                details = {
                    "error_message": e.message,
                    "testimonial_id": params.key
                }
            );
            
            flashInsert(error="Failed to unfeature testimonial: " & e.message);
            redirectTo(action="index");
        }
    }
    
    /**
     * Delete a testimonial
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

    function featuredTestimonial(){
        try{
            var testimonial = model("testimonial").findByKey(params.id);
            if(structKeyExists(params, "isFeatured-#params.id#")){
                testimonial.isFeatured = true;
                message = "Testimonial is Featured Successfully."
            }else{
                testimonial.isFeatured = false;
                message = "Testimonial is unFeatured Successfully."
            }
            testimonial.save();
            renderText(message);
            return;
        } catch(e) {
            cfheader(statusCode=500);
            return;
        }
    }

    private function testimonialApproval(id){
        var Testimonial = model("Testimonial").findByKey(id);
        var user = model("user").findByKey(Testimonial.userId);

        if (!isNull(Testimonial)) {
            
            Testimonial.status = "Approved"; //approved 
            Testimonial.isApproved = true;           
            if (Testimonial.save()) {
                siteurl = urlFor(route="home", onlyPath=false);
                var emailparams = {
                    "name" = user.fullname,
                    "buttonTitle" = "View Your Testimonial",
                    "content" = "Thank you for writing a testimonial. Your testimonial has been approved and published on the Wheels website.",
                    "URl" = siteurl,
                    "Footer" = "If you did not write testinomial, you can safely ignore this email.",
                    "footerGreetings" = "Thank you for being a part of Wheels community.",
                    "isSubscriber" = user.newsletter
                };
                emailContent = renderView(template="/email", layout=false, returnAs="string", params=emailparams);
                cfheader(name="Content-Type" value="text/html; charset=UTF-8");
                cfmail( 
                    to = "#user.email#", 
                    from = "#application.env.mail_from#", 
                    subject = "Your testimonial has been approved and published", 
                    server = "#application.env.smtp_host#", 
                    port = "#application.env.smtp_port#", 
                    username = "#application.env.smtp_username#", 
                    password = "#application.env.smtp_password#", 
                    type = "html"
                ) { 
                    writeOutput(emailContent);
                };
                return {
                    success = true,
                    message = "Testimonial approved successfully."
                };
            } else {
                return {
                    success = false,
                    errors = Testimonial.allErrors(),
                    message = "Failed to approve Testimonial."
                };
            }
        }
        
        return {
            success = false,
            message = "Testimonial not found"
        };
    }
    
    private function testimonialReject(id){
        var Testimonial = model("Testimonial").findByKey(id);
        var user = model("user").findByKey(Testimonial.userId);
        
        if (!isNull(Testimonial)) {
            
            Testimonial.status = "Rejected"; //reject
            Testimonial.isApproved = false;
            if (Testimonial.save()) {
                return {
                    success = true,
                    message = "Testimonial rejected successfully."
                };
            } else {
                return {
                    success = false,
                    errors = Testimonial.allErrors(),
                    message = "Failed to reject Testimonial."
                };
            }
        }
        
        return {
            success = false,
            message = "Testimonial not found"
        };
    }
}