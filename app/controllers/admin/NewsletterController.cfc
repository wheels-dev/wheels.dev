component extends="app.Controllers.Controller" {
    function config() {
        usesLayout(template="/admin/AdminController/layout");
        filters(through="checkAdminAccess");
    }

    // List all newsletter subscribers
    function index() {
        // Get all newsletter subscribers (both users and non-users)
        var userSubscribers = model("User").findAll(where="newsletter = 1");
        var nonUserSubscribers = model("NewsletterSubscriber").findAll(where="status = 'active'");
        
        // Combine the results
        var allSubscribers = [];
        
        // Add user subscribers
        for (var user in userSubscribers) {
            allSubscribers.append({
                email: user.email,
                name: user.firstname & " " & user.lastname,
                type: "user",
                subscribedAt: user.createdAt
            });
        }
        
        // Add non-user subscribers
        for (var subscriber in nonUserSubscribers) {
            allSubscribers.append({
                email: subscriber.email,
                name: "",
                type: "subscriber",
                subscribedAt: subscriber.createdAt
            });
        }
        
        // Sort by subscription date
        allSubscribers.sort(function(a, b) {
            return dateCompare(b.subscribedAt, a.subscribedAt);
        });

        // Get statistics
        stats = {
            totalSubscribers: arrayLen(allSubscribers),
            userSubscribers: userSubscribers.recordCount,
            nonUserSubscribers: nonUserSubscribers.recordCount,
            pendingSubscribers: model("NewsletterSubscriber").count(where="status = 'pending'"),
            inactiveSubscribers: model("NewsletterSubscriber").count(where="status = 'inactive'")
        };

        // Log the dashboard access
        model("Log").log(
            category = "wheels.newsletter",
            level = "INFO",
            message = "Newsletter dashboard accessed",
            details = {
                "total_subscribers": stats.totalSubscribers,
                "user_subscribers": stats.userSubscribers,
                "non_user_subscribers": stats.nonUserSubscribers,
                "pending_subscribers": stats.pendingSubscribers,
                "inactive_subscribers": stats.inactiveSubscribers,
                "ip_address": cgi.REMOTE_ADDR
            },
            userId = session.userID
        );
        data = {
            "subscribers": allSubscribers,
            "stats": stats
        }
        return renderWith(data=data);
    }

    // Send newsletter to all subscribers
    function send() {
        try {
            var subject = params.subject;
            var content = params.content;
            
            if (isNull(subject) || isNull(content)) {
                model("Log").log(
                    category = "wheels.newsletter",
                    level = "WARN",
                    message = "Newsletter send failed - missing required fields",
                    details = {
                        "subject": isNull(subject) ? "" : subject,
                        "content_length": isNull(content) ? 0 : len(content),
                        "ip_address": cgi.REMOTE_ADDR
                    },
                    userId = session.userID
                );
                return renderWith(data={
                    success: false,
                    message: "Subject and content are required."
                });
            }
            
            // Get all active subscribers
            var userSubscribers = model("User").findAll(where="newsletter = true");
            var nonUserSubscribers = model("NewsletterSubscriber").findAll(where="status = 'active'");
            
            // Log the newsletter send attempt
            model("Log").log(
                category = "wheels.newsletter",
                level = "INFO",
                message = "Newsletter send started",
                details = {
                    "subject": subject,
                    "content_length": len(content),
                    "user_subscribers": userSubscribers.recordCount,
                    "non_user_subscribers": nonUserSubscribers.recordCount,
                    "ip_address": cgi.REMOTE_ADDR
                },
                userId = session.userID
            );
            
            // Send to user subscribers
            for (var user in userSubscribers) {
                sendEmail(
                    to=user.email,
                    from=application.env.mail_from,
                    subject=subject,
                    template="template",
                    content=content,
                    subscriber=user.email,
                    type="html"
                );
            }
            
            // Send to non-user subscribers
            for (var subscriber in nonUserSubscribers) {
                sendEmail(
                    to=subscriber.email,
                    from=application.env.mail_from,
                    subject=subject,
                    template="template",
                    content=content,
                    subscriber=subscriber.email,
                    type="html"
                );
            }
            
            // Log successful send
            model("Log").log(
                category = "wheels.newsletter",
                level = "INFO",
                message = "Newsletter sent successfully",
                details = {
                    "subject": subject,
                    "content_length": len(content),
                    "total_recipients": userSubscribers.recordCount + nonUserSubscribers.recordCount,
                    "ip_address": cgi.REMOTE_ADDR
                },
                userId = session.userID
            );
            
            return renderWith(data={
                success: true,
                message: "Newsletter sent successfully!"
            });
        } catch (any e) {
            // Log the error
            model("Log").log(
                category = "wheels.newsletter",
                level = "ERROR",
                message = "Newsletter send failed",
                details = {
                    "error_message": e.message,
                    "error_detail": e.detail,
                    "error_type": e.type,
                    "subject": isNull(subject) ? "" : subject,
                    "content_length": isNull(content) ? 0 : len(content),
                    "ip_address": cgi.REMOTE_ADDR
                },
                userId = session.userID
            );
            return renderWith(data={
                success: false,
                message: "An error occurred while sending the newsletter."
            });
        }
    }

    // Unsubscribe a user from newsletter
    function unsubscribe() {
        try {
            var email = params.email;
            var type = params.type;
            var response = {};
            
            // Log the unsubscribe attempt
            model("Log").log(
                category = "wheels.newsletter",
                level = "INFO",
                message = "Newsletter unsubscribe attempt",
                details = {
                    "email": email,
                    "type": type,
                    "ip_address": cgi.REMOTE_ADDR
                },
                userId = session.userID
            );
            
            if (type == "user") {
                var user = model("User").findOne(where="email = '#email#'");
                if (!isNull(user)) {
                    user.update(newsletter=false);
                    model("Log").log(
                        category = "wheels.newsletter",
                        level = "INFO",
                        message = "User unsubscribed from newsletter",
                        details = {
                            "email": email,
                            "user_id": user.id,
                            "ip_address": cgi.REMOTE_ADDR
                        },
                        userId = session.userID
                    );
                    response = {
                        "success" = true,
                        "message" = "User has been unsubscribed."
                    };
                } else {
                    response = {
                        "success" = false,
                        "message" = "User not found."
                    };
                }
            } else {
                var subscriber = model("NewsletterSubscriber").findOne(where="email = '#email#'");
                if (!isNull(subscriber)) {
                    subscriber.update(status="inactive");
                    model("Log").log(
                        category = "wheels.newsletter",
                        level = "INFO",
                        message = "Subscriber unsubscribed from newsletter",
                        details = {
                            "email": email,
                            "subscriber_id": subscriber.id,
                            "ip_address": cgi.REMOTE_ADDR
                        },
                        userId = session.userID
                    );
                    response = {
                        "success" = true,
                        "message" = "Subscriber has been unsubscribed."
                    };
                } else {
                    response = {
                        "success" = false,
                        "message" = "Subscriber not found."
                    };
                }
            }
            
            renderText(SerializeJSON(response));
        } catch (any e) {
            // Log the error
            model("Log").log(
                category = "wheels.newsletter",
                level = "ERROR",
                message = "Newsletter unsubscribe failed",
                details = {
                    "error_message": e.message,
                    "error_detail": e.detail,
                    "error_type": e.type,
                    "email": email,
                    "type": type,
                    "ip_address": cgi.REMOTE_ADDR
                },
                userId = session.userID
            );
            
            renderText(SerializeJSON({
                "success" = false,
                "message" = "An error occurred while unsubscribing the user."
            }));
        }
    }

    // Filter subscribers by type
    function filterByType() {
        var type = params.type ?: "all";
        var subscribers = [];
        
        if (type == "all" || type == "") {
            // Get all newsletter subscribers (both users and non-users)
            var userSubscribers = model("User").findAll(where="newsletter = 1");
            var nonUserSubscribers = model("NewsletterSubscriber").findAll(where="status = 'active'");
            
            // Add user subscribers
            for (var user in userSubscribers) {
                subscribers.append({
                    email: user.email,
                    name: user.firstname & " " & user.lastname,
                    type: "user",
                    subscribedAt: user.createdAt
                });
            }
            
            // Add non-user subscribers
            for (var subscriber in nonUserSubscribers) {
                subscribers.append({
                    email: subscriber.email,
                    name: "",
                    type: "subscriber",
                    subscribedAt: subscriber.createdAt
                });
            }
        } else if (type == "user") {
            var userSubscribers = model("User").findAll(where="newsletter = 1");
            for (var user in userSubscribers) {
                subscribers.append({
                    email: user.email,
                    name: user.firstname & " " & user.lastname,
                    type: "user",
                    subscribedAt: user.createdAt
                });
            }
        } else if (type == "subscriber") {
            var nonUserSubscribers = model("NewsletterSubscriber").findAll(where="status = 'active'");
            for (var subscriber in nonUserSubscribers) {
                subscribers.append({
                    email: subscriber.email,
                    name: "",
                    type: "subscriber",
                    subscribedAt: subscriber.createdAt
                });
            }
        } else if (type == "pending") {
            var pendingSubscribers = model("NewsletterSubscriber").findAll(where="status = 'pending'");
            for (var subscriber in pendingSubscribers) {
                subscribers.append({
                    email: subscriber.email,
                    name: "",
                    type: "pending",
                    subscribedAt: subscriber.createdAt
                });
            }
        } else if (type == "inactive") {
            var inactiveSubscribers = model("NewsletterSubscriber").findAll(where="status = 'inactive'");
            for (var subscriber in inactiveSubscribers) {
                subscribers.append({
                    email: subscriber.email,
                    name: "",
                    type: "inactive",
                    subscribedAt: subscriber.createdAt
                });
            }
        }
        
        // Sort by subscription date
        subscribers.sort(function(a, b) {
            return dateCompare(b.subscribedAt, a.subscribedAt);
        });
        
        data = {
            "subscribers": subscribers
        };
        
        return renderPartial(partial="subscribersTable");
    }

    // Search subscribers
    function search() {
        param name="params.searchTerm" default="";
        var searchTerm = params.searchTerm;
        var subscribers = [];
        
        if (len(trim(searchTerm))) {
            // Search in users table
            var userSubscribers = model("User").findAll(where="newsletter = 1 AND (email LIKE '%#searchTerm#%' OR firstname LIKE '%#searchTerm#%' OR lastname LIKE '%#searchTerm#%')");
            for (var user in userSubscribers) {
                subscribers.append({
                    email: user.email,
                    name: user.firstname & " " & user.lastname,
                    type: "user",
                    subscribedAt: user.createdAt
                });
            }
            
            // Search in newsletter_subscribers table
            var nonUserSubscribers = model("NewsletterSubscriber").findAll(where="email LIKE '%#searchTerm#%'");
            for (var subscriber in nonUserSubscribers) {
                subscribers.append({
                    email: subscriber.email,
                    name: "",
                    type: subscriber.status,
                    subscribedAt: subscriber.createdAt
                });
            }
        } else {
            // If search term is empty, show all subscribers
            var userSubscribers = model("User").findAll(where="newsletter = 1");
            var nonUserSubscribers = model("NewsletterSubscriber").findAll(where="status = 'active'");
            
            // Add user subscribers
            for (var user in userSubscribers) {
                subscribers.append({
                    email: user.email,
                    name: user.firstname & " " & user.lastname,
                    type: "user",
                    subscribedAt: user.createdAt
                });
            }
            
            // Add non-user subscribers
            for (var subscriber in nonUserSubscribers) {
                subscribers.append({
                    email: subscriber.email,
                    name: "",
                    type: "subscriber",
                    subscribedAt: subscriber.createdAt
                });
            }
        }
        
        // Sort by subscription date
        subscribers.sort(function(a, b) {
            return dateCompare(b.subscribedAt, a.subscribedAt);
        });
        
        if (arrayLen(subscribers) EQ 0) {
            renderText("<div class='text-center py-4 text-muted'>No record found</div>");
            return;
        }

        data = {
            "subscribers": subscribers
        };
        
        return renderPartial(partial="subscribersTable");
    }

    // Export subscribers to CSV
    function export() {
        try {
            // Get all subscribers
            var userSubscribers = model("User").findAll(where="newsletter = 1");
            var nonUserSubscribers = model("NewsletterSubscriber").findAll(where="status = 'active'");
            
            // Create CSV content with proper line endings
            var newLine = chr(13) & chr(10);
            var csvContent = "Email,Name,Type,Subscription Date" & newLine;
            
            // Add user subscribers
            for (var user in userSubscribers) {
                csvContent &= '"#user.email#","#user.firstname# #user.lastname#","User","#dateFormat(user.createdAt, "yyyy-mm-dd")#"' & newLine;
            }
            
            // Add non-user subscribers
            for (var subscriber in nonUserSubscribers) {
                csvContent &= '"#subscriber.email#"," ","Subscriber","#dateFormat(subscriber.createdAt, "yyyy-mm-dd")#"' & newLine;
            }
            
            // Set response headers for CSV download
            getPageContext().getResponse().setContentType("text/csv");
            getPageContext().getResponse().setHeader("Content-Disposition", "attachment; filename=newsletter_subscribers_#dateFormat(now(), "yyyymmdd")#.csv");
            
            // Log the export
            model("Log").log(
                category = "wheels.newsletter",
                level = "INFO",
                message = "Newsletter subscribers exported",
                details = {
                    "total_subscribers": userSubscribers.recordCount + nonUserSubscribers.recordCount,
                    "ip_address": cgi.REMOTE_ADDR
                },
                userId = session.userID
            );
            
            // Output the CSV content
            writeOutput(csvContent);
            abort;
            
        } catch (any e) {
            // Log the error
            model("Log").log(
                category = "wheels.newsletter",
                level = "ERROR",
                message = "Newsletter export failed",
                details = {
                    "error_message": e.message,
                    "error_detail": e.detail,
                    "error_type": e.type,
                    "ip_address": cgi.REMOTE_ADDR
                },
                userId = session.userID
            );
            data = {
                success: false,
                message: "An error occurred while exporting subscribers."
            };
            // Return error response
            return renderWith(data=data);
        }
    }
} 