<cfoutput>
    <div class="bg-white p-4 box-shadow rounded-4 mt-3">
        <div class="categoryResponce container">
            <div class="d-flex mb-3 justify-content-between align-items-center">
                <div>
                    <h1 class="fs-24 fw-bold">Categories</h1>
                </div>
                <div>
                    <a class="btn bg--primary text-white px-5" hx-get="/admin/category/add" hx-trigger="click" hx-target="body" hx-swap="innerHTML"><i class="fa-solid fa-plus me-2"></i>Add Category</a>
                </div>
            </div>
            <div class="table-responsive">
                <table id="categoryTable" class="table table-hover table-striped">
                    <thead>
                        <tr>
                            <th>No.</th>
                            <th>Name</th>
                            <th>Description</th>
                            <th>Parent category</th>
                            <th>Status</th>
                            <th></th>
                        </tr>
                    </thead>
                    <tbody>
                        <cfloop from="1" to="#categories.recordCount#" index="i">
                            <cfset categoryId = categories.id[i]>
                            <tr>
                                <td>#i#</td>
                                <td>#categories.name[i]#</td>
                                <td>#categories.description[i]#</td>
                                <td>
                                    <cfset parentCategory = model("category").findAll(where="id = ?", params=[categories.parentId[i]])>
                                    <cfif parentCategory.recordCount neq 0>
                                        #parentCategory.name#
                                    </cfif>
                                </td>
                                <td>
                                    <cfif categories.isactive[i] eq 1>
                                        <span class="badge bg-success">Actice</span>
                                    <cfelse>
                                        <span class="badge bg-danger">Inactive</span>
                                    </cfif>
                                </td>
                                <td>
                                    <div class="dropdown">
                                        <div class="fw-bold cursor-pointer me-2" data-bs-toggle="dropdown" aria-expanded="false">
                                            ...
                                        </div>
                                        <ul class="dropdown-menu">
                                            <li>
                                                <a hx-post="/admin/category/edit" 
                                                    hx-vals='{"id": "#categoryId#"}'
                                                    hx-target="body" 
                                                    hx-swap="innerHTML"
                                                    class="dropdown-item text-success fs-16">Edit</a>
                                            </li>
                                            <li>
                                                <a hx-post="/admin/category/delete" 
                                                    hx-vals='{"id": "#categoryId#"}'
                                                    hx-target="body" 
                                                    hx-swap="innerHTML"
                                                    hx-confirm="Are you sure you want to delete this category?" 
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