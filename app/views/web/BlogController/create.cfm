<main class="main-blog">
    <div class="container py-5">
        <div class="row justify-content-center justify-content-lg-between">
            <div class="col-lg-8 col-12">
                <div class="bg-white rounded-5 shadow-sm mt-4 p-4">
                    <h1 class="text-center fs-24 fw-bold">Create</h1>
                    <form id="blogForm" hx-post="/blog/store" hx-target="body" hx-swap="outerHTML" hx-push-url="/blog" class="needs-validation" novalidate hx-validate="true" enctype="multipart/form-data">
                        <input class="form-control" type="hidden" name="id" id="id" value="">
    
                        <div class="mb-3">
                            <label class="form-label mb-1 fs-14 fw-medium">
                                Title <span class="text-danger">*</span>
                            </label>
                            <input placeholder="Enter the title" class="form-control fs-14" type="text" name="title" id="title" value="" maxlength="159" required>
                        </div>
    
                        <div class="mb-3">
                            <label class="form-label mb-1 fs-14 fw-medium">
                                Post Category <span class="text-danger">*</span>
                            </label>
                            <select class="form-select fs-14" name="categoryId" id="categoryId" required hx-get="/blog/loadCategories" hx-trigger="load" hx-target="#categoryId" hx-swap="innerHTML" multiple="multiple">
                                <option value="">Select Category</option>
                            </select>
                        </div>
    
                        <div class="mb-3">
                            <label class="form-label mb-1 fs-14 fw-medium">
                                Post Type <span class="text-danger">*</span>
                            </label>
                            <select class="form-control fs-14" name="posttypeId" id="posttypeId" required hx-get="/blog/loadPostTypes" hx-trigger="load" hx-target="#posttypeId" hx-swap="innerHTML">
                                <option value="">Select Post Type</option>
                            </select>
                        </div>
                        
                        <div class="mb-3">
                            <label class="form-label mb-1 fs-14 fw-medium">
                                Post Tags <span class="text-danger">*</span>
                            </label>
                            <div class="d-flex form-control p-0 flex-wrap gap-1" id="tagContainer">
                                <input type="text" onblur="document.getElementById('tagContainer').classList.remove('parent-focus'); this.classList.remove('shadow-none');" onfocus="document.getElementById('tagContainer').classList.add('parent-focus'); this.classList.add('shadow-none');" class="fs-14 border-0 form-control" id="tagInput" placeholder="Enter tags and press comma (,)">
                            </div>
                            <input type="hidden" name="postTags" id="postTags">
                        </div>
    
                        <div class="mb-3">
                            <label class="form-label mb-1 fs-14 fw-medium">
                                Post Create Date
                            </label>
                            <input class="form-control fs-14" type="date" name="postCreatedDate" id="postCreatedDate" value="">
                        </div>
    
                        <div class="mb-3">
                            <div id="toolbar-container" class="border-bottom-0 border rounded-top">
                                <span class="ql-formats m-lg-0 my-1 px-3 rounded py-1 border">
                                    <select class="ql-size"></select>
                                </span>
                                <span class="ql-formats m-lg-0 my-1 px-3 rounded py-1 border">
                                    <button class="ql-bold"></button>
                                    <button class="ql-italic"></button>
                                    <button class="ql-underline"></button>
                                    <button class="ql-strike"></button>
                                </span>
                                <span class="ql-formats m-lg-0 my-1 px-3 rounded py-1 border">
                                    <select class="ql-color"></select>
                                    <select class="ql-background"></select>
                                </span>
                                <span class="ql-formats m-lg-0 my-1 px-3 rounded py-1 border">
                                    <button class="ql-header" value="1"></button>
                                    <button class="ql-header" value="2"></button>
                                    <button class="ql-header" value="3"></button>
                                    <button class="ql-blockquote"></button>
                                    <button class="ql-code-block"></button>
                                </span>
                                <span class="ql-formats m-lg-0 my-1 px-3 rounded py-1 border">
                                    <button class="ql-list" value="ordered"></button>
                                    <button class="ql-list" value="bullet"></button>
                                    <button class="ql-indent" value="-1"></button>
                                    <button class="ql-indent" value="+1"></button>
                                </span>
                                <span class="ql-formats m-lg-0 my-1 px-3 rounded py-1 border">
                                    <button class="ql-direction" value="rtl"></button>
                                    <select class="ql-align"></select>
                                </span>
                                <span class="ql-formats m-lg-0 my-1 px-3 rounded py-1 border">
                                    <button class="ql-link"></button>
                                    <button class="ql-image"></button>
                                    <button class="ql-video"></button>
                                    <button class="ql-formula"></button>
                                </span>
                                <span class="ql-formats m-lg-0 my-1 px-3 rounded py-1 border">
                                    <button class="ql-clean"></button>
                                </span>
                            </div>
                            <div class="form-control border border-top-0 rounded-top-0" id="editor" style="height: 300px;"></div>
                            <input class="form-control" type="hidden" name="content" id="content">
                        </div>
    
                        <input type="hidden" name="isDraft" id="isDraft" value="0">
                        <div class="text-end">
                            <button type="button" class="btn btn-outline-secondary px-3 py-2 rounded fs-14" id="saveDraftBtn">
                                Save as Draft
                            </button>
                            <button type="submit" class="bg--secondary btn--secondary text-white px-3 py-2 rounded fs-14">Submit</button>
                        </div>
                    </form>
                    <div id="message"></div>
                </div>
            </div>
            <div class="col-lg-4 col-12">
                <h4 class="mb-3">Live Preview</h4>
                <div id="previewContent" class="p-3 border rounded bg-white">
                    <h2 id="previewTitle" class="fs-20 fw-bold mb-3 text-primary"></h2>
                    <div id="previewMeta" class="mb-3">
                        <div id="previewCategories" class="mb-1"></div>
                        <div id="previewTags"></div>
                    </div>
                    <div id="previewBody" class="border p-3 rounded bg-light"></div>
                </div>
            </div>
        </div>
    </div>

    <script>
        const quill = new Quill('#editor', {
            modules: {
            syntax: true,
            toolbar: '#toolbar-container',
            },
            placeholder: 'Compose an epic...',
            theme: 'snow',
        });

        function syncQuillContent() {
            document.getElementById('content').value = quill.root.innerHTML.trim();
        }

        document.getElementById("saveDraftBtn").addEventListener("click", function () {
            document.getElementById("isDraft").value = "1"; // Set draft flag
            document.getElementById("blogForm").requestSubmit(); // Trigger form submission
        });

        document.getElementById('blogForm').addEventListener("submit", function (event) {
            syncQuillContent();

            var isValid = true;
            const title = document.getElementById('title');
            const categoryId = document.getElementById('categoryId');
            const posttypeId = document.getElementById('posttypeId');
            const postTags = document.getElementById('postTags');
            const content = document.getElementById('content');
            const editor = document.getElementById("editor");

            // Check if it's a draft submission
            const isDraft = document.getElementById("isDraft").value === "1";

            // Reset validation styles
            [title, categoryId, posttypeId, postTags].forEach(field => field.classList.remove("is-invalid"));
            editor.classList.remove("border-danger");

            // Validate fields only if it's NOT a draft
            if (!isDraft) {
                if (title.value.trim() === "") {
                    isValid = false;
                    title.classList.add("is-invalid");
                }
                if (categoryId.value.trim() === "") {
                    isValid = false;
                    categoryId.classList.add("is-invalid");
                }
                if (posttypeId.value.trim() === "") {
                    isValid = false;
                    posttypeId.classList.add("is-invalid");
                }
                if (postTags.value.trim() === "") {
                    isValid = false;
                    postTags.classList.add("is-invalid");
                }
                if (content.value.trim() === "<p><br></p>" || content.value.trim() === "") {
                    isValid = false;
                    editor.classList.add("border-danger");
                }
            }

            if (!isValid) {
                event.preventDefault();
                alert("Please fill out all required fields.");
                return false;
            }
        });     

        document.addEventListener("htmx:afterSwap", function(evt) {
            if (evt.target.id === "categoryId") {
                $('#categoryId').select2({
                    placeholder: "Select Categories",
                    theme: "bootstrap-5",
                    width: $(this).data('width') ? $(this).data('width') : $(this).hasClass('w-100') ? '100%' : '100%',
                    maximumSelectionLength: 5 // Limit to 5 categories
                });
            }
        });

        $(document).ready(function () {
            $('#categoryId').select2({
                    placeholder: "Select Categories",
                    theme: "bootstrap-5",
                    width: $(this).data('width') ? $(this).data('width') : $(this).hasClass('w-100') ? '100%' : '100%',
                    maximumSelectionLength: 5 // Limit to 5 categories
            });

            const tagContainer = document.getElementById("tagContainer");
            const tagInput = document.getElementById("tagInput");
            const postTags = document.getElementById("postTags");
            let tags = [];

            tagInput.addEventListener("keydown", function (event) {
                if ((event.key === "," || event.key === "Enter") && tags.length < 5) {
                    event.preventDefault();
                    let tagText = tagInput.value.trim().replace(/,/g, ""); // Remove any commas
                    if (tagText !== "" && !tags.includes(tagText)) {
                        tags.push(tagText);
                        addTag(tagText);
                        updateHiddenTags();
                        tagInput.value = "";
                    }
                } else if (tags.length >= 5) {
                    event.preventDefault();
                }
            });

            function addTag(tagText) {
                const tagElement = document.createElement("span");
                tagElement.classList.add("tag","cursor-pointer");
                tagElement.innerHTML = `${tagText} <span class="remove-tag"></span>`;
                
                tagElement.querySelector(".remove-tag").addEventListener("click", function () {
                    removeTag(tagText);
                });

                tagContainer.insertBefore(tagElement, tagInput);
            }

            function removeTag(tagText) {
                tags = tags.filter(tag => tag !== tagText);
                updateHiddenTags();
                renderTags();
            }

            function renderTags() {
                tagContainer.querySelectorAll(".tag").forEach(tag => tag.remove());
                tags.forEach(tag => addTag(tag));
            }

            function updateHiddenTags() {
                postTags.value = tags.join(",");
            }
            
            // Live preview logic
            function updatePreview() {
                // Title
                const title = document.getElementById("title").value;
                document.getElementById("previewTitle").innerText = title;

                // Content
                document.getElementById("previewBody").innerHTML = quill.root.innerHTML.trim();

                // Categories
                const categorySelect = document.getElementById("categoryId");
                const selectedCategories = Array.from(categorySelect.selectedOptions).map(opt => opt.text);
                const previewCategories = document.getElementById("previewCategories");
                previewCategories.innerHTML = '';
                selectedCategories.forEach(cat => {
                    const badge = document.createElement("span");
                    badge.className = "badge bg-primary me-1 mb-1";
                    badge.textContent = cat;
                    previewCategories.appendChild(badge);
                });

                // Tags
                const previewTags = document.getElementById("previewTags");
                previewTags.innerHTML = '';
                tags.forEach(tag => {
                    const badge = document.createElement("span");
                    badge.className = "badge bg-secondary me-1 mb-1";
                    badge.textContent = tag;
                    previewTags.appendChild(badge);
                });
            }

            // Event listeners
            document.getElementById("title").addEventListener("input", updatePreview);
            document.getElementById("categoryId").addEventListener("change", updatePreview);
            quill.on('text-change', updatePreview);
        });
    </script>
</main>