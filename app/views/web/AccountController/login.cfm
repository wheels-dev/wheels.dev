<div id="loading" class="htmx-indicator loading-overlay">
    <div class="loading-spinner">
        <span class="spinner-border text-primary" style="width: 3rem; height: 3rem;"></span>
        <p class="mt-2 text-white">Loading...</p>
    </div>
</div>
<div class="login-container gy-7">
    <div id="response"></div>
    <cfparam name="params.message" default="">
    <cfset message = decodeFromURL(params.message)>

    <cfif len(message)>
        <div class="alert alert-success alert-dismissible fade show" role="alert">
            <cfoutput>  #message#  </cfoutput>
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
    </cfif>
    <div class="d-flex align-items-center justify-content-center fw-bolder fs-3 d-inline-block mb-3">
        <!---<cfoutput>
           #imageTag(source = 'PAI50_logo.png')#
        </cfoutput>--->
    </div>
    <h3 class="text-center fw-bold">Sign In</h3>
    <p class="text-center opacity-75 mb-5">Get access to your account</p>
    <form id="loginForm" hx-post="/account/authenticate" hx-target="#response" hx-indicator="#loading" hx-swap="innerHTML">
        <div class="mb-3">
            <label class="form-label ">Email</label>
            <div class="input-group">
                <input type="email" class="form-control fs-14 opacity-75" name="email" placeholder="Email" required>
            </div>
            <div class="invalid-feedback">Please enter a valid email.</div>
        </div>
        <div class="mb-3">
            <label class="form-label ">Password</label>
            <div class="input-group">
                <input type="password" class="form-control fs-14 opacity-75" name="password" placeholder="Password" required minlength="8">
            </div>
            <div class="invalid-feedback">Password must be at least 8 characters.</div>
            <div class="text-end mt-2">
                <a href="/admin/forgetPassword" class="fs-14 text-primary">Forgot Password?</a>
            </div>
        </div>
        <button type="submit" class="btn btn-primary w-100 fs-14 mb-5 mt-2 font-weight-medium">Sign In</button>
    </form>
</div>