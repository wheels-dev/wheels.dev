<main>
    <div class="container py-5">
        <div class="row justify-content-center justify-content-lg-between">
            <div class="bg-white rounded-5 shadow-sm mt-4 p-4">
                <a href="user/addEditUser"> Add User </a>
                <h1 class="text-center fs-24 fw-bold">Users List</h1>
                <table class="table table-hover">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>First Name</th>
                            <th>Last Name</th>
                            <th>Email</th>
                            <th>Status</th>
                            <th>Role</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody id="users-container" hx-get="/user/loadUsers" hx-trigger="load" hx-target="#users-container" hx-swap="innerHTML">
                        <!--- Load User List thorugh partial view --->
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</main>
