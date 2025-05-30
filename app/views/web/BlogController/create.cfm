<main class="main-blog">
<cfoutput>
    <div class="container py-5">
        <div class="row justify-content-center justify-content-lg-between">
            <div class="col-lg-12 col-12">
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
                            <input placeholder="Enter your article title" class="form-control fs-14" type="text" name="title" id="title" value="#isEdit ? blog.title : ''#" maxlength="160" required>
                            <small id="title-message" class="text-muted mt-1 d-block fs-13">Maximum 160 characters</small>
                            <input type="hidden" id="titleExists" name="titleExists" value="0">
                        </div>
    
                        <div class="mb-3">
                            <label class="form-label mb-1 fs-14 fw-medium">
                                Post Category <span class="text-danger">*</span>
                            </label>
                            <select class="form-select fs-14" name="categoryId" id="categoryId" required multiple="multiple">
                                <option value="">Select Categories</option>
                                <cfif isEdit>
                                    <cfloop query="categories">
                                        <option value="#categories.id#" <cfif arrayFind(blog.categories, categories.id)>selected</cfif>>#categories.name#</option>
                                    </cfloop>
                                <cfelse>
                                    <option value="" disabled>Loading categories...</option>
                                    <cfloop query="categories">
                                        <option value="#categories.id#">#categories.name#</option>
                                    </cfloop>
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
                                    <cfloop query="postTypes">
                                        <option value="#postTypes.id#">#postTypes.name#</option>
                                    </cfloop>
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
    
                        <input class="form-control fs-14" type="hidden" name="postCreatedDate" id="postCreatedDate" value="<cfif isEdit>#dateFormat(blog.postCreatedDate, 'yyyy-mm-dd')#</cfif>">
    
                        <div class="mb-3">
                            <label class="form-label mb-1 fs-14 fw-medium">
                                Content <span class="text-danger">*</span>
                            </label>
                            <textarea id="editor" name="content"><cfif isEdit>#blog.content#</cfif></textarea>
                        </div>
    
                        <input type="hidden" name="isDraft" id="isDraft" value="0">
                        <div class="text-end">
                            <a href="/blog" class="btn btn-secondary px-3 py-2 rounded fs-14 me-2">
                                Cancel
                            </a>
                            <button type="button" class="btn btn-dark px-3 py-2 rounded fs-14" id="saveDraftBtn">
                                Save as Draft
                            </button>
                            <button type="submit" class="bg--primary btn--secondary text-white px-3 py-2 rounded fs-14">Submit</button>
                        </div>
                    </form>
                    <div id="message"></div>
                </div>
            </div>
        </div>
    </div>
