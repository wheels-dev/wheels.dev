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
        <tbody id="users-container" hx-get="/user/list" hx-trigger="load" hx-target="#users-container" hx-swap="innerHTML">
            <!--- Load User List thorugh partial view --->
        </tbody>
    </table>
</div>
