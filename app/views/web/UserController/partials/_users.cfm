
<cfscript>
    for (var i = 1; i <= users.recordCount; i++) {
        // Determine the status text based on the value of users.status[i]
        var statusText = (users.status[i] == 1) ? "Active" : "Inactive";

        writeOutput('<tr> <td>' & users.id[i] & '</td>');
        writeOutput('<td>' & users.firstname[i] & '</td>');
        writeOutput('<td>' & users.lastname[i] & '</td>');
        writeOutput('<td>' & users.email[i] & '</td>');
        writeOutput('<td>' & statusText & '</td>'); // Show "Active" or "Inactive"
        writeOutput('<td>' & users.name[i] & '</td>');
        // writeOutput('<td>' & '<a href="user/addEditUser?id=#users.id[i]#">Edit</a> | 
        //     <a href="user/delete?id=#users.id[i]#">Delete</a>' & '</td></tr>');

        writeOutput('<td>' & 
            '<a href="user/addEditUser?id=#users.id[i]#">Edit</a> | 
            <a href="user/delete?id=#users.id[i]#" 
            onclick="return confirmDelete(#users.id[i]#);">Delete</a>' & '</td></tr>');
    }
</cfscript>

<script type="text/javascript">
    // JavaScript function to show a confirmation alert
    function confirmDelete(userId) {
        var confirmation = confirm("Are you sure you want to delete this user?");
        if (confirmation) {
            // Redirect to the delete URL if confirmed
            window.location.href = "user/delete?id=" + userId;
        }
        return false; // Prevent the default action (following the link)
    }
</script>