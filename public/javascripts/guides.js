document.addEventListener('DOMContentLoaded', function () {
    let lunrIndex = null;
    let lunrDocs = [];

    const urlParams = new URLSearchParams(window.location.search);
    const filePath = urlParams.get("filePath");

    if (filePath){
        // Find the matching sidebar link
        const matchingLink = document.querySelector(`.category[hx-get="/guides/${filePath}"]`);
        // 1. Remove existing active states and open accordions
        document.querySelectorAll(".category").forEach(link => {
            link.classList.remove("active");
        });
    
        if (matchingLink) {
            // Add active styling
            matchingLink.classList.add("active"); // Add your active class name here
    
            // 3. If this is inside a button (subparent with path), expand its button too
                const linkButton = matchingLink.closest("button.accordion-button");
                if (linkButton) {
                    const collapseId = linkButton.getAttribute("data-bs-target");
                    const targetCollapse = document.querySelector(collapseId);
                    if (targetCollapse) {
                        targetCollapse.classList.add("show");
                    }
                    linkButton.classList.remove("collapsed");
                    linkButton.setAttribute("aria-expanded", "true");
                }

                // 4. Expand all ancestor accordion-collapse blocks
                let parentCollapse = matchingLink.closest(".accordion-collapse");
                while (parentCollapse) {
                    parentCollapse.classList.add("show");

                    const parentCollapseId = parentCollapse.id;
                    const parentButton = document.querySelector(`button[data-bs-target="#${parentCollapseId}"]`);
                    if (parentButton) {
                        parentButton.classList.remove("collapsed");
                        parentButton.setAttribute("aria-expanded", "true");
                    }

                    parentCollapse = parentCollapse.parentElement.closest(".accordion-collapse");
                }
            // 3. Replace URL to clean format
            const cleanUrl = `/guides/${filePath}`;
            window.history.replaceState({}, "", cleanUrl);
        }
    }

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
    convertGitBookCodeBlocks(guidesContent);
    convertMarkdownTablesInParagraphs(guidesContent);
    updateBreadcrumbFromSidebar();
});
window.addEventListener("load", () => {
    setTimeout(() => {
        const loader = document.getElementById("globalPageLoader");
        if (loader) loader.classList.add("d-none"); // Hide loader
    }, 300);
});

