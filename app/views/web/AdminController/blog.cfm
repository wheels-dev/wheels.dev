<main>
    <cfoutput>
        <div class="container py-5">
            <div class="col-auto">
                <h1 class="fs-24 mb-5 fw-bold">Blogs</h1>
            </div>
            <table id="blogTable" class="table table-hover">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Title</th>
                        <th>Status</th>
                        <th>Categories</th>
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
                            <td>#i#</td>
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
                            <td>#blogs.fullName[i]#</td>
                            <td>
                                <cfif blogs.status[i] eq 'Approved'>
                                    <span class="badge bg-success">Approved</span>
                                <cfelseif blogs.status[i] eq 'Rejected'>
                                    <span class="badge bg-danger">Rejected</span>
                                <cfelse>
                                    <span class="badge bg-warning text-dark">Pending</span>
                                </cfif>
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
                                                hx-vals='{"id": "#blogId#"}'
                                                hx-confirm="Are you sure you want to approve this blog?"
                                            >Approve</button>
                                        </li>
                                        <li>
                                            <button 
                                                class="dropdown-item text-danger fs-16"
                                                hx-post="reject" 
                                                hx-vals='{"id": "#blogId#"}'
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
        let table = new DataTable('#blogTable', {
            columnDefs: [
                {
                    targets: [5,6], // Adjust these indexes based on your actual table structure
                    orderable: false
                }
            ]
        });
    </script>
</main>
