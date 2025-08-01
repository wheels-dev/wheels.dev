<cfoutput>
<div class="bg-white p-4 box-shadow col-xl-9 rounded-4 mt-3">
    <div class="row gx-6 align-items-center">
        <div class="col-auto">
            <h1 class="fs-24 fw-bold">
                <cfparam  name="id" default=0>
                <cfparam  name="firstName" default=''>
                <cfparam  name="lastName" default=''>
                <cfparam  name="email" default=''>
                <cfparam  name="roleId" default=''>
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
                    <cfset locked = user.locked>
                <cfelse>
                    <cfset action = "Add">
                    <cfset id = 0>
                    <cfset firstName = "">
                    <cfset lastName = "">
                    <cfset email = "">
                    <cfset roleId = "">
                    <cfset status = "">
                    <cfset locked = false>
                </cfif>
                #action# User
            </h1>
        </div>
    </div>
    <div class="row">
        <form class="row g-3 mb-6 needs-validation" id="userForm" novalidate action="/admin/user/store" method="post" hx-validate="true">
            <input name="id" type="hidden" id="id" value="#id#">

            <div class="col-sm-6 col-md-6 mb-3">
                <div class="form-floating">
                    <input name="firstName" type="text" placeholder="Enter your firstname" class="form-control fs-18" id="firstName"
                    aria-describedby="firstNameHelp" required minlength="3" maxlength="20" value="#firstName#">
                    <label for="firstName" class="form-label fs-18 fw-medium">First Name <span class="text-danger">*</span></label>
                    <div class="invalid-feedback">First Name must be between 3 and 20 characters.</div>
                </div>
            </div>
            <div class="col-sm-6 col-md-6 mb-3">
                <div class="form-floating">
                    <input name="lastName" type="text" placeholder="Enter your lastname" class="form-control fs-14" id="lastName"
                    aria-describedby="lastNameHelp" required minlength="3" maxlength="20" value="#lastName#">
                    <label for="lastName" class="form-label fs-18 fw-medium">Last Name <span class="text-danger">*</span></label>
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
            <div class="col-sm-6 col-md-6 mb-3">
                <div class="form-floating form-floating-advance-select">
                    <label class="form-label mb-1 fs-18 fw-medium">
                        Lock Status
                    </label>
                    <select class="form-control fs-18" name="locked" id="locked">
                        <option value="false" <cfif locked eq false>selected</cfif>>Unlocked</option>
                        <option value="true" <cfif locked eq true>selected</cfif>>Locked</option>
                    </select>
                    <small class="form-text text-muted">Locked users cannot login regardless of failed attempts</small>
                </div>
            </div>
            <div class="col-sm-6 col-md-6 mb-3">
                <div class="form-floating form-floating-advance-select">
                    <label class="form-label mb-1 fs-18 fw-medium">
                        Role <span class="text-danger">*</span>
                    </label>
                    <select class="form-control fs-18" name="roleId" id="roleId" required hx-get="/admin/user/loadRoles?id=#id#&roleId=#roleId#"  hx-trigger="load" hx-target="##roleId" hx-swap="innerHTML">
                        <option value="">Select Role</option>
                    </select>
                </div>
            </div>
            <cfif id eq 0>
                <div class="form-check col-sm-6 col-md-6">
                    <div class="form-check mt-2">
                        <input name="termsCheck" type="checkbox" class="form-check-input form-check-input-primary" id="termsCheck" required>
                        <label class="form-check-label fs-18" for="termsCheck">Agree to Terms & Privacy Policy</label>
                        <div class="invalid-feedback">You must agree to the terms and privacy policy.</div>
                    </div>
                </div>
            </cfif>

            <div class="col-12 gy-6">
                <div class="row g-2 justify-content-end">
                    <div class="col-auto">
                        <button hx-get="/admin/user" hx-trigger="click" hx-swap="innerHTML" hx-target="body" class="btn btn-dark px-sm-5 fs-14">Cancel</button>
                    </div>
                    <div class="col-auto">
                        <button type="submit" class="btn bg--primary text-white px-sm-5 fs-14">Save</button>
                    </div>
                </div>
            </div>
        </form>
    </div>
</div>
    <script>
        <cfif id eq 0>
            const form = document.getElementById('userForm');
            form.addEventListener('submit', function (event) {
                const password = document.getElementById('passwordHash').value;
                const confirmPassword = document.getElementById('confirmPassword').value;

                if (password !== confirmPassword) {
                    event.preventDefault();
                    document.getElementById('confirmPassword').setCustomValidity('Passwords must match.');
                    document.getElementById('confirmPassword').classList.add('is-invalid');
                } else {
                    document.getElementById('confirmPassword').setCustomValidity('');
                    document.getElementById('confirmPassword').classList.remove('is-invalid');
                }
            });
        </cfif>

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

