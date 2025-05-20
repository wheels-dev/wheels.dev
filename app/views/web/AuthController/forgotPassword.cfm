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

                <form hx-boost="true" class="pt-4 needs-validation" id="forgotPasswordForm" novalidate
                    hx-post="/auth/send-reset-link" hx-swap="none" aria-label="Forgot Password Form">

                    <div class="mb-3">
                        <div class="bg--input d-flex align-items-center px-3 py-3 rounded-4 border gap-2 transition-all hover:border-primary">
                            <svg width="20" height="20" class="flex-shrink-0" viewBox="0 0 24 24" fill="none"
                                xmlns="http://www.w3.org/2000/svg" aria-hidden="true">
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
                                name="email" required autocomplete="email" aria-label="Email Address">
                        </div>
                        <div class="invalid-feedback" data-field-error="email">Please enter a valid email address.</div>
                        <div class="invalid-feedback" data-empty-error="email">Email field cannot be empty!</div>
                    </div>

                    <div class="space-y-3">
                        <button type="submit" class="bg--primary d-block w-100 text-white px-3 py-2 rounded-3 fs-16 hover:bg-primary-dark transition-all" aria-label="Send Reset Link">
                            <span class="spinner-border spinner-border-sm d-none" role="status" aria-hidden="true"></span>
                            <span class="button-text">Send Reset Link</span>
                        </button>

                        <div class="text-center">
                            <p class="fs-14 text--secondary fw-medium">
                                Remember your password?
                                <a href="/login" class="text--primary hover:text-primary" data-hx-boost="false">Login here</a>
                            </p>
                        </div>
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
    document.addEventListener('DOMContentLoaded', function () {
        const forgotPasswordForm = document.getElementById('forgotPasswordForm');
        const emailInput = document.getElementById('email');
        const submitButton = forgotPasswordForm.querySelector('button[type="submit"]');
        const spinner = submitButton.querySelector('.spinner-border');
        const buttonText = submitButton.querySelector('.button-text');

        function clearBootstrapValidationStyles() {
            forgotPasswordForm.classList.remove('was-validated');
            const errorMessages = forgotPasswordForm.querySelectorAll('.invalid-feedback');
            errorMessages.forEach(function(el) {
                el.style.display = 'none';
            });
            emailInput.classList.remove('is-invalid');
        }

        function showBootstrapValidationError(inputElement) {
            inputElement.classList.add('is-invalid');
            const errorSelector = `.invalid-feedback[data-field-error="${inputElement.name}"]`;
            const errorDiv = inputElement.closest('.mb-3').querySelector(errorSelector);
            if (errorDiv) {
                errorDiv.style.display = 'block';
            }
        }

        forgotPasswordForm.addEventListener('htmx:beforeRequest', function(event) {
            const requestPath = event.detail.requestConfig.path;
            const formAction = forgotPasswordForm.getAttribute('hx-post');

            if (requestPath !== formAction) {
                return;
            }

            clearBootstrapValidationStyles();
            let formIsValid = true;
            let notificationShown = false;

            // Validate Email
            const emailValue = emailInput.value.trim();
            if (emailValue === '') {
                notifier.show('Required', 'Email field cannot be empty!', 'danger', '', 4000);
                emailInput.classList.add('is-invalid');
                formIsValid = false;
                notificationShown = true;
            } else if (!emailInput.checkValidity()) {
                showBootstrapValidationError(emailInput);
                formIsValid = false;
            }

            if (!formIsValid) {
                event.preventDefault();
                if (!notificationShown) {
                    forgotPasswordForm.classList.add('was-validated');
                }
            } else {
                submitButton.disabled = true;
                spinner.classList.remove('d-none');
                buttonText.textContent = 'Sending...';
            }
        });

        forgotPasswordForm.addEventListener('htmx:afterRequest', function (event) {
            submitButton.disabled = false;
            spinner.classList.add('d-none');
            buttonText.textContent = 'Send Reset Link';
            
            const xhr = event.detail.xhr;
            clearBootstrapValidationStyles();
            if (xhr.responseText && xhr.responseText.trim() !== '' && xhr.responseURL.includes("/auth/send-reset-link")) {
                if (event.detail.successful) {
                    if (xhr.status === 200 && xhr.responseURL.includes("/auth/send-reset-link")) {
                        notifier.show('Success!', 'Reset instructions have been sent to your email.', 'success', '', 4000);
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
    });
</script> 