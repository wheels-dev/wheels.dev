<main class="main-bg">
    <div class="container py-5">
        <!-- Title -->
        <h1 class="text-center fw-bold fs-60">Download Wheels</h1>

        <div class="bg-white rounded-18 px-4 py-5 mt-lg-5">
            <div class="row mt-lg-5 mt-3">
                <!-- Windows Download Block -->
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
                            <p class="mb-1"><strong>Requirements:</strong> OS Windows 10 or 11 (64-bit), 100 Mb free disk space.</p>
                            <p class="text--secondary fw-normal mb-1">
                                <strong>Troubleshooting:</strong> If the installer fails, try running it with administrative privileges or temporarily disable antivirus software.
                            </p>
                        </div>
                        <div class="text-center">
                            <a class="btn important:text--primary mt-2 px-4 fs-16 py-2 rounded-3 border border--primary hover:bg--primary hover:text-white bg-transparent text--secondary transition"
                                href="https://github.com/wheels-dev/wheels/raw/develop/tools/installer/windows/installer/wheels-installer.exe">Download</a>
                        </div>
                    </div>
                </div>
                <!-- Mac Download Block -->
                <div class="col-lg-6 col-12 mt-lg-0 mt-5">
                    <div class="position-relative d-block docs-container bg-white border-2 px-4 py-5 cursor-pointer rounded-4 border--lightGray hover:border--primary">
                        <div class="docs-badge d-flex align-items-center gap-2 bg--primary px-3 py-2 text-white">
                            <p class="fw-bold text-uppercase fs-12">Mac</p>
                            <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5"
                                stroke="currentColor" width="20" height="20">
                                <path stroke-linecap="round" stroke-linejoin="round" d="m8.25 4.5 7.5 7.5-7.5 7.5" />
                            </svg>
                        </div>
                        <div>
                            <p class="mb-1"><strong>Requirements:</strong> macOS 10.15 (Catalina) or later, 100 MB free disk space.</p>
                            <p class="mb-1 text--secondary fw-normal">
                                <strong>Troubleshooting:</strong> If the installer fails, right-click (or Control-click) the installer and select <strong>Open</strong> to bypass Gatekeeper. You may need to allow the app in <strong>System Settings &gt; Privacy &amp; Security</strong> if macOS blocks the installation.
                            </p>
                        </div>
                        <div class="text-center">
                            <a class="btn important:text--primary mt-2 px-4 fs-16 py-2 rounded-3 border border--primary hover:bg--primary hover:text-white bg-transparent text--secondary transition"
                                href="https://github.com/wheels-dev/wheels/raw/develop/tools/installer/macos/installer/wheels-installer.dmg">Download</a>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Other Installation Options -->
            <div>
                <p class="fs-22 text--primary mt-4 fw-bold mb-2">Other Installation Options</p>
                <!-- CLI Installation -->
                <p class="text--secondary ml-5">
                    <strong>Wheels CLI :</strong> Follow the
                    <a <cfoutput>href="#urlfor(route='load-Guides')#"</cfoutput> class="text--primary">Installation guide</a>
                    to install Wheels using the CLI.
                </p>
                <!-- Manual Download Link -->
                <p class="text--secondary ml-5">
                    <strong>Download Manually :</strong> You can
                    <a href="https://github.com/wheels-dev/wheels/releases" target="_blank" class="text--primary">download the latest release</a>
                    manually and extract it to your preferred directory.
                </p>

                <!-- Detailed Manual Installation Instructions -->
                <div class="bg-light rounded-4 p-4 my-4 shadow-sm">
                    <h3 class="fs-18 fw-bold text--primary mb-3">Manual Installation &amp; Setup without CommandBox/CLI</h3>
                    <p class="text--secondary mb-3">If you want to install Wheels manually without using CommandBox or the CLI, here’s a clear breakdown of what’s required and how to get it running.</p>
                    <p class="fw-bold text--primary mb-2">Core pieces you need:</p>
                    <ul class="mb-3 pl-4">
                        <li><strong>wheels-core</strong> – the framework itself (routing, ORM, request lifecycle, etc.)</li>
                        <li><strong>wheels-base-template</strong> – provides the standard app structure (controllers, models, views, config, events, etc.)</li>
                        <li><strong>WireBox</strong> – required for dependency injection and object lifecycle management</li>
                        <li><strong>TestBox</strong> – optional if you’re only running the app, but strongly recommended for testing</li>
                    </ul>
                    <p class="fw-bold text--primary mb-2">Step-by-step setup:</p>
                    <ol class="mb-3 pl-4">
                        <li>Create your application directory</li>
                        <li>
                        Download the latest stable version of the required packages from ForgeBox:
                        <span class="text--primary">wheels-base-template, wheels-core, WireBox, TestBox (optional)</span>.
                        </li>
                        <li>
                        First extract <strong>wheels-base-template</strong> in your application directory. Your structure will look like:
                        <pre class="bg-dark text-white p-2 rounded-3 mt-2 mb-2 small">
