<main class="main-bg">
    <div class="container py-5">
        <a href="/api" class="py-2 px-3 bg-white shadow-sm rounded-3">
            <i class="bi bi-arrow-left"></i>
            <span class="fs-14 text--secondary">
                Back
            </span>
        </a>

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
                    <button
                        class="text--lightGray border d-flex align-items-center gap-2 rounded-4 fs-14 fw-normal px-3 py-2 bg-transparent">
                        <i class="bi bi-tags"></i>
                        Modal Configuration
                    </button>
                    <button
                        class="text--lightGray border d-flex align-items-center gap-2 rounded-4 fs-14 fw-normal px-3 py-2 bg-transparent">
                        <i class="bi bi-tags"></i>
                        Miscellanious Function
                    </button>
                    <button
                        class="text--lightGray border d-flex align-items-center gap-2 rounded-4 fs-14 fw-normal px-3 py-2 bg-transparent">
                        <i class="bi bi-arrow-return-left"></i>
                        Void
                    </button>
                    <button
                        class="text--lightGray border d-flex align-items-center gap-2 rounded-4 fs-14 fw-normal px-3 py-2 bg-transparent">
                        <i class="bi bi-lightning-charge-fill"></i>
                        Model
                    </button>
                    <button
                        class="text--lightGray border d-flex align-items-center gap-2 rounded-4 fs-14 fw-normal px-3 py-2 bg-transparent">
                        <i class="bi bi-lightning-charge-fill"></i>
                        Controller
                    </button>
                    <button
                        class="text--lightGray border d-flex align-items-center gap-2 rounded-4 fs-14 fw-normal px-3 py-2 bg-transparent">
                        <i class="bi bi-lightning-charge-fill"></i>
                        test
                    </button>
                    <button
                        class="text--lightGray border d-flex align-items-center gap-2 rounded-4 fs-14 fw-normal px-3 py-2 bg-transparent">
                        <i class="bi bi-lightning-charge-fill"></i>
                        migrator
                    </button>
                    <button
                        class="text--lightGray border d-flex align-items-center gap-2 rounded-4 fs-14 fw-normal px-3 py-2 bg-transparent">
                        <i class="bi bi-lightning-charge-fill"></i>
                        migration
                    </button>
                    <button
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
</main>