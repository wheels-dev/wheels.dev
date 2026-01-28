<main class="main-bg">
    <div class="container py-5">
        <!-- Title -->
        <h1 class="text-center fw-bold fs-60">Download Wheels & Migration Guide</h1>

        <div class="bg-white rounded-18 px-4 py-5 mt-lg-5">
            
            <!-- Download Section Header -->
            <div class="mb-4">
                <h2 class="fs-22 text--primary fw-bold mb-2">
                    <svg class="me-2" width="24" height="24" fill="currentColor" viewBox="0 0 16 16">
                        <path d="M.5 9.9a.5.5 0 0 1 .5.5v2.5a1 1 0 0 0 1 1h12a1 1 0 0 0 1-1v-2.5a.5.5 0 0 1 1 0v2.5a2 2 0 0 1-2 2H2a2 2 0 0 1-2-2v-2.5a.5.5 0 0 1 .5-.5z"/>
                        <path d="M7.646 11.854a.5.5 0 0 0 .708 0l3-3a.5.5 0 0 0-.708-.708L8.5 10.293V1.5a.5.5 0 0 0-1 0v8.793L5.354 8.146a.5.5 0 1 0-.708.708l3 3z"/>
                    </svg>
                    Download Wheels Installer
                </h2>
                <p class="text--secondary">Choose your operating system to download the installer</p>
            </div>

            <div class="row mt-lg-5 mt-3">
                <!-- Windows Download Block -->
                <div class="col-lg-6 col-12 mt-lg-0 mt-3">
                    <div class="position-relative d-block docs-container bg-white border-2 px-4 py-4 rounded-4 border--lightGray hover:border--primary shadow-sm">
                        <div class="docs-badge d-flex align-items-center gap-2 bg--primary px-3 py-2 text-white mb-3">
                            <p class="fw-bold text-uppercase fs-12 mb-0">Windows</p>
                            <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5"
                                stroke="currentColor" width="20" height="20">
                                <path stroke-linecap="round" stroke-linejoin="round" d="m8.25 4.5 7.5 7.5-7.5 7.5" />
                            </svg>
                        </div>
                        
                        <h3 class="fs-5 fw-bold mb-3">Windows 10/11 (64-bit)</h3>
                        
                        <div class="mb-3">
                            <p class="fw-semibold mb-2">Requirements:</p>
                            <ul class="text--secondary small ps-3">
                                <li>Windows 10 or 11 (64-bit)</li>
                                <li>100 MB free disk space</li>
                            </ul>
                        </div>
                        
                        <div class="mb-4">
                            <p class="fw-semibold mb-2">Troubleshooting:</p>
                            <p class="text--secondary small mb-0">
                                Run installer with administrative privileges or disable antivirus temporarily if needed.
                            </p>
                        </div>
                        
                        <div class="text-center mt-4">
                            <a class="btn important:text--primary px-4 fs-16 py-2 rounded-3 border border--primary hover:bg--primary hover:text-white bg-transparent text--secondary transition w-100"
                                href="https://github.com/wheels-dev/wheels/raw/develop/tools/installer/windows/installer/wheels-installer.exe">
                                Download for Windows
                            </a>
                        </div>
                    </div>
                </div>

                <!-- Mac Download Block -->
                <div class="col-lg-6 col-12 mt-lg-0 mt-3">
                    <div class="position-relative d-block docs-container bg-white border-2 px-4 py-4 rounded-4 border--lightGray hover:border--primary shadow-sm">
                        <div class="docs-badge d-flex align-items-center gap-2 bg--primary px-3 py-2 text-white mb-3">
                            <p class="fw-bold text-uppercase fs-12 mb-0">Mac</p>
                            <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5"
                                stroke="currentColor" width="20" height="20">
                                <path stroke-linecap="round" stroke-linejoin="round" d="m8.25 4.5 7.5 7.5-7.5 7.5" />
                            </svg>
                        </div>
                        
                        <h3 class="fs-5 fw-bold mb-3">macOS 10.15+ (Catalina or later)</h3>
                        
                        <div class="mb-3">
                            <p class="fw-semibold mb-2">Requirements:</p>
                            <ul class="text--secondary small ps-3">
                                <li>macOS 10.15 (Catalina) or later</li>
                                <li>100 MB free disk space</li>
                            </ul>
                        </div>
                        
                        <div class="mb-4">
                            <p class="fw-semibold mb-2">Troubleshooting:</p>
                            <p class="text--secondary small mb-0">
                                Right-click or Control-click installer → Open to bypass Gatekeeper. Allow app in <strong>System Settings → Privacy & Security</strong> if blocked.
                            </p>
                        </div>
                        
                        <div class="text-center mt-4">
                            <a class="btn important:text--primary px-4 fs-16 py-2 rounded-3 border border--primary hover:bg--primary hover:text-white bg-transparent text--secondary transition w-100"
                                href="https://github.com/wheels-dev/wheels/raw/develop/tools/installer/macos/installer/wheels-installer.dmg">
                                Download for Mac
                            </a>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Section Divider -->
            <hr class="my-5">

            <!-- Other Installation Options -->
            <div class="mb-5">
                <h2 class="fs-22 text--primary fw-bold mb-3">Other Installation Options</h2>
                
                <div class="row">
                    <div class="col-md-6 mb-3">
                        <div class="bg-light border border--lightGray rounded-4 p-4 h-100">
                            <h3 class="fs-5 fw-bold mb-2">Wheels CLI</h3>
                            <p class="text--secondary mb-3">
                                Install Wheels using the command line interface for more control and automation.
                            </p>
                            <cfoutput>
                                <a href="#urlfor(route='load-Guides')#" class="text--primary fw-semibold text-decoration-none">
                                    View Installation Guide →
                                </a>
                            </cfoutput>
                        </div>
                    </div>
                    
                    <div class="col-md-6 mb-3">
                        <div class="bg-light border border--lightGray rounded-4 p-4 h-100">
                            <h3 class="fs-5 fw-bold mb-2">Manual Download</h3>
                            <p class="text--secondary mb-3">
                                Download the latest release manually and extract it to your preferred directory.
                            </p>
                            <a href="https://github.com/wheels-dev/wheels/releases" target="_blank" class="text--primary fw-semibold text-decoration-none">
                                Download from GitHub →
                            </a>
                        </div>
                    </div>
                </div>

                <!-- Manual Installation Accordion -->
                <div class="accordion mt-4" id="manualInstallAccordion">
                    <div class="accordion-item bg-white border border--lightGray rounded-4">
                        <h2 class="accordion-header">
                            <button class="accordion-button collapsed btn important:text--primary px-4 py-3 rounded-3 border border--primary hover:bg--primary hover:text-white bg-transparent text--secondary transition" type="button" data-bs-toggle="collapse" data-bs-target="#manualInstall">
                                <span class="fw-bold fs-5">Manual Installation & Setup Instructions</span>
                            </button>
                        </h2>
                        <div id="manualInstall" class="accordion-collapse collapse" data-bs-parent="#manualInstallAccordion">
                            <div class="accordion-body bg-white px-4 py-4 border-top border--lightGray">
                                <h4 class="fs-6 fw-bold mb-3">Required Packages</h4>
                                <ul class="mb-4">
                                    <li><strong>wheels-core</strong> – framework core (routing, ORM, request lifecycle)</li>
                                    <li><strong>wheels-base-template</strong> – standard app structure (controllers, models, views, config, events)</li>
                                    <li><strong>WireBox</strong> – required for dependency injection</li>
                                    <li><strong>TestBox</strong> – optional for testing</li>
                                </ul>
                                
                                <h4 class="fs-6 fw-bold mb-3">Installation Steps</h4>
                                <ol class="mb-3">
                                    <li class="mb-2">Create your application directory.</li>
                                    <li class="mb-2">Download latest stable versions of required packages.</li>
                                    <li class="mb-2">Extract <strong>wheels-base-template</strong> in your app directory:
                                        <pre class="bg-dark text-white p-3 rounded-3 mt-2 mb-2 small overflow-auto">/my-wheels-app
    /app
    /config
    /db
    /public
    /vendor
    /tests</pre>
                                    </li>
                                    <li class="mb-2">Extract <strong>wheels-core</strong>, <strong>WireBox</strong>, <strong>TestBox</strong> inside <code>/vendor</code>.</li>
                                    <li class="mb-2">Set <code>/public/index.cfm</code> as the entry point in IIS/Apache/Nginx.</li>
                                </ol>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Section Divider -->
            <hr class="my-5">

            <!-- Migration Guide Section -->
            <div class="bg-light border-2 px-4 py-4 rounded-4 border--lightGray">
                <div class="d-flex align-items-start gap-3 mb-3">
                    <svg class="text--primary flex-shrink-0" width="32" height="32" fill="none" stroke="currentColor" stroke-width="2">
                        <circle cx="16" cy="16" r="14" stroke-opacity="0.25" fill="#f7e2d9"/>
                        <path stroke-linecap="round" stroke-linejoin="round" d="M16 10v6m0 4h.01" stroke="#f0330d"/>
                    </svg>
                    <div class="flex-grow-1">
                        <h2 class="fs-4 fw-bold text--primary mb-2">Wheels 2.5 → 3.0 Migration Guide</h2>
                        <p class="text--secondary mb-0">
                            Step-by-step upgrade path for migrating from Wheels 2.5 to Wheels 3.0, covering file structure, code updates, and testing.
                        </p>
                    </div>
                </div>

                <!-- Migration Guide Toggle Button -->
                <div class="text-center mb-3">
                    <div class="d-flex flex-wrap justify-content-center gap-2">
                        <button class="btn important:text--primary px-4 py-2 rounded-3 border border--primary hover:bg--primary hover:text-white bg-transparent text--secondary transition" type="button" data-bs-toggle="collapse" data-bs-target="#migrationGuideContent">
                            <span class="fw-semibold">Show Migration Guide</span>
                            <svg xmlns="http://www.w3.org/2000/svg" class="ms-2" width="16" height="16" fill="currentColor" viewBox="0 0 16 16">
                                <path fill-rule="evenodd" d="M1.646 4.646a.5.5 0 0 1 .708 0L8 10.293l5.646-5.647a.5.5 0 0 1 .708.708l-6 6a.5.5 0 0 1-.708 0l-6-6a.5.5 0 0 1 0-.708z"/>
                            </svg>
                        </button>
                        <button class="btn important:text--primary px-4 py-2 rounded-3 border border--primary hover:bg--primary hover:text-white bg-transparent text--secondary transition" type="button" onclick="expandAllSteps()">
                            <span class="fw-semibold">Expand All Steps</span>
                        </button>
                        <button class="btn important:text--primary px-4 py-2 rounded-3 border border--primary hover:bg--primary hover:text-white bg-transparent text--secondary transition" type="button" onclick="collapseAllSteps()">
                            <span class="fw-semibold">Collapse All Steps</span>
                        </button>
                    </div>
                </div>

                <!-- Collapsible Migration Guide Content -->
                <div class="collapse" id="migrationGuideContent">
                    <div class="bg-white rounded-4 p-4">
                        
                        <!-- Migration Steps Accordion -->
                        <div class="accordion" id="migrationAccordion">
                            
                            <!-- Step 1 -->
                            <div class="accordion-item mb-3 bg-white border border--lightGray rounded-3">
                                <h2 class="accordion-header">
                                    <button class="accordion-button collapsed bg-white px-4 py-3" type="button" data-bs-toggle="collapse" data-bs-target="#step1">
                                        <span class="badge bg--primary text-white me-3 px-3 py-2">1</span>
                                        <span class="fw-bold fs-5 text-dark">Pre-Migration Checks</span>
                                    </button>
                                </h2>
                                <div id="step1" class="accordion-collapse collapse" data-bs-parent="#migrationAccordion">
                                    <div class="accordion-body bg-white px-4 py-4 border-top border--lightGray">
                                        <ul class="mb-0">
                                            <li class="mb-2"><strong>Backup everything:</strong> Files, database schema/data, configs, dependencies.</li>
                                            <li class="mb-2"><strong>Verify current version:</strong> Fully test your Wheels 2.5 app. Document custom code, plugins, and overrides.</li>
                                            <li class="mb-2"><strong>Save server configs:</strong> Copy .env, server.json, box.json, and test locally or on staging before migration.</li>
                                        </ul>
                                    </div>
                                </div>
                            </div>

                            <!-- Step 2 -->
                            <div class="accordion-item mb-3 bg-white border border--lightGray rounded-3">
                                <h2 class="accordion-header">
                                    <button class="accordion-button collapsed bg-white px-4 py-3" type="button" data-bs-toggle="collapse" data-bs-target="#step2">
                                        <span class="badge bg--primary text-white me-3 px-3 py-2">2</span>
                                        <span class="fw-bold fs-5 text-dark">Install Wheels 3.0</span>
                                    </button>
                                </h2>
                                <div id="step2" class="accordion-collapse collapse" data-bs-parent="#migrationAccordion">
                                    <div class="accordion-body bg-white px-4 py-4 border-top border--lightGray">
                                        <ul class="mb-3">
                                            <li class="mb-2">Download the latest Wheels 3.0 version.</li>
                                            <li class="mb-2">Ensure CF server compatibility.</li>
                                            <li class="mb-2">Install core packages:
                                                <div class="mt-2">
                                                    <span class="badge bg-dark text-light me-1">wheels-core</span>
                                                    <span class="badge bg-dark text-light me-1">wheels-base-template</span>
                                                    <span class="badge bg-dark text-light me-1">WireBox</span>
                                                    <span class="badge bg-dark text-light">TestBox</span>
                                                    <span class="text--secondary small ms-2">(optional but recommended)</span>
                                                </div>
                                            </li>
                                        </ul>
                                    </div>
                                </div>
                            </div>

                            <!-- Step 3 -->
                            <div class="accordion-item mb-3 bg-white border border--lightGray rounded-3">
                                <h2 class="accordion-header">
                                    <button class="accordion-button collapsed bg-white px-4 py-3" type="button" data-bs-toggle="collapse" data-bs-target="#step3">
                                        <span class="badge bg--primary text-white me-3 px-3 py-2">3</span>
                                        <span class="fw-bold fs-5 text-dark">Project Restructuring</span>
                                    </button>
                                </h2>
                                <div id="step3" class="accordion-collapse collapse" data-bs-parent="#migrationAccordion">
                                    <div class="accordion-body bg-white px-4 py-4 border-top border--lightGray">
                                        <p class="mb-3">Move files to match the new Wheels 3.0 structure:</p>
                                        
                                        <div class="row g-3 mb-3">
                                            <div class="col-lg-4 col-md-6">
                                                <div class="bg-light p-3 rounded-3">
                                                    <h5 class="fs-6 fw-bold mb-2">App Directory</h5>
                                                    <pre class="bg-dark text-white p-2 rounded-2 small mb-0 overflow-auto">/app
    /controllers
    /models
    /views
    /events
    /global
    /migrator</pre>
                                                </div>
                                            </div>
                                            
                                            <div class="col-lg-4 col-md-6">
                                                <div class="bg-light p-3 rounded-3">
                                                    <h5 class="fs-6 fw-bold mb-2">Public Directory</h5>
                                                    <pre class="bg-dark text-white p-2 rounded-2 small mb-0 overflow-auto">/public
    /js
    /css
    /images
    /files
    /misc
    index.cfm
    Application.cfc
    urlrewrite.xml</pre>
                                                </div>
                                            </div>
                                            
                                            <div class="col-lg-4 col-md-6">
                                                <div class="bg-light p-3 rounded-3">
                                                    <h5 class="fs-6 fw-bold mb-2">Vendor Directory</h5>
                                                    <pre class="bg-dark text-white p-2 rounded-2 small mb-0 overflow-auto">/vendor
    /wheels-core
    /WireBox
    /TestBox</pre>
                                                </div>
                                            </div>
                                        </div>
                                        
                                        <div class="alert alert-warning mb-0">
                                            <strong>Note:</strong> <code>/vendor</code> is now <strong>required</strong> for all dependencies. Wheels should not reside in your app folder.
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- Step 4 -->
                            <div class="accordion-item mb-3 bg-white border border--lightGray rounded-3">
                                <h2 class="accordion-header">
                                    <button class="accordion-button collapsed bg-white px-4 py-3" type="button" data-bs-toggle="collapse" data-bs-target="#step4">
                                        <span class="badge bg--primary text-white me-3 px-3 py-2">4</span>
                                        <span class="fw-bold fs-5 text-dark">Code Updates</span>
                                    </button>
                                </h2>
                                <div id="step4" class="accordion-collapse collapse" data-bs-parent="#migrationAccordion">
                                    <div class="accordion-body bg-white px-4 py-4 border-top border--lightGray">
                                        <ul class="mb-0">
                                            <li class="mb-2"><strong>Namespace updates:</strong> Controllers → <code>app.controllers.Controller</code>, Models → <code>app.models.Model</code></li>
                                            <li class="mb-2"><strong>Environment variables:</strong> Use <code>application.env</code>, not <code>this.env</code>. Remove manual copying.</li>
                                            <li class="mb-2"><strong>Custom functions / overrides:</strong> Use <code>superfindAll()</code> instead of <code>super.findAll()</code> in overrides.</li>
                                            <li class="mb-2"><strong>box.json:</strong> Verify latest dependencies and remove deprecated packages.</li>
                                        </ul>
                                    </div>
                                </div>
                            </div>

                            <!-- Step 5 -->
                            <div class="accordion-item mb-3 bg-white border border--lightGray rounded-3">
                                <h2 class="accordion-header">
                                    <button class="accordion-button collapsed bg-white px-4 py-3" type="button" data-bs-toggle="collapse" data-bs-target="#step5">
                                        <span class="badge bg--primary text-white me-3 px-3 py-2">5</span>
                                        <span class="fw-bold fs-5 text-dark">Database / ORM Adjustments</span>
                                    </button>
                                </h2>
                                <div id="step5" class="accordion-collapse collapse" data-bs-parent="#migrationAccordion">
                                    <div class="accordion-body bg-white px-4 py-4 border-top border--lightGray">
                                        <ul class="mb-0">
                                            <li class="mb-2">Remove duplicate columns in selects; Wheels 3.0 is stricter.</li>
                                            <li class="mb-2">One property per DB column. No duplicates.</li>
                                            <li class="mb-2">Adjust queries using <code>#filterList#</code> or dynamic columns.</li>
                                        </ul>
                                    </div>
                                </div>
                            </div>

                            <!-- Step 6 -->
                            <div class="accordion-item mb-3 bg-white border border--lightGray rounded-3">
                                <h2 class="accordion-header">
                                    <button class="accordion-button collapsed bg-white px-4 py-3" type="button" data-bs-toggle="collapse" data-bs-target="#step6">
                                        <span class="badge bg--primary text-white me-3 px-3 py-2">6</span>
                                        <span class="fw-bold fs-5 text-dark">Dependency Installation</span>
                                    </button>
                                </h2>
                                <div id="step6" class="accordion-collapse collapse" data-bs-parent="#migrationAccordion">
                                    <div class="accordion-body bg-white px-4 py-4 border-top border--lightGray">
                                        <h5 class="fs-6 fw-bold mb-2">CLI Installation:</h5>
                                        <pre class="bg-dark text-white p-3 rounded-3 mb-3 overflow-auto">cd /path/to/my-wheels-app
