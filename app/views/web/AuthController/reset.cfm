<main class="w-100 vh-100 d-flex justify-content-center align-items-center">
    <div class="row w-100 m-lg-auto m-2">
        <div class="col-lg-5 bg-white col-12 mx-auto p-3 shadow rounded-18">
            <div class="d-flex justify-content-center align-items-center">
                <img src="/img/wheels-logo.png" alt="wheels.dev Logo" width="180">
            </div>
            <div class="mt-2">
                <div class="border-bottom text-center pb-3">
                    <h1 class="fs-24 mb-0 fw-bold text--secondary">Reset Your Password</h1>
                    <p class="fs-16">Regain Access to Your Account Safely and Securely</p>
                </div>

                <form class="pt-3 px-1 needs-validation" id="loginForm" novalidate>
                    <div class="mb-3">
                        <label for="password" class="form-label fs-14 fw-medium">Password</label>
                        <input type="password" placeholder="Enter your password" class="form-control fs-14"
                            id="password" required minlength="8">
                        <div class="invalid-feedback">Password must be at least 8 characters long.</div>
                    </div>

                    <div class="mb-3">
                        <label for="confirmPassword" class="form-label fs-14 fw-medium">Confirm Password</label>
                        <input type="password" placeholder="Confirm your password" class="form-control fs-14"
                            id="confirmPassword" required>
                        <div class="invalid-feedback">Passwords must match.</div>
                    </div>

                    <div>
                        <a href="/user/login" class="text-primary float-end mb-2 fs-14">Login here</a>
                        <button type="submit" class="bg--secondary text-white px-3 py-2 rounded fs-14">Reset</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</main>

<script>
    (function () {
        'use strict'
        var form = document.querySelector('.needs-validation')
        form.addEventListener('submit', function (event) {
            if (!form.checkValidity()) {
                event.preventDefault()
                event.stopPropagation()
            }
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
            form.classList.add('was-validated');
        }, false)
    })()
</script>