<cfoutput>
    <div class="container">
        <div class="bg-white p-4 box-shadow rounded-4 mt-3">
            <div id="flash-message" class="my-3"></div>
            <div class="d-flex mb-3 justify-content-between align-items-center">
                <div class="col-auto">
                    <h1 class="text-center fs-24 fw-bold">Contributors</h1>
                </div>
                <div>
                    <a id="syncBtn" class="btn bg--primary text-white px-5" hx-get="#urlFor(route='adminSync-contributors')#" hx-trigger="click" hx-swap="none">
                        <span class="label">Sync Contributors</span>
                    </a>
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
                            <cfset contributorId = contributors.id[i]>
                            <tr>
                                <td class="p-2">#i#</td>
                                <td>#contributors.name[i]#</td>
                                <td>#contributors.Username[i]#</td>
                                <td>#contributors.description[i]#</td>
                                <td>
                                    <cfscript>
                                        var roleIds = listToArray(contributors.roles[i], ",");
                                        var roleNames = [];
                                        for (var rid in roleIds) {
                                            if (structKeyExists(contributorRolesMap, rid)) {
                                                arrayAppend(roleNames, contributorRolesMap[rid]);
                                            }
                                        }
                                        writeOutput(arrayToList(roleNames, ", "));
                                    </cfscript>
                                </td>
                                <td class="text-end">
                                    <div class="dropdown">
                                        <div class="fw-bold cursor-pointer me-2" data-bs-toggle="dropdown" aria-expanded="false">
                                            ...
                                        </div>
                                        <ul class="dropdown-menu">
                                            <li>
                                                <a hx-post="#urlFor(route='adminEdit-contributors')#" 
                                                    hx-vals='{"id": "#contributorId#"}'
                                                    hx-target="body" 
                                                    hx-swap="innerHTML"
                                                    class="dropdown-item text-success fs-16">Edit</a>
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
<script>
    let mytable = new DataTable('#contributorsTable',{
        columnDefs: [{
            targets: [5],
            orderable: !1
        }]
    }).on("draw", (function() {
        htmx.process(document.body)
    }
    ));

    const syncBtn = document.getElementById("syncBtn");
    const label = syncBtn.querySelector(".label");

    // Show loader on request
    syncBtn.addEventListener("htmx:beforeRequest", function() {
        label.textContent = "Syncing...";
    });

    // Hide loader on success
    syncBtn.addEventListener("htmx:afterOnLoad", function(evt) {
        const xhr = evt.detail.xhr;
        label.textContent = "Sync Contributors";
        if(xhr.status === 200 && xhr.responseURL.includes('admin/contributors')){
            notifier.show("Success", "Contributors synced successfully!", "success", "", 5000);
        }
    });

    // Handle errors
    syncBtn.addEventListener("htmx:responseError", function(evt) {
        label.textContent = "Sync Contributors";
        notifier.show("Error", "Something went wrong while syncing contributors.", "danger", "", 5000);
    });
</script>