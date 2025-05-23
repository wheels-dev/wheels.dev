<div class="container">
    <div class="bg-white p-4 box-shadow rounded-4 mt-3">
        <div id="flash-message" class="my-3"></div>
        <div class="d-flex mb-3 justify-content-between align-items-center">
            <div class="col-auto">
                <h1 class="text-center fs-24 fw-bold">Features List</h1>
            </div>
        </div>
        <div class="table-responsive">
            <table id="featureTable" class="table table-hover table-striped">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Title</th>
                        <th>Description</th>
                        <th></th>
                    </tr>
                </thead>
                <tbody id="features-container">
                    <cfscript>
                        for (var i = 1; i <= features.recordCount; i++) {
                            writeOutput('<tr> <td>' & i & '</td>');
                            writeOutput('<td>' & features.title[i] & '</td>');
                            writeOutput('<td>' & features.description[i] & '</td>');
                            writeOutput('<td>
                                <div class="dropdown">
                                    <div class="fw-bold cursor-pointer me-2" data-bs-toggle="dropdown" aria-expanded="false">
                                        ...
                                    </div>
                                    <ul class="dropdown-menu">
                                        <li>
                                            <a hx-get="/admin/feature/edit/#features.id[i]#" hx-target="body" hx-trigger="click" hx-swap="innerHTML" class="dropdown-item text-success fs-16">Edit</a>
                                        </li>
                                    </ul>
                                </div>
                            </td>');
                        }
                    </cfscript>
                </tbody>
            </table>
        </div>
    </div>
</div>
<script type="text/javascript">
    var table = new DataTable('#featureTable', {
        columnDefs: [
            {
                targets: [3],
                orderable: false
            }
        ]
    });
    table.on('draw', function() {
        htmx.process(document.body);
    });

    document.body.addEventListener("htmx:afterRequest", function(event) {
        const xhr = event.detail.xhr;
        if (xhr.status === 200 && xhr.responseURL.includes("/admin/feature/deleteFeature/")) {
            document.querySelector("#flash-message").innerHTML = `
            <div class="alert alert-subtle-success alert-dismissible fade show" role="alert">
                Feature deleted successfully!
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>`;

            // Auto-hide after 5 seconds
            setTimeout(() => {
                const alert = document.querySelector("#flash-message .alert");
                if (alert) alert.classList.remove("show");
            }, 5000);
        } else if(xhr.status === 500 && xhr.responseURL.includes("/admin/feature/deleteFeature/")){
            document.querySelector("#flash-message").innerHTML = `
            <div class="alert alert-subtle-danger alert-dismissible fade show" role="alert">
                Error: Feature not deleted!
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>`;
        }
    });
</script>
