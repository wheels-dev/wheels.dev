<main class="main-bg">
    <div class="container py-5">
        <h1 class="text-center fw-bold fs-60">Download Wheels</h1>
        <div class="bg-white rounded-18 px-4 py-5 mt-lg-5">
            <div class="row mt-lg-5 mt-3">
                <div class="col-lg-6 col-12 mt-lg-0 mt-5">
                    <div class="position-relative d-block docs-container bg-white border-2 px-4 py-5 cursor-pointer rounded-4 border--lightGray hover:border--primary">
                        <div class="docs-badge d-flex align-items-center gap-2 bg--primary px-3 py-2 text-white">
                            <p class="fw-bold text-uppercase fs-12">Windows</p>
                            <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5"
                                stroke="currentColor" width="20" height="20">
                                <path stroke-linecap="round" stroke-linejoin="round" d="m8.25 4.5 7.5 7.5-7.5 7.5" />
                            </svg>
                        </div>
                        <div>
                            <p><strong>Requirements:</strong> OS Windows 10 or 11 (64-bit), 100 Mb free disk space.</p>
                            <p class="text--secondary fw-normal">
                                <strong>Troubleshooting:</strong> If the installer fails, try running it with administrative privileges or temporarily disable antivirus software.
                            </p>
                        </div>
                        <div class="text-center">
                            <a class="btn important:text--primary mt-2 px-4 fs-16 py-2 rounded-3 border border--primary hover:bg--primary hover:text-white bg-transparent text--secondary transition" href="https://github.com/wheels-dev/wheels/raw/develop/tools/installer/windows/installer/wheels-installer.exe">Download</a>
                        </div>
                    </div>
                </div>

                <div class="col-lg-6 col-12 mt-lg-0 mt-5">
                    <div class="position-relative d-block docs-container bg-white border-2 px-4 py-5 cursor-pointer rounded-4 border--lightGray hover:border--primary">
                        <div class="docs-badge d-flex align-items-center gap-2 bg--primary px-3 py-2 text-white">
                            <p class="fw-bold text-uppercase fs-12">Mac</p>
                            <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5"
                                stroke="currentColor" width="20" height="20">
                                <path stroke-linecap="round" stroke-linejoin="round" d="m8.25 4.5 7.5 7.5-7.5 7.5" />
                            </svg>
                        </div>
                        <div class="text-center">
                            <p class="text--secondary fw-normal">
                                The Mac installer will be available soon.  
                                In the meantime, you can <a href="https://github.com/cfwheels/cfwheels/releases/latest" target="_blank" class="link-danger">Download Wheels</a> manually.
                            </p>
                            <p style="visibility: hidden;">Requirements</p>
                            <a class="btn important:text--primary mt-2 px-4 fs-16 py-2 rounded-3 border border--primary hover:bg--primary hover:text-white bg-transparent text--secondary transition" style="visibility: hidden;" href="##">Download for Mac(.dmg)</a>
                        </div>
                    </div>
                </div>
            </div>
            <div>
                <p class="fs-22 text--primary mt-4 fw-bold mb-2">Other Installation Options</p>
                <p class="text--secondary ml-5"> <strong>Wheels CLI :</strong> Follow the <a <cfoutput>href="#urlfor(route="load-Guides")#"</cfoutput> class="text--primary">Installation guide</a> to install Wheels using the CLI.</p>
                <p class="text--secondary ml-5"> <strong>Download Manually :</strong> You can <a href="https://github.com/cfwheels/cfwheels/releases/latest" target="_blank" class="text--primary">download the latest release</a> manually and extract it to your preferred directory.</p>
            </div>
        </div>
    </div>
</main>