document.body.addEventListener('htmx:beforeSwap', function (e) {
    // Only process if response is HTML and target exists
    if (e.detail.xhr && e.detail.target && e.detail.xhr.responseType !== 'json') {
        const tempDiv = document.createElement('div');
        tempDiv.innerHTML = e.detail.xhr.responseText;

        const guidesContent = tempDiv.querySelector('.guides-docs-content');
        if (!guidesContent) return;

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
        convertGitBookCodeBlocks(guidesContent);
        convertMarkdownTablesInParagraphs(guidesContent);
        // Replace the response with modified HTML
        e.detail.xhr.responseText = tempDiv.innerHTML;
        e.detail.shouldSwap = true;
        e.detail.target.innerHTML = tempDiv.innerHTML;

        // Prevent default swap
        e.preventDefault();
        const modal = bootstrap.Modal.getInstance(document.getElementById("searchModal"));
        document.getElementById("searchDocs").value="";
        document.getElementById("result").innerHTML=`
        <div class="d-flex justify-content-center align-content-center align-items-baseline">
            <i class="bi bi-search-heart text--primary"> Search...</i>
        </div>`;
        if (modal) modal.hide();
    }
    if (e.detail.requestConfig) {
        history.pushState({}, "", e.detail.requestConfig.path);
        updateCategoryActive();
        updateBreadcrumbFromSidebar();
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
        <a hx-get="${doc.url}" hx-swap="innerHTML" hx-trigger="click" hx-target="#main" hx-push-url="true" class="text-decoration-none text-dark cursor-pointer result-item d-block px-3 py-2 border-bottom">
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

    let skipCollapseRoot = null;

    if (activeButton) {
        // Check if activeButton is a subparent (i.e., it has child accordion inside)
        const parentAccordionItem = activeButton.closest('.accordion-item');
        if (parentAccordionItem && parentAccordionItem.querySelector('.accordion-collapse .category')) {
            skipCollapseRoot = parentAccordionItem;
        }
    }

    // Collapse everything except the subtree of the active subparent
    document.querySelectorAll('.accordion-collapse').forEach(collapse => {
        if (!skipCollapseRoot || !skipCollapseRoot.contains(collapse)) {
            collapse.classList.remove('show');
        }
    });
    document.querySelectorAll('.accordion-button').forEach(button => {
        if (!skipCollapseRoot || !skipCollapseRoot.contains(button)) {
            button.classList.add('collapsed');
        }
    });

    if (activeButton) {
        // Walk upwards and open all parents
        let currentElement = activeButton;

        while (currentElement) {
            const collapse = currentElement.closest('.accordion-collapse');
            if (collapse) {
                collapse.classList.add('show');

                const header = collapse.previousElementSibling;
                if (header) {
                    const btn = header.querySelector('.accordion-button');
                    if (btn) {
                        btn.classList.remove('collapsed');
                        btn.classList.add('active');
                        btn.setAttribute('data-breadcrumb', activeButton.getAttribute('data-breadcrumb'));
                    }
                }

                currentElement = collapse.closest('.accordion-item');
            } else {
                break;
            }
        }
    }
};

function convertGitBookCodeBlocks(container) {
    const paragraphs = Array.from(container.querySelectorAll('p'));

    paragraphs.forEach(p => {
        const rawHTML = p.innerHTML;
        const regex = /\{\%\s*code\s+title=["']?(.+?)["']?\s*\%\}/;
        const match = rawHTML.match(regex);

        if (match) {
            let title = match[1].trim();
            if ((title.startsWith('"') && title.endsWith('"')) || (title.startsWith("'") && title.endsWith("'"))) {
                title = title.slice(1, -1).trim();
            }
            const prefixText = rawHTML.split(match[0])[0].trim(); // Any text before the {% code ... %}

            const pre = p.nextElementSibling;
            const endP = pre?.nextElementSibling;

            if (pre?.tagName === "PRE" && endP?.textContent.trim() === "{% endcode %}") {
                const code = pre.outerHTML;

                const block = document.createElement("div");
                block.className = "gitbook-code-block";

                block.innerHTML = `
                    ${prefixText ? `<p>${prefixText}</p>` : ""}
                    ${title ? `<div class="gitbook-code-header">${title}</div>` : ""}
                    ${code}
                `;

                endP.remove();
                pre.remove();
                p.replaceWith(block);
            }
        }
    });
}

function convertMarkdownTablesInParagraphs(container = document) {
    const paragraphs = container.querySelectorAll("p");

    paragraphs.forEach(p => {
        const text = p.textContent.trim();

        if (text.startsWith("|") && text.includes("|")) {
            const lines = text.split("\n").filter(line => line.trim().startsWith("|"));

            if (lines.length >= 2) {
                const table = document.createElement("table");
                table.classList.add("custom-table");

                lines.forEach((line, index) => {
                    if (index === 1) return; // Skip alignment row

                    const tr = document.createElement("tr");
                    const cells = line.split("|").slice(1, -1).map(cell => cell.trim());

                    cells.forEach(cellText => {
                        const cell = document.createElement(index === 0 ? "th" : "td");
                        cell.textContent = cellText;
                        tr.appendChild(cell);
                    });

                    table.appendChild(tr);
                });

                p.replaceWith(table);
            }
        }
    });
}

function updateBreadcrumbFromSidebar() {
    const activeLink = document.querySelector('.category.active, .accordion-button.active');
    const breadcrumbText = activeLink?.getAttribute('data-breadcrumb');
    if (breadcrumbText) {
        const breadcrumbContainer = document.getElementById("breadcrumb-nav");
        if (breadcrumbContainer) {
            breadcrumbContainer.innerHTML = breadcrumbText
                .split(" > ")
                .map((item, index, arr) => {
                    return `<span class="text--secondary small">${item}</span>`;
                })
                .join(` <i class="bi bi-chevron-right mx-1 text-muted small"></i>`);
        }
    }
}