/my-wheels-app
    /app
    /config
    /db
    /public
    /vendor
    /tests
                        </pre>
                        </li>
                        <li>
                            Extract <strong>wheels-core</strong>, <strong>WireBox</strong>, and <strong>TestBox</strong> inside the <code>/vendor</code> folder and you are good to go.
                        </li>
                        <li>
                            The main entry point for a Wheels 3.0 application is <code>/public/index.cfm</code>. Configure this as the entry point in IIS to make sure the Wheels application works correctly.
                        </li>
                    </ol>
                </div>

            <!-- Structural/Migration Changes from 2.5 to 3.0 -->
            <div class="alert alert-info bg-secondary bg-opacity-10 border-0 rounded-4 p-4 my-4">
                <div class="d-flex align-items-center mb-2">
                    <svg class="me-2 text--primary" width="24" height="24" fill="none" stroke="currentColor" stroke-width="2">
                    <circle cx="12" cy="12" r="10" stroke-opacity="0.2"/>
                    <path stroke-linecap="round" stroke-linejoin="round" d="M12 8v4m0 4h.01"/>
                    </svg>
                    <span class="fw-bold fs-16 text--primary">Steps &amp; Structural Changes from 2.5 to 3.0</span>
                </div>
                <ul class="mb-0">
                    <li>
                        <strong>Entry Point</strong> – Wheels 3.0 apps use <code>/public/index.cfm</code> as the entry, not <code>/index.cfm</code> in your root dir.<br>
                        <span class="text--secondary fs-14">Update your server/IIS/Apache config to point to <code>/public/index.cfm</code>!</span>
                    </li>
                    <li>
                        <strong>App Structure</strong> – The recommended directory layout now includes <code>/vendor</code> for dependencies like wheels-core, wirebox, and testbox.<br>
                        <span class="text--secondary fs-14">You no longer drop wheels into /wheels inside the app folder!</span>
                    </li>
                    <li>
                        <strong>Dependency Management</strong> – All core libraries should be installed in <code>/vendor</code><br>
                        <span class="text--secondary fs-14">WireBox and TestBox are managed as first-class dependencies for IOC and testing.</span>
                    </li>
                    <li>
                        <strong>Code/Config Changes</strong> – Some settings and conventions have changed; review the migration docs and update configs accordingly.
                    </li>
                    <li>
                        <cfoutput>
                            <strong>Recommended:</strong> Read the <a href="#urlfor(route='load-Guides')#" target="_blank" class="text--primary">Wheels 3.0 Upgrade Guide</a> before migrating any 2.5 project.
                        </cfoutput>
                    </li>
                </ul>
                </div>

                <!-- Expandable Migration Quick-Guide -->
                <div class="mt-4">
                    <div class="alert alert-warning bg-warning bg-opacity-10 border-0 rounded-4 p-4 shadow-sm">
                        <div class="d-flex align-items-center mb-2">
                            <svg class="me-2 text-warning" width="24" height="24" fill="none" stroke="currentColor" stroke-width="2">
                                <circle cx="12" cy="12" r="10" stroke-opacity="0.2"/>
                                <path stroke-linecap="round" stroke-linejoin="round" d="M12 8v4m0 4h.01"/>
                            </svg>
                            <span class="fw-bold fs-16 text-warning">Framework Migration Quick-Guide</span>
                        </div>
                        <ul class="mb-2">
                            <li><strong>Backup everything:</strong> Files, database (schema/data), and configs. Test your restore process before touching your app!</li>
                            <li><strong>Review project structure:</strong> <code>controllers</code>, <code>models</code>, <code>views</code>, <code>public/</code> assets (JS, CSS, images) now belong in new standard folders. Core entry moved to <code>public/index.cfm</code>.</li>
                            <li><strong>Dependencies update:</strong> Install/upgrade:
                                <span class="badge bg-dark text-light me-2 mb-1">wheels-core</span>
                                <span class="badge bg-dark text-light me-2 mb-1">wheels-base-template</span>
                                <span class="badge bg-dark text-light me-2 mb-1">WireBox</span>
                                <span class="badge bg-dark text-light mb-1">TestBox</span>
                            </li>
                            <li><strong>Update configs/code:</strong> Adjust references to new namespaces, update custom helpers/plugins, and check all environment/config settings.</li>
                            <li><strong>Test in staging:</strong> Validate UI/API/db access, automated tests, and custom features before production.</li>
                            <li>
                                <strong>Need a step-by-step checklist?</strong>
                                <button class="btn btn-link text--primary p-0 align-baseline" data-bs-toggle="collapse" data-bs-target="#collapseGuide" aria-expanded="false" aria-controls="collapseGuide">
                                Expand the Complete Framework Migration Guide
                                </button>
                            </li>
                        </ul>
                        <div id="collapseGuide" class="collapse mt-3">
                            <ul>
                                <li><strong>1. Preparation:</strong> Backup files/configs/db, verify compatibility, document plugins and overrides.</li>
                                <li><strong>2. Install/Update Framework:</strong> Download from official sources, check dependency and CF server version compatibility, install core packages, validate paths.</li>
                                <li><strong>3. Project Re-structure:</strong>
                                <ul>
                                    <li>Controllers to <code>app/controllers</code></li>
                                    <li>Models to <code>app/models</code></li>
                                    <li>Views to <code>app/views</code></li>
                                    <li>Events to <code>app/events</code></li>
                                    <li>Helpers/Utils to <code>app/global</code></li>
                                    <li>Public assets (images, js, css) to <code>public/</code></li>
                                    <li>Entry point: <code>public/index.cfm</code></li>
                                </ul>
                                </li>
                                <li><strong>4. Code Updates:</strong> Update namespace references, refactor custom/overridden framework methods, audit helpers/plugins for DI.</li>
                                <li><strong>5. Dependency Installation:</strong> Remove deprecated packages, verify new ones function at runtime.</li>
                                <li><strong>6. Testing:</strong> Launch the app, monitor logs, validate endpoints and models, run all tests.</li>
                                <li><strong>7. Finalize:</strong> Remove debug code, document all changes, clean up project before deployment.</li>
                                <li><strong>Tips:</strong> Always backup, test incrementally, automate where possible, and document everything!</li>
                            </ul>
                        </div>
                    </div>
                </div>
                <!-- End of Migration Quick-Guide/Checklist -->
            </div>
        </div>
    </div>
</main>