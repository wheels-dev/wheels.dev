<cfoutput>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Verify Your Newsletter Subscription</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            line-height: 1.6;
            color: ##333;
            max-width: 600px;
            margin: 0 auto;
            padding: 20px;
        }
        .header {
            text-align: center;
            margin-bottom: 30px;
        }
        .logo {
            max-width: 200px;
            height: auto;
        }
        .content {
            background-color: ##f9f9f9;
            padding: 30px;
            border-radius: 5px;
            margin-bottom: 30px;
        }
        .button {
            display: inline-block;
            padding: 12px 24px;
            background-color: ##007bff;
            color: ##fff !important;
            text-decoration: none !important;
            border-radius: 4px;
            margin: 20px 0;
        }
        .footer {
            text-align: center;
            font-size: 12px;
            color: ##666;
            margin-top: 30px;
        }
        .unsubscribe {
            text-align: center;
            margin-top: 20px;
            font-size: 12px;
            color: ##666;
        }
    </style>
</head>
<body>
    <div class="header">
        <img src="https://wheels.dev/img/wheels-logo.png" alt="Wheels.dev Logo" class="logo">
    </div>
    
    <div class="content">
        <h2>Verify Your Newsletter Subscription</h2>
        <p>Hello,</p>
        <p>Thank you for subscribing to the Wheels.dev newsletter! To complete your subscription, please click the button below:</p>
        
        <div style="text-align: center;">
            <a href="#URLFor(route='newsletter-verify', token=subscriber.verification_token)#" class="button">Verify Subscription</a>
        </div>
        
        <p>If you did not request this subscription, please ignore this email.</p>
    </div>
    
    <div class="unsubscribe">
        <p>If you no longer wish to receive our newsletter, you can <a href="#URLFor(route='newsletter-unsubscribe', email=subscriber.email)#">unsubscribe here</a>.</p>
    </div>
    
    <div class="footer">
        <p>&copy; #Year(Now())# Wheels.dev. All rights reserved.</p>
    </div>
</body>
</html> 
</cfoutput>