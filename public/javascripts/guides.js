document.addEventListener('DOMContentLoaded', function () {
    let lunrIndex = null;
    let lunrDocs = [];

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
        const modal = bootstrap.Modal.getInstance(document.getElementById("searchModal"));
        if (modal) modal.hide();
    }
    if (e.detail.requestConfig) {
        history.pushState({}, "", e.detail.requestConfig.path);
        updateCategoryActive();
    }
});

document.body.addEventListener("htmx:afterSwap", function (e) {
    // Only proceed if we're loading the search index
    if (e.target.id === "searchIndexHolder") {
        try {
            lunrDocs = JSON.parse(e.target.innerText);

            // Build lunr index
            lunrIndex = lunr(function () {
                this.ref("url");
                this.field("title");
                this.field("body");
                lunrDocs.forEach(doc => this.add(doc));
            });
        } catch (err) {
            console.error("Failed to parse search index:", err);
        }
    }
});

document.getElementById("searchDocs").addEventListener("input", function (e) {
    const loader = document.getElementById("search-loader");
    const resultsContainer = document.getElementById("result");

    // Clear previous results and show loader
    resultsContainer.innerHTML = "";
    loader.style.display = "block";

    const query = e.target.value;

    if (!lunrIndex || query.length === 0) {
        loader.style.display = "none";
        return;
    }

    // Small timeout to simulate processing time (optional)
    setTimeout(() => {
        const results = lunrIndex.search(query);

        if (results.length === 0) {
            resultsContainer.innerHTML = `<p class="text-muted">No results found.</p>`;
        } else {
            resultsContainer.innerHTML = renderSearchResults(results, lunrDocs, query);
            htmx.process(resultsContainer);
        }

        loader.style.display = "none";
    }, 1000); // small delay for better UX feel
});

const highlightMatch = (text, query) => {
    const regex = new RegExp(`(${query})`, 'gi');
    return text.replace(regex, '<mark>$1</mark>');
};
  
const renderSearchResults = (results, docs, query) => {
    return results.map(r => {
        const doc = docs.find(d => d.url === r.ref);
        if (!doc) return "";
        const version = "3.0.0-SNAPSHOT";
        return `
        <a hx-get="${doc.url}" hx-swap="innerHTML" hx-trigger="click" hx-target="#main" hx-push-url="true" class="text-decoration-none text-dark result-item d-block px-3 py-2 border-bottom">
            <div class="d-flex align-items-center justify-content-between">
            <div class="d-flex align-items-start gap-2">
                <i class="bi bi-file-earmark-text text-muted bold mt-3"></i>
                <div>
                <small class="text-muted">${version}</small>
                <div class="fw-semibold">${highlightMatch(doc.title, query)}</div>
                <div class="small text-muted">${highlightMatch(doc.body.slice(0, 100), query)}...</div>
                </div>
            </div>
            <i class="bi bi-chevron-right text-muted align-self-center"></i>
            </div>
        </a>
        `;
    }).join("");
};

const updateCategoryActive = () => {
    const currentPath = window.location.pathname;
    const buttons = document.querySelectorAll('.category');
    let activeButton = null;
    buttons.forEach(btn => {
        const hxGet = btn.getAttribute('hx-get');
        if (hxGet === currentPath) {
            btn.classList.add('active');
            activeButton = btn;
        } else {
            btn.classList.remove('active');
        }
    });

    // Collapse everything by default
    document.querySelectorAll('.accordion-collapse').forEach(c => c.classList.remove('show'));
    document.querySelectorAll('.accordion-button').forEach(b => b.classList.add('collapsed'));

    if (activeButton) {
        // Start from the current .category button and walk up to all parents
        let currentElement = activeButton;

        while (currentElement) {
            // Find closest accordion-collapse and open it
            const collapse = currentElement.closest('.accordion-collapse');
            if (collapse) {
                collapse.classList.add('show');

                // Find the related .accordion-button and expand it
                const header = collapse.previousElementSibling;
                if (header) {
                    const btn = header.querySelector('.accordion-button');
                    if (btn) {
                        btn.classList.remove('collapsed');
                        btn.classList.add('active'); // optional: for visual active state
                    }
                }

                // Move up: set currentElement to the parent of the collapse
                currentElement = collapse.closest('.accordion-item');
            } else {
                break;
            }
        }
    }
};
