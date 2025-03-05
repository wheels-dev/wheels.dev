<main class="w-100 vh-100 d-flex justify-content-center align-items-center">
    <div class="row w-100 m-lg-auto m-2">
        <div class="col-lg-5 bg-white col-12 mx-auto p-3 shadow rounded-18">
            <div class="d-flex justify-content-center align-items-center">
                <img src="/images/wheels-logo.png" alt="Logo" width="180">
            </div>
            <div class="mt-2">
                <div class="border-bottom text-center pb-3">
                    <h1 class="fs-24 mb-0 fw-bold text--secondary">Welcome to Wheels</h1>
                    <p class="fs-16">Please register your account!</p>
                </div>

                <form class="pt-3 px-1 needs-validation" id="registrationForm" novalidate hx-post="/auth/store" hx-validate="true">
                    <div class="mb-3">
                        <label for="userName" class="form-label fs-14 fw-medium">Username</label>
                        <input name="userName" type="text" placeholder="Enter your username" class="form-control fs-14" id="userName"
                            aria-describedby="userNameHelp" required minlength="3" maxlength="20">
                        <div class="invalid-feedback">Username must be between 3 and 20 characters.</div>
                    </div>
                    <div class="mb-3">
                        <label for="email" class="form-label fs-14 fw-medium">Email address</label>
                        <input name="email" type="email" placeholder="Enter your email address" class="form-control fs-14" id="email"
                            aria-describedby="emailHelp" required>
                        <div class="invalid-feedback">Please enter a valid email address.</div>
                    </div>
                    <div class="mb-3">
                        <label for="password" class="form-label fs-14 fw-medium">Password</label>
                        <input name="password" type="password" placeholder="Enter your password" class="form-control fs-14"
                            id="password" required minlength="8">
                        <div class="invalid-feedback">Password must be at least 8 characters long.</div>
                    </div>
                    <div class="mb-3">
                        <label for="confirmPassword" class="form-label fs-14 fw-medium">Confirm Password</label>
                        <input name="confirmPassword" type="password" placeholder="Confirm your password" class="form-control fs-14"
                            id="confirmPassword" required>
                        <div class="invalid-feedback">Passwords must match.</div>
                    </div>
                    <div class="mb-3 form-check">
                        <input name="termsCheck" type="checkbox" class="form-check-input" id="termsCheck" required>
                        <label class="form-check-label fs-14" for="termsCheck">Agree to Terms & Privacy Policy</label>
                        <div class="invalid-feedback">You must agree to the terms and privacy policy.</div>
                    </div>

                    <div class="d-flex justify-content-between flex-wrap gap-2 align-items-start">
                        <button type="submit" class="bg--secondary text-white px-3 py-2 rounded fs-14">Register</button>
                        <p class="mb-2 fs-14">
                            Have an account ?
                            <a href="/login" class="text-primary">Login here</a>
                        </p>
                    </div>
                </form>
            </div>
        </div>
    </div>
</main>

<script>
    const form = document.getElementById('registrationForm');
    form.addEventListener('submit', function (event) {
        const password = document.getElementById('password').value;
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
