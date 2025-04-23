
<cfscript>
    for (var i = 1; i <= users.recordCount; i++) {
        // Determine the status text based on the value of users.status[i]
        var statusText = (users.status[i] == 1) ? "Active" : "Inactive";

        writeOutput('<tr> <td class="text-center">' & i & '</td>');
        writeOutput('<td>' & users.firstname[i] & '</td>');
        writeOutput('<td>' & users.lastname[i] & '</td>');
        writeOutput('<td>' & users.email[i] & '</td>');
        writeOutput('<td>' & statusText & '</td>'); // Show "Active" or "Inactive"
        writeOutput('<td>' & users.name[i] & '</td>');

        writeOutput('<td class="text-center">
            <div class="dropdown">
                <div class="fw-bold cursor-pointer" data-bs-toggle="dropdown" aria-expanded="false">
                    ...
                </div>
                <ul class="dropdown-menu">
                    <li>
                        <a href="user/add?id=#users.id[i]#" class="dropdown-item text-success fs-16">Edit</a>
                    </li>
                    <li>
                        <a href="user/delete?id=#users.id[i]#" class="dropdown-item text-danger fs-16" onclick="return confirmDelete(#users.id[i]#);">Delete</a>
                    </li>
                </ul>
            </div>
        </td>');
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
<script>
    let table = new DataTable('#userTable', {
        columnDefs: [
            {
                targets: [5,6], // Adjust these indexes based on your actual table structure
                orderable: false
            }
        ]
    });
</script>