document.addEventListener('DOMContentLoaded', function () {
    const searchTrigger = document.getElementById('searchTrigger');
    const searchModal = new bootstrap.Modal(document.getElementById('searchModal'));

    // Open modal on click
    if (searchTrigger) {
        searchTrigger.addEventListener('click', () => {
            searchModal.show();
            setTimeout(() => {
                document.getElementById('searchDocs').focus();
            }, 200); // Focus after modal animation
        });
    }

    // Open modal on Ctrl+K or Cmd+K
    document.addEventListener('keydown', function (e) {
        if ((e.ctrlKey || e.metaKey) && e.key.toLowerCase() === 'k') {
            e.preventDefault();
            searchModal.show();
            setTimeout(() => {
                document.getElementById('searchDocs').focus();
            }, 200);
        }
    });

    const buttons = document.querySelectorAll('.category');

    buttons.forEach(button => {
        button.addEventListener('click', function () {
            // Remove 'active' class from all buttons
            buttons.forEach(btn => btn.classList.remove('active'));

            // Add 'active' class to the clicked button
            this.classList.add('active');
        });
    });

    const contentImages = document.querySelectorAll('.guides-docs-content img');

    contentImages.forEach(img => {
        const src = img.getAttribute('src');
        if (src && src.startsWith('.gitbook')) {
            // Extract filename (after last slash)
            const filename = src.split('/').pop();
            img.setAttribute('src', `/img/${filename}`);
        }
    });

    // 3. Convert {% hint %} to Bootstrap alerts
    const guidesContent = document.querySelector('.guides-docs-content');
    if (guidesContent) {
        let html = guidesContent.innerHTML;

        html = html.replace(/{%\s*hint\s+style=["']?(\w+)["']?\s*%}/gi, function (match, style) {
            return `<div class="alert alert-${style}"> <i class="bi bi-info-circle"></i>`;
        });

        html = html.replace(/{%\s*endhint\s*%}/gi, '</div>');

        guidesContent.innerHTML = html;
    };

    const container = document.querySelector('.guides-docs-content');

    if (!container) return;

    let html = container.innerHTML;

    // Find all {% tabs %} ... {% endtabs %} blocks
    const tabBlockRegex = /{%\s*tabs\s*%}([\s\S]*?){%\s*endtabs\s*%}/gi;
    let tabIndex = 0;

    html = html.replace(tabBlockRegex, function (fullMatch, tabContent) {
        const tabTitleRegex = /{%\s*tab\s+title=["“”']?([^"“”']+)["“”']?\s*%}([\s\S]*?){%\s*endtab\s*%}/gi;

        let tabsHtml = `<ul class="nav nav-tabs" role="tablist">`;
        let contentHtml = `<div class="tab-content">`;

        let tabMatch, tabCounter = 0;

        while ((tabMatch = tabTitleRegex.exec(tabContent)) !== null) {
            const title = tabMatch[1].trim();
            const content = tabMatch[2].trim();

            const activeClass = tabCounter === 0 ? 'active' : '';
            const showClass = tabCounter === 0 ? 'show active' : '';

            const tabId = `tab-${tabIndex}-${tabCounter}`;

            tabsHtml += `<li class="nav-item">
                <a class="nav-link ${activeClass}" data-bs-toggle="tab" href="#${tabId}" role="tab">${title}</a>
            </li>`;

            contentHtml += `<div class="tab-pane fade ${showClass}" id="${tabId}" role="tabpanel">
                ${content}
            </div>`;

            tabCounter++;
        }

        tabsHtml += `</ul>`;
        contentHtml += `</div>`;

        tabIndex++;

        return `<div class="gitbooktabs border rounded-3 my-4 p-3">${tabsHtml}${contentHtml}</div>`;
    });

    container.innerHTML = html;


    const contentForDescription = document.querySelector(".guides-docs-content");
    if (!contentForDescription) return;

    // Find all child nodes
    const children = Array.from(contentForDescription.childNodes);

    // Find and process description-like heading (matches <h1>, <h2>, etc. starting with "description:")
    for (let i = 0; i < children.length; i++) {
        const node = children[i];
        if (
            node.nodeType === 1 &&
            /^H[1-6]$/.test(node.tagName) &&
            (node.textContent.trim().toLowerCase().startsWith("description:"))
        ) {
            // Extract text after "description:"
            let text = node.textContent.trim();
            text = text.replace(/^description:\s*/i, "");
            // Remove special YAML markers like ">-" or "|"
            text = text.replace(/^[-|>]+\s*/, "");

            const descriptionText = text.trim();
            
            // Create new paragraph element
            const p = document.createElement("p");
            p.className = "description";
            p.textContent = descriptionText;

            // Find first <h1> to insert after
            const firstH1 = contentForDescription.querySelector("h1");
            if (firstH1) {
                firstH1.insertAdjacentElement("afterend", p);
            } else {
                contentForDescription.insertBefore(p, contentForDescription.firstChild);
            }

            // Remove original description heading
            contentForDescription.removeChild(node);
            break;
        }
    }

    // Remove first <hr> if it's at the top
    const firstElement = contentForDescription.firstElementChild;
    if (firstElement && firstElement.tagName === "HR") {
        contentForDescription.removeChild(firstElement);
    }
});

document.body.addEventListener('htmx:beforeSwap', function (e) {
    // Only process if response is HTML and target exists
    if (e.detail.xhr && e.detail.target && e.detail.xhr.responseType !== 'json') {
        const tempDiv = document.createElement('div');
        tempDiv.innerHTML = e.detail.xhr.responseText;

        const guidesContent = tempDiv.querySelector('.guides-docs-content');
        if (!guidesContent) return;

        // Transform images
        const contentImages = guidesContent.querySelectorAll('img');
        contentImages.forEach(img => {
            const src = img.getAttribute('src');
            if (src && src.startsWith('.gitbook')) {
                const filename = src.split('/').pop();
                img.setAttribute('src', `/img/${filename}`);
            }
        });

        // Convert GitBook hints to alerts
        let html = guidesContent.innerHTML;
        html = html.replace(/{%\s*hint\s+style=["']?(\w+)["']?\s*%}/gi, (_, style) => {
            return `<div class="alert alert-${style}"> <i class="bi bi-info-circle"></i>`;
        });
        html = html.replace(/{%\s*endhint\s*%}/gi, '</div>');
        guidesContent.innerHTML = html;

        // Convert GitBook tabs to Bootstrap HTML
        const tabBlockRegex = /{%\s*tabs\s*%}([\s\S]*?){%\s*endtabs\s*%}/gi;
        let tabIndex = 0;
        guidesContent.innerHTML = guidesContent.innerHTML.replace(tabBlockRegex, function (fullMatch, tabContent) {
            const tabTitleRegex = /{%\s*tab\s+title=["“”']?([^"“”']+)["“”']?\s*%}([\s\S]*?){%\s*endtab\s*%}/gi;

            let tabsHtml = `<ul class="nav nav-tabs" role="tablist">`;
            let contentHtml = `<div class="tab-content">`;

            let tabMatch, tabCounter = 0;

            while ((tabMatch = tabTitleRegex.exec(tabContent)) !== null) {
                const title = tabMatch[1].trim();
                const content = tabMatch[2].trim();

                const activeClass = tabCounter === 0 ? 'active' : '';
                const showClass = tabCounter === 0 ? 'show active' : '';

                const tabId = `tab-${tabIndex}-${tabCounter}`;

                tabsHtml += `<li class="nav-item">
                    <a class="nav-link ${activeClass}" data-bs-toggle="tab" href="#${tabId}" role="tab">${title}</a>
                </li>`;

                contentHtml += `<div class="tab-pane fade ${showClass}" id="${tabId}" role="tabpanel">
                    ${content}
                </div>`;

                tabCounter++;
            }

            tabsHtml += `</ul>`;
            contentHtml += `</div>`;

            tabIndex++;

            return `<div class="border my-2 p-2">${tabsHtml}${contentHtml}</div>`;
        });

        // --- Handle description: move it after first <h1> and remove top <hr> ---
        const children = Array.from(guidesContent.childNodes);
        for (let i = 0; i < children.length; i++) {
            const node = children[i];
            if (
                node.nodeType === 1 &&
                /^H[1-6]$/.test(node.tagName) &&
                (node.textContent.trim().toLowerCase().startsWith("description:") || node.textContent.trim().toLowerCase().startsWith("description: >-"))
            ) {
                // const descriptionText = node.textContent.split(":").slice(1).join(":").trim();
                let text = node.textContent.trim();

                text = text.replace(/^description:\s*/i, "");
                text = text.replace(/^[-|>]+\s*/, "");

                const descriptionText = text.trim();

                const p = document.createElement("p");
                p.className = "description";
                p.textContent = descriptionText;

                const firstH1 = guidesContent.querySelector("h1");
                if (firstH1) {
                    firstH1.insertAdjacentElement("afterend", p);
                } else {
                    guidesContent.insertBefore(p, guidesContent.firstChild);
                }

                guidesContent.removeChild(node);
                break;
            }
        }

        const firstElement = guidesContent.firstElementChild;
        if (firstElement && firstElement.tagName === "HR") {
            guidesContent.removeChild(firstElement);
        }

        // Replace the response with modified HTML
        e.detail.xhr.responseText = tempDiv.innerHTML;
        e.detail.shouldSwap = true;
        e.detail.target.innerHTML = tempDiv.innerHTML;

        // Prevent default swap
        e.preventDefault();
    }
});
