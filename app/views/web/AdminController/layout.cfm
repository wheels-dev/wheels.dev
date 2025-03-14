<html lang="en">
<head>+
    <cfoutput>#csrfMetaTags()#</cfoutput>
    <meta charset="UTF-8">
    <title>Admin Panel</title>
    <mta name="viewport" content="width=device-width, initial-scale=1.0">
    <script src="https://unpkg.com/htmx.org@1.9.2"></script>
    <link rel="stylesheet" href="/stylesheets/admin.css">
    <!-- Bootstrap CSS -->
    <link href="/stylesheets/font.css" rel="stylesheet">
    <link href="/stylesheets/bootstrap.css" rel="stylesheet">
    <link href="/stylesheets/color.css" rel="stylesheet">
    <link href="/stylesheets/style.css" rel="stylesheet">
    <link href="/stylesheets/utils.css" rel="stylesheet">
</head>
<body>
    <cfset isUserAuth = find("/user/", cgi.path_info)>
    <nav class="navbar <cfoutput> #isUserAuth ? "d-none" : ""# </cfoutput> sticky-top navbar-expand-lg py-2 nav-bg">
        <div class="container">
            <a class="navbar-brand" href="/">
                <img src="/images/wheels-logo.png" alt="Bootstrap" width="260">
            </a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse"
                data-bs-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false"
                aria-label="Toggle navigation">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarSupportedContent">
                <ul class="navbar-nav divide-x-primary mx-auto mb-2 mb-lg-0 align-items-center">
                    <li class="nav-item px-3">
                        <a href="/admin/dashboard" hx-get="/admin/dashboard" hx-target="#content" hx-push-url="true">Dashboard</a>
                    </li>
                    <li class="nav-item px-3">
                        <a href="/admin/user">Users</a>
                    </li>
                    <li class="nav-item px-3">
                        <a href="/admin/blogs" hx-get="/admin/blogs" hx-target="#content" hx-push-url="true">Blogs</a>
                    </li>

                    <div class="col-lg-5 mt-lg-0 mt-3 offset-lg-3 col-12 d-flex justify-content-end gap-3">
                        <cfif StructKeyExists(session, "userId") and session.userId neq ''>
                            <cfoutput>
                                <a href="##" class="btn btn-secondary px-4">#session.username#</a>
                                <a href="/logout" class="btn btn-primary px-4">Logout</a>
                            </cfoutput>
                        </cfif>
                    </div>
                   
                </ul>
                
            </div>
        </div>
    </nav>
    <!---     <nav> 
        <a href="/admin/dashboard" hx-get="/admin/dashboard" hx-target="#content" hx-push-url="true">Dashboard</a>
        <a href="/admin/users" hx-get="/admin/users" hx-target="#content" hx-push-url="true">Users</a>
        <a href="/admin/blogs" hx-get="/admin/blogs" hx-target="#content" hx-push-url="true">Blogs</a>
    </nav>--->
    <main id="content">
        <!-- Content will be dynamically loaded here -->
        <cfoutput>
            #flashMessages()#
            #includeContent()#
        </cfoutput>
    </main>
    <!-- Bootstrap JS -->
    <script src="/javascripts/bootstrap.js"></script>
    <script src="/javascripts/jquery.min.js"></script>
</body>
</html>