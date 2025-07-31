
<style>
    .body {
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
        color: #ffffff;
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
        color: #ffffff;
        text-decoration: none;
        font-size: 14px;
        font-weight: 600;
        padding: 12px 24px;
        border-radius: 1rem;
    }
    .button-download{
        display: inline-block;
        background-color: #6BE89D;;
        color: #0c1620;
        text-decoration: none;
        font-size: 14px;
        font-weight: 600;
        padding: 12px 24px;
        border-radius: 1rem;
    }
    .emailfooter {
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
<div class="body">
    <cfoutput>
        <a href="#urlFor(route="adminemail-templates")#" class="py-2 px-3 bg-white shadow-sm rounded-3" >
            <i class="bi bi-arrow-left"></i>
            <span class="fs-14 text--secondary">
                Back
            </span>
        </a>
        <div class="container">
            <img class="mt-4" src="/img/wheels-logo.png" alt="wheels.dev Logo" width="260">
            <cfif structKeyExists(email, "welcomeMessage")>
                <h1 class="mt-4">#email.welcomeMessage#</h1>
            </cfif>
            <h2 class="mt-4 fs-22">Dear #session.username#</h2>
            <p class="mb-4 mt-4">#email.message#</p>
            <cfif email.buttonTitle neq "">
                <a href="javascript:void(0)" class="button"> #email.buttonTitle# </a>
            </cfif>
            <cfif email.footerNote neq "">
                <p class="emailfooter">#email.footerNote#</p>
            </cfif>

            <hr
                style="width:100%;border:none;border-top:1px solid ##CCCCCC;margin:0"
            />
            <cfif structKeyExists(email, "footerGreetings") AND email.footerGreeting neq "">
                <p class="mb-4" style="font-size: 14px;">#email.footerGreeting#</p>
            </cfif>
            <div style="margin-top: 15px; text-align: center;">
                <a href="https://wheels.dev/guides" target="_blank" class="button-start"> Get Started </a>
                <a style="margin-left : 8px;" href="https://github.com/wheels-dev/wheels/releases" target="_blank" class="button-download"> Download </a>
            </div>
            <cfif email.closingRemark neq "">
                <p class="mt-4 fs-14">#email.closingRemark#</p>
            </cfif>
            <cfif email.teamSignature neq "">
                <h5 class="mt-4 mb-4 fs-14">The Team Wheels<h5>
            </cfif>
            <div class="signatureBox">
                <p class="signature">&copy;2005-2025 Wheels.Dev. All rights are reserved.<br>Wheels is licensed under the Apache License, Version 2.0.</p>
                <cfif structKeyExists(email, "isSubscriber") AND email.isSubscriber eq true>
                    <p class="footer" style="color: 707070 !important; margin: 5px !important; font-size: 12px;">You're receiving this email because you're part of the Wheels community. If you'd like to manage your preferences or unsubscribe, click <a href="javascript:void(0)">here</a>.</p>
                </cfif>
            </div>
        </div>
    </cfoutput>
</div>