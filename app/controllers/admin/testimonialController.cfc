component extends="app.Controllers.Controller" {

    function config() {
        verifies(except="testimonials,testimonialDetails,delete,approve,reject,checkAdminAccess", params="key", paramsTypes="integer");
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


    private function testimonialApproval(id){
        var Testimonial = model("Testimonial").findByKey(id);
        var user = model("user").findByKey(Testimonial.userId);

        if (!isNull(Testimonial)) {
            
            Testimonial.status = "Approved"; //approved 
            Testimonial.is_Approved = true;           
            if (Testimonial.save()) {
                siteurl = "http://#cgi.http_host#/";
                emailContent = generateApprovalEmail(siteurl);
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
                    message = "Testimonial status approved successfully"
                };
            } else {
                return {
                    success = false,
                    errors = Testimonial.allErrors(),
                    message = "Failed to approve Testimonial status"
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
            Testimonial.is_Approved = false;
            if (Testimonial.save()) {
                siteurl = "http://#cgi.http_host#/";
                emailContent = generateRejectEmail(siteurl);
                cfheader(name="Content-Type" value="text/html; charset=UTF-8");
                cfmail( 
                    to = "#user.email#", 
                    from = "#application.env.mail_from#", 
                    subject = "Your testimonial has been rejected.", 
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
                    message = "Testimonial status rejected successfully"
                };
            } else {
                return {
                    success = false,
                    errors = Testimonial.allErrors(),
                    message = "Failed to reject Testimonial status"
                };
            }
        }
        
        return {
            success = false,
            message = "Testimonial not found"
        };
    }
    private string function generateApprovalEmail(required string siteurl) {
            return '
                <!DOCTYPE html>
                <html>
                <head>
                    <meta charset="UTF-8">
                    <meta name="viewport" content="width=device-width, initial-scale=1.0">
                    <title>Verify Your Account</title>
                    <style>
                        body {
                            font-family: Arial, sans-serif;
                            background-color: ##f4f4f4;
                            margin: 0;
                            padding: 0;
                        }
                        .container {
                            max-width: 600px;
                            margin: 40px auto;
                            background: ##ffffff;
                            padding: 20px;
                            border-radius: 8px;
                            box-shadow: 0px 4px 10px rgba(0, 0, 0, 0.1);
                            text-align: center;
                        }
                        .logo {
                            width: 120px;
                            margin-bottom: 20px;
                        }
                        h1 {
                            color: ##333;
                            font-size: 24px;
                        }
                        p {
                            color: ##666;
                            font-size: 16px;
                            line-height: 1.5;
                        }
                        .button {
                            display: inline-block;
                            background-color: ##007BFF;
                            color: ##ffffff;
                            text-decoration: none;
                            font-size: 18px;
                            padding: 12px 20px;
                            border-radius: 6px;
                            margin-top: 20px;
                        }
                        .footer {
                            margin-top: 30px;
                            font-size: 14px;
                            color: ##999;
                        }
                    </style>
                </head>
                <body>

                    <div class="container">
                        <img src="https://avatars.githubusercontent.com/u/159224?s=200&v=4" alt="Bootstrap" width="260">
                        <h1>Welcome to Wheels.dev!</h1>
                        <p>Thank you for writing a testimonial. Your testimonial has been approved and published on the Wheels website.</p>
                        <a href="' & siteurl & '" class="button">View Your Testimonial</a>
                        <p class="footer">If you did not write testinomial, you can safely ignore this email.</p>
                    </div>

                </body>
                </html>
            ';
    }

    private string function generateRejectEmail(required string siteurl) {
            return '
                <!DOCTYPE html>
                <html>
                <head>
                    <meta charset="UTF-8">
                    <meta name="viewport" content="width=device-width, initial-scale=1.0">
                    <title>Verify Your Account</title>
                    <style>
                        body {
                            font-family: Arial, sans-serif;
                            background-color: ##f4f4f4;
                            margin: 0;
                            padding: 0;
                        }
                        .container {
                            max-width: 600px;
                            margin: 40px auto;
                            background: ##ffffff;
                            padding: 20px;
                            border-radius: 8px;
                            box-shadow: 0px 4px 10px rgba(0, 0, 0, 0.1);
                            text-align: center;
                        }
                        .logo {
                            width: 120px;
                            margin-bottom: 20px;
                        }
                        h1 {
                            color: ##333;
                            font-size: 24px;
                        }
                        p {
                            color: ##666;
                            font-size: 16px;
                            line-height: 1.5;
                        }
                        .button {
                            display: inline-block;
                            background-color: ##007BFF;
                            color: ##ffffff;
                            text-decoration: none;
                            font-size: 18px;
                            padding: 12px 20px;
                            border-radius: 6px;
                            margin-top: 20px;
                        }
                        .footer {
                            margin-top: 30px;
                            font-size: 14px;
                            color: ##999;
                        }
                    </style>
                </head>
                <body>

                    <div class="container">
                        <img src="https://avatars.githubusercontent.com/u/159224?s=200&v=4" alt="Bootstrap" width="260">
                        <h1>Welcome to Wheels.dev!</h1>
                        <p>Thank you for writing a testimonial. Your testimonial has been Rejected and not published on the Wheels website.</p>
                        <p class="footer">If you did not write testinomial, you can safely ignore this email.</p>
                    </div>

                </body>
                </html>
            ';
    }
}