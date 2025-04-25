<h1>Users</h1>
<input type="text" id="search" name="search" placeholder="Search users..." 
       hx-get="/admin/users" hx-trigger="keyup changed delay:500ms" 
       hx-target="#userList" hx-push-url="true">
<table>
    <thead>
        <tr>
            <th>Name</th>
            <th>Email</th>
            <th>Actions</th>
        </tr>
    </thead>
    <tbody id="userList">
        <cfloop array="#users#" item="user">
            <tr>
                <td>#user.name#</td>
                <td>#user.email#</td>
                <td>
                    <a href="/admin/userForm?key=#user.id#" hx-get="/admin/userForm?key=#user.id#" hx-target="#content">Edit</a>
                </td>
            </tr>
        </cfloop>
    </tbody>
</table>
