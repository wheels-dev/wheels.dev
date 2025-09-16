<cfoutput>
<div class="col-xl-9 bg-white p-4 box-shadow rounded-4 mt-3">
    <div class="row gx-6 align-items-center">
        <div class="col-auto">
            <h1 class="fs-24 fw-bold">
                Edit Contributors
            </h1>
        </div>
    </div>
    <div class="row">
        <form class="row g-3 mb-6 needs-validation" id="emailForm" novalidate method="POST" action="#urlFor(route="adminStore-contributors")#">
            <input name="id" type="hidden" id="id" value="#contributor.id#">

            <div class="col-sm-6 col-md-6 mb-3">
                <div class="form-floating">
                    <input name="name" type="text" placeholder="Enter Contributor name" class="form-control fs-18" id="name"
                    aria-describedby="nameHelp" required minlength="3" maxlength="50" value="#contributor.name#">
                    <label for="username" class="form-label fs-18 fw-medium">Name <span class="text-danger">*</span></label>
                    <div class="invalid-feedback">Name must be required.</div>
                </div>
            </div>
            <div class="col-sm-6 col-md-6 mb-3">
                <div class="form-floating">
                    <input name="username" type="text" placeholder="Username" class="form-control fs-14" id="username"
                    aria-describedby="usernameHelp" required minlength="3" maxlength="50" value="#contributor.username#">
                    <label for="username" class="form-label fs-18 fw-medium">User Name <span class="text-danger">*</span></label>
                    <div class="invalid-feedback">User Name must be required.</div>
                </div>
            </div>

            <div class="col-sm-6 col-md-6 col-lg-12 mb-3">
                <div class="form-floating">
                    <textarea name="description" type="textArea" placeholder="Enter Contributor description" class="form-control fs-14" id="description"
                    aria-describedby="descriptionHelp" minlength="9" maxlength="999" style="height: 80px">#contributor.description#</textArea>
                    <label for="description" class="form-label fs-18 fw-medium">Description</label>
                    <div class="invalid-feedback">Description must be between 9 and 999 characters.</div>
                </div>
            </div>
            <div class="col-sm-6 col-md-6 col-lg-12 mb-3">
                <label class="form-label fs-18 fw-medium d-block">Roles <span class="text-danger">*</span></label>

                <cfloop query="roles">
                    <div class="form-check form-check-inline">
                        <input class="form-check-input" 
                            type="checkbox" 
                            name="roles[]" 
                            id="role#roles.id#" 
                            value="#roles.id#"
                            <cfif listFindNoCase(contributor.roles, roles.id)>checked</cfif>>
                        <label class="form-check-label" for="role#roles.id#">#roles.roleName#</label>
                    </div>
                </cfloop>

                <div class="invalid-feedback d-block">Please select at least one role.</div>
            </div>
            <div class="col-12 gy-6">
                <div class="row g-3 justify-content-end">
                    <div class="col-auto">
                        <a hx-get="#urlFor(route="adminget-contributors")#" hx-target="body" hx-push-url="true" class="btn btn-dark px-sm-5 fs-14">Cancel</a>
                    </div>
                    <div class="col-auto">
                        <button type="submit" class="btn bg--primary text-white px-sm-5 fs-14">Save</button>
                    </div>
                </div>
            </div>
        </form>
    </div>
</div>
    <script src="/js/editEmailTemplate.js"></script>
</cfoutput>