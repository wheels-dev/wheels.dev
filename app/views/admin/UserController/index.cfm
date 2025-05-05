<div class="container">
    <div class="bg-white p-4 box-shadow rounded-4 mt-3">
        <div id="flash-message" class="my-3"></div>
        <div class="d-flex mb-3 justify-content-between align-items-center">
            <div class="col-auto">
                <h1 class="text-center fs-24 fw-bold">Users List</h1>
            </div>
            <div>
                <a class="btn bg--primary text-white px-5" hx-get="/admin/user/add" hx-target="body" hx-trigger="click" hx-swap="innerHTML"><i class="fa-solid fa-plus me-2"></i>Add User</a>
            </div>
        </div>
        <div class="table-responsive">
            <table id="userTable" class="table table-hover table-striped">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>First Name</th>
                        <th>Last Name</th>
                        <th>Email</th>
                        <th>Status</th>
                        <th>Role</th>
                        <th></th>
                    </tr>
                </thead>
                <tbody id="users-container">
                    <cfscript>
                        for (var i = 1; i <= users.recordCount; i++) {
                            // Determine the status text based on the value of users.status[i]
                            var statusText = (users.status[i] == 1) ? "Active" : "Inactive";
                            if(users.id[i] neq "#session.userId#"){
                                writeOutput('<tr> <td>' & i & '</td>');
                                writeOutput('<td>' & users.firstname[i] & '</td>');
                                writeOutput('<td>' & users.lastname[i] & '</td>');
                                writeOutput('<td>' & users.email[i] & '</td>');
                                writeOutput('<td>' & statusText & '</td>'); // Show "Active" or "Inactive"
                                writeOutput('<td>' & users.name[i] & '</td>');
    
                                writeOutput('<td>
                                    <div class="dropdown">
                                        <div class="fw-bold cursor-pointer me-2" data-bs-toggle="dropdown" aria-expanded="false">
                                            ...
                                        </div>
                                        <ul class="dropdown-menu">
                                            <li>
                                                <a hx-get="/admin/user/edit/#users.id[i]#" hx-target="body" hx-trigger="click" hx-swap="innerHTML" class="dropdown-item text-success fs-16">Edit</a>
                                            </li>
                                            <li>
                                                <a hx-get="/admin/user/delete/#users.id[i]#" hx-target="closest tr" hx-swap="outerHTML" hx-trigger="click" hx-confirm="Are you sure you want to delete this user?" class="dropdown-item text-danger fs-16"">Delete</a>
                                            </li>
                                        </ul>
                                    </div>
                                </td>');
                            }
                        }
                    </cfscript>
                </tbody>
            </table>
        </div>
    </div>
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

    document.body.addEventListener("htmx:afterRequest", function(event) {
        const xhr = event.detail.xhr;
        if (xhr.status === 200 && xhr.responseURL.includes("/user/delete/")) {
            document.querySelector("#flash-message").innerHTML = `
            <div class="alert alert-subtle-success alert-dismissible fade show" role="alert">
                User deleted successfully!
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>`;

            // Auto-hide after 5 seconds
            setTimeout(() => {
                const alert = document.querySelector("#flash-message .alert");
                if (alert) alert.classList.remove("show");
            }, 5000);
        }else if(xhr.status === 500 && xhr.responseURL.includes("/user/delete/")){
            document.querySelector("#flash-message").innerHTML = `
            <div class="alert alert-subtle-danger alert-dismissible fade show" role="alert">
                Error: User not deleted!
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>`;
        }
    });

</script>