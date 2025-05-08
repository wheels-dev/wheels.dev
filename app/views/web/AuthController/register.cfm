<main class="w-100 vh-100 position-relative">
    <div class="row w-100 h-100 m-lg-auto">
        <div class="col-lg-6 bg-white col-12">
            <div class="flex-column d-flex py-4 justify-content-center h-100 gap-3 align-items-center">
                <h1 class="fs-36 mb-0 fw-bold text--secondary">Welcome to</h1>
                <a href="/">
                    <img src="/images/wheels-logo.png" width="300" alt="Logo">
                </a>
                <p class="text--secondary fw-medium fs-18 text-center w-100 max-w-450 mx-auto pt-4">
                    Wheels is an open-source CFML framework inspired by Ruby on Rails. It offers fast app development,
                    organized code structure, and is easy and fun to learn.
                </p>
            </div>
        </div>
        <div
            class="col-lg-6 p-lg-auto p-0 main-login col-12 d-flex flex-column justify-content-center align-items-center">
            <div class="bg-white p-4 border rounded-4 w-100 max-w-570 mx-auto">
                <div>
                    <h1 class="fs-24 mb-0 fw-bold text--secondary">Sign Up</h1>
                    <p class="fs-16 text--secondary fw-medium pt-2">Register your account</p>

                    <form class="pt-3 needs-validation" id="registrationForm" novalidate hx-post="/auth/store"
                        hx-validate="true">
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <div class="bg--input d-flex align-items-center px-3 py-3 rounded-4 border gap-2">
                                    <svg width="20" height="20" viewBox="0 0 24 24" fill="none"
                                        xmlns="http://www.w3.org/2000/svg">
                                        <g opacity="0.6">
                                            <path
                                                d="M12 12C14.7614 12 17 9.76142 17 7C17 4.23858 14.7614 2 12 2C9.23858 2 7 4.23858 7 7C7 9.76142 9.23858 12 12 12Z"
                                                stroke="#0C1620" stroke-width="1.5" stroke-linecap="round"
                                                stroke-linejoin="round" />
                                            <path
                                                d="M20.5901 22C20.5901 18.13 16.7402 15 12.0002 15C7.26015 15 3.41016 18.13 3.41016 22"
                                                stroke="#0C1620" stroke-width="1.5" stroke-linecap="round"
                                                stroke-linejoin="round" />
                                        </g>
                                    </svg>
                                    <input type="text" placeholder="Enter First Name"
                                        class="fs-14 flex-grow-1 outline-none bg-transparent input-autofill" id="firstName"
                                        name="firstName" required minlength="3" maxlength="20">
                                </div>
                                <div class="invalid-feedback px-3 py-1">First name must be between 3 and 20 characters.</div>
                            </div>

                            <div class="col-md-6 mb-3">
                                <div class="bg--input d-flex align-items-center px-3 py-3 rounded-4 border gap-2">
                                    <svg width="20" height="20" viewBox="0 0 24 24" fill="none"
                                        xmlns="http://www.w3.org/2000/svg">
                                        <g opacity="0.6">
                                            <path
                                                d="M12 12C14.7614 12 17 9.76142 17 7C17 4.23858 14.7614 2 12 2C9.23858 2 7 4.23858 7 7C7 9.76142 9.23858 12 12 12Z"
                                                stroke="#0C1620" stroke-width="1.5" stroke-linecap="round"
                                                stroke-linejoin="round" />
                                            <path
                                                d="M20.5901 22C20.5901 18.13 16.7402 15 12.0002 15C7.26015 15 3.41016 18.13 3.41016 22"
                                                stroke="#0C1620" stroke-width="1.5" stroke-linecap="round"
                                                stroke-linejoin="round" />
                                        </g>
                                    </svg>
                                    <input type="text" placeholder="Enter Last Name"
                                        class="fs-14 flex-grow-1 outline-none bg-transparent input-autofill" id="lastName"
                                        name="lastName" required minlength="3" maxlength="20">
                                </div>
                                <div class="invalid-feedback px-3 py-1">Last name must be between 3 and 20 characters.</div>
                            </div>

                            <div class="mb-3">
                                <div class="bg--input d-flex align-items-center px-3 py-3 rounded-4 border gap-2">
                                    <svg width="20" height="20" class="flex-shrink-0" viewBox="0 0 24 24" fill="none"
                                        xmlns="http://www.w3.org/2000/svg">
                                        <g opacity="0.6">
                                            <path
                                                d="M17 20.5H7C4 20.5 2 19 2 15.5V8.5C2 5 4 3.5 7 3.5H17C20 3.5 22 5 22 8.5V15.5C22 19 20 20.5 17 20.5Z"
                                                stroke="#0C1620" stroke-width="1.5" stroke-miterlimit="10"
                                                stroke-linecap="round" stroke-linejoin="round" />
                                            <path d="M17 9L13.87 11.5C12.84 12.32 11.15 12.32 10.12 11.5L7 9"
                                                stroke="#0C1620" stroke-width="1.5" stroke-miterlimit="10"
                                                stroke-linecap="round" stroke-linejoin="round" />
                                        </g>
                                    </svg>
                                    <input type="email" placeholder="Enter your email"
                                        class="fs-14 flex-grow-1 outline-none bg-transparent input-autofill" id="email"
                                        name="email" required>
                                </div>
                                <div class="invalid-feedback px-3 py-1">Please enter a valid email address.</div>
                            </div>

                            <div class="col-md-6 mb-3">
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
                                        class="fs-14 flex-grow-1 outline-none bg-transparent input-autofill"
                                        id="passwordHash" name="passwordHash" required minlength="8">
                                </div>
                                <div class="invalid-feedback px-3 py-1">Password must be at least 8 characters long.</div>
                            </div>

                            <div class="col-md-6 mb-3">
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
                                    <input type="password" placeholder="Re-enter password"
                                        class="fs-14 flex-grow-1 outline-none bg-transparent input-autofill"
                                        id="confirmPassword" name="confirmPassword" required minlength="8">
                                </div>
                                <div class="invalid-feedback px-3 py-1">Passwords must match.</div>
                            </div>
                        </div>
                        <div class="form-check">
                            <input name="termsCheck" type="checkbox" class="form-check-input form-check-input-primary"
                                id="termsCheck" required>
                            <label class="form-check-label text--secondary fs-14" for="termsCheck">Agree to Terms &
                                Privacy
                                Policy</label>
                            <div class="invalid-feedback">You must agree to the terms and privacy policy.</div>
                        </div>
                        <div class="mb-3 form-check">
                            <input name="newsletter" type="checkbox" class="form-check-input form-check-input-primary"
                                id="newsletter">
                            <label class="form-check-label text--secondary fs-14" for="newsletter">Subscribe to newsletter</label>
                        </div>
                        <!--- <div class="mb-3">
                            <div class="g-recaptcha" data-sitekey="SITE_KEY_HERE"></div>
                            <div class="invalid-feedback d-block" id="captchaError" style="display: none;">Please complete the CAPTCHA.</div>
                        </div> --->

                        <div class="space-y-3">
                            <button type="submit"
                                class="bg--primary d-block w-100 text-white px-3 py-2 rounded-3 fs-16">Register</button>
                            <div class="text-center">
                                <p class="fs-14 text--secondary fw-medium">
                                    Have an account ?
                                    <a href="/login" class="text--primary">Login here</a>
                                </p>
                            </div>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</main>

