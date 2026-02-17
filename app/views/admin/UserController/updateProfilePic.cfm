<main class="w-100 vh-100 d-flex justify-content-center align-items-center main-login position-relative">
    <div class="row w-100 m-lg-auto m-2">
        <div class="col-lg-5 bg-white col-12 mx-auto p-3 rounded-18">
            <div class="mt-2">
                <h1 class="fs-24 mb-0 fw-bold text--secondary text-center">Profile Picture</h1>

                <div class="text-center pb-3 my-4">
                    <cfoutput>
                        <img src="#gravatarUrl(session.email, 300)#"
                            class="rounded-circle"
                            style="width:150px; height:150px;"
                            onerror="this.style.display='none';this.nextElementSibling.style.display='flex';"
                            alt="avatar">
                        <div style="display:none;width:150px;height:150px;font-size:3rem;"
                            class="align-items-center justify-content-center mx-auto #getAvatarColorByLetter(ucase(left(listLast(session.username, ' '), 1)))# text-white rounded-circle fw-bold text-uppercase">
                            #ucase(left(listLast(session.username, " "), 1))#
                        </div>
                    </cfoutput>
                </div>

                <div class="text-center px-3">
                    <p class="fs-14 text--secondary">
                        Your profile picture is powered by <strong>Gravatar</strong>.
                        To change your avatar, update it on Gravatar using the email address associated with your account.
                    </p>
                    <a href="https://gravatar.com" target="_blank" rel="noopener noreferrer" class="bg--primary text-white px-4 py-2 rounded fs-14 text-decoration-none d-inline-block mt-2">
                        Manage Avatar on Gravatar
                    </a>
                    <button type="button" class="bg--default text-dark px-3 py-2 rounded fs-14 d-inline-block mt-2 ms-2 border-0" onclick="history.back()">Back</button>
                </div>
            </div>
        </div>
    </div>
</main>
