<main class="main">
    <div class="container py-5">
        <h1 class="text-center fw-bold fs-60">Install Wheels</h1>
        <p class="text--secondary fs-18 text-center fw-medium">This page provides information on how to install Wheels on your operating system.</p>
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
                    <p>You can install Wheels by downloading our installer:</p>
                    <a href="https://github.com/wheels-dev/wheels/raw/develop/tools/installer/windows/installer/wheels-installer.exe" class="btn mt-2 bg--primary text-white py-2 px-2 rounded-8" download>
                        Download Wheels for Windows (.exe)
                    </a>
                    <p class="mt-2">After downloading, double-click the file and follow the installation steps.</p>
                    <p>Ensure your system meets the following requirements before installation:</p>
                    <ul>
                        <li><strong>Operating System:</strong> Windows 10 or 11 (64-bit)</li>
                        <li><strong>Disk Space:</strong> At least 100 MB of free space</li>
                    </ul>
                    <p><strong>Troubleshooting:</strong> If the installer fails, ensure you have administrative privileges and temporarily disable antivirus software during installation.</p>
                    <p><strong>Alternative Installation:</strong> You can <a href="https://github.com/cfwheels/cfwheels/releases/latest" target="_blank" class="link-danger">download the latest release</a> manually and extract it to your preferred directory.</p>
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