<main class="main-blog">
<cfoutput>
    <div class="container py-5">
        <div class="row justify-content-center justify-content-lg-between">
            <div class="col-lg-8 col-12">
                <div class="bg-white rounded-5 shadow-sm mt-4 p-4">
                    <h1 class="text-center fs-24 fw-bold">#isEdit ? 'Edit' : 'Create'# Blog Post</h1>
                    <cfif isEdit>
                        <div id="editLoader" class="position-fixed top-50 start-50 translate-middle" style="display: none; z-index: 9999;">
                            <div class="spinner-border text-primary" role="status">
                                <span class="visually-hidden">Saving...</span>
                            </div>
                        </div>
                    </cfif>
                    <form id="blogForm" hx-post="#isEdit ? '/blog/update/#blog.id#' : '/blog/store'#" hx-target="body" hx-swap="outerHTML" hx-push-url="/blog" class="needs-validation" novalidate hx-validate="true" enctype="multipart/form-data" onsubmit="document.getElementById('editLoader').style.display = 'block';">
                        <input type="hidden" name="_method" value="#isEdit ? 'PUT' : 'POST'#">
                        <input class="form-control" type="hidden" name="id" id="id" value="#isEdit ? blog.id : ''#">
    
                        <div class="mb-3">
                            <label class="form-label mb-1 fs-14 fw-medium">
                                Title <span class="text-danger">*</span>
                            </label>
                            <input placeholder="Enter the title" class="form-control fs-14" type="text" name="title" id="title" value="#isEdit ? blog.title : ''#" maxlength="159" required>
                            <small id="title-message" class="text-muted mt-1 d-block fs-13"></small>
                            <input type="hidden" id="titleExists" name="titleExists" value="0">
                        </div>
    
                        <div class="mb-3">
                            <label class="form-label mb-1 fs-14 fw-medium">
                                Post Category <span class="text-danger">*</span>
                            </label>
                            <select class="form-select fs-14" name="categoryId" id="categoryId" required multiple="multiple">
                                <option value="">Select Category</option>
                                <cfif isEdit>
                                    <cfloop query="categories">
                                        <option value="#categories.id#" <cfif arrayFind(blog.categories, categories.id)>selected</cfif>>#categories.name#</option>
                                    </cfloop>
                                <cfelse>
                                    <option value="" disabled>Loading categories...</option>
                                </cfif>
                            </select>
                        </div>
    
                        <div class="mb-3">
                            <label class="form-label mb-1 fs-14 fw-medium">
                                Post Type <span class="text-danger">*</span>
                            </label>
                            <select class="form-control fs-14" name="posttypeId" id="posttypeId" required>
                                <option value="">Select Post Type</option>
                                <cfif isEdit>
                                    <cfloop query="postTypes">
                                        <option value="#postTypes.id#" <cfif blog.posttypeId EQ postTypes.id>selected</cfif>>#postTypes.name#</option>
                                    </cfloop>
                                <cfelse>
                                    <option value="" disabled>Loading post types...</option>
                                </cfif>
                            </select>
                        </div>
                        
                        <div class="mb-3">
                            <label class="form-label mb-1 fs-14 fw-medium">
                                Post Tags <span class="text-danger">*</span>
                            </label>
                            <div class="d-flex form-control p-0 flex-wrap gap-1" id="tagContainer">
                                <input type="text" onblur="document.getElementById('tagContainer').classList.remove('parent-focus'); this.classList.remove('shadow-none');" onfocus="document.getElementById('tagContainer').classList.add('parent-focus'); this.classList.add('shadow-none');" class="fs-14 border-0 form-control" id="tagInput" placeholder="Enter tags and press comma (,)" value="<cfif isEdit>#blog.tags#</cfif>">
                            </div>
                            <input type="hidden" name="postTags" id="postTags" value="<cfif isEdit>#blog.tags#</cfif>">
                        </div>
    
                        <div class="mb-3">
                            <label class="form-label mb-1 fs-14 fw-medium">
                                Post Create Date
                            </label>
                            <input class="form-control fs-14" type="date" name="postCreatedDate" id="postCreatedDate" value="<cfif isEdit>#dateFormat(blog.postCreatedDate, 'yyyy-mm-dd')#</cfif>">
                        </div>
    
                        <div class="mb-3">
                            <div id="toolbar-container" class="border-bottom-0 border rounded-top">
                                <span class="ql-formats my-1 px-1 me-1 rounded py-1 border">
                                    <select class="ql-size"></select>
                                </span>
                                <span class="ql-formats my-1 px-1 me-1 rounded py-1 border">
                                    <button class="ql-bold"></button>
                                    <button class="ql-italic"></button>
                                    <button class="ql-underline"></button>
                                    <button class="ql-strike"></button>
                                </span>
                                <span class="ql-formats my-1 px-1 me-1 rounded py-1 border">
                                    <select class="ql-color"></select>
                                    <select class="ql-background"></select>
                                </span>
                                <span class="ql-formats my-1 px-1 me-1 rounded py-1 border">
                                    <button class="ql-header" value="1"></button>
                                    <button class="ql-header" value="2"></button>
                                    <button class="ql-header" value="3"></button>
                                    <button class="ql-blockquote"></button>
                                    <button class="ql-code-block"></button>
                                </span>
                                <span class="ql-formats my-1 px-1 me-1 rounded py-1 border">
                                    <button class="ql-list" value="ordered"></button>
                                    <button class="ql-list" value="bullet"></button>
                                    <button class="ql-indent" value="-1"></button>
                                    <button class="ql-indent" value="+1"></button>
                                </span>
                                <span class="ql-formats my-1 px-1 me-1 rounded py-1 border">
                                    <button class="ql-direction" value="rtl"></button>
                                    <select class="ql-align"></select>
                                </span>
                                <span class="ql-formats my-1 px-1 me-1 rounded py-1 border">
                                    <button class="ql-link"></button>
                                    <button class="ql-image"></button>
                                    <button class="ql-video"></button>
                                    <button class="ql-formula"></button>
                                </span>
                                <span class="ql-formats my-1 px-1 me-1 rounded py-1 border">
                                    <button class="ql-clean"></button>
                                </span>
                            </div>
                            <div class="form-control border border-top-0 rounded-top-0" id="editor" style="height: 300px;"><cfif isEdit>#blog.content#</cfif></div>
                            <input class="form-control" type="hidden" name="content" id="content" value="<cfif isEdit>#htmlEditFormat(blog.content)#</cfif>">
                        </div>
    
                        <input type="hidden" name="isDraft" id="isDraft" value="0">
                        <div class="text-end">
                            <button type="button" class="btn btn-outline-dark px-3 py-2 rounded fs-14" id="saveDraftBtn">
                                Save as Draft
                            </button>
                            <button type="submit" class="bg--primary btn--secondary text-white px-3 py-2 rounded fs-14">Submit</button>
                        </div>
                    </form>
                    <div id="message"></div>
                </div>
            </div>
            <div class="col-lg-4 col-12">
                <h4 class="mb-3">Live Preview</h4>
                <div id="previewContent" class="p-3 border rounded bg-white">
                    <h2 id="previewTitle" class="fs-20 fw-bold mb-3"></h2>
                    <div id="previewMeta" class="mb-3">
                        <div id="previewCategories" class="mb-1"></div>
                        <div id="previewTags"></div>
                    </div>
                    <div id="previewBody" class="border p-3 rounded bg-light"></div>
                </div>
            </div>
        </div>
    </div>
