<html lang="en">
<head>+
    <cfoutput>#csrfMetaTags()#</cfoutput>
    <meta charset="UTF-8">
    <title>Admin Panel</title>
    <mta name="viewport" content="width=device-width, initial-scale=1.0">
    <script src="https://unpkg.com/htmx.org@1.9.2"></script>
    <link rel="stylesheet" href="/stylesheets/admin.css">
</head>
<body>
    <nav>
        <a href="/admin/dashboard" hx-get="/admin/dashboard" hx-target="#content" hx-push-url="true">Dashboard</a>
        <a href="/admin/users" hx-get="/admin/users" hx-target="#content" hx-push-url="true">Users</a>
        <a href="/admin/blogs" hx-get="/admin/blogs" hx-target="#content" hx-push-url="true">Blogs</a>
    </nav>
    <main id="content">
        <!-- Content will be dynamically loaded here -->
    </main>
</body>
</html>