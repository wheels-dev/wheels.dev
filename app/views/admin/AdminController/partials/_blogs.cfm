<div id="responseTable">
    <cfoutput>
        <div class="container py-5">
            <div class="d-flex justify-content-between align-items-center">
                <div class="col-auto">
                    <h1 class="fs-24 mb-5 fw-bold">Blogs</h1>
                </div>
                <div class="d-flex gap-2">
                    <form id="bulkRejectForm" hx-post="/admin/bulkReject" hx-target="##responseTable" hx-swap="innerHTML">#authenticityTokenField()#</form>
                    <button id="bulkRejectBtn" class="btn btn-ligh border solid mb-3">Reject Selected</button>
                    <form id="bulkForm" hx-post="bulkApprove" hx-target="##responseTable" hx-swap="innerHTML">#authenticityTokenField()#</form>
                    <button id="bulkApproveBtn" class="btn bg--primary text-white mb-3">Approve Selected</button>
                </div>
            </div>
            <table id="blogTable" class="table table-hover mb-5">
                <thead>
                    <tr>
                        <th>
                            <div class="form-check">
                                <input type="checkbox" class="form-check-input" id="selectAll">
                            </div>
                        </th>
                        <th>No.</th>
                        <th>Title</th>
                        <th>Status</th>
                        <th>Categories</th>
                        <th>Publish Date</th>
                        <th>Disable Comments</th>
                        <th>Created By</th>
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
                                <div class="form-check">
                                    <input type="checkbox" class="rowCheckbox form-check-input" value="#blogId#">
                                </div>
                            </td>
                            <td>#i#</td>
                            <td><a href="blog/#blogs.slug[i]#" class="cursor-pointer text-primary">#blogs.title[i]#</a></td>
                            <td>#blogs.NAME[i]#</td>
                            <td><cfif structKeyExists(blogCategoryMap, blogs.id[i])>#arrayToList(blogCategoryMap[blogs.id[i]])#</cfif></td>
                            <td>
                                <input class="form-control form-control-sm" id="publishDate-#blogs.id[i]#" name="publishDate-#blogs.id[i]#" type="datetime-local" <cfif len(trim(blogs.publishedAt[i]))>value="#dateFormat(blogs.publishedAt[i], 'yyyy-mm-dd')#T#timeFormat(blogs.publishedAt[i], 'HH:mm')#"</cfif> hx-post="/admin/publishblog/#blogs.id[i]#" hx-vals='{"authenticityToken": "#authenticityToken()#"}' hx-trigger="change" hx-target="this" hx-swap="none" style="min-width: 180px;"/>
                            </td>
                            <td>
                                <div class="form-check form-switch">
                                    <input class="form-check-input" id="closeComment-#blogs.id[i]#" name="closeComment-#blogs.id[i]#" type="checkbox" <cfif blogs.iscommentClosed[i]> checked </cfif> hx-post="/admin/closeComments/#blogs.id[i]#" hx-vals='{"authenticityToken": "#authenticityToken()#"}' hx-trigger="change" hx-target="this" hx-swap="none"/>
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
                                    <div class="fw-bold cursor-pointer" data-bs-toggle="dropdown" aria-expanded="false">
                                        ...
                                    </div>
                                    <ul class="dropdown-menu">
                                        <li>
                                            <button
                                                class="dropdown-item text-success fs-16"
                                                hx-post="approve"
                                                hx-vals='{"id": "#blogs.id[i]#", "authenticityToken": "#authenticityToken()#"}'
                                                hx-target=".approval-status-#blogId#"
                                                hx-swap="innerHTML"
                                                hx-confirm="Are you sure you want to approve this blog?"
                                            >Approve</button>
                                        </li>
                                        <li>
                                            <button
                                                class="dropdown-item text-danger fs-16"
                                                hx-post="reject"
                                                hx-vals='{"id": "#blogs.id[i]#", "authenticityToken": "#authenticityToken()#"}'
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
    </script>
</div>