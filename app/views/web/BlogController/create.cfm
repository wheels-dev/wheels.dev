<main class="main-blog">
    <div class="container py-5">
        <div class="row justify-content-center justify-content-lg-between">
            <div class="bg-white rounded-5 shadow-sm mt-4 p-4">
                <h1 class="text-center fs-24 fw-bold">Create Blog Post</h1>
                <form id="blogForm" hx-post="/blog/store" hx-target="#message" hx-swap="innerHTML" class="needs-validation" novalidate hx-validate="true">
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
                        <select class="form-control fs-14" name="categoryId" id="categoryId" required hx-get="/blog/loadCategories" hx-trigger="load" hx-target="#categoryId" hx-swap="innerHTML">
                            <option value="">Select Category</option>
                        </select>
                    </div>

                    <div class="mb-3">
                        <label class="form-label mb-1 fs-14 fw-medium">
                            Post Status <span class="text-danger">*</span>
                        </label>
                        <select class="form-control fs-14" name="statusId" id="statusId" required hx-get="/blog/loadStatuses" hx-trigger="load" hx-target="#statusId" hx-swap="innerHTML">
                            <option value="">Select Status</option>
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
                            Attachment
                        </label>
                        <input class="form-control fs-14" type="file" name="attachment" id="attachment" value="">
                    </div>

                    <div class="mb-3">
                        <label for="content" class="form-label mb-1 fs-14 fw-medium">
                            Content <span class="text-danger">*</span>
                        </label>
                        <div class="rounded-bottom" id="editor" style="height: 300px;"></div>
                        <input class="form-control fs-14" type="hidden" name="content" id="content"><br>
                    </div>

                    <div class="text-end">
                        <button type="submit" class="bg--secondary text-white px-3 py-2 rounded fs-14">Submit</button>
                    </div>
                </form>

                <div class="mb-3">
                    <h3 class="pb-1 fs-14 fw-medium">Preview</h3>
                    <div id="preview" class="rounded min-h-200 form-control p-2 fs-14"></div>
                </div>
                <div id="message"></div>
            </div>
        </div>
    </div>

    <script>
        const quill = new Quill('#editor', { theme: 'snow' });

        function syncQuillContent() {
            document.getElementById('content').value = quill.root.innerHTML.trim();
        }

        document.getElementById('blogForm').addEventListener("submit", function (event) {
            syncQuillContent(); // Ensure content is set before submit

            var isValid = true;

            const title = document.getElementById('title');
            const categoryId = document.getElementById('categoryId');
            const statusId = document.getElementById('statusId');
            const posttypeId = document.getElementById('posttypeId');
            const posttag = document.getElementById('posttag');
            const content = document.getElementById('content');
            const excerpt = document.getElementById('excerpt');
            const editor = document.getElementById("editor");

            // Reset validation styles
            [title, categoryId, statusId, posttypeId, posttag, excerpt].forEach(field => field.classList.remove("is-invalid"));
            editor.classList.remove("border-danger");

            // Validate fields
            if (title.value.trim() === "") {
                isValid = false;
                title.classList.add("is-invalid");
            }
            if (categoryId.value.trim() === "") {
                isValid = false;
                categoryId.classList.add("is-invalid");
            }
            if (statusId.value.trim() === "") {
                isValid = false;
                statusId.classList.add("is-invalid");
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

            // If validation fails, prevent request
            if (!isValid) {
                event.preventDefault();
                alert("Please fill out all required fields.");
                return false;
            }
        });

        // Live preview while typing
        quill.on("text-change", function () {
            document.getElementById("preview").innerHTML = quill.root.innerHTML;
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

        document.addEventListener("DOMContentLoaded", function() {
            $('#posttypeId').select2({});
            $('#statusId').select2({});
            $('#categoryId').select2({});
        });
    </script>
</main>