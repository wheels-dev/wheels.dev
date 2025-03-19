<main class="main-bg">
    <div class="container py-5">
        <div class="row">
            <div class="col-lg-4 col-12">
                <cfoutput>#includePartial("partials/versions")#</cfoutput>
                <!---<select class="form-control border-0 shadow-sm p-2 fs-16 bg-white">
                    <option value="">Version</option>
                    <option value="3.0.0-SNAPSHOT">3.0.0-SNAPSHOT</option>
                    <option value="2.5.0">2.5.0</option>
                    <option value="2.4.0">2.4.0</option>
                    <option value="2.3.0">2.3.0</option>
                    <option value="2.2.0">2.2.0</option>
                    <option value="2.1.0">2.1.0</option>
                    <option value="1.4.5">1.4.5</option>
                </select>--->
            </div>
            <div class="col-lg-4 mt-lg-0 mt-3 offset-lg-4 col-12">
                <div class="d-flex api flex-wrap align-items-center justify-content-end gap-3">
                    <button
                        onclick="handleApiSection('All', this)"
                        class="active px-4 filter-button fs-16 py-2 d-flex align-items-center gap-2 rounded-3 border--iris bg-transparent text--secondary">
                        A-Z Functions
                        <svg class="d-none" width="16" height="16" viewBox="0 0 16 16" fill="none" xmlns="http://www.w3.org/2000/svg">
                            <path
                                d="M8 0C3.592 0 0 3.592 0 8C0 12.408 3.592 16 8 16C12.408 16 16 12.408 16 8C16 3.592 12.408 0 8 0ZM11.768 6.96797L7.76799 10.968C7.60799 11.12 7.408 11.2 7.2 11.2C6.992 11.2 6.79201 11.12 6.63201 10.968L4.23201 8.56797C3.92001 8.25597 3.92001 7.74403 4.23201 7.43203C4.54401 7.12003 5.05599 7.12003 5.36799 7.43203L7.2 9.27207L10.632 5.83203C10.944 5.52003 11.456 5.52003 11.768 5.83203C12.08 6.14403 12.08 6.65597 11.768 6.96797Z"
                                fill="white" />
                        </svg>
                    </button>
                    <button
                        onclick="handleApiSection('Sections', this)"
                        class="px-4 filter-button fs-16 py-2 d-flex align-items-center gap-2 rounded-3 border--iris bg-transparent text--secondary">
                        Sections
                        <svg class="d-none" width="16" height="16" viewBox="0 0 16 16" fill="none"
                            xmlns="http://www.w3.org/2000/svg">
                            <path
                                d="M8 0C3.592 0 0 3.592 0 8C0 12.408 3.592 16 8 16C12.408 16 16 12.408 16 8C16 3.592 12.408 0 8 0ZM11.768 6.96797L7.76799 10.968C7.60799 11.12 7.408 11.2 7.2 11.2C6.992 11.2 6.79201 11.12 6.63201 10.968L4.23201 8.56797C3.92001 8.25597 3.92001 7.74403 4.23201 7.43203C4.54401 7.12003 5.05599 7.12003 5.36799 7.43203L7.2 9.27207L10.632 5.83203C10.944 5.52003 11.456 5.52003 11.768 5.83203C12.08 6.14403 12.08 6.65597 11.768 6.96797Z"
                                fill="white" />
                        </svg>
                    </button>
                </div>
            </div>
        </div>
        <hr class="my-4">

        <div class="row justify-content-center justify-content-lg-between">
            <div class="mt-lg-0 mt-3 col-lg-9 col-12">
                <div class="p-3 rounded-18 bg-white">
                    <div class="d-flex align-items-center gap-2">
                        <h1 class="text--primary fs-24 fw-bold">accessibleProperties()</h1>
                        <div class="dropdown">
                            <button
                                class="dropdown-toggle outline-none border-0 no-dropdown-arrow text-center bg-transparent"
                                type="button" data-bs-toggle="dropdown" aria-expanded="false">
                                <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5"
                                    stroke="currentColor" width="25" height="25" class="text--lightGray">
                                    <path stroke-linecap="round" stroke-linejoin="round" d="m19.5 8.25-7.5 7.5-7.5-7.5" />
                                </svg>
                            </button>
                            <ul class="dropdown-menu">
                                <li class="dropdown-item fs-14 cursor-pointer">Permalink</li>
                                <li class="dropdown-item fs-14 cursor-pointer">JSON</li>
                            </ul>
                        </div>
                    </div>
                    <div>
                        <div class="d-flex api-filter-buttons align-items-center my-3 gap-2 flex-wrap">
                            <button onclick="handleApiFilters(this)"
                                class="text--lightGray border d-flex align-items-center gap-2 rounded-4 fs-14 fw-normal px-3 py-2 bg-transparent">
                                <i class="bi bi-tags"></i>
                                Modal Configuration
                            </button>
                            <button onclick="handleApiFilters(this)"
                                class="text--lightGray border d-flex align-items-center gap-2 rounded-4 fs-14 fw-normal px-3 py-2 bg-transparent">
                                <i class="bi bi-tags"></i>
                                Miscellanious Function
                            </button>
                            <button onclick="handleApiFilters(this)"
                                class="text--lightGray border d-flex align-items-center gap-2 rounded-4 fs-14 fw-normal px-3 py-2 bg-transparent">
                                <i class="bi bi-arrow-return-left"></i>
                                Void
                            </button>
                            <button onclick="handleApiFilters(this)"
                                class="text--lightGray border d-flex align-items-center gap-2 rounded-4 fs-14 fw-normal px-3 py-2 bg-transparent">
                                <i class="bi bi-lightning-charge-fill"></i>
                                Model
                            </button>
                            <button onclick="handleApiFilters(this)"
                                class="text--lightGray border d-flex align-items-center gap-2 rounded-4 fs-14 fw-normal px-3 py-2 bg-transparent">
                                <i class="bi bi-lightning-charge-fill"></i>
                                Controller
                            </button>
                            <button onclick="handleApiFilters(this)"
                                class="text--lightGray border d-flex align-items-center gap-2 rounded-4 fs-14 fw-normal px-3 py-2 bg-transparent">
                                <i class="bi bi-lightning-charge-fill"></i>
                                test
                            </button>
                            <button onclick="handleApiFilters(this)"
                                class="text--lightGray border d-flex align-items-center gap-2 rounded-4 fs-14 fw-normal px-3 py-2 bg-transparent">
                                <i class="bi bi-lightning-charge-fill"></i>
                                migrator
                            </button>
                            <button onclick="handleApiFilters(this)"
                                class="text--lightGray border d-flex align-items-center gap-2 rounded-4 fs-14 fw-normal px-3 py-2 bg-transparent">
                                <i class="bi bi-lightning-charge-fill"></i>
                                migration
                            </button>
                            <button onclick="handleApiFilters(this)"
                                class="text--lightGray border d-flex align-items-center gap-2 rounded-4 fs-14 fw-normal px-3 py-2 bg-transparent">
                                <i class="bi bi-lightning-charge-fill"></i>
                                table
                            </button>
                        </div>
                        <p class="fs-14 fw-normal">Use this method to specify which properties can be set through mass
                            assignment.</p>
                    </div>
                    <div class="mt-4 overflow-x-auto no-scrollbar">
                        <table class="table table-responsive">
                            <thead class="table--iris">
                                <tr>
                                    <th scope="col" class="text-white px-lg-3 px-1 fs-14 fw-semibold">Name</th>
                                    <th scope="col" class="text-white px-lg-3 px-1 fs-14 fw-semibold">Type</th>
                                    <th scope="col" class="text-white px-lg-3 px-1 fs-14 fw-semibold">Required</th>
                                    <th scope="col" class="text-white px-lg-3 px-1 fs-14 fw-semibold">Default</th>
                                    <th scope="col" class="text-white px-lg-3 px-1 fs-14 fw-semibold">Description</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td class="text-black p-lg-3 p-1 fs-14 fw-normal">Properties</td>
                                    <td class="text-black p-lg-3 p-1 fs-14 fw-normal">String</td>
                                    <td class="text-black p-lg-3 p-1 fs-14 fw-normal">No</td>
                                    <td class="text-black p-lg-3 p-1 fs-14 fw-normal">No</td>
                                    <td class="text-black p-lg-3 p-1 fs-14 fw-normal">Property name (or list of property
                                        names)
                                        that are allowed</td>
                                </tr>
                                <tr class="table-light">
                                    <td class="text-black p-lg-3 p-1 fs-14 fw-normal">Properties</td>
                                    <td class="text-black p-lg-3 p-1 fs-14 fw-normal">String</td>
                                    <td class="text-black p-lg-3 p-1 fs-14 fw-normal">No</td>
                                    <td class="text-black p-lg-3 p-1 fs-14 fw-normal">No</td>
                                    <td class="text-black p-lg-3 p-1 fs-14 fw-normal">Property name (or list of property
                                        names)
                                        that are allowed</td>
                                </tr>
                                <tr>
                                    <td class="text-black p-lg-3 p-1 fs-14 fw-normal">Properties</td>
                                    <td class="text-black p-lg-3 p-1 fs-14 fw-normal">String</td>
                                    <td class="text-black p-lg-3 p-1 fs-14 fw-normal">No</td>
                                    <td class="text-black p-lg-3 p-1 fs-14 fw-normal">No</td>
                                    <td class="text-black p-lg-3 p-1 fs-14 fw-normal">Property name (or list of property
                                        names)
                                        that are allowed</td>
                                </tr>
                                <tr class="table-light">
                                    <td class="text-black p-lg-3 p-1 fs-14 fw-normal">Properties</td>
                                    <td class="text-black p-lg-3 p-1 fs-14 fw-normal">String</td>
                                    <td class="text-black p-lg-3 p-1 fs-14 fw-normal">No</td>
                                    <td class="text-black p-lg-3 p-1 fs-14 fw-normal">No</td>
                                    <td class="text-black p-lg-3 p-1 fs-14 fw-normal">Property name (or list of property
                                        names)
                                        that are allowed</td>
                                </tr>
                                <tr>
                                    <td class="text-black p-lg-3 p-1 fs-14 fw-normal">Properties</td>
                                    <td class="text-black p-lg-3 p-1 fs-14 fw-normal">String</td>
                                    <td class="text-black p-lg-3 p-1 fs-14 fw-normal">No</td>
                                    <td class="text-black p-lg-3 p-1 fs-14 fw-normal">No</td>
                                    <td class="text-black p-lg-3 p-1 fs-14 fw-normal">Property name (or list of property
                                        names)
                                        that are allowed to be altered through mass Property name (or list of property
                                        names)
                                        that are allowed to be altered through mass Property name</td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                    <div style="background-color: rgba(243, 243, 243, 1); border: 2px rgba(179, 179, 179, 0.6) solid;"
                        class="p-4 rounded-18">
                        <pre class="fs-14 fw-normal m-0 p-0">
                            // Add the `js` format
                            addFormat(extension="js", mimeType="text/javascript");
                            
                            // Add the `ppt` and `pptx` formats
                            addFormat(extension="ppt", mimeType="application/vnd.ms-powerpoint");
                            addFormat(extension="pptx", mimeType="application/vnd.ms-powerpoint");
                        </pre>
                        <div class="text-end">
                            <i class="bi bi-copy text--iris fs-5 cursor-pointer"></i>
                        </div>
                    </div>
                </div>

                <div class="p-3 mt-3 rounded-18 bg-white">
                    <div class="d-flex align-items-center gap-2">
                        <h1 class="text--primary fs-24 fw-bold">accessibleProperties()</h1>
                        <div class="dropdown">
                            <button
                                class="dropdown-toggle outline-none border-0 no-dropdown-arrow text-center bg-transparent"
                                type="button" data-bs-toggle="dropdown" aria-expanded="false">
                                <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5"
                                    stroke="currentColor" width="25" height="25" class="text--lightGray">
                                    <path stroke-linecap="round" stroke-linejoin="round" d="m19.5 8.25-7.5 7.5-7.5-7.5" />
                                </svg>
                            </button>
                            <ul class="dropdown-menu">
                                <li class="dropdown-item fs-14 cursor-pointer">Permalink</li>
                                <li class="dropdown-item fs-14 cursor-pointer">JSON</li>
                            </ul>
                        </div>
                    </div>
                    <div>
                        <div class="d-flex api-filter-buttons align-items-center my-3 gap-2 flex-wrap">
                            <button onclick="handleApiFilters(this)"
                                class="text--lightGray border d-flex align-items-center gap-2 rounded-4 fs-14 fw-normal px-3 py-2 bg-transparent">
                                <i class="bi bi-tags"></i>
                                Modal Configuration
                            </button>
                            <button onclick="handleApiFilters(this)"
                                class="text--lightGray border d-flex align-items-center gap-2 rounded-4 fs-14 fw-normal px-3 py-2 bg-transparent">
                                <i class="bi bi-tags"></i>
                                Miscellanious Function
                            </button>
                            <button onclick="handleApiFilters(this)"
                                class="text--lightGray border d-flex align-items-center gap-2 rounded-4 fs-14 fw-normal px-3 py-2 bg-transparent">
                                <i class="bi bi-arrow-return-left"></i>
                                Void
                            </button>
                            <button onclick="handleApiFilters(this)"
                                class="text--lightGray border d-flex align-items-center gap-2 rounded-4 fs-14 fw-normal px-3 py-2 bg-transparent">
                                <i class="bi bi-lightning-charge-fill"></i>
                                Model
                            </button>
                            <button onclick="handleApiFilters(this)"
                                class="text--lightGray border d-flex align-items-center gap-2 rounded-4 fs-14 fw-normal px-3 py-2 bg-transparent">
                                <i class="bi bi-lightning-charge-fill"></i>
                                Controller
                            </button>
                            <button onclick="handleApiFilters(this)"
                                class="text--lightGray border d-flex align-items-center gap-2 rounded-4 fs-14 fw-normal px-3 py-2 bg-transparent">
                                <i class="bi bi-lightning-charge-fill"></i>
                                test
                            </button>
                            <button onclick="handleApiFilters(this)"
                                class="text--lightGray border d-flex align-items-center gap-2 rounded-4 fs-14 fw-normal px-3 py-2 bg-transparent">
                                <i class="bi bi-lightning-charge-fill"></i>
                                migrator
                            </button>
                            <button onclick="handleApiFilters(this)"
                                class="text--lightGray border d-flex align-items-center gap-2 rounded-4 fs-14 fw-normal px-3 py-2 bg-transparent">
                                <i class="bi bi-lightning-charge-fill"></i>
                                migration
                            </button>
                            <button onclick="handleApiFilters(this)"
                                class="text--lightGray border d-flex align-items-center gap-2 rounded-4 fs-14 fw-normal px-3 py-2 bg-transparent">
                                <i class="bi bi-lightning-charge-fill"></i>
                                table
                            </button>
                        </div>
                        <p class="fs-14 fw-normal">Use this method to specify which properties can be set through mass
                            assignment.</p>
                    </div>
                    <div class="mt-4 overflow-x-auto no-scrollbar">
                        <table class="table table-responsive">
                            <thead class="table--iris">
                                <tr>
                                    <th scope="col" class="text-white px-lg-3 px-1 fs-14 fw-semibold">Name</th>
                                    <th scope="col" class="text-white px-lg-3 px-1 fs-14 fw-semibold">Type</th>
                                    <th scope="col" class="text-white px-lg-3 px-1 fs-14 fw-semibold">Required</th>
                                    <th scope="col" class="text-white px-lg-3 px-1 fs-14 fw-semibold">Default</th>
                                    <th scope="col" class="text-white px-lg-3 px-1 fs-14 fw-semibold">Description</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td class="text-black p-lg-3 p-1 fs-14 fw-normal">Properties</td>
                                    <td class="text-black p-lg-3 p-1 fs-14 fw-normal">String</td>
                                    <td class="text-black p-lg-3 p-1 fs-14 fw-normal">No</td>
                                    <td class="text-black p-lg-3 p-1 fs-14 fw-normal">No</td>
                                    <td class="text-black p-lg-3 p-1 fs-14 fw-normal">Property name (or list of property
                                        names)
                                        that are allowed</td>
                                </tr>
                                <tr class="table-light">
                                    <td class="text-black p-lg-3 p-1 fs-14 fw-normal">Properties</td>
                                    <td class="text-black p-lg-3 p-1 fs-14 fw-normal">String</td>
                                    <td class="text-black p-lg-3 p-1 fs-14 fw-normal">No</td>
                                    <td class="text-black p-lg-3 p-1 fs-14 fw-normal">No</td>
                                    <td class="text-black p-lg-3 p-1 fs-14 fw-normal">Property name (or list of property
                                        names)
                                        that are allowed</td>
                                </tr>
                                <tr>
                                    <td class="text-black p-lg-3 p-1 fs-14 fw-normal">Properties</td>
                                    <td class="text-black p-lg-3 p-1 fs-14 fw-normal">String</td>
                                    <td class="text-black p-lg-3 p-1 fs-14 fw-normal">No</td>
                                    <td class="text-black p-lg-3 p-1 fs-14 fw-normal">No</td>
                                    <td class="text-black p-lg-3 p-1 fs-14 fw-normal">Property name (or list of property
                                        names)
                                        that are allowed</td>
                                </tr>
                                <tr class="table-light">
                                    <td class="text-black p-lg-3 p-1 fs-14 fw-normal">Properties</td>
                                    <td class="text-black p-lg-3 p-1 fs-14 fw-normal">String</td>
                                    <td class="text-black p-lg-3 p-1 fs-14 fw-normal">No</td>
                                    <td class="text-black p-lg-3 p-1 fs-14 fw-normal">No</td>
                                    <td class="text-black p-lg-3 p-1 fs-14 fw-normal">Property name (or list of property
                                        names)
                                        that are allowed</td>
                                </tr>
                                <tr>
                                    <td class="text-black p-lg-3 p-1 fs-14 fw-normal">Properties</td>
                                    <td class="text-black p-lg-3 p-1 fs-14 fw-normal">String</td>
                                    <td class="text-black p-lg-3 p-1 fs-14 fw-normal">No</td>
                                    <td class="text-black p-lg-3 p-1 fs-14 fw-normal">No</td>
                                    <td class="text-black p-lg-3 p-1 fs-14 fw-normal">Property name (or list of property
                                        names)
                                        that are allowed to be altered through mass Property name (or list of property
                                        names)
                                        that are allowed to be altered through mass Property name</td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                    <div style="background-color: rgba(243, 243, 243, 1); border: 2px rgba(179, 179, 179, 0.6) solid;"
                        class="p-4 rounded-18">
                        <pre class="fs-14 fw-normal m-0 p-0">
                            // Add the `js` format
                            addFormat(extension="js", mimeType="text/javascript");
                            
                            // Add the `ppt` and `pptx` formats
                            addFormat(extension="ppt", mimeType="application/vnd.ms-powerpoint");
                            addFormat(extension="pptx", mimeType="application/vnd.ms-powerpoint");
                        </pre>
                        <div class="text-end">
                            <i class="bi bi-copy text--iris fs-5 cursor-pointer"></i>
                        </div>
                    </div>
                </div>

                <div class="p-3 mt-3 rounded-18 bg-white">
                    <div class="d-flex align-items-center gap-2">
                        <h1 class="text--primary fs-24 fw-bold">accessibleProperties()</h1>
                        <div class="dropdown">
                            <button
                                class="dropdown-toggle outline-none border-0 no-dropdown-arrow text-center bg-transparent"
                                type="button" data-bs-toggle="dropdown" aria-expanded="false">
                                <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5"
                                    stroke="currentColor" width="25" height="25" class="text--lightGray">
                                    <path stroke-linecap="round" stroke-linejoin="round" d="m19.5 8.25-7.5 7.5-7.5-7.5" />
                                </svg>
                            </button>
                            <ul class="dropdown-menu">
                                <li class="dropdown-item fs-14 cursor-pointer">Permalink</li>
                                <li class="dropdown-item fs-14 cursor-pointer">JSON</li>
                            </ul>
                        </div>
                    </div>
                    <div>
                        <div class="d-flex api-filter-buttons align-items-center my-3 gap-2 flex-wrap">
                            <button onclick="handleApiFilters(this)"
                                class="text--lightGray border d-flex align-items-center gap-2 rounded-4 fs-14 fw-normal px-3 py-2 bg-transparent">
                                <i class="bi bi-tags"></i>
                                Modal Configuration
                            </button>
                            <button onclick="handleApiFilters(this)"
                                class="text--lightGray border d-flex align-items-center gap-2 rounded-4 fs-14 fw-normal px-3 py-2 bg-transparent">
                                <i class="bi bi-tags"></i>
                                Miscellanious Function
                            </button>
                            <button onclick="handleApiFilters(this)"
                                class="text--lightGray border d-flex align-items-center gap-2 rounded-4 fs-14 fw-normal px-3 py-2 bg-transparent">
                                <i class="bi bi-arrow-return-left"></i>
                                Void
                            </button>
                            <button onclick="handleApiFilters(this)"
                                class="text--lightGray border d-flex align-items-center gap-2 rounded-4 fs-14 fw-normal px-3 py-2 bg-transparent">
                                <i class="bi bi-lightning-charge-fill"></i>
                                Model
                            </button>
                            <button onclick="handleApiFilters(this)"
                                class="text--lightGray border d-flex align-items-center gap-2 rounded-4 fs-14 fw-normal px-3 py-2 bg-transparent">
                                <i class="bi bi-lightning-charge-fill"></i>
                                Controller
                            </button>
                            <button onclick="handleApiFilters(this)"
                                class="text--lightGray border d-flex align-items-center gap-2 rounded-4 fs-14 fw-normal px-3 py-2 bg-transparent">
                                <i class="bi bi-lightning-charge-fill"></i>
                                test
                            </button>
                            <button onclick="handleApiFilters(this)"
                                class="text--lightGray border d-flex align-items-center gap-2 rounded-4 fs-14 fw-normal px-3 py-2 bg-transparent">
                                <i class="bi bi-lightning-charge-fill"></i>
                                migrator
                            </button>
                            <button onclick="handleApiFilters(this)"
                                class="text--lightGray border d-flex align-items-center gap-2 rounded-4 fs-14 fw-normal px-3 py-2 bg-transparent">
                                <i class="bi bi-lightning-charge-fill"></i>
                                migration
                            </button>
                            <button onclick="handleApiFilters(this)"
                                class="text--lightGray border d-flex align-items-center gap-2 rounded-4 fs-14 fw-normal px-3 py-2 bg-transparent">
                                <i class="bi bi-lightning-charge-fill"></i>
                                table
                            </button>
                        </div>
                        <p class="fs-14 fw-normal">Use this method to specify which properties can be set through mass
                            assignment.</p>
                    </div>
                    <div class="mt-4 overflow-x-auto no-scrollbar">
                        <table class="table table-responsive">
                            <thead class="table--iris">
                                <tr>
                                    <th scope="col" class="text-white px-lg-3 px-1 fs-14 fw-semibold">Name</th>
                                    <th scope="col" class="text-white px-lg-3 px-1 fs-14 fw-semibold">Type</th>
                                    <th scope="col" class="text-white px-lg-3 px-1 fs-14 fw-semibold">Required</th>
                                    <th scope="col" class="text-white px-lg-3 px-1 fs-14 fw-semibold">Default</th>
                                    <th scope="col" class="text-white px-lg-3 px-1 fs-14 fw-semibold">Description</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td class="text-black p-lg-3 p-1 fs-14 fw-normal">Properties</td>
                                    <td class="text-black p-lg-3 p-1 fs-14 fw-normal">String</td>
                                    <td class="text-black p-lg-3 p-1 fs-14 fw-normal">No</td>
                                    <td class="text-black p-lg-3 p-1 fs-14 fw-normal">No</td>
                                    <td class="text-black p-lg-3 p-1 fs-14 fw-normal">Property name (or list of property
                                        names)
                                        that are allowed</td>
                                </tr>
                                <tr class="table-light">
                                    <td class="text-black p-lg-3 p-1 fs-14 fw-normal">Properties</td>
                                    <td class="text-black p-lg-3 p-1 fs-14 fw-normal">String</td>
                                    <td class="text-black p-lg-3 p-1 fs-14 fw-normal">No</td>
                                    <td class="text-black p-lg-3 p-1 fs-14 fw-normal">No</td>
                                    <td class="text-black p-lg-3 p-1 fs-14 fw-normal">Property name (or list of property
                                        names)
                                        that are allowed</td>
                                </tr>
                                <tr>
                                    <td class="text-black p-lg-3 p-1 fs-14 fw-normal">Properties</td>
                                    <td class="text-black p-lg-3 p-1 fs-14 fw-normal">String</td>
                                    <td class="text-black p-lg-3 p-1 fs-14 fw-normal">No</td>
                                    <td class="text-black p-lg-3 p-1 fs-14 fw-normal">No</td>
                                    <td class="text-black p-lg-3 p-1 fs-14 fw-normal">Property name (or list of property
                                        names)
                                        that are allowed</td>
                                </tr>
                                <tr class="table-light">
                                    <td class="text-black p-lg-3 p-1 fs-14 fw-normal">Properties</td>
                                    <td class="text-black p-lg-3 p-1 fs-14 fw-normal">String</td>
                                    <td class="text-black p-lg-3 p-1 fs-14 fw-normal">No</td>
                                    <td class="text-black p-lg-3 p-1 fs-14 fw-normal">No</td>
                                    <td class="text-black p-lg-3 p-1 fs-14 fw-normal">Property name (or list of property
                                        names)
                                        that are allowed</td>
                                </tr>
                                <tr>
                                    <td class="text-black p-lg-3 p-1 fs-14 fw-normal">Properties</td>
                                    <td class="text-black p-lg-3 p-1 fs-14 fw-normal">String</td>
                                    <td class="text-black p-lg-3 p-1 fs-14 fw-normal">No</td>
                                    <td class="text-black p-lg-3 p-1 fs-14 fw-normal">No</td>
                                    <td class="text-black p-lg-3 p-1 fs-14 fw-normal">Property name (or list of property
                                        names)
                                        that are allowed to be altered through mass Property name (or list of property
                                        names)
                                        that are allowed to be altered through mass Property name</td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                    <div style="background-color: rgba(243, 243, 243, 1); border: 2px rgba(179, 179, 179, 0.6) solid;"
                        class="p-4 rounded-18">
                        <pre class="fs-14 fw-normal m-0 p-0">
                            // Add the `js` format
                            addFormat(extension="js", mimeType="text/javascript");
                            
                            // Add the `ppt` and `pptx` formats
                            addFormat(extension="ppt", mimeType="application/vnd.ms-powerpoint");
                            addFormat(extension="pptx", mimeType="application/vnd.ms-powerpoint");
                        </pre>
                        <div class="text-end">
                            <i class="bi bi-copy text--iris fs-5 cursor-pointer"></i>
                        </div>
                    </div>
                </div>
            </div>
            <div id="functionsContainer" class="col-lg-3 col-12 order-lg-0 order-first">
                <div class="bg-white p-3 rounded-18 no-scrollbar h-70vh overflow-y-auto">
                    <div class="space-y-2 px-2">
                        <p class="fs-14 cursor-pointer fw-normal text--iris">All</p>
                        <p class="fs-14 cursor-pointer fw-normal text--iris">accessibleProperties()</p>
                        <p class="fs-14 cursor-pointer fw-normal text--iris">addColumn()</p>
                        <p class="fs-14 cursor-pointer fw-normal text--iris">addError()</p>
                        <p class="fs-14 cursor-pointer fw-normal text--iris">addErrorToBase()</p>
                        <p class="fs-14 cursor-pointer fw-normal text--iris">addForeignKey()</p>
                    </div>
                </div>
            </div>
            <div id="sectionContainer" class="col-lg-3 col-12 d-none order-lg-0 order-first">
                <div class="bg-white p-3 rounded-18 no-scrollbar h-70vh overflow-y-auto">
                    <div class="accordion" id="guidesAccordion">
                        <div class="accordion-item bg-transparent border-0">
                            <div class="accordion-header section pe-2 text-white">
                                <button class="accordion-button fs-14 fw-normal shadow-none p-2 rounded-3 text--iris" style="background-color: rgba(179, 179, 179, 0.12);"
                                    type="button" data-bs-toggle="collapse" data-bs-target="#introduction"
                                    aria-expanded="true" aria-controls="introduction">
                                    Configuration
                                </button>
                            </div>
                            <div id="introduction" class="accordion-collapse collapse show"
                                data-bs-parent="#guidesAccordion">
                                <div class="accordion-body pb-0 space-y-3 pt-3 px-0 position-relative">
                                    <div class="space-y-3 ps-4">
                                        <p class="fs-14 fw-normal cursor-pointer text--iris">Miscellanious Functions</p>
                                        <p class="fs-14 fw-normal cursor-pointer text--iris">Routing</p>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</main>