<main class="main-blog">
    <script src="https://cdn.quilljs.com/1.3.6/quill.min.js"></script>
    <link href="https://cdn.quilljs.com/1.3.6/quill.snow.css" rel="stylesheet">
    <script src="https://unpkg.com/htmx.org@1.9.5"></script>

    <style>
        #preview { border: 1px solid #ccc; padding: 10px; min-height: 200px; }
    </style>

    <div class="container py-5">
        <div class="row justify-content-center justify-content-lg-between">
            <div class="p-3 flex-grow-1 bg-white rounded-start-4 d-flex justify-content-between flex-column">
                <h1 class="text-center">Create Blog Post</h1>
                <form id="blogForm" hx-post="/blog/store" hx-target="#message" hx-swap="innerHTML">
                    <label class="form-label">Title:</label>
                    <input class="form-control" type="text" name="title" id="title" required>

                    <cfoutput>
                        <label class="form-label">Post Category:</label>
                        <select class="form-control" name="categoryId" id="categoryId" required>
                            <option value="">Select Category</option>
                            <cfloop query="categorylist">
                                <option value="#id#">#name#</option>
                            </cfloop>
                        </select>
                    
                        <label class="form-label">Post Status:</label>
                        <select class="form-control" name="statusId" id="statusId" required>
                            <option value="">Select Status</option>
                            <cfloop query="statuslist">
                                <option value="#id#">#name#</option>
                            </cfloop>
                        </select>
                        
                        <label class="form-label">Post Type:</label>
                        <select class="form-control" name="posttypeId" id="posttypeId" required>
                            <option value="">Select Post Type</option>
                            <cfloop query="posttypelist">
                                <option value="#id#">#name#</option>
                            </cfloop>
                        </select>
                    </cfoutput>

                    <label for="content" class="form-label">Content:</label>
                    <div class="form-control" id="editor" style="height: 300px;"></div>
                    <input class="form-control" type="hidden" name="content" id="content"><br>
                    
                    <div class="text-end">
                        <button type="submit" class="btn btn-success">Submit</button>
                    </div>
                </form>
                
                <br><br>
                <h3>Preview:</h3>
                <div id="preview"></div>
                <div id="message"></div>
        
        
            </div>
        </div>
    </div>
    
    <script>
        const quill = new Quill('#editor', { theme: 'snow' });
    
        document.getElementById('blogForm').addEventListener("htmx:configRequest", function(event) {
            let isValid = true;
    
            const title = document.getElementById('title');
            const categoryId = document.getElementById('categoryId');
            const statusId = document.getElementById('statusId');
            const posttypeId = document.getElementById('posttypeId');
            const content = document.getElementById('content');
            const editor = document.getElementById("editor");
    
            // Sync Quill content with hidden input
            content.value = quill.root.innerHTML.trim();
    
            // Reset validation classes
            [title, categoryId, statusId, posttypeId].forEach(field => field.classList.remove("is-invalid"));
            editor.classList.remove("border-danger");
    
            // Validate title
            if (title.value.trim() === "") {
                isValid = false;
                title.classList.add("is-invalid");
            }
    
            // Validate category 
            if (categoryId.value.trim() === "") {
                isValid = false;
                categoryId.classList.add("is-invalid");
            }
    
            // Validate post status 
            if (statusId.value.trim() === "") {
                isValid = false;
                statusId.classList.add("is-invalid");
            }
    
            // Validate post type 
            if (posttypeId.value.trim() === "") {
                isValid = false;
                posttypeId.classList.add("is-invalid");
            }
    
            // Validate content (Quill editor)
            if (content.value.trim() === "<p><br></p>" || content.value.trim() === "") {
                isValid = false;
                editor.classList.add("border-danger");
            }
    
            // If validation fails, prevent HTMX from sending request
            if (!isValid) {
                event.preventDefault(); // Prevent HTMX request
                alert("Please fill out all required fields.");
            }
        });
    
        // Live preview while typing
        quill.on("text-change", function() {
            document.getElementById("preview").innerHTML = quill.root.innerHTML;
        });
    </script>
    
</main>