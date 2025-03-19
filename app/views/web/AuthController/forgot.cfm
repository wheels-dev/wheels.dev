<main class="w-100 vh-100 d-flex justify-content-center align-items-center">
    <div class="row w-100 m-lg-auto m-2">
        <div class="col-lg-5 bg-white col-12 mx-auto p-3 shadow rounded-18">
            <div class="mt-2">
                <div class="border-bottom text-center pb-3">
                    <h1 class="fs-24 mb-0 fw-bold text--secondary">Forgot Password</h1>
                </div>

                <form class="pt-3 px-1 needs-validation" id="loginForm" novalidate>
                    <div class="mb-3">
                        <label for="email" class="form-label fs-14 fw-medium">Email address</label>
                        <input type="email" placeholder="Enter your email address" class="form-control fs-14" id="email" required>
                        <div class="invalid-feedback">Please enter a valid email address.</div>
                    </div>

                    <div>
                        <a href="/user/login" class="text-primary float-end mb-2 fs-14">Login here</a>
                        <button type="submit" class="bg--secondary text-white px-3 py-2 rounded fs-14">Submit</button>
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
            form.classList.add('was-validated')
        }, false)
    })()
</script>