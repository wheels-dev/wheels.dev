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

    // Add event listener for EasyMDE changes
    easyMDE.codemirror.on("change", function() {
        const content = easyMDE.value();
        document.getElementById('content').value = content;
    });

    document.addEventListener('htmx:configRequest', function(evt) {
        if (evt.detail.elt.id === 'blogForm') {
            const content = easyMDE.value();
            const formData = evt.detail.parameters;
            
            // Ensure content is in the form data
            formData.content = content;
        }
    });

    document.getElementById('blogForm').addEventListener('htmx:beforeRequest', function(evt) {
        const content = easyMDE.value();
        const formData = new FormData(this);
        formData.set('content', content);
    });

    // Handle draft saving
    document.getElementById("saveDraftBtn").addEventListener("click", function() {
        // Force sync before setting draft flag
        if (typeof easyMDE !== 'undefined') {
            easyMDE.codemirror.save();
        }
        document.getElementById("isDraft").value = "1";
        document.getElementById("blogForm").requestSubmit();
    });

    // Form validation
    document.getElementById('blogForm').addEventListener("submit", function(event) {
        // Force sync EasyMDE content before validation
        let content = "";
        if (typeof easyMDE !== 'undefined') {
            content = easyMDE.value();
            document.getElementById('content').value = content;
        }

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
            if (content.trim() === "") {
                isValid = false;
                editor.classList.add("border-danger");
            }
        }

        if (!isValid) {
            event.preventDefault();
            notifier.show('Error!', 'Please fill out all required fields.', '', '/img/high_priority-48.png', 4000);
            return false;
        }

        // Ensure content is set in the form before submission
        const formData = new FormData(this);
        formData.set('content', content);
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