<!-- Include Google reCAPTCHA -->
<script src="https://www.google.com/recaptcha/api.js" async defer></script>

<script>
    (function () {
        'use strict'
        const form = document.getElementById('registrationForm');

        const fields = {
            firstName: {
                validator: value => value.length >= 3 && value.length <= 20,
                message: 'First name must be between 3 and 20 characters.'
            },
            lastName: {
                validator: value => value.length >= 3 && value.length <= 20,
                message: 'Last name must be between 3 and 20 characters.'
            },
            email: {
                validator: value => /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(value),
                message: 'Please enter a valid email address.'
            },
            passwordHash: {
                validator: value => value.length >= 8,
                message: 'Password must be at least 8 characters long.'
            },
            confirmPassword: {
                validator: (value, form) => value === form.passwordHash.value,
                message: 'Passwords must match.'
            },
            termsCheck: {
                validator: checked => checked,
                message: 'You must agree to the terms and privacy policy.'
            }
        };

        form.addEventListener('submit', function (event) {
            let hasErrors = false;
            clearAllErrors();

            for (const fieldId in fields) {
                const input = form[fieldId];
                const { validator, message } = fields[fieldId];
                const isValid = validator(input.type === 'checkbox' ? input.checked : input.value, form);

                if (!isValid) {
                    showError(input, message);
                    hasErrors = true;
                }
            }

            if (hasErrors) {
                event.preventDefault();
            }

            // Optionally validate CAPTCHA
            // const captchaResponse = grecaptcha.getResponse();
            // if (captchaResponse.length === 0) {
            //     event.preventDefault();
            //     document.getElementById('captchaError').style.display = 'block';
            // } else {
            //     document.getElementById('captchaError').style.display = 'none';
            // }
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
</script>