install wirebox
install testbox</pre>

                                        <h5 class="fs-6 fw-bold mb-2">Manual Installation (optional):</h5>
                                        <ol class="mb-3">
                                            <li class="mb-2">Download the latest stable versions of <strong>WireBox</strong> and <strong>TestBox</strong> from ForgeBox.</li>
                                            <li class="mb-2">Extract both into your project's <code>/vendor</code> folder:
                                                <pre class="bg-dark text-white p-3 rounded-3 mt-2 mb-2 overflow-auto">/my-wheels-app
    /vendor
        /WireBox
        /TestBox</pre>
                                            </li>
                                            <li class="mb-2">Ensure your application can reference them from <code>/vendor</code> at runtime.</li>
                                        </ol>

                                        <div class="alert alert-info mb-0">
                                            You can choose either method: manual extraction or CLI installation. Both ensure WireBox and TestBox are available for your application.
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- Step 7 -->
                            <div class="accordion-item mb-3 bg-white border border--lightGray rounded-3">
                                <h2 class="accordion-header">
                                    <button class="accordion-button collapsed bg-white px-4 py-3" type="button" data-bs-toggle="collapse" data-bs-target="#step7">
                                        <span class="badge bg--primary text-white me-3 px-3 py-2">7</span>
                                        <span class="fw-bold fs-5 text-dark">Testing & Debugging</span>
                                    </button>
                                </h2>
                                <div id="step7" class="accordion-collapse collapse" data-bs-parent="#migrationAccordion">
                                    <div class="accordion-body bg-white px-4 py-4 border-top border--lightGray">
                                        <ul class="mb-0">
                                            <li class="mb-2">Start the app: <code>start</code></li>
                                            <li class="mb-2">Check logs for missing files, paths, and dependency conflicts.</li>
                                            <li class="mb-2">Test:
                                                <ul class="mt-2">
                                                    <li>UI & API endpoints</li>
                                                    <li>Authentication</li>
                                                    <li>DB migrations & ORM models</li>
                                                    <li>Custom helpers/plugins</li>
                                                </ul>
                                            </li>
                                        </ul>
                                    </div>
                                </div>
                            </div>

                            <!-- Step 8 -->
                            <div class="accordion-item mb-3 bg-white border border--lightGray rounded-3">
                                <h2 class="accordion-header">
                                    <button class="accordion-button collapsed bg-white px-4 py-3" type="button" data-bs-toggle="collapse" data-bs-target="#step8">
                                        <span class="badge bg--primary text-white me-3 px-3 py-2">8</span>
                                        <span class="fw-bold fs-5 text-dark">Final Steps</span>
                                    </button>
                                </h2>
                                <div id="step8" class="accordion-collapse collapse" data-bs-parent="#migrationAccordion">
                                    <div class="accordion-body bg-white px-4 py-4 border-top border--lightGray">
                                        <ul class="mb-0">
                                            <li class="mb-2">Remove debug/test code.</li>
                                            <li class="mb-2">Document changes and deployment instructions.</li>
                                            <li class="mb-2">Deploy to staging before production.</li>
                                            <li class="mb-2">Automate tests and CI/CD pipelines.</li>
                                            <li class="mb-2">Keep backups until migration is verified.</li>
                                        </ul>
                                    </div>
                                </div>
                            </div>

                            <!-- Step 9 - Checklist -->
                            <div class="accordion-item mb-3 bg-white border border--lightGray rounded-3">
                                <h2 class="accordion-header">
                                    <button class="accordion-button collapsed bg-white px-4 py-3" type="button" data-bs-toggle="collapse" data-bs-target="#step9">
                                        <span class="badge bg--primary text-white me-3 px-3 py-2">9</span>
                                        <span class="fw-bold fs-5 text-dark">Migration Checklist</span>
                                    </button>
                                </h2>
                                <div id="step9" class="accordion-collapse collapse" data-bs-parent="#migrationAccordion">
                                    <div class="accordion-body bg-white px-4 py-4 border-top border--lightGray">
                                        <p class="text--secondary mb-3">Click items to mark them as complete:</p>
                                        
                                        <div id="migrationChecklist">
                                            <div class="form-check mb-2">
                                                <input class="form-check-input" type="checkbox" id="check1">
                                                <label class="form-check-label" for="check1">
                                                    Backup project, configs, and DB
                                                </label>
                                            </div>
                                            <div class="form-check mb-2">
                                                <input class="form-check-input" type="checkbox" id="check2">
                                                <label class="form-check-label" for="check2">
                                                    Verify Wheels 2.5 app
                                                </label>
                                            </div>
                                            <div class="form-check mb-2">
                                                <input class="form-check-input" type="checkbox" id="check3">
                                                <label class="form-check-label" for="check3">
                                                    Install Wheels 3.0 & dependencies
                                                </label>
                                            </div>
                                            <div class="form-check mb-2">
                                                <input class="form-check-input" type="checkbox" id="check4">
                                                <label class="form-check-label" for="check4">
                                                    Restructure (app, public, vendor)
                                                </label>
                                            </div>
                                            <div class="form-check mb-2">
                                                <input class="form-check-input" type="checkbox" id="check5">
                                                <label class="form-check-label" for="check5">
                                                    Update namespaces, paths, env vars
                                                </label>
                                            </div>
                                            <div class="form-check mb-2">
                                                <input class="form-check-input" type="checkbox" id="check6">
                                                <label class="form-check-label" for="check6">
                                                    Refactor overrides/helpers
                                                </label>
                                            </div>
                                            <div class="form-check mb-2">
                                                <input class="form-check-input" type="checkbox" id="check7">
                                                <label class="form-check-label" for="check7">
                                                    Adjust ORM mappings/queries
                                                </label>
                                            </div>
                                            <div class="form-check mb-2">
                                                <input class="form-check-input" type="checkbox" id="check8">
                                                <label class="form-check-label" for="check8">
                                                    Test in staging
                                                </label>
                                            </div>
                                            <div class="form-check mb-3">
                                                <input class="form-check-input" type="checkbox" id="check9">
                                                <label class="form-check-label" for="check9">
                                                    Final cleanup and deployment
                                                </label>
                                            </div>
                                        </div>

                                        <div class="alert alert-success">
                                            <strong>💡 Tips:</strong> Always backup, test incrementally, automate what you can, and document every change.
                                        </div>
                                    </div>
                                </div>
                            </div>

                        </div>
                        <!-- End Accordion -->

                    </div>
                </div>
                <!-- End Collapsible Content -->

            </div>
            <!-- End Migration Guide Section -->

        </div>
    </div>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <!-- Expand/Collapse All Accordion Steps -->
    <script>
        function expandAllSteps() {
            // First show the migration guide if it's hidden
            const migrationGuideContent = document.getElementById('migrationGuideContent');
            const migrationGuideCollapse = new bootstrap.Collapse(migrationGuideContent, {
                toggle: false
            });
            migrationGuideCollapse.show();
            
            // Then expand all accordion items
            const accordionItems = document.querySelectorAll('#migrationAccordion .accordion-collapse');
            accordionItems.forEach(item => {
                const collapse = new bootstrap.Collapse(item, {
                    toggle: false
                });
                collapse.show();
            });
        }
        
        function collapseAllSteps() {
            const accordionItems = document.querySelectorAll('#migrationAccordion .accordion-collapse');
            accordionItems.forEach(item => {
                const collapse = new bootstrap.Collapse(item, {
                    toggle: false
                });
                collapse.hide();
            });
        }
    </script>
    
    <!-- Simple Checklist Persistence -->
    <script>
        // Save checklist state to localStorage
        document.addEventListener('DOMContentLoaded', function() {
            const checkboxes = document.querySelectorAll('#migrationChecklist input[type="checkbox"]');
            
            // Load saved state
            checkboxes.forEach(checkbox => {
                const saved = localStorage.getItem(checkbox.id);
                if (saved === 'true') {
                    checkbox.checked = true;
                }
                
                // Save on change
                checkbox.addEventListener('change', function() {
                    localStorage.setItem(this.id, this.checked);
                });
            });
        });
    </script>
</main>