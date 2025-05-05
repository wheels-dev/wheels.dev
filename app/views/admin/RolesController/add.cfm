<cfoutput>
<div class="col-xl-9 bg-white p-4 box-shadow rounded-4 mt-3">
    <div class="row gx-6 align-items-center">
        <div class="col-auto">
            <h1 class="fs-24 fw-bold">
                <cfparam  name="id" default=0>
                <cfparam  name="name" default=''>
                <cfparam  name="description" default=''>
                <cfparam  name="parentRoleId" default=''>
                <cfparam  name="status" default=''>
                <cfif structKeyExists(params, "id") OR id gt 0>
                    <cfset action = "Edit">
                    <cfset id = Role.id>
                    <cfset name = Role.name>
                    <cfset description = Role.description>
                    <cfset status = Role.status>
                <cfelse>
                    <cfset action = "Add">  
                </cfif>
                #action# Role 
            </h1>
        </div>
    </div>
    <div class="row">
        <form class="row g-3 mb-6 needs-validation" id="RoleForm" novalidate hx-post="/admin/Role/save" hx-target="body" hx-validate="true">
            <input name="id" type="hidden" id="id" value="#id#">

            <div class="col-sm-6 col-md-6 mb-3">
                <div class="form-floating">
                    <input name="Name" type="text" placeholder="Enter Role name" class="form-control fs-18" id="Name"
                    aria-describedby="NameHelp" required minlength="3" maxlength="30" value="#name#" <cfif id eq 0>hx-post="/admin/role/exist" hx-trigger="blur changed delay:300ms" hx-target="##nameValidationMsg" hx-swap="innerHTML"</cfif>>
                    <label for="Name" class="form-label fs-18 fw-medium">Name <span class="text-danger">*</span></label>
                    <div class="invalid-feedback">Name must be between 2 and 30 characters.</div>
                    <div id="nameValidationMsg" class="mt-1 fs-14 text-danger"></div>
                </div>
            </div>
            <div class="col-sm-6 col-md-6 mb-3">
                <div class="form-floating form-floating-advance-select">
                    <label class="form-label mb-1 fs-18 fw-medium">
                        Status <span class="text-danger">*</span>
                    </label>
                    <select class="form-control fs-18" name="status" id="status" required>
                        <option value="">Select Status</option>
                        <option value="true" <cfif status eq true>selected</cfif>>Active</option>
                        <option value="false" <cfif status eq false>selected</cfif>>Inactive</option>
                    </select>
                </div>
            </div>
            <div class="col-sm-6 col-md-6 col-lg-12 mb-3">
                <div class="form-floating">
                    <textarea name="description" type="textArea" placeholder="Enter Role description" class="form-control fs-14" id="description"
                    aria-describedby="descriptionHelp" minlength="3" maxlength="100" style="height: 80px">#description#</textArea>
                    <label for="description" class="form-label fs-18 fw-medium">Description</label>
                    <div class="invalid-feedback">Role description must be between 3 and 100 characters.</div>
                </div>
            </div>
            <div class="col-12 gy-6">
                <div class="row g-3 justify-content-end">
                    <div class="col-auto">
                        <button type="submit" class="btn bg--primary text-white px-sm-5 fs-14">Save</button>
                    </div>
                    <div class="col-auto">
                        <a hx-get="/admin/Role" hx-target="body" class="btn btn-dark px-sm-5 fs-14">Cancel</a>
                    </div>
                </div>
            </div>
        </form>
    </div>
</div>
    <script>
        (function () {
            'use strict'
            var form = document.querySelector('.needs-validation')
            form.addEventListener('submit', function (event) {
                if (!form.checkValidity()) {
                    event.preventDefault()
                    event.stopPropagation()
                }
                form.classList.add('was-validated')
            }, false)
        })();
        document.body.addEventListener("htmx:afterRequest", function(event) {
            const xhr = event.detail.xhr;
            if (xhr.status === 500 && xhr.responseURL.includes("/admin/Role/save")) {
                notifier.show('Error', 'Something went wrong!', 'danger', '', 5000);
            }
            if (xhr.status === 200 && xhr.responseURL.includes("/admin/Role/save")) {
                notifier.show('Success', 'Role save successfully!', 'success', '', 5000);
            }
        });
    </script>
</cfoutput>