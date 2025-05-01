<cfoutput>
    <div class="rolesResponce container py-5">
        <div class="row mb-4 gx-6 gy-3 align-items-center">
            <div class="col-auto">
                <h1 class="fs-24 fw-bold">Roles</h1>
            </div>
            <div class="col-auto">
                <a class="btn btn-primary px-5" hx-get="/admin/role/add" hx-trigger="click" hx-target="body" hx-swap="innerHTML"><i class="fa-solid fa-plus me-2"></i>Add Role</a>
            </div>
        </div>
        <table id="rolesTable" class="table table-hover mb-5">
            <thead>
                <tr>
                    <th class="w-5-col">No.</th>
                    <th class="w-20-col">Name</th>
                    <th class="w-35-col">Description</th>
                    <th class="w-10-col">Status</th>
                    <th class="w-10-col"></th>
                </tr>
            </thead>
            <tbody>
                <cfloop from="1" to="#roles.recordCount#" index="i">
                    <cfset roleId = roles.id[i]>
                    <tr>
                        <td class="p-2">#i#</td>
                        <td>#roles.name[i]#</td>
                        <td>#roles.description[i]#</td>
                        <td>
                            <cfif roles.status[i] eq 1>
                                <span class="badge bg-success">Actice</span>
                            <cfelse>
                                <span class="badge bg-danger">Inactive</span>
                            </cfif>
                        </td>
                        <td class="text-end">
                            <div class="dropdown">
                                <div class="fw-bold cursor-pointer" data-bs-toggle="dropdown" aria-expanded="false">
                                    ...
                                </div>
                                <ul class="dropdown-menu">
                                    <li>
                                        <a hx-post="/admin/role/edit" 
                                            hx-vals='{"id": "#roleId#"}'
                                            hx-target="body" 
                                            hx-swap="innerHTML"
                                            class="dropdown-item text-success fs-16">Edit</a>
                                    </li>
                                    <li>
                                        <a hx-post="/admin/role/delete" 
                                            hx-vals='{"id": "#roleId#"}'
                                            hx-target="closest tr" 
                                            hx-swap="outerHTML"
                                            hx-trigger="click"
                                            hx-confirm="Are you sure you want to delete this role? It will affect all users assigned to this role." 
                                            class="dropdown-item text-danger fs-16">Delete</a>
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
    var table = new DataTable('#rolesTable', {
        columnDefs: [
            {
                targets: [3,4], // Adjust these indexes based on your actual table structure
                orderable: false
            }
        ]
    });
    table.on('draw', function() {
        htmx.process(document.body);
    });
    document.body.addEventListener("htmx:afterRequest", function(event) {
        const xhr = event.detail.xhr;;
        if (xhr.status === 500 && xhr.responseURL.includes("/admin/role/delete")) {
            notifier.show('Error', 'Something went wrong! role not deleted.', 'danger', '', 5000);
        }
        if (xhr.status === 500 && xhr.responseURL.includes("/admin/role/edit")) {
            notifier.show('Error', 'Something went wrong!', 'danger', '', 5000);
        }
        if (xhr.status === 200 && xhr.responseURL.includes("/admin/role/edit")) {
            notifier.show('Success', 'Role save successfully!', 'success', '', 5000);
        }
    });
</script>