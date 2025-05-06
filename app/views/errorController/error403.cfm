<cfoutput>
    <div class="px-3">
        <div class="row min-vh-100 flex-center p-5">
            <div class="col-12 col-xl-10 col-xxl-8">
                <div class="row justify-content-center align-items-center g-5">
                    <div class="col-12 col-lg-6 text-center order-lg-1">
                            #imageTag(source = '403-illustration.png', alt="", width="400", class="img-fluid w-lg-100 d-dark-none")# 
                            #imageTag(source = 'dark_403-illustration.png', alt="", width="540", class="img-fluid w-md-50 w-lg-100 d-light-none")# 
                    </div>
                    <div class="col-12 col-lg-6 text-center text-lg-start">
                        #imageTag(source = '403.png', alt="", class="img-fluid mb-6 w-50 w-lg-75 d-dark-none")#
                        #imageTag(source = 'dark_403.png', alt="", class="img-fluid mb-6 w-50 w-lg-75 d-light-none")#
                        <h2 class="text-body-secondary fw-bolder mb-3">Access Forbidden!</h2>
                        <p class="text-body mb-5">You do not have the permissions to access the content.</p><a class="btn btn-lg bg--primary text-white" href="/admin">Go Home</a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</cfoutput>