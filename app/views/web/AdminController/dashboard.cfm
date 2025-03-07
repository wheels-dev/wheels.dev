<h1>Admin Dashboard</h1>
<div>
    <p>Total Users: <span id="totalUsers">#stats.totalUsers#</span></p>
    <p>Active Users: <span id="activeUsers">#stats.activeUsers#</span></p>
    <p>Total Blogs: <span id="totalBlogs">#stats.totalBlogs#</span></p>
</div>
<h2>Recent Users</h2>
<ul>
    <cfloop array="#recentUsers#" item="user">
        <li>#user.name# (#user.email#)</li>
    </cfloop>
</ul>

<h2>Recent Blogs</h2>
<ul>
    <cfloop array="#recentBlogs#" item="blog">
        <li>#blog.title# - #blog.status#</li>
    </cfloop>
</ul>
