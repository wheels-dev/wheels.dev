<main class="w-100 vh-100 d-flex justify-content-center align-items-center">
    <div class="row w-100 m-lg-auto m-2">
        <div class="col-lg-5 bg-white col-12 mx-auto p-4 shadow rounded-18">
            <div class="border-bottom text-center pb-3">
                <h1 class="fs-24 mb-0 fw-bold text--secondary">Welcome to Wheels</h1>
                <p class="fs-16">Please register your account!</p>
            </div>

            <form class="pt-3 needs-validation" id="registrationForm" novalidate hx-post="/auth/store" hx-validate="true">
                <div class="row mb-3">
                    <div class="col-md-6">
                        <label for="firstName" class="form-label fs-14 fw-medium">First Name</label>
                        <input name="firstName" type="text" placeholder="Enter First Name" class="form-control fs-14"
                               id="firstName" required minlength="3" maxlength="20">
                        <div class="invalid-feedback">First name must be between 3 and 20 characters.</div>
                    </div>
                    <div class="col-md-6">
                        <label for="lastName" class="form-label fs-14 fw-medium">Last Name</label>
                        <input name="lastName" type="text" placeholder="Enter Last Name" class="form-control fs-14"
                               id="lastName" required minlength="3" maxlength="20">
                        <div class="invalid-feedback">Last name must be between 3 and 20 characters.</div>
                    </div>
                </div>

                <div class="mb-3">
                    <label for="email" class="form-label fs-14 fw-medium">Email Address</label>
                    <input name="email" type="email" placeholder="Enter your Email Address" class="form-control fs-14"
                           id="email" required>
                    <div class="invalid-feedback">Please enter a valid email address.</div>
                </div>

                <div class="mb-3">
                    <label for="passwordHash" class="form-label fs-14 fw-medium">Password</label>
                    <input name="passwordHash" type="password" placeholder="Enter your password" class="form-control fs-14"
                           id="passwordHash" required minlength="8">
                    <div class="invalid-feedback">Password must be at least 8 characters long.</div>
                </div>

                <div class="mb-3">
                    <label for="confirmPassword" class="form-label fs-14 fw-medium">Confirm Password</label>
                    <input name="confirmPassword" type="password" placeholder="Confirm your password"
                           class="form-control fs-14" id="confirmPassword" required>
                    <div class="invalid-feedback">Passwords must match.</div>
                </div>

                <div class="mb-3 form-check">
                    <input name="termsCheck" type="checkbox" class="form-check-input" id="termsCheck" required>
                    <label class="form-check-label fs-14" for="termsCheck">Agree to Terms & Privacy Policy</label>
                    <div class="invalid-feedback">You must agree to the terms and privacy policy.</div>
                </div>

                <!--- <div class="mb-3">
                    <!-- Google reCAPTCHA -->
                    <div class="g-recaptcha" data-sitekey="YOUR_SITE_KEY_HERE"></div>
                    <div class="invalid-feedback d-block" id="captchaError" style="display: none;">Please complete the CAPTCHA.</div>
                </div> --->

                <div class="d-flex justify-content-between flex-wrap gap-2 align-items-start">
                    <button type="submit" class="bg--secondary text-white px-3 py-2 rounded fs-14">Register</button>
                    <p class="mb-2 fs-14">
                        Have an account?
                        <a href="/login" class="text-primary">Login here</a>
                    </p>
                </div>
            </form>
        </div>
    </div>
</main>

<!-- Include Google reCAPTCHA -->
<script src="https://www.google.com/recaptcha/api.js" async defer></script>

<script>
    const form = document.getElementById('registrationForm');
    form.addEventListener('submit', function (event) {
        const password = document.getElementById('passwordHash').value;
        const confirmPassword = document.getElementById('confirmPassword').value;

        // Password match check
        if (password !== confirmPassword) {
            event.preventDefault();
            document.getElementById('confirmPassword').setCustomValidity('Passwords must match.');
            document.getElementById('confirmPassword').classList.add('is-invalid');
        } else {
            document.getElementById('confirmPassword').setCustomValidity('');
            document.getElementById('confirmPassword').classList.remove('is-invalid');
        }

        // reCAPTCHA check
        // const captchaResponse = grecaptcha.getResponse();
        // if (captchaResponse.length === 0) {
        //     event.preventDefault();
        //     document.getElementById('captchaError').style.display = 'block';
        // } else {
        //     document.getElementById('captchaError').style.display = 'none';
        // }
    });

    // Bootstrap form validation
    (function () {
        'use strict'
        form.addEventListener('submit', function (event) {
            if (!form.checkValidity()) {
                event.preventDefault()
                event.stopPropagation()
            }
            form.classList.add('was-validated')
        }, false)
    })();
</script>
