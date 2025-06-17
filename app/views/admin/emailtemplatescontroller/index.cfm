<div class="container">
    <div class="bg-white p-4 box-shadow rounded-4 mt-3">
        <div id="flash-message" class="my-3"></div>
        <div class="d-flex mb-3 justify-content-between align-items-center">
            <div class="col-auto">
                <h1 class="text-center fs-24 fw-bold">Emails List</h1>
            </div>
        </div>
        <div class="table-responsive">
            <table id="emailTable" class="table table-hover table-striped">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Title</th>
                        <th>Subject</th>
                        <th>Content</th>
                        <th></th>
                    </tr>
                </thead>
                <tbody>
                    <cfoutput>
                        <cfloop from="1" to="#emails.recordCount#" index="i">
                            <cfset emailId = emails.id[i]>
                            <tr>
                                <td class="p-2">#i#</td>
                                <td>#emails.title[i]#</td>
                                <td>#emails.subject[i]#</td>
                                <td>#emails.message[i]#</td>
                                <td class="text-end">
                                    <div class="dropdown">
                                        <div class="fw-bold cursor-pointer me-2" data-bs-toggle="dropdown" aria-expanded="false">
                                            ...
                                        </div>
                                        <ul class="dropdown-menu">
                                            <li>
                                                <a hx-get="/admin/email/view/#emailId#" 
                                                    hx-target="body" 
                                                    hx-swap="innerHTML"
                                                    hx-push-url= "true"
                                                    class="dropdown-item fs-16">Preview</a>
                                            </li>
                                            <li>
                                                <a hx-get="/admin/email/edit/#emailId#" 
                                                    hx-target="body" 
                                                    hx-push-url= "true"
                                                    hx-swap="innerHTML"
                                                    class="dropdown-item fs-16">Edit</a>
                                            </li>
                                        </ul>
                                    </div>
                                </td>
                            </tr>
                        </cfloop>
                    </cfoutput>
                </tbody>
            </table>
        </div>
    </div>
</div>