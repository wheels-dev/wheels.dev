<main class="w-100 vh-100 d-flex justify-content-center align-items-center main-login position-relative">
    <div class="pt-3 ps-5 position-absolute top-0 start-0">
        <img src="/images/wheels-logo.png" width="200" alt="Logo">
    </div>
    <div class="row w-100 m-lg-auto m-2">
        <div class="col-lg-4 bg-white col-12 position-relative mx-auto p-4 border rounded-4">
            <div class="mt-2">
                <h1 class="fs-24 mb-0 fw-bold text--secondary">Login</h1>
                <p class="fs-16 text--secondary fw-medium pt-2">Please login to your account</p>
                <form hx-boost="true" class="pt-4 needs-validation" id="loginForm" novalidate hx-validate="true"
                    hx-post="/auth/authenticate" hx-target="body" hx-swap="outerHTML" hx-push-url="true">

                    <div class="mb-3">
                        <div class="bg--input d-flex align-items-center px-3 py-3 rounded-4 border gap-2">
                            <svg width="20" height="20" class="flex-shrink-0" viewBox="0 0 24 24" fill="none"
                                xmlns="http://www.w3.org/2000/svg">
                                <g opacity="0.6">
                                    <path
                                        d="M17 20.5H7C4 20.5 2 19 2 15.5V8.5C2 5 4 3.5 7 3.5H17C20 3.5 22 5 22 8.5V15.5C22 19 20 20.5 17 20.5Z"
                                        stroke="#0C1620" stroke-width="1.5" stroke-miterlimit="10"
                                        stroke-linecap="round" stroke-linejoin="round" />
                                    <path d="M17 9L13.87 11.5C12.84 12.32 11.15 12.32 10.12 11.5L7 9" stroke="#0C1620"
                                        stroke-width="1.5" stroke-miterlimit="10" stroke-linecap="round"
                                        stroke-linejoin="round" />
                                </g>
                            </svg>
                            <input type="email" placeholder="Enter your email"
                                class="fs-14 flex-grow-1 outline-none bg-transparent input-autofill" id="email"
                                name="email" required>
                        </div>
                        <div class="invalid-feedback">Please enter a valid email address.</div>
                    </div>
                    <div class="mb-3">
                        <div class="bg--input d-flex align-items-center px-3 py-3 rounded-4 border gap-2">
                            <svg width="20" height="20" class="flex-shrink-0" viewBox="0 0 24 24" fill="none"
                                xmlns="http://www.w3.org/2000/svg">
                                <g opacity="0.6">
                                    <path d="M6 10V8C6 4.69 7 2 12 2C17 2 18 4.69 18 8V10" stroke="#292D32"
                                        stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round" />
                                    <path
                                        d="M17 22H7C3 22 2 21 2 17V15C2 11 3 10 7 10H17C21 10 22 11 22 15V17C22 21 21 22 17 22Z"
                                        stroke="#292D32" stroke-width="1.5" stroke-linecap="round"
                                        stroke-linejoin="round" />
                                    <path d="M15.9965 16H16.0054" stroke="#292D32" stroke-width="2"
                                        stroke-linecap="round" stroke-linejoin="round" />
                                    <path d="M11.9955 16H12.0045" stroke="#292D32" stroke-width="2"
                                        stroke-linecap="round" stroke-linejoin="round" />
                                    <path d="M7.99451 16H8.00349" stroke="#292D32" stroke-width="2"
                                        stroke-linecap="round" stroke-linejoin="round" />
                                </g>
                            </svg>
                            <input type="password" placeholder="Enter your password"
                                class="fs-14 flex-grow-1 outline-none bg-transparent input-autofill" id="passwordHash"
                                name="passwordHash" required minlength="8">
                        </div>
                        <div class="invalid-feedback">Password must be at least 8 characters long.</div>
                    </div>

                    <div class="space-y-3">
                        <div class="text-end d-none">
                            <a href="/user/forgot-password" class="text--primary fw-medium fs-14">Forgot Password</a>
                        </div>

                        <button type="submit"
                            class="bg--primary d-block w-100 text-white px-3 py-2 rounded-3 fs-16">Login</button>

                        <div class="text-center">
                            <p class="fs-14 text--secondary fw-medium">
                                Don't have an account ?
                                <a href="/register" class="text--primary">Register here</a>
                            </p>
                        </div>
                    </div>
                </form>
            </div>
            <div class="position-absolute d-lg-block d-none" style="left: -210px; top: 38%;">
                <img src="/images/authVector.png" class="img-fluid" width="250" height="250" />
            </div>
            <div class="position-absolute d-lg-block d-none" style="right: -120px; top: 60%;">
                <img src="/images/authVector2.png" class="img-fluid" width="150" height="150" />
            </div>
        </div>
    </div>
</main>

<script>
    document.addEventListener('DOMContentLoaded', function () {
        const form = document.getElementById('loginForm');
        const emailInput = document.getElementById('email');
        const passwordInput = document.getElementById('passwordHash');

        form.addEventListener('submit', function (e) {
            let hasErrors = false;

            clearErrors();

            const emailValue = emailInput.value.trim();
            if (!validateEmail(emailValue)) {
                showError(emailInput, 'Please enter a valid email address.');
                hasErrors = true;
            }

            const passwordValue = passwordInput.value.trim();
            if (passwordValue.length < 8) {
                showError(passwordInput, 'Password must be at least 8 characters long.');
                hasErrors = true;
            }

            if (hasErrors) {
                e.preventDefault();
            }
        });

        function validateEmail(email) {
            const re = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
            return re.test(email.toLowerCase());
        }

        function showError(input, message) {
            const errorDiv = input.closest('.mb-3').querySelector('.invalid-feedback');
            input.classList.add('is-invalid');
            if (errorDiv) {
                errorDiv.textContent = message;
                errorDiv.style.display = 'block';
            }
        }

        function clearErrors() {
            [emailInput, passwordInput].forEach(input => {
                input.classList.remove('is-invalid');
                const errorDiv = input.closest('.mb-3').querySelector('.invalid-feedback');
                if (errorDiv) {
                    errorDiv.textContent = '';
                    errorDiv.style.display = 'none';
                }
            });
        }
    });
</script>