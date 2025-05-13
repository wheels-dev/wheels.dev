<main>
    <div id="responseTable" class="bg-white p-4 box-shadow rounded-4 mt-3">
        <cfoutput>
            <div class="container">
                <div class="d-flex justify-content-between align-items-center">
                    <div class="col-auto">
                        <h1 class="fs-24 mb-3 fw-bold">Blogs</h1>
                    </div>
                    <div class="d-flex gap-2">
                        <form id="bulkRejectForm" hx-post="/admin/bulkReject" hx-target="##responseTable" hx-swap="innerHTML"></form>
                        <button id="bulkRejectBtn" class="btn btn-ligh border solid mb-3">Reject Selected</button>
                        <form id="bulkForm" hx-post="/admin/bulkApprove" hx-target="##responseTable" hx-swap="innerHTML"></form>
                        <button id="bulkApproveBtn" class="btn bg--primary text-white mb-3">Approve Selected</button>
                    </div>
                </div>
                <div class="table-responsive">
                    <table id="blogTable" class="table table-hover table-striped">
                        <thead>
                            <tr>
                                <th>
                                    <div class="form-check">
                                        <input type="checkbox" class="form-check-input form-check-input-primary" id="selectAll">
                                    </div>
                                </th>
                                <th>No.</th>
                                <th>Title</th>
                                <th>Status</th>
                                <th>Categories</th>
                                <th>Publish</th>
                                <th>Disable Comments</th>
                                <th>Author</th>
                                <th>Approval Status</th>
                                <th></th>
                            </tr>
                        </thead>
                        <tbody>
                            <cfloop from="1" to="#blogs.recordCount#" index="i">
                                <cfset blogId = blogs.id[i]>
                                <cfset truncatedContent = left(blogs.content[i], 100) & "...">
    
                                <tr id="blog-#blogId#">
                                    <td>
                                        <div class="form-check ms-2">
                                            <input type="checkbox" class="rowCheckbox form-check-input form-check-input-primary" value="#blogId#">
                                        </div>
                                    </td>
                                    <td class="text-center">#i#</td>
                                    <td><a href="blog/#blogs.slug[i]#" class="cursor-pointer text-primary">#blogs.title[i]#</a></td>
                                    <td>#blogs.NAME[i]#</td>
                                    <cfscript>
                                        var categories = model("BlogCategory").findAll(
                                            select = "name",
                                            where = "blogId = #blogs.id[i]#",
                                            include = "Blog,Category"
                                        );
                                        var categoryNames = valueList(categories.name);
                                    </cfscript>
                                    <td>#categoryNames#</td>
                                    <td>
                                        <div class="form-check form-switch">
                                            <input class="form-check-input" id="isPublished-#blogs.id[i]#" name="isPublished-#blogs.id[i]#" type="checkbox" <cfif blogs.isPublished[i]> checked </cfif> hx-get="/admin/publishblog/#blogs.id[i]#" hx-trigger="change" hx-target="this" hx-swap="none"/>
                                        </div>
                                    </td>
                                    <td>
                                        <div class="form-check form-switch">
                                            <input class="form-check-input" id="closeComment-#blogs.id[i]#" name="closeComment-#blogs.id[i]#" type="checkbox" <cfif blogs.iscommentClosed[i]> checked </cfif> hx-get="/admin/closeComments/#blogs.id[i]#" hx-trigger="change" hx-target="this" hx-swap="none"/>
                                        </div>
                                    </td>
                                    <td>#blogs.fullName[i]#</td>
                                    <td>
                                        <span class="approval-status-#blogId#">
                                            <cfif blogs.status[i] eq 'Approved'>
                                                <span class="badge bg-success">Approved</span>
                                            <cfelseif blogs.status[i] eq 'Rejected'>
                                                <span class="badge bg-danger">Rejected</span>
                                            <cfelse>
                                                <span class="badge bg-warning text-dark">Pending</span>
                                            </cfif>
                                        </span>
                                    </td>
                                    <td>
                                        <div class="dropdown">
                                            <div class="fw-bold cursor-pointer me-2" data-bs-toggle="dropdown" aria-expanded="false">
                                                ...
                                            </div>
                                            <ul class="dropdown-menu">
                                                <li>
                                                    <a 
                                                        class="dropdown-item fs-16"
                                                        href="blog/edit/#blogs.id[i]#" 
                                                    >Edit</a>
                                                </li>
                                                <li>
                                                    <button 
                                                        class="dropdown-item text-success fs-16"
                                                        hx-post="approve" 
                                                        hx-vals='{"id": "#blogs.id[i]#"}'
                                                        hx-target=".approval-status-#blogId#"
                                                        hx-swap="innerHTML"
                                                        hx-confirm="Are you sure you want to approve this blog?"
                                                    >Approve</button>
                                                </li>
                                                <li>
                                                    <button 
                                                        class="dropdown-item text-danger fs-16"
                                                        hx-post="reject" 
                                                        hx-vals='{"id": "#blogs.id[i]#"}'
                                                        hx-target=".approval-status-#blogId#"
                                                        hx-swap="innerHTML"
                                                        hx-confirm="Are you sure you want to reject this blog?"
                                                    >Reject</button>
                                                </li>
                                            </ul>
                                        </div>
                                    </td>
                                </tr>
                            </cfloop>
                        </tbody>
                    </table>
                </div>
            </div>
        </cfoutput>
        <script>
            var table = new DataTable('#blogTable', {
                columnDefs: [
                    {
                        targets: [0,6,7], // Adjust these indexes based on your actual table structure
                        orderable: false
                    }
                ]
            });
            table.on('draw', function() {
                htmx.process(document.body);
            });
            document.getElementById("selectAll").addEventListener("change", function() {
                let checkboxes = document.querySelectorAll(".rowCheckbox");
                checkboxes.forEach(cb => cb.checked = this.checked);
            });
            document.getElementById("bulkApproveBtn").addEventListener("click", function (event) {
                event.preventDefault(); // Cancel default button behavior

                const selected = document.querySelectorAll(".rowCheckbox:checked");

                if (selected.length === 0) {
                    alert("Please select at least one blog to approve.");
                    return;
                }
                const confirmAction = confirm(`Are you sure you want to approve ${selected.length} blog(s)?`);
                if (!confirmAction) {
                    return; // Stop if user cancels
                }
                const form = document.getElementById("bulkForm");
                form.innerHTML = ""; // Clear previous hidden inputs

                // Add hidden inputs to the form
                selected.forEach(cb => {
                    const input = document.createElement("input");
                    input.type = "hidden";
                    input.name = "selectedBlogIds[]";
                    input.value = cb.value;
                    form.appendChild(input);
                });

                // Submit via HTMX (uses requestSubmit to ensure HTMX captures it)
                form.requestSubmit();
            });
            document.getElementById("bulkRejectBtn").addEventListener("click", function (event) {
                event.preventDefault(); // Cancel default button behavior

                const selected = document.querySelectorAll(".rowCheckbox:checked");

                if (selected.length === 0) {
                    alert("Please select at least one blog to reject.");
                    return;
                }
                const confirmAction = confirm(`Are you sure you want to reject ${selected.length} blog(s)?`);
                if (!confirmAction) {
                    return; // Stop if user cancels
                }
                const form = document.getElementById("bulkRejectForm");
                form.innerHTML = ""; // Clear previous hidden inputs

                // Add hidden inputs to the form
                selected.forEach(cb => {
                    const input = document.createElement("input");
                    input.type = "hidden";
                    input.name = "selectedBlogIds[]";
                    input.value = cb.value;
                    form.appendChild(input);
                });

                // Submit via HTMX (uses requestSubmit to ensure HTMX captures it)
                form.requestSubmit();
            });
            document.body.addEventListener("htmx:afterRequest", function(event) {
                const xhr = event.detail.xhr;
                if (xhr.status === 500 && xhr.responseURL.includes("/admin/reject")) {
                    notifier.show('Error', 'Something went wrong!', 'danger', '', 5000);
                }
                if (xhr.status === 500 && xhr.responseURL.includes("/admin/approve")) {
                    notifier.show('Error', 'Something went wrong!', 'danger', '', 5000);
                }
                if (xhr.status === 200 && xhr.responseURL.includes("/admin/reject")) {
                    notifier.show('Success', 'Blogs post rejected successfully!', 'success', '', 5000);
                }
                if (xhr.status === 200 && xhr.responseURL.includes("/admin/approve")) {
                    notifier.show('Success', 'Blog post approved successfully!', 'success', '', 5000);
                }
                if (xhr.status === 500 && xhr.responseURL.includes("/admin/bulkApprove")) {
                    notifier.show('Error', 'Something went wrong!', 'danger', '', 5000);
                }
                if (xhr.status === 500 && xhr.responseURL.includes("/admin/bulkReject")) {
                    notifier.show('Error', 'Something went wrong!', 'danger', '', 5000);
                }
                if (xhr.status === 200 && xhr.responseURL.includes("/admin/bulkApprove")) {
                    notifier.show('Success', 'Blogs posts are approved successfully!', 'success', '', 5000);
                }
                if (xhr.status === 200 && xhr.responseURL.includes("/admin/bulkReject")) {
                    notifier.show('Success', 'Blogs posts rejected Successfully!', 'success', '', 5000);
                }
                if (xhr.status === 500 && xhr.responseURL.includes("/admin/publishblog")) {
                    notifier.show('Error', 'Something went wrong!', 'danger', '', 5000);
                }
                if (xhr.status === 200 && xhr.responseURL.includes("/admin/publishblog")) {
                    notifier.show('Success', 'Blog publish successfully!', 'success', '', 5000);
                }
                if (xhr.status === 500 && xhr.responseURL.includes("/admin/closeComments")) {
                    notifier.show('Error', 'Something went wrong!', 'danger', '', 5000);
                }
                if (xhr.status === 200 && xhr.responseURL.includes("/admin/closeComments")) {
                    notifier.show('Success', xhr.responseText, 'success', '', 5000);
                }
            });
        </script>
    </div>
</main>
