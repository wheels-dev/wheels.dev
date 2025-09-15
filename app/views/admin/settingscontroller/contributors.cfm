<cfoutput>
    <div class="container">
        <div class="bg-white p-4 box-shadow rounded-4 mt-3">
            <div id="flash-message" class="my-3"></div>
            <div class="d-flex mb-3 justify-content-between align-items-center">
                <div class="col-auto">
                    <h1 class="text-center fs-24 fw-bold">Contributors</h1>
                </div>
                <div>
                    <a class="btn bg--primary text-white px-5" hx-get="#urlFor(route='adminSync-contributors')#" hx-target="body" hx-trigger="click" hx-swap="innerHTML"></i>Sync Contributors</a>
                </div>
            </div>
            <div class="table-responsive">
                <table id="contributorsTable" class="table table-hover table-striped">
                    <thead>
                        <tr>
                            <th>No.</th>
                            <th>Name</th>
                            <th>User Name</th>
                            <th>Description</th>
                            <th>Contribution Roles</th>
                            <th></th>
                        </tr>
                    </thead>
                    <tbody>
                        <cfloop from="1" to="#contributors.recordCount#" index="i">
                            <cfset roleId = contributors.id[i]>
                            <tr>
                                <td class="p-2">#i#</td>
                                <td>#contributors.name[i]#</td>
                                <td>#contributors.Username#</td>
                                <td>#contributors.description[i]#</td>
                                <cfscript>
                                    var role = model("contributor_role").findOneByid(contributors.roles);
                                </cfscript>
                                <td>#role.RoleName#</td>
                                <td class="text-end">
                                    <div class="dropdown">
                                        <div class="fw-bold cursor-pointer me-2" data-bs-toggle="dropdown" aria-expanded="false">
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
        </div>
    </div>
</cfoutput>