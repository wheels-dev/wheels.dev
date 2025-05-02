<cfoutput>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Welcome to Wheels.dev Newsletter</title>
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
        .content {
            background-color: ##f9f9f9;
            padding: 20px;
            border-radius: 5px;
        }
        .footer {
            text-align: center;
            margin-top: 30px;
            font-size: 12px;
            color: ##666;
        }
        .unsubscribe {
            text-align: center;
            margin-top: 20px;
            font-size: 12px;
        }
    </style>
</head>
<body>
    <div class="header">
        <img src="" alt="Wheels.dev" width="200">
    </div>
    
    <div class="content">
        <h2>Welcome to Wheels.dev Newsletter!</h2>
        <p>Thank you for subscribing to our newsletter. We're excited to keep you updated with the latest news, updates, and resources from the Wheels.dev community.</p>
        <p>You'll receive regular updates about:</p>
        <ul>
            <li>New features and improvements</li>
            <li>Community events and meetups</li>
            <li>Helpful tutorials and guides</li>
            <li>Latest releases and updates</li>
        </ul>
        <p>If you have any questions or suggestions, feel free to reply to this email.</p>
    </div>
    
    <div class="unsubscribe">
        <p>If you no longer wish to receive our newsletter, you can <a href="http://#cgi.http_host#/newsletter/unsubscribe?email=#subscriberEmail#">unsubscribe here</a>.</p>
    </div>
    
    <div class="footer">
        <p>&copy; #year(now())# Wheels.dev. All rights reserved.</p>
    </div>
</body>
</html>
</cfoutput> 