<main class="w-100 vh-100 d-flex justify-content-center align-items-center main-login position-relative">
    <div class="position-absolute w-100 top-0 start-0">
        <div class="container w-100 px-0 pt-3">
            <a href="/" class="text-decoration-none container">
                <img src="/img/wheels-logo.png" width="200" alt="Wheels.dev Logo" class="hover:opacity-80 transition-all">
            </a>
        </div>
    </div>
    <div class="row w-100 m-lg-auto m-2">
        <div class="col-lg-4 bg-white col-12 position-relative mx-auto p-4 border rounded-4 shadow-sm">
            <div class="mt-2">
                <h1 class="fs-24 mb-0 fw-bold text--secondary">Welcome Back</h1>
                <p class="fs-16 text--secondary fw-medium pt-2">Please login to continue</p>

                <form class="pt-4 needs-validation" id="loginForm" novalidate
                    hx-post="/auth/authenticate" hx-swap="none" aria-label="Login Form">
                    <cfoutput>#authenticityTokenField()#</cfoutput>

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
                            <input type="email" placeholder="Email Address"
                                class="fs-14 flex-grow-1 outline-none bg-transparent input-autofill" id="email"
                                name="email" required autocomplete="email" aria-label="Email Address">
                        </div>
                        <div class="invalid-feedback" data-field-error="email">Please enter a valid email address.</div>
                        <div class="invalid-feedback" data-empty-error="email">Email field cannot be empty!</div>
                    </div>
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
                            <input type="password" placeholder="Password"
                                class="fs-14 flex-grow-1 outline-none bg-transparent input-autofill" id="password"
                                name="password" required minlength="8" autocomplete="current-password" aria-label="Password">
                            <button type="button" class="btn btn-link p-0" onclick="togglePasswordVisibility()" aria-label="Toggle Password Visibility">
                                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                                    <path d="M12 5C5.63636 5 2 12 2 12C2 12 5.63636 19 12 19C18.3636 19 22 12 22 12C22 12 18.3636 5 12 5Z" stroke="#292D32" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>
                                    <path d="M12 15C13.6569 15 15 13.6569 15 12C15 10.3431 13.6569 9 12 9C10.3431 9 9 10.3431 9 12C9 13.6569 10.3431 15 12 15Z" stroke="#292D32" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>
                                </svg>
                            </button>
                        </div>
                        <div class="invalid-feedback" data-field-error="password">Password must be at least 8 characters long.</div>
                        <div class="invalid-feedback" data-empty-error="password">Password field cannot be empty!</div>
                    </div>
                    <cfoutput>
                        <div class="space-y-3">
                            <div class="d-flex justify-content-between align-items-center">
                                <div class="form-check">
                                    <input type="checkbox" class="form-check-input form-check-input-primary" id="rememberMe" name="rememberMe" aria-label="Remember Me">
                                    <label class="form-check-label fs-14 text--secondary" for="rememberMe">Remember me</label>
                                </div>
                                <a href="#urlFor(route='forgot-password')#" class="text--primary fw-medium fs-14 hover:text-primary" data-hx-boost="false">Forgot Password?</a>
                            </div>

                            <button type="submit" class="bg--primary d-block w-100 text-white px-3 py-2 rounded-3 fs-16 hover:bg-primary-dark transition-all" aria-label="Login Button">
                                <span class="spinner-border spinner-border-sm d-none" role="status" aria-hidden="true"></span>
                                <span class="button-text">Login</span>
                            </button>

                            <div class="text-center">
                                <p class="fs-14 text--secondary fw-medium">
                                    Don't have an account?
                                    <a href="#urlFor(route='auth-register')#" class="text--primary hover:text-primary" data-hx-boost="false">Register</a>
                                </p>
                            </div>
                        </div>
                    </cfoutput>
                </form>
            </div>
            <div class="position-absolute d-lg-block d-none" style="left: -225px; top: 38%;">
                <img src="/img/authVector.png" class="img-fluid" width="250" height="250" alt="Wheels.dev auth" />
            </div>
            <div class="position-absolute d-lg-block d-none" style="right: -120px; top: 60%;">
                <img src="/img/authVector2.png" class="img-fluid" width="150" height="150" alt="Wheels.dev auth" />
            </div>
        </div>
    </div>
</main>
<script>
    const fieldsToTrim = ["email", "password"];
    fieldsToTrim.forEach(function (fieldId) {
        const field = document.getElementById(fieldId);
        if (field) {
            field.addEventListener("input", function () {
                const trimmedValue = field.value.replace(/^\s+|\s+$/g, '');
                if (["text", "search", "password", "url", "tel"].includes(field.type)) {
                    const cursorPos = field.selectionStart;
                    field.value = trimmedValue;
                    field.setSelectionRange(cursorPos, cursorPos);
                } else {
                    field.value = trimmedValue;
                }
            });
        }
    });
</script>