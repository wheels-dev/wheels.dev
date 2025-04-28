<cfoutput>
    <div class="row mb-4 gx-6 gy-3 align-items-center">
        <div class="col-auto">
            <h1 class="fs-24 fw-bold">
                <cfparam  name="id" default=0>
                <cfparam  name="name" default=''>
                <cfparam  name="description" default=''>
                <cfparam  name="parentCategoryId" default=''>
                <cfparam  name="status" default=''>
                <cfif structKeyExists(params, "id") OR id gt 0>
                    <cfset user = findById(params.id)>
                    <cfset action = "Edit">
                    <cfset id = user.id>
                    <cfset firstName = user.firstName>
                    <cfset lastName = user.lastName>
                    <cfset email = user.email>
                    <cfset roleId = user.roleId>
                    <cfset status = user.status>
                <cfelse>
                    <cfset action = "Add">  
                </cfif>
                Add category 
            </h1>
        </div>
    </div>
    <div class="row">
        <div class="col-xl-9">
                <form class="row g-3 mb-6 needs-validation" id="userForm" novalidate hx-post="admin/category/save" hx-target="body" hx-validate="true">
                    <input name="id" type="hidden" id="id" value="#id#">

                    <div class="col-sm-6 col-md-6 mb-3">
                        <div class="form-floating">
                            <input name="Name" type="text" placeholder="Enter category name" class="form-control fs-18" id="Name"
                            aria-describedby="NameHelp" required minlength="3" maxlength="20" value="#name#">
                            <label for="Name" class="form-label fs-18 fw-medium">Name <span class="text-danger">*</span></label>
                            <div class="invalid-feedback">Name must be between 2 and 20 characters.</div>
                        </div>
                    </div>
                    <div class="col-sm-6 col-md-6 mb-3">
                        <div class="form-floating form-floating-advance-select">
                            <label class="form-label mb-1 fs-18 fw-medium">
                                Parent Category
                            </label>
                            <select class="form-control fs-18" name="parentCategoryId" id="parentCategoryId" hx-get="/admin/loadCategories?id=#id#&parentCategoryId=#parentCategoryId#"  hx-trigger="load" hx-target="##parentCategoryId" hx-swap="innerHTML">
                                <option value="">Select Category</option>
                            </select>
                        </div>
                    </div>
                    <div class="col-sm-6 col-md-6 mb-3">
                        <div class="form-floating">
                            <input name="lastName" type="text" placeholder="Enter your lastname" class="form-control fs-14" id="lastName"
                            aria-describedby="lastNameHelp" required minlength="3" maxlength="20" value="#lastName#">
                            <label for="lastName" class="form-label fs-18 fw-medium">Name <span class="text-danger">*</span></label>
                            <div class="invalid-feedback">Last Name must be between 3 and 20 characters.</div>
                        </div>
                    </div>
                    <div class="col-sm-6 col-md-6 col-lg-12 mb-3">
                        <div class="form-floating">
                            <input name="email" type="email" placeholder="Enter your email address" class="form-control fs-18" id="email"
                            aria-describedby="emailHelp" required value="#email#">
                            <label for="email" class="form-label fs-18 fw-medium">Email address <span class="text-danger">*</span></label>
                            <div class="invalid-feedback">Please enter a valid email address.</div>
                        </div>
                    </div>
                    <cfif id eq 0>
                        <div class="col-sm-6 col-md-6 mb-3">
                            <div class="form-floating">
                                <input name="passwordHash" type="password" placeholder="Enter your password" class="form-control fs-18"
                                id="passwordHash" required minlength="8">
                                <label for="passwordHash" class="form-label fs-18 fw-medium">Password <span class="text-danger">*</span></label>
                                <div class="invalid-feedback">Password must be at least 8 characters long.</div>
                            </div>
                        </div>
                        <div class="col-sm-6 col-md-6 mb-3">
                            <div class="form-floating">
                                <input name="confirmPassword" type="password" placeholder="Confirm your password" class="form-control fs-18"
                                id="confirmPassword" required>
                                <label for="confirmPassword" class="form-label fs-18 fw-medium">Confirm Password <span class="text-danger">*</span></label>
                                <div class="invalid-feedback">Passwords must match.</div>
                            </div>
                        </div>
                    </cfif>
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
                    <div class="col-12 gy-6">
                        <div class="row g-3 justify-content-end">
                            <div class="col-auto">
                                <button type="submit" class="bg--secondary text-white px-3 py-2 rounded px-sm-15 fs-14">Save</button>
                            </div>
                            <div class="col-auto">
                                <a href="/admin/user" class="btn btn-primary px-5">Cancel</a>
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

