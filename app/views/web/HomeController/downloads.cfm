<main class="main">
    <div class="container py-5">
        <h1 class="text-center fw-bold fs-60">Wheels Downloads & Resources</h1>
        <p class="text--secondary fs-18 text-center fw-medium">Get the latest stable release of the Wheels CFML framework and start building apps faster.</p>
        <!---<div class="mt-5">
            <div class="items border-2 border--lightGray row border-start-0 border-end-0 border-bottom-0 py-5">
                <div class="col-lg-3 col-12 mb-3 mb-lg-0">
                    <p class="fw-bold text--secondary">
                    <cfoutput>Nov 13, 2023</cfoutput>
                    </p>
                </div>
                <div class="col-lg-9 col-12">
                    <cfoutput>
                        <p class="text--primary fs-22 fw-bold text-decoration-underline hover:text--primary-dark transition">
                            CFWheels v2.5.1
                        </p>
                        <p class="text--secondary fs-18 pt-2">
                            This is a maintenance release fixing an issue introduced with v.2.5.0 release where setting an alternate datasource in the model was being ignored and the default datasource was being used instead.
                        </p>
                        <div class="pt-3">
                            <a href="https://github.com/wheels-dev/wheels/releases/tag/v2.5.1" class="btn btn-sm btn-outline-danger me-2 mb-2" target="_blank">
                            Download
                            </a>
                        </div>
                    </cfoutput>
                </div>
            </div>
        </div>--->
        <!--- Tabs Nav --->
        <div class="mt-5">
            <ul class="nav nav-tabs border--primary" id="downloadTabs" role="tablist">
                <li class="nav-item" role="presentation">
                    <button class="nav-link active text--primary" id="windows-tab" data-bs-toggle="tab" data-bs-target="#windows" type="button" role="tab" aria-controls="windows" aria-selected="true">
                    Windows
                    </button>
                </li>
                <li class="nav-item" role="presentation">
                    <button class="nav-link text--primary" id="mac-tab" data-bs-toggle="tab" data-bs-target="#mac" type="button" role="tab" aria-controls="mac" aria-selected="false">
                    Mac
                    </button>
                </li>
            </ul>
    
            <!--- Tabs Content --->
            <div class="tab-content px-3 mt-3 border--primar" id="downloadTabsContent">
                <!--- Windows --->
                <div class="tab-pane fade show active" id="windows" role="tabpanel" aria-labelledby="windows-tab">
                    <h3>Install on Windows</h3>
                    <p>You can install Wheels using popular Windows package managers:</p>
                    <ul>
                    <li><strong>Chocolatey:</strong> <code>choco install wheels</code></li>
                    <li><strong>Scoop:</strong> <code>scoop install wheels</code></li>
                    </ul>
                    <p>Or <a href="https://github.com/cfwheels/cfwheels/releases/latest">download the latest release</a> manually.</p>
                </div>
    
                <!--- Mac --->
                <div class="tab-pane fade" id="mac" role="tabpanel" aria-labelledby="mac-tab">
                    <h3>Install on Mac</h3>
                    <p>On macOS, you can install Wheels using Homebrew:</p>
                    <ul>
                    <li><strong>Homebrew:</strong> <code>brew install wheels</code></li>
                    </ul>
                    <p>You can also <a href="https://github.com/cfwheels/cfwheels/releases/latest">download the package</a> directly for manual installation.</p>
                </div>
            </div>
        </div>
    </div>
</main>