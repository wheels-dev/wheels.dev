<main class="w-100 vh-100 d-flex justify-content-center align-items-center main-login position-relative">
    <div class="row w-100 m-lg-auto m-2">
        <div class="col-lg-5 bg-white col-12 mx-auto p-3 rounded-18">
            <div class="mt-2">
                <h1 class="fs-24 mb-0 fw-bold text--secondary">Change Profile Picture</h1>

                <div class="text-center pb-3 my-4">
                    <cfif !structKeyExists(session, "profilePic") OR session.profilePic == "">
                        <cfset session.profilePic = "avatar-rounded.webp">
                    </cfif>
                    <cfoutput>
                        #imageTag(source = '#session.profilePic#', alt="user profile pic", height="150", width="150", class="rounded-circle")#
                    </cfoutput>
                </div>
                <form class="pt-3 px-1 needs-validation" id="profilePicForm" enctype="multipart/form-data" novalidate hx-post="/admin/user/upload-profile-pic" hx-validate="true">
                    <div class="mb-3">
                        <label for="formFile" class="form-label">Profile Picture</label>
                        <input type="file" id="imageInput" class="form-control" name="profilePic" accept="image/*" required>
                        <div id="fileError" class="text-danger fs-14 mt-1"></div>
                    </div>

                    <div class="d-flex flex-wrap justify-content-center gap-2 align-items-start">
                        <button type="submit" class="bg--primary text-white px-3 py-2 rounded fs-14">Save</button>
                        <button type="button" class="bg--default text-dark px-3 py-2 rounded fs-14" onclick="history.back()">Cancel</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</main>
<script>
    document.getElementById("profilePicForm").addEventListener("submit", function (e) {
        const fileInput = document.getElementById("imageInput");
        const errorDiv = document.getElementById("fileError");
        const file = fileInput.files[0];

        // Clear previous error message
        errorDiv.textContent = "";

        if (file) {
            const validExtensions = ["image/png", "image/jpeg", "image/jpg", "image/gif", "image/webp"];
            if (!validExtensions.includes(file.type)) {
                e.preventDefault(); // Prevent form submission
                errorDiv.textContent = "Please upload a valid image file (png, jpg, jpeg, gif, webp).";
            }
        } else {
            e.preventDefault();
            errorDiv.textContent = "Please select an image file to upload.";
        }
    });
</script>
