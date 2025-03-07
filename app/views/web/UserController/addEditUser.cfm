<main>
    <div class="container py-5">
        <div class="row justify-content-center justify-content-lg-between">
            <div class="bg-white rounded-5 shadow-sm mt-4 p-4">
                <h1 class="text-center fs-24 fw-bold">
                    <cfif id gt 0>
                        Edit
                    <cfelse>
                        Add  
                    </cfif>
                    User
                </h1>
                
                <form class="pt-3 px-1 needs-validation" id="userForm" novalidate hx-post="/user/store" hx-validate="true">
                    <input name="id" type="hidden" id="id">

                    <div class="mb-3">
                        <label for="firstName" class="form-label fs-14 fw-medium">First Name <span class="text-danger">*</span></label>
                        <input name="firstName" type="text" placeholder="Enter your firstname" class="form-control fs-14" id="firstName"
                            aria-describedby="firstNameHelp" required minlength="3" maxlength="20">
                        <div class="invalid-feedback">First Name must be between 3 and 20 characters.</div>
                    </div>
                    <div class="mb-3">
                        <label for="lastName" class="form-label fs-14 fw-medium">Last Name <span class="text-danger">*</span></label>
                        <input name="lastName" type="text" placeholder="Enter your lastname" class="form-control fs-14" id="lastName"
                            aria-describedby="lastNameHelp" required minlength="3" maxlength="20">
                        <div class="invalid-feedback">Last Name must be between 3 and 20 characters.</div>
                    </div>
                    <div class="mb-3">
                        <label for="email" class="form-label fs-14 fw-medium">Email address <span class="text-danger">*</span></label>
                        <input name="email" type="email" placeholder="Enter your email address" class="form-control fs-14" id="email"
                            aria-describedby="emailHelp" required>
                        <div class="invalid-feedback">Please enter a valid email address.</div>
                    </div>
                    <div class="mb-3">
                        <label for="passwordHash" class="form-label fs-14 fw-medium">Password <span class="text-danger">*</span></label>
                        <input name="passwordHash" type="password" placeholder="Enter your password" class="form-control fs-14"
                            id="passwordHash" required minlength="3">
                        <div class="invalid-feedback">Password must be at least 8 characters long.</div>
                    </div>
                    <div class="mb-3">
                        <label for="confirmPassword" class="form-label fs-14 fw-medium">Confirm Password <span class="text-danger">*</span></label>
                        <input name="confirmPassword" type="password" placeholder="Confirm your password" class="form-control fs-14"
                            id="confirmPassword" required>
                        <div class="invalid-feedback">Passwords must match.</div>
                    </div>
                    <div class="mb-3">
                        <label class="form-label mb-1 fs-14 fw-medium">
                            Role <span class="text-danger">*</span>
                        </label>
                        <select class="form-control fs-14" name="roleId" id="roleId" required hx-get="/user/loadRoles" hx-trigger="load" hx-target="#roleId" hx-swap="innerHTML">
                            <option value="">Select Role</option>
                        </select>
                    </div>
                    <div class="mb-3 form-check">
                        <input name="termsCheck" type="checkbox" class="form-check-input" id="termsCheck" required>
                        <label class="form-check-label fs-14" for="termsCheck">Agree to Terms & Privacy Policy</label>
                        <div class="invalid-feedback">You must agree to the terms and privacy policy.</div>
                    </div>

                    <div class="d-flex justify-content-between flex-wrap gap-2 align-items-start">
                        <button type="submit" class="bg--secondary text-white px-3 py-2 rounded fs-14">Save User</button>
                        <p class="mb-2 fs-14">
                            <a href="/user" class="text-primary">Back to User List</a>
                        </p>
                    </div>
                </form>
            </div>
        </div>
    </div>
</main>

<script>
    const form = document.getElementById('userForm');
    form.addEventListener('submit', function (event) {
        const password = document.getElementById('passwordHash').value;
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