</cfoutput>
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // Initialize EasyMDE configuration
            const easyMDE = new EasyMDE({
                element: document.getElementById('editor'),
                spellChecker: false,
                status: false,
                autofocus: true,
                toolbar: [
                    "bold", "italic", "heading", "|",
                    "quote", "unordered-list", "ordered-list", "|",
                    "link", "image", "code", "|",
                    "preview", "side-by-side", "fullscreen", "|",
                    "guide"
                ],
                uploadImage: true,
                imageUploadEndpoint: '/blog/upload',
                imageMaxSize: 1024 * 1024 * 3, // 3MB
                imageAccept: 'image/png, image/jpeg, image/gif, image/webp',
                imageTexts: {
                    sbInit: 'Upload an image',
                    sbOnDragEnter: 'Drop image here',
                    sbOnDrop: 'Uploading...',
                    sbProgress: 'Uploading...',
                    sbOnUploaded: 'Uploaded!',
                    sizeUnits: 'b,Kb,Mb'
                },
                previewRender: function(plainText) {
                    return marked.parse(plainText);
                },
                // GitHub-like styling
                theme: "github-light",
                sideBySideFullscreen: false,
                maxHeight: "500px",
                minHeight: "500px",
                placeholder: "Write your blog post here...",
                shortcuts: {
                    "toggleSideBySide": "Ctrl-Alt-P",
                    "toggleFullScreen": "Ctrl-Alt-F",
                    "togglePreview": "Ctrl-Alt-V",
                    "toggleBold": "Ctrl-B",
                    "toggleItalic": "Ctrl-I",
                    "drawLink": "Ctrl-K",
                    "drawImage": "Ctrl-G",
                    "drawTable": "Ctrl-T",
                    "toggleHeadingSmaller": "Ctrl-H",
                    "toggleHeadingBigger": "Ctrl-Shift-H",
                    "toggleUnorderedList": "Ctrl-L",
                    "toggleOrderedList": "Ctrl-Alt-L",
                    "toggleCodeBlock": "Ctrl-Alt-C",
                    "toggleBlockquote": "Ctrl-Q",
                    "togglePreview": "Ctrl-P"
                }
            });

            // Handle draft saving
            document.getElementById("saveDraftBtn").addEventListener("click", function() {
                document.getElementById("isDraft").value = "1";
                document.getElementById("blogForm").requestSubmit();
            });

            // Form validation
            document.getElementById('blogForm').addEventListener("submit", function(event) {
                var isValid = true;
                const title = document.getElementById('title');
                const categoryId = document.getElementById('categoryId');
                const posttypeId = document.getElementById('posttypeId');
                const postTags = document.getElementById('postTags');
                const editor = document.getElementById("editor");
                const tagInput = document.getElementById("tagInput");

                // Check if it's a draft submission
                const isDraft = document.getElementById("isDraft").value === "1";

                // Reset validation styles
                [title, categoryId, posttypeId, tagInput].forEach(field => field.classList.remove("is-invalid"));
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
                    if (easyMDE.value().trim() === "") {
                        isValid = false;
                        editor.classList.add("border-danger");
                    }
                }

                if (!isValid) {
                    event.preventDefault();
                    notifier.show('Error!', 'Please fill out all required fields.', '', '/images/high_priority-48.png', 4000);
                    return false;
                }
            });

            // Live preview logic
            // function updatePreview() {
            //     // Title
            //     const title = document.getElementById("title").value;
            //     document.getElementById("previewTitle").innerText = title || "Blog Title Preview";

            //     // Content
            //     document.getElementById("previewBody").innerHTML = marked.parse(easyMDE.value()) || "<p>Your blog content will appear here...</p>";

            //     // Categories
            //     const categorySelect = document.getElementById("categoryId");
            //     const selectedCategories = Array.from(categorySelect.selectedOptions).map(opt => opt.text);
            //     const previewCategories = document.getElementById("previewCategories");
            //     previewCategories.innerHTML = '';
                
            //     if (selectedCategories.length > 0) {
            //         selectedCategories.forEach(cat => {
            //             if (cat !== "Select Category") {
            //                 const badge = document.createElement("span");
            //                 badge.className = "badge bg-primary me-1 mb-1";
            //                 badge.textContent = cat;
            //                 previewCategories.appendChild(badge);
            //             }
            //         });
            //     } else {
            //         previewCategories.innerHTML = '<span class="text-muted fs-13">No categories selected</span>';
            //     }

            //     // Tags
            //     const previewTags = document.getElementById("previewTags");
            //     previewTags.innerHTML = '';
                
            //     if (tags.length > 0) {
            //         tags.forEach(tag => {
            //             const badge = document.createElement("span");
            //             badge.className = "badge bg-secondary me-1 mb-1";
            //             badge.textContent = tag;
            //             previewTags.appendChild(badge);
            //         });
            //     } else {
            //         previewTags.innerHTML = '<span class="text-muted fs-13">No tags added</span>';
            //     }
            // }

            // Initialize preview on page load
            // updatePreview();

            // Event listeners for preview updates
            // document.getElementById("title").addEventListener("input", updatePreview);
            // document.getElementById("categoryId").addEventListener("change", updatePreview);
            // easyMDE.codemirror.on("change", updatePreview);

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
                        // updatePreview(); // Update preview when tag is added
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
                    // updatePreview(); // Update preview when tag is removed
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