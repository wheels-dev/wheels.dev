<main class="main-blog">
    <div class="container py-5">
        <div class="row justify-content-center justify-content-lg-between">
            <div class="bg-white rounded-5 shadow-sm mt-4 p-4">
                <h1 class="text-center fs-24 fw-bold">Create Blog Post</h1>
                <form id="blogForm" hx-post="/blog/store" hx-target="body" hx-swap="outerHTML" hx-push-url="/blog" class="needs-validation" novalidate hx-validate="true" enctype="multipart/form-data">
                    <input class="form-control" type="hidden" name="id" id="id" value="">

                    <div class="mb-3">
                        <label class="form-label mb-1 fs-14 fw-medium">
                            Title <span class="text-danger">*</span>
                        </label>
                        <input placeholder="Enter the title" class="form-control fs-14" type="text" name="title" id="title" value="" maxlength="240" required>
                    </div>

                    <div class="mb-3">
                        <label class="form-label mb-1 fs-14 fw-medium">
                            Post Category <span class="text-danger">*</span>
                        </label>
                        <select class="form-control fs-14" name="categoryId" id="categoryId" required hx-get="/blog/loadCategories" hx-trigger="load" hx-target="#categoryId" hx-swap="innerHTML" multiple="multiple">
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
                        <input placeholder="Enter the Tags" class="form-control fs-14" type="text" name="posttag" id="posttag" value="" maxlength="240" required>
                    </div>

                    <div class="mb-3">
                        <label class="form-label mb-1 fs-14 fw-medium">
                            Excerpt <span class="text-danger">*</span>
                        </label>
                        <textarea rows="4" placeholder="Enter the Excerpt (short summary/preview)" class="form-control fs-14" type="text" name="excerpt" id="excerpt" value="" required maxlength="400"></textarea>
                        <div id="counter1">(0/450)</div>
                    </div>

                    <div class="mb-3">
                        <label class="form-label mb-1 fs-14 fw-medium">
                            Cover Image
                        </label>
                        <input class="form-control fs-14" type="file" name="attachment" id="attachment" value="">
                    </div>

                    <div class="mb-3">
                        <div id="toolbar-container" class="border-bottom-0 border rounded-top">
                            <span class="ql-formats m-lg-0 my-1 px-3 rounded py-1 border">
                                <select class="ql-font"></select>
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
                                <button class="ql-script" value="sub"></button>
                                <button class="ql-script" value="super"></button>
                            </span>
                            <span class="ql-formats m-lg-0 my-1 px-3 rounded py-1 border">
                                <button class="ql-header" value="1"></button>
                                <button class="ql-header" value="2"></button>
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
            const posttag = document.getElementById('posttag');
            const content = document.getElementById('content');
            const excerpt = document.getElementById('excerpt');
            const editor = document.getElementById("editor");

            // Check if it's a draft submission
            const isDraft = document.getElementById("isDraft").value === "1";

            // Reset validation styles
            [title, categoryId, posttypeId, posttag, excerpt].forEach(field => field.classList.remove("is-invalid"));
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
                if (posttag.value.trim() === "") {
                    isValid = false;
                    posttag.classList.add("is-invalid");
                }
                if (excerpt.value.trim() === "") {
                    isValid = false;
                    excerpt.classList.add("is-invalid");
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
                $('#categoryId').select2();
            }
        });

        $(document).ready(function() {
            $('#categoryId').select2();
        });
     

        // Function to update character count
        function updateCharacterCount(textareaId, counterId, maxChars) {
            const textarea = document.getElementById(textareaId);
            const counter = document.getElementById(counterId);
            const currentChars = textarea.value.length;
            
            counter.textContent = `(${currentChars}/${maxChars})`;
        }
        
        // Attach event listeners to textarea fields
        const textareas = document.querySelectorAll('textarea');
        textareas.forEach((textarea, index) => {
            const counterId = `counter${index + 1}`;
            const maxChars = 450; // Adjust as needed
            
            // Initial character count update
            updateCharacterCount(textarea.id, counterId, maxChars);
            
            // Attach event listener for keyup event
            textarea.addEventListener('keyup', () => {
            updateCharacterCount(textarea.id, counterId, maxChars);
            });
        });
  
    </script>
</main>