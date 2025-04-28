<div class="container py-5">
    <div class="row mb-4 gx-6 gy-3 align-items-center">
        <div class="col-auto">
            <h1 class="text-center fs-24 fw-bold">Users List</h1>
        </div>
        <div class="col-auto">
            <a class="btn btn-primary px-5" href="user/add"><i class="fa-solid fa-plus me-2"></i>Add User</a>
        </div>
    </div>
    <table id="userTable" class="table table-hover">
        <thead>
            <tr>
                <th class="text-center">ID</th>
                <th>First Name</th>
                <th>Last Name</th>
                <th>Email</th>
                <th>Status</th>
                <th>Role</th>
                <th>Actions</th>
            </tr>
        </thead>
        <tbody id="users-container">
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
                                    <a href="user/edit/#users.id[i]#" class="dropdown-item text-success fs-16">Edit</a>
                                </li>
                                <li>
                                    <a href="user/delete/#users.id[i]#" class="dropdown-item text-danger fs-16" onclick="return confirmDelete(#users.id[i]#);">Delete</a>
                                </li>
                            </ul>
                        </div>
                    </td>');
                }
            </cfscript>
        </tbody>
    </table>
</div>
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
    var table = new DataTable('#userTable', {
        columnDefs: [
            {
                targets: [5,6], // Adjust these indexes based on your actual table structure
                orderable: false
            }
        ]
    });
    table.on('draw', function() {
        htmx.process(document.body);
    });
</script>