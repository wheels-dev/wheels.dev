<cfoutput>
<div class="bg-white p-4 box-shadow col-xl-12 rounded-4 mt-3">
    <div class="row gx-6 align-items-center">
        <div class="col-auto">
            <h1 class="fs-24 fw-bold">
                <cfparam  name="id" default=0>
                <cfparam  name="title" default=''>
                <cfparam  name="image" default=''>
                <cfparam  name="description" default=''>
                <cfif structKeyExists(params, "id") OR id gt 0>
                    <cfset feature = findById(params.id)>
                    <cfset action = "Edit">
                    <cfset id = feature.id>
                    <cfset title = feature.title>
                    <cfset image = feature.image>
                    <cfset description = feature.description>
                <cfelse>
                    <cfset action = "Add">  
                </cfif>
                #action# Feature
            </h1>
        </div>
    </div>
    <div class="row">
        <form class="row g-3 mb-6 needs-validation" id="featureForm" novalidate action="/admin/feature/store" method="post" hx-validate="true">
            <input name="id" type="hidden" id="id" value="#id#">

            <div class="col-sm-6 col-md-6 mb-3">
                <div class="form-floating">
                    <input name="title" type="text" placeholder="Enter title" class="form-control fs-18" id="title"
                    aria-describedby="titleHelp" required minlength="3" maxlength="100" value="#title#">
                    <label for="title" class="form-label fs-18 fw-medium">Title <span class="text-danger">*</span></label>
                    <div class="invalid-feedback">Title must be between 3 and 100 characters.</div>
                </div>
            </div>
            <div class="col-sm-6 col-md-6 mb-3">
                <div class="form-floating">
                    <input name="image" type="text" placeholder="Enter image URL" class="form-control fs-18" id="image"
                    aria-describedby="imageHelp" value="#image#">
                    <label for="image" class="form-label fs-18 fw-medium">Image URL</label>
                </div>
            </div>
            <div class="col-sm-12 mb-3">
                <div class="form-floating">
                    <textarea name="description" id="description" class="form-control" placeholder="Enter description" rows="5">#description#</textarea>
                    <label for="description" class="form-label fs-18 fw-medium">Description</label>
                </div>
            </div>

            <div class="col-12 gy-6">
                <div class="row g-3 justify-content-end">
                    <div class="col-auto">
                        <button type="submit" class="btn bg--primary text-white px-sm-5 fs-14">Save</button>
                    </div>
                    <div class="col-auto">
                        <button hx-get="/admin/feature" hx-trigger="click" hx-swap="innerHTML" hx-target="body" class="btn btn-dark px-sm-5 fs-14">Cancel</button>
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
    })()
</script>
</cfoutput>
