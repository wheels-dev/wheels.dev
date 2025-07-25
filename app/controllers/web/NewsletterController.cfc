component extends="app.Controllers.Controller" {
    function config() {
        // Set the layout for all actions
        verifies(except="verify,subscribe,unsubscribe", params="token", paramsTypes="string");
        usesLayout(template="/layout", except="verify");
        // Set the layout for JSON responses
        usesLayout(template="/responseLayout", only="subscribe,unsubscribe");
    }

    function subscribe() {
        try {
            var email = params.email;
            
            // Log subscription attempt
            model("Log").log(
                category = "Newsletter",
                level = "INFO",
                message = "Newsletter subscription attempt",
                details = {
                    "email" = email,
                    "ip_address" = cgi.REMOTE_ADDR,
                    "user_agent" = cgi.HTTP_USER_AGENT,
                    "action" = "subscribe",
                    "status" = "attempt"
                }
            );

            // Check if email exists in users table
            var user = model("User").findOne(where="email = '#email#'");
            if (isStruct(user) && structKeyExists(user, "id")) {
                // Update existing user's newsletter subscription
                user.update(newsletter = true);
                
                // Log successful subscription
                model("Log").log(
                    category = "Newsletter",
                    level = "INFO",
                    message = "Existing user subscribed to newsletter",
                    details = {
                        "email" = email,
                        "user_id" = user.id,
                        "ip_address" = cgi.REMOTE_ADDR,
                        "user_agent" = cgi.HTTP_USER_AGENT,
                        "action" = "subscribe",
                        "status" = "success",
                        "type" = "existing_user"
                    }
                );

                data = {
                    "success" = true,
                    "message" = "You have been subscribed to our newsletter!"
                };
                renderWith(data=data, hideDebugInformation=true, status=200, layout='/responseLayout');
                return;
            }

            // Check if email exists in newsletter_subscribers table
            var subscriber = model("NewsletterSubscriber").findOne(where="email = '#email#'");
            if (isStruct(subscriber) && structKeyExists(subscriber, "status")) {
                if (subscriber.status == "inactive") {
                    // Reactivate subscriber
                    subscriber.update(status = "pending", verificationToken = generateVerificationToken());
                    
                    // Log reactivation
                    model("Log").log(
                        category = "Newsletter",
                        level = "INFO",
                        message = "Reactivated newsletter subscription",
                        details = {
                            "email" = email,
                            "subscriber_id" = subscriber.id,
                            "ip_address" = cgi.REMOTE_ADDR,
                            "user_agent" = cgi.HTTP_USER_AGENT,
                            "action" = "subscribe",
                            "status" = "success",
                            "type" = "reactivation"
                        }
                    );
                } else if (subscriber.status == "pending") {                    
                    // Log E-mail Already Sent
                    model("Log").log(
                        category = "Newsletter",
                        level = "INFO",
                        message = "Newsletter subscription Already Sent",
                        details = {
                            "email" = email,
                            "subscriber_id" = subscriber.id,
                            "ip_address" = cgi.REMOTE_ADDR,
                            "user_agent" = cgi.HTTP_USER_AGENT,
                            "action" = "subscribe",
                            "status" = "success",
                            "type" = "reactivation"
                        }
                    );
                    
                    data = {
                        "success" = false,
                        "message" = "Verification email already sent. Please check your inbox."
                    };
                    renderWith(data=data, hideDebugInformation=true, status=200, layout='/responseLayout');
                    return;
                } else {
                    // Log duplicate subscription attempt
                    model("Log").log(
                        category = "Newsletter",
                        level = "WARN",
                        message = "Duplicate newsletter subscription attempt",
                        details = {
                            "email" = email,
                            "subscriber_id" = subscriber.id,
                            "ip_address" = cgi.REMOTE_ADDR,
                            "user_agent" = cgi.HTTP_USER_AGENT,
                            "action" = "subscribe",
                            "status" = "failed",
                            "reason" = "already_subscribed"
                        }
                    );

                    data = {
                        "success" = false,
                        "message" = "You are already subscribed to our newsletter!"
                    };
                    renderWith(data=data, hideDebugInformation=true, status=200, layout='/responseLayout');
                    return;
                }
            } else {
                // Create new subscriber
                subscriber = model("NewsletterSubscriber").new();
                subscriber.email = email;
                subscriber.status = "pending";
                subscriber.verification_token = generateVerificationToken();
                subscriber.save();
                
                // Log new subscription
                model("Log").log(
                    category = "Newsletter",
                    level = "INFO",
                    message = "New newsletter subscription",
                    details = {
                        "email" = email,
                        "subscriber_id" = subscriber.id,
                        "ip_address" = cgi.REMOTE_ADDR,
                        "user_agent" = cgi.HTTP_USER_AGENT,
                        "action" = "subscribe",
                        "status" = "success",
                        "type" = "new_subscriber"
                    }
                );
            }

            // Send verification email
            var emailContent = renderView(template="verify", layout=false, returnAs="string", subscriber = subscriber);
            cfheader(name="Content-Type", value="text/html; charset=UTF-8");
            cfmail( 
                from = application.env.mail_from,
                to = email,
                subject = "Verify your newsletter subscription",
                server = application.env.smtp_host, 
                port = application.env.smtp_port, 
                username = application.env.smtp_username, 
                password = application.env.smtp_password, 
                type = "text/html"
            ){ 
                writeOutput(emailContent);
            };

            data = {
                "success" = true,
                "message" = "Please check your email to verify your subscription."
            };
            renderWith(data=data, hideDebugInformation=true, status=200, layout='/responseLayout');

        } catch (any e) {
            // Log error
            model("Log").log(
                category = "Newsletter",
                level = "ERROR",
                message = "Error in newsletter subscription",
                details = {
                    "email" = email,
                    "ip_address" = cgi.REMOTE_ADDR,
                    "user_agent" = cgi.HTTP_USER_AGENT,
                    "action" = "subscribe",
                    "status" = "error",
                    "error_message" = e.message,
                    "error_stacktrace" = e.stackTrace,
                    "error_type" = e.type,
                    "error_detail" = e.detail
                }
            );

            data = {
                "success" = false,
                "message" = "An error occurred. Please try again later."
            };
            renderWith(data=data, hideDebugInformation=true, status=500, layout='/responseLayout');
        }
    }

    function verify() {
        try {
            var token = params.token;
            var subscriber = model("NewsletterSubscriber").findOne(where="verification_token = '#token#' AND status = 'pending'");
            
            if (isNull(subscriber)) {
                // Log invalid verification attempt
                model("Log").log(
                    category = "Newsletter",
                    level = "WARN",
                    message = "Invalid verification token",
                    details = {
                        "token" = token,
                        "ip_address" = cgi.REMOTE_ADDR,
                        "user_agent" = cgi.HTTP_USER_AGENT,
                        "action" = "verify",
                        "status" = "failed",
                        "reason" = "invalid_token"
                    }
                );

                location("/", false);
            }

            // Activate subscriber
            subscriber.update(status = "active");
            
            // Log successful verification
            model("Log").log(
                category = "Newsletter",
                level = "INFO",
                message = "Newsletter subscription verified",
                details = {
                    "email" = subscriber.email,
                    "subscriber_id" = subscriber.id,
                    "ip_address" = cgi.REMOTE_ADDR,
                    "user_agent" = cgi.HTTP_USER_AGENT,
                    "action" = "verify",
                    "status" = "success"
                }
            );

            // Send welcome email
            var emailContent = renderView(template="welcome", layout=false, returnAs="string", subscriber = subscriber);
            cfheader(name="Content-Type", value="text/html; charset=UTF-8");
            cfmail( 
                from = application.env.mail_from,
                to = subscriber.email,
                subject = "Welcome to our newsletter!",
                server = application.env.smtp_host, 
                port = application.env.smtp_port, 
                username = application.env.smtp_username, 
                password = application.env.smtp_password, 
                type = "text/html"
            ){ 
                writeOutput(emailContent);
            };

            location("/", false);
        } catch (any e) {
            // Log error
            model("Log").log(
                category = "Newsletter",
                level = "ERROR",
                message = "Error in newsletter verification",
                details = {
                    "token" = params.token,
                    "ip_address" = cgi.REMOTE_ADDR,
                    "user_agent" = cgi.HTTP_USER_AGENT,
                    "action" = "verify",
                    "status" = "error",
                    "error_message" = e.message,
                    "error_stacktrace" = e.stackTrace,
                    "error_type" = e.type,
                    "error_detail" = e.detail
                }
            );

                location("/", false);
        }
    }

    function unsubscribe() {
        try {
            var email = params.email;
            
            // Log unsubscribe attempt
            model("Log").log(
                category = "Newsletter",
                level = "INFO",
                message = "Newsletter unsubscribe attempt",
                details = {
                    "email" = email,
                    "ip_address" = cgi.REMOTE_ADDR,
                    "user_agent" = cgi.HTTP_USER_AGENT,
                    "action" = "unsubscribe",
                    "status" = "attempt"
                }
            );

            // Check if email exists in users table
            var user = model("User").findOne(where="email = '#email#'");
            if (!isNull(user)) {
                // Update user's newsletter subscription
                user.update(newsletter = false);
                
                // Log successful unsubscription
                model("Log").log(
                    category = "Newsletter",
                    level = "INFO",
                    message = "User unsubscribed from newsletter",
                    details = {
                        "email" = email,
                        "user_id" = user.id,
                        "ip_address" = cgi.REMOTE_ADDR,
                        "user_agent" = cgi.HTTP_USER_AGENT,
                        "action" = "unsubscribe",
                        "status" = "success",
                        "type" = "existing_user"
                    }
                );

                data = {
                    "success" = true,
                    "message" = "You have been unsubscribed from our newsletter."
                };
                renderWith(data=data, hideDebugInformation=true, status=200, layout='/responseLayout');
                return;
            }

            // Check if email exists in newsletter_subscribers table
            var subscriber = model("NewsletterSubscriber").findOne(where="email = '#email#'");
            if (!isNull(subscriber)) {
                // Update subscriber status
                subscriber.update(status = "inactive");
                
                // Log successful unsubscription
                model("Log").log(
                    category = "Newsletter",
                    level = "INFO",
                    message = "Subscriber unsubscribed from newsletter",
                    details = {
                        "email" = email,
                        "subscriber_id" = subscriber.id,
                        "ip_address" = cgi.REMOTE_ADDR,
                        "user_agent" = cgi.HTTP_USER_AGENT,
                        "action" = "unsubscribe",
                        "status" = "success",
                        "type" = "newsletter_subscriber"
                    }
                );

                data = {
                    "success" = true,
                    "message" = "You have been unsubscribed from our newsletter."
                };
                renderWith(data=data, hideDebugInformation=true, status=200, layout='/responseLayout');
            } else {
                // Log failed unsubscription
                model("Log").log(
                    category = "Newsletter",
                    level = "WARN",
                    message = "Unsubscribe attempt for non-existent email",
                    details = {
                        "email" = email,
                        "ip_address" = cgi.REMOTE_ADDR,
                        "user_agent" = cgi.HTTP_USER_AGENT,
                        "action" = "unsubscribe",
                        "status" = "failed",
                        "reason" = "email_not_found"
                    }
                );

                data = {
                    "success" = false,
                    "message" = "Email not found in our records."
                };
                renderWith(data=data, hideDebugInformation=true, status=404, layout='/responseLayout');
            }

        } catch (any e) {
            // Log error
            model("Log").log(
                category = "Newsletter",
                level = "ERROR",
                message = "Error in newsletter unsubscription",
                details = {
                    "email" = params.email,
                    "ip_address" = cgi.REMOTE_ADDR,
                    "user_agent" = cgi.HTTP_USER_AGENT,
                    "action" = "unsubscribe",
                    "status" = "error",
                    "error_message" = e.message,
                    "error_stacktrace" = e.stackTrace,
                    "error_type" = e.type,
                    "error_detail" = e.detail
                }
            );

            data = {
                "success" = false,
                "message" = "An error occurred. Please try again later."
            };
            renderWith(data=data, hideDebugInformation=true, status=500, layout='/responseLayout');
        }
    }

    private function generateVerificationToken() {
        return CreateUUID();
    }
} 