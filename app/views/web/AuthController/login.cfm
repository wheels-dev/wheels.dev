<main class="w-100 vh-100 d-flex justify-content-center align-items-center">
    <div class="row w-100 m-lg-auto m-2">
        <div class="col-lg-5 bg-white col-12 mx-auto p-3 shadow rounded-18">
            <div class="d-flex justify-content-center align-items-center">
                <img src="/images/wheels-logo.png" alt="Logo" width="180">
            </div>
            <div class="mt-2">
                <div class="border-bottom text-center pb-3">
                    <h1 class="fs-24 mb-0 fw-bold text--secondary">Welcome Back</h1>
                    <p class="fs-16">Please login to your account</p>
                </div>
                <div id="loginmessage"></div>

                <form class="pt-3 px-1 needs-validation" id="loginForm" hx-target="#loginmessage" class="needs-validation" novalidate hx-validate="true" hx-post="/auth/authenticate" hx-swap="innerHTML">
                    <div class="mb-3">
                        <label for="email" class="form-label fs-14 fw-medium">Email address</label>
                        <input type="email" placeholder="Enter your email address" class="form-control fs-14" id="email" name="email"
                            required>
                        <div class="invalid-feedback">Please enter a valid email address.</div>
                    </div>
                    <div class="mb-3">
                        <label for="password" class="form-label fs-14 fw-medium">Password</label>
                        <input type="password" placeholder="Enter your password" class="form-control fs-14" name="password"
                            id="password" required minlength="8">
                        <div class="invalid-feedback">Password must be at least 8 characters long.</div>
                    </div>

                    <div class="d-flex justify-content-between flex-wrap gap-2 align-items-end">
                        <button type="submit" class="bg--secondary text-white px-3 py-2 rounded fs-14">Login</button>
                        <div class="text-end">
                            <a href="/user/forgot-password" class="text-primary fs-14">Forgot Password</a>
                            <p class="fs-14">
                                Don't have an account ?
                                <a href="/user/register" class="text-primary">Register here</a>
                            </p>
                        </div>
                    </div>
                </form>
            </div>
        </div>
    </div>
</main>

<script>

    document.getElementById('loginForm').addEventListener("submit", function (event) {
            var isValid = true;

            const email = document.getElementById('email');
            const password = document.getElementById('password');
           

            // Reset validation styles
            [email, password].forEach(field => field.classList.remove("is-invalid"));

            // Validate fields
            if (email.value.trim() === "") {
                isValid = false;
                email.classList.add("is-invalid");
            }
            if (password.value.trim() === "") {
                isValid = false;
                password.classList.add("is-invalid");
            }
            
            // If validation fails, prevent request
            if (!isValid) {
                event.preventDefault();
                alert("Please fill out all required fields.");
                return false;
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