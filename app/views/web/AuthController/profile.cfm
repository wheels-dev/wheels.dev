<main class="w-100 vh-100 d-flex justify-content-center align-items-center">
    <div class="row w-100 m-lg-auto m-2">
        <div class="col-lg-5 bg-white col-12 mx-auto p-3 shadow rounded-18">
            <div class="d-flex justify-content-center align-items-center">
                <img src="/img/wheels-logo.png" alt="wheels.dev Logo" width="180">
            </div>
            <div class="mt-2">
                <div class="border-bottom text-center pb-3">
                    <h1 class="fs-24 mb-0 fw-bold text--secondary">Welcome to Wheels</h1>
                    <p class="fs-16">Please update your profile</p>
                </div>

                <form class="pt-3 px-1 h-70vh overflow-y-auto no-scrollbar needs-validation" id="updateProfileForm" novalidate>
                    <cfoutput>#authenticityTokenField()#</cfoutput>
                    <div class="mb-3">
                        <label for="firstName" class="form-label fs-14 fw-medium">First name</label>
                        <input type="text" placeholder="Enter your firstname" class="form-control fs-14" id="firstName" required>
                        <div class="invalid-feedback">First name is required.</div>
                    </div>
                    <div class="mb-3">
                        <label for="lastName" class="form-label fs-14 fw-medium">Last name</label>
                        <input type="text" placeholder="Enter your lastname" class="form-control fs-14" id="lastName" required>
                        <div class="invalid-feedback">Last name is required.</div>
                    </div>
                    <div class="mb-3">
                        <label for="bio" class="form-label fs-14 fw-medium">Bio</label>
                        <textarea class="form-control fs-14" placeholder="Enter your bio" id="bio" rows="3"></textarea>
                        <div class="invalid-feedback">Bio should be at least 20 characters long.</div>
                    </div>
                    <div class="mb-3">
                        <label for="formFile" class="form-label fs-14 fw-medium">Profile Image</label>
                        <input class="form-control fs-14" type="file" id="formFile">
                        <div class="invalid-feedback">Please upload a profile image.</div>
                    </div>
                    <div class="mb-3">
                        <label for="github" class="form-label fs-14 fw-medium">Github</label>
                        <input type="url" placeholder="Enter your github profile url" class="form-control fs-14" id="github" pattern="https?://.*" aria-describedby="githubHelp">
                        <div class="invalid-feedback">Please enter a valid Github URL starting with 'http://' or 'https://'.</div>
                    </div>
                    <div class="mb-3">
                        <label for="twitter" class="form-label fs-14 fw-medium">Twitter</label>
                        <input type="url" placeholder="Enter your twitter profile url" class="form-control fs-14" id="twitter" pattern="https?://.*" aria-describedby="twitterHelp">
                        <div class="invalid-feedback">Please enter a valid Twitter URL starting with 'http://' or 'https://'.</div>
                    </div>

                    <div class="text-end">
                        <button type="submit" class="bg--secondary text-white px-3 py-2 rounded fs-14">Update</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</main>

<script>
    (function () {
        'use strict'
        var forms = document.querySelectorAll('.needs-validation')
        Array.prototype.slice.call(forms)
            .forEach(function (form) {
                form.addEventListener('submit', function (event) {
                    if (!form.checkValidity()) {
                        event.preventDefault()
                        event.stopPropagation()
                    }
                    form.classList.add('was-validated')
                }, false)
            })
    })()
</script>