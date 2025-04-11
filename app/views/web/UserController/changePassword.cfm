<main class="w-100 vh-100 d-flex justify-content-center align-items-center">
    <div class="row w-100 m-lg-auto m-2">
        <div class="col-lg-5 bg-white col-12 mx-auto p-3 shadow rounded-18">
            <div class="mt-2">
                <div class="border-bottom text-center pb-3">
                    <h1 class="fs-24 mb-0 fw-bold text--secondary">Welcome to Wheels</h1>
                    <p class="fs-16">Change Password!</p>
                </div>

                <form class="pt-3 px-1 needs-validation" id="changePasswordForm" novalidate hx-post="/user/update-Password" hx-validate="true">
                    <div class="mb-3">
                        <label for="passwordHash" class="form-label fs-14 fw-medium">New Password</label>
                        <input name="passwordHash" type="password" placeholder="Enter your password" class="form-control fs-14"
                            id="passwordHash" required minlength="8">
                        <div class="invalid-feedback">Password must be at least 8 characters long.</div>
                    </div>
                    <div class="mb-3">
                        <label for="confirmPassword" class="form-label fs-14 fw-medium">Confirm Password</label>
                        <input name="confirmPassword" type="password" placeholder="Confirm your password" class="form-control fs-14"
                            id="confirmPassword" required>
                        <div class="invalid-feedback">Passwords must match.</div>
                    </div>

                    <div class="d-flex flex-wrap gap-2 align-items-start">
                        <button type="submit" class="bg--secondary text-white px-3 py-2 rounded fs-14">Save</button>
                        <button type="button" class="bg--default text-dark px-3 py-2 rounded fs-14" onclick="history.back()">Cancel</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</main>

<script>
    const form = document.getElementById('changePasswordForm');
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