</cfoutput>
    <script>
        document.addEventListener('DOMContentLoaded', function() {
        // Initialize Quill editor
        const quill = new Quill('#editor', {
            modules: {
                syntax: true,
                toolbar: '#toolbar-container',
            },
            placeholder: 'Compose an epic...',
            theme: 'snow',
        });

        // Load existing content if in edit mode
        const contentField = document.getElementById('content');
        if (contentField && contentField.value.trim()) {
            quill.clipboard.dangerouslyPasteHTML(contentField.value);
        }
        
        function syncQuillContent() {
            document.getElementById('content').value = quill.root.innerHTML.trim();
        }

        // Handle draft saving
        document.getElementById("saveDraftBtn").addEventListener("click", function () {
            document.getElementById("isDraft").value = "1"; // Set draft flag
            document.getElementById("blogForm").requestSubmit(); // Trigger form submission
        });

        // Form validation
        document.getElementById('blogForm').addEventListener("submit", function (event) {
            syncQuillContent();

            var isValid = true;
            const title = document.getElementById('title');
            const categoryId = document.getElementById('categoryId');
            const posttypeId = document.getElementById('posttypeId');
            const postTags = document.getElementById('postTags');
            const content = document.getElementById('content');
            const editor = document.getElementById("editor");
            const tagInput = document.getElementById("tagInput");
            const toolbar = document.getElementById('toolbar-container');

            // Check if it's a draft submission
            const isDraft = document.getElementById("isDraft").value === "1";

            // Reset validation styles
            [title, categoryId, posttypeId, tagInput].forEach(field => field.classList.remove("is-invalid"));
            toolbar.classList.remove("border-danger");
            editor.classList.remove("border-danger");

            // Title uniqueness check
            const titleExists = document.getElementById('titleExists');
            if (titleExists && titleExists.value === "1") {
                isValid = false;
                title.classList.add("is-invalid");
            }
            
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
                    tagInput.classList.add("is-invalid");
                    tagInput.classList.remove("border-0");
                }
                if (content.value.trim() === "<p><br></p>" || content.value.trim() === "") {
                    isValid = false;
                    toolbar.classList.add("border-danger");
                    editor.classList.add("border-danger");
                }
            }

            if (!isValid) {
                event.preventDefault();
                notifier.show('Error!', 'Please fill out all required fields.', '', 'images/high_priority-48.png', 4000);
                return false;
            }
        });     

        // Select2 initialization after HTMX swap
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

        // Initialize Select2
        $('#categoryId').select2({
            placeholder: "Select Categories",
            theme: "bootstrap-5",
            width: $(this).data('width') ? $(this).data('width') : $(this).hasClass('w-100') ? '100%' : '100%',
            maximumSelectionLength: 5 // Limit to 5 categories
        });

        // Tags handling
        const tagContainer = document.getElementById("tagContainer");
        const tagInput = document.getElementById("tagInput");
        const postTags = document.getElementById("postTags");
        let tags = [];

        // Initialize tags from hidden field
        if (postTags.value) {
            tags = postTags.value.split(',');
            renderTags();
        }

        tagInput.addEventListener("keydown", function (event) {
            if ((event.key === "," || event.key === "Enter") && tags.length < 5) {
                event.preventDefault();
                let tagText = tagInput.value.trim().replace(/,/g, ""); // Remove any commas
                if (tagText !== "" && !tags.includes(tagText)) {
                    tags.push(tagText);
                    addTag(tagText);
                    updateHiddenTags();
                    tagInput.value = "";
                    updatePreview(); // Update preview when tag is added
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
                updatePreview(); // Update preview when tag is removed
            });

            tagContainer.insertBefore(tagElement, tagInput);
        }

        function removeTag(tagText) {
            tags = tags.filter(tag => tag !== tagText);
            updateHiddenTags();
            renderTags();
        }

        function renderTags() {
            // Remove existing tags
            tagContainer.querySelectorAll(".tag").forEach(tag => tag.remove());
            // Add all tags from the array
            tags.forEach(tag => addTag(tag));
        }

        function updateHiddenTags() {
            postTags.value = tags.join(",");
        }
        
        // Live preview logic
        function updatePreview() {
            // Title
            const title = document.getElementById("title").value;
            document.getElementById("previewTitle").innerText = title || "Blog Title Preview";

            // Content
            document.getElementById("previewBody").innerHTML = quill.root.innerHTML.trim() || "<p>Your blog content will appear here...</p>";

            // Categories
            const categorySelect = document.getElementById("categoryId");
            const selectedCategories = Array.from(categorySelect.selectedOptions).map(opt => opt.text);
            const previewCategories = document.getElementById("previewCategories");
            previewCategories.innerHTML = '';
            
            if (selectedCategories.length > 0) {
                selectedCategories.forEach(cat => {
                    if (cat !== "Select Category") {
                        const badge = document.createElement("span");
                        badge.className = "badge bg-primary me-1 mb-1";
                        badge.textContent = cat;
                        previewCategories.appendChild(badge);
                    }
                });
            } else {
                previewCategories.innerHTML = '<span class="text-muted fs-13">No categories selected</span>';
            }

            // Tags
            const previewTags = document.getElementById("previewTags");
            previewTags.innerHTML = '';
            
            if (tags.length > 0) {
                tags.forEach(tag => {
                    const badge = document.createElement("span");
                    badge.className = "badge bg-secondary me-1 mb-1";
                    badge.textContent = tag;
                    previewTags.appendChild(badge);
                });
            } else {
                previewTags.innerHTML = '<span class="text-muted fs-13">No tags added</span>';
            }
        }

        // Initialize preview on page load
        updatePreview();

        // Event listeners for preview updates
        document.getElementById("title").addEventListener("input", updatePreview);
        document.getElementById("categoryId").addEventListener("change", updatePreview);
        quill.on('text-change', updatePreview);
        
        // Fix the check-title functionality to work with both POST and PUT methods
        const titleInput = document.getElementById('title');
        if (titleInput) {
            titleInput.addEventListener('blur', function() {
                const titleValue = this.value.trim();
                if (titleValue) {
                    // Get the current blog ID if in edit mode
                    const blogId = document.getElementById('id').value || '';
                    
                    // Create a FormData object to send with the request
                    const formData = new FormData();
                    formData.append('title', titleValue);
                    
                    // Include the ID for edit mode to exclude current post from duplicate check
                    if (blogId) {
                        formData.append('id', blogId);
                    }
                    
                    // Use fetch API instead of hx-post to have more control
                    fetch('/blog/check-title', {
                        method: 'POST',
                        body: formData
                    })
                    .then(response => response.text())
                    .then(data => {
                        document.getElementById('title-message').innerHTML = data;
                        
                        // After updating the DOM with the response, update validation state
                        const titleExists = document.getElementById('titleExists');
                        if (titleExists && titleExists.value === "1") {
                            titleInput.classList.add("is-invalid");
                        } else {
                            titleInput.classList.remove("is-invalid");
                        }
                    })
                    .catch(error => {
                        console.error('Error checking title:', error);
                        document.getElementById('title-message').innerHTML = '<span class="text-danger">Error checking title availability</span>';
                    });
                } else {
                    // Clear message if title is empty
                    document.getElementById('title-message').innerHTML = '';
                }
            });
        }
    });
    </script>
</main>