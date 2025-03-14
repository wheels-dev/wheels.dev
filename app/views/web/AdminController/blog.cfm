<main>
    <div class="container py-5">
        <div class="row justify-content-center justify-content-lg-between">
            <div class="bg-white rounded-5 shadow-sm mt-4 p-4">
                <h1 class="text-center fs-24 fw-bold">Blogs List</h1>
                <table class="table table-hover">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Title</th>
                            <th>Slug</th>
                            <th>Excerpt</th>
                            <th>Category</th>
                            <th>Status</th>
                            <th>Post Type</th>
                            <th>Created By</th>
                            <th>Content</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody id="blogs-container" hx-get="/admin/BlogList" hx-trigger="load" hx-target="#blogs-container" hx-swap="innerHTML">
                        <!--- Load Blog List thorugh partial view --->
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</main>
