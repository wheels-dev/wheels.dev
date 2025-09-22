<main class="main">
    <div class="container py-5">
        <h1 class="text-center fw-bold fs-60">Install Wheels</h1>
        <p class="text--secondary fs-18 text-center fw-medium">This guide walks you through installing Wheels (both the software/library and its dependencies) on your operating system.</p>
        <div class="mt-3">
            <p class="mb-2">Follow the section for the operating system you use:</p>
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
                    </ul>
                    <p>Or <a href="https://github.com/cfwheels/cfwheels/releases/latest" target="_blank" class="link-danger">download the latest release</a> manually.</p>
                </div>
    
                <!--- Mac --->
                <div class="tab-pane fade" id="mac" role="tabpanel" aria-labelledby="mac-tab">
                    <h3>Install on Mac</h3>
                    <p>On macOS, you can install Wheels using Homebrew:</p>
                    <ul>
                    <li><strong>Homebrew:</strong> <code>brew install wheels</code></li>
                    </ul>
                    <p>You can also <a href="https://github.com/cfwheels/cfwheels/releases/latest" target="_blank" class="link-danger">download the package</a> directly for manual installation.</p>
                </div>
            </div>
        </div>
    </div>
</main>