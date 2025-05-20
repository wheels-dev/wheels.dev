<main class="w-100 vh-100 d-flex justify-content-center align-items-center main-login position-relative">
    <div class="position-absolute w-100 top-0 start-0">
        <div class="container w-100 px-0 pt-3">
            <a href="/" class="text-decoration-none container">
                <img src="/images/wheels-logo.png" width="200" alt="Wheels.dev Logo" class="hover:opacity-80 transition-all">
            </a>
        </div>
    </div>
    <div class="row w-100 m-lg-auto m-2">
        <div class="col-lg-4 bg-white col-12 position-relative mx-auto p-4 border rounded-4 shadow-sm">
            <div class="mt-2">
                <h1 class="fs-24 mb-0 fw-bold text--secondary">Reset Password</h1>
                <p class="fs-16 text--secondary fw-medium pt-2">Enter your email to receive reset instructions</p>

                <form hx-validate="true" class="pt-4 needs-validation" id="forgotPasswordForm" novalidate
                    hx-post="/auth/update-password" hx-swap="none" aria-label="Forgot Password Form">

                    <div class="mb-3">
                        <div class="bg--input d-flex align-items-center px-3 py-3 rounded-4 border gap-2 transition-all hover:border-primary">
                            <svg width="20" height="20" class="flex-shrink-0" viewBox="0 0 24 24" fill="none"
                                xmlns="http://www.w3.org/2000/svg" aria-hidden="true">
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
                            <input type="password" placeholder="Enter new password"
                                class="fs-14 flex-grow-1 outline-none bg-transparent input-autofill" id="password"
                                name="password" required minlength="8">
                        </div>
                        <div class="invalid-feedback" data-empty-error="password">Password field cannot be empty!</div>
                    </div>

                    <div class="mb-3">
                        <div class="bg--input d-flex align-items-center px-3 py-3 rounded-4 border gap-2 transition-all hover:border-primary">
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
                            <input type="password" placeholder="Re-enter password"
                                class="fs-14 flex-grow-1 outline-none bg-transparent input-autofill"
                                id="confirmPassword" name="confirmPassword" required minlength="8">
                        </div>
                        <div class="invalid-feedback px-3 py-1">Passwords must match.</div>
                    </div>
                    <cfoutput>
                        <input type="hidden" name="token" value="#params.token#"/>
                    </cfoutput>
                    <div class="space-y-3">
                        <button type="submit" class="bg--primary d-block w-100 text-white px-3 py-2 rounded-3 fs-16 hover:bg-primary-dark transition-all" aria-label="Submitting... ">
                            <span class="spinner-border spinner-border-sm d-none" role="status" aria-hidden="true"></span>
                            <span class="button-text">Submit</span>
                        </button>
                    </div>
                </form>
            </div>
            <div class="position-absolute d-lg-block d-none" style="left: -210px; top: 38%;">
                <img src="/images/authVector.png" class="img-fluid" width="250" height="250" alt="Decorative Vector" />
            </div>
            <div class="position-absolute d-lg-block d-none" style="right: -120px; top: 60%;">
                <img src="/images/authVector2.png" class="img-fluid" width="150" height="150" alt="Decorative Vector" />
            </div>
        </div>
    </div>
</main>
<script>
    (function () {
        'use strict'
        const form = document.getElementById('forgotPasswordForm');

        const fields = {
            password: {
                validator: value => value.length >= 8,
                message: 'Password must be at least 8 characters long.'
            },
            confirmPassword: {
                validator: (value, form) => value === form.password.value,
                message: 'Passwords must match.'
            }
        };

        form.addEventListener('submit', function (event) {
            let hasErrors = false;
            clearAllErrors();

            for (const fieldId in fields) {
                const input = form[fieldId];
                const { validator, message } = fields[fieldId];
                const isValid = validator(input.value, form);

                if (!isValid) {
                    showError(input, message);
                    hasErrors = true;
                }
            }

            if (hasErrors) {
                event.preventDefault();
            }
        });

        function showError(input, message) {
            const errorDiv = input.closest('.mb-3')?.querySelector('.invalid-feedback') || input.parentElement.querySelector('.invalid-feedback');
            if (errorDiv) {
                errorDiv.textContent = message;
                errorDiv.style.display = 'block';
            }
            input.classList.add('is-invalid');
        }

        function clearAllErrors() {
            const errorFields = form.querySelectorAll('.is-invalid');
            errorFields.forEach(input => input.classList.remove('is-invalid'));

            const errorDivs = form.querySelectorAll('.invalid-feedback');
            errorDivs.forEach(div => {
                div.textContent = '';
                div.style.display = 'none';
            });

        }
    })();

    forgotPasswordForm.addEventListener('htmx:afterRequest', function (event) {
            
            const xhr = event.detail.xhr;
            if (xhr.responseText && xhr.responseText.trim() !== '' && xhr.responseURL.includes("/auth/update-password")) {
                if (event.detail.successful) {
                    if (xhr.status === 200 && xhr.responseURL.includes("/auth/update-password")) {
                        notifier.show('Success!', xhr.responseText, 'success', '', 4000);
                            setTimeout(() => {
                                window.location.href = "/login";
                            }, 3000);
                    } else {
                        notifier.show('Error', 'No account found with that email address.', 'warning', '', 4000);
                    }
                } else {
                    notifier.show('Error', 'An error occurred. Please try again.', 'danger', '', 4000);
                }
            } else {
                notifier.show('Error', 'An unexpected error occurred. Please try again.', 'danger', '', 4000);
            }
        });
</script>
