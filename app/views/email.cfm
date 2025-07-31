<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <style>
            body {
                font-family: Arial, sans-serif;
                background-color: #f4f4f4;
                margin: 0;
                padding: 0;
            }
            .container {
                max-width: 600px;
                margin: 40px auto;
                background: #ffffff;
                padding: 20px;
                border-radius: 8px;
                box-shadow: 0px 4px 10px rgba(0, 0, 0, 0.1);
                text-align: center;
            }
            .signatureBox{
                background: #e7e7e7;
                padding: 6px;
                border-radius: 8px;
            }
            .logo {
                width: 120px;
                margin-bottom: 20px;
            }
            h1 {
                color: #444;
                font-size: 24px;
            }
            h2 {
                color: #444;
                font-size: 21px;
            }
            h5 {
                color: #444;
                font-size: 12px;
            }
            p {
                color: #666;
                font-size: 18px;
                line-height: 1.5;
            }
            .button {
                display: inline-block;
                background-color: #ef3b2d;
                color: #ffffff !important;
                text-decoration: none !important;
                text-decoration: none;
                font-size: 16px;
                font-weight: 600;
                padding: 14px 28px;
                border-radius: 1rem;
                margin-top: 20px;
            }
            .button-start{
                display: inline-block;
                background-color: #ef3b2d;
                color: #ffffff !important;
                text-decoration: none !important;
                font-size: 14px;
                font-weight: 600;
                padding: 12px 24px;
                border-radius: 1rem;
            }
            .button-download{
                display: inline-block;
                background-color: #6BE89D;;
                color: #0c1620 !important;
                text-decoration: none !important;
                font-size: 14px;
                font-weight: 600;
                padding: 12px 24px;
                border-radius: 1rem;
            }
            .footer {
                margin-top: 30px;
                font-size: 14px;
                color: #666;
            }
            .mb-4{
                margin-bottom: 4px; 
            }
            .signature{
                margin-top: 5px;
                font-size: 12px;
                color: #666;
            }
        </style>
    </head>
    <body>
        <cfoutput>
            <div class="container">
                  <img style="margin-top: 5px;" src="https://wheels.dev/img/wheels-logo.png" alt="Wheels.dev Logo" width="260">
                <cfif structKeyExists(params, "welcomeMessage") AND params.welcomeMessage neq "">
                    <h1 class="mt-4">#params.welcomeMessage#</h1>
                </cfif>
                <h2 class="mt-4">Dear #params.name#</h2>
                <p class="mb-4">#params.content#</p>
                <cfif params.buttonTitle neq "">
                    <a href="#params.URl#" class="button"> #params.buttonTitle# </a>
                </cfif>
                <cfif params.footerNote neq "">
                    <p class="footer">#params.footerNote#</p>
                </cfif>

                <hr
                  style="width:100%;border:none;border-top:1px solid ##CCCCCC;margin:0"
                />
                <cfif structKeyExists(params, "footerGreetings") AND params.footerGreetings neq "">
                    <p class="mb-4" style="font-size: 14px;">#params.footerGreetings#</p>
                </cfif>
                <div style="margin-top: 15px; text-align: center;">
                    <a href="https://wheels.dev/guides" target="_blank" class="button-start"> Get Started </a>
                    <a style="margin-left : 8px;" href="https://github.com/wheels-dev/wheels/releases" target="_blank" class="button-download"> Download </a>
                </div>
                <cfif params.closingRemark neq "">
                    <p style="font-size: 14px;">#params.closingRemark#</p>
                </cfif>
                <cfif params.teamSignature neq "">
                    <h5 style="margin-top: 5px !important; font-size: 14px;">#params.teamSignature#<h5>
                </cfif>
                <div class="signatureBox">
                    <p class="signature">&copy;2005-2025 Wheels.Dev. All rights are reserved.<br>Wheels is licensed under the Apache License, Version 2.0.</p>
                    <cfif structKeyExists(params, "isSubscriber") AND params.isSubscriber eq true>
                        <p class="footer" style="color: 707070 !important; margin: 5px !important; font-size: 12px;">You're receiving this email because you're part of the Wheels community. If you'd like to manage your preferences or unsubscribe, click <a href="javascript:void(0)">here</a>.</p>
                    </cfif>
                </div>
            </div>
        </cfoutput>
    </body>
</html>