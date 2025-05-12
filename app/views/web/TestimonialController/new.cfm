<cfoutput>
<form method="post"
      action="#urlFor(route="create-testimonial")#"
      enctype="multipart/form-data"
      hx-post="#urlFor(route="create-testimonial")#"
      hx-target="##testimonial-form-container"
      hx-swap="outerHTML"
      hx-encoding="multipart/form-data"
      hx-on="htmx:afterOnLoad: handleTestimonialResponse(event)">
</cfoutput>

    <div id="form-messages"></div>

    <div class="mb-3">
        <label for="companyName" class="form-label">Company Name</label>
        <input type="text"
               name="companyName"
               id="companyName"
               class="form-control"
               required>
    </div>

    <div class="mb-3">
        <label for="content" class="form-label">Your Testimonial</label>
        <textarea name="content"
                  id="content"
                  class="form-control"
                  rows="5"
                  required
                  minlength="20"
                  maxlength="500"></textarea>
        <div class="form-text">Please share your experience (20-500 characters).</div>
    </div>

    <div class="mb-3">
        <label class="form-label">Rating (1-5 Stars)</label>
        <div class="d-flex">
            <div class="form-check form-check-inline">
                <input class="form-check-input" type="radio" name="rating" id="rating1" value="1" required>
                <label class="form-check-label" for="rating1">1 Star</label>
            </div>
            <div class="form-check form-check-inline">
                <input class="form-check-input" type="radio" name="rating" id="rating2" value="2">
                <label class="form-check-label" for="rating2">2 Stars</label>
            </div>
            <div class="form-check form-check-inline">
                <input class="form-check-input" type="radio" name="rating" id="rating3" value="3">
                <label class="form-check-label" for="rating3">3 Stars</label>
            </div>
            <div class="form-check form-check-inline">
                <input class="form-check-input" type="radio" name="rating" id="rating4" value="4">
                <label class="form-check-label" for="rating4">4 Stars</label>
            </div>
            <div class="form-check form-check-inline">
                <input class="form-check-input" type="radio" name="rating" id="rating5" value="5">
                <label class="form-check-label" for="rating5">5 Stars</label>
            </div>
        </div>
    </div>

    <div class="mb-3">
        <label for="experienceLevel" class="form-label">Your Experience Level with Wheels.dev</label>
        <select name="experienceLevel"
                id="experienceLevel"
                class="form-select"
                required>
            <option value="" selected disabled>-- Select Level --</option>
            <option value="Beginner">Beginner</option>
            <option value="Intermediate">Intermediate</option>
            <option value="Advanced">Advanced</option>
            <option value="Expert">Expert</option>
        </select>
    </div>

    <div class="mb-3">
        <label for="websiteUrl" class="form-label">Company Website (Optional)</label>
        <input type="url"
               name="websiteUrl"
               id="websiteUrl"
               class="form-control"
               placeholder="https://...">
    </div>

    <div class="mb-3">
        <label for="socialMediaLinks" class="form-label">Social Media Link (Optional)</label>
        <input type="url"
               name="socialMediaLinks"
               id="socialMediaLinks"
               class="form-control"
               placeholder="https://linkedin.com/in/...">
    </div>

    <div class="mb-3">
        <label for="logo" class="form-label">Company Logo (Optional)</label>
        <input type="file"
               name="logo"
               id="logo"
               class="form-control"
               accept="image/jpeg, image/png, image/gif, image/webp">
        <div class="form-text">Upload JPG, PNG, GIF, or WEBP.</div>
    </div>

    <div class="mb-3 form-check">
        <input type="checkbox"
               name="displayPermission"
               id="displayPermission"
               value="true"
               class="form-check-input">
        <label class="form-check-label" for="displayPermission">I grant permission to display this testimonial publicly.</label>
        <input type="hidden" name="displayPermission" value="false">
    </div>

    <div class="d-grid">
        <button type="submit" class="btn btn-primary">Submit Testimonial</button>
    </div>

</form>

<script>
    function handleTestimonialResponse(event) {
        var xhr = event.detail.xhr;
        var response = null;
        try {
            response = JSON.parse(xhr.responseText);
        } catch (e) {
            // Not JSON, ignore
            return;
        }
        var formMessages = document.getElementById('form-messages');
        if (!formMessages) return;

        if (response.success) {
            formMessages.innerHTML = '<div class="alert alert-success">' + response.message + '</div>';
            // Close modal after short delay
            setTimeout(function() {
                var modalEl = document.getElementById('testimonialPromptModal');
                if (modalEl) {
                    var modalInstance = bootstrap.Modal.getInstance(modalEl);
                    if (modalInstance) {
                        modalInstance.hide();
                    }
                }
            }, 1500);
        } else {
            formMessages.innerHTML = '<div class="alert alert-danger">' + response.message + '</div>';
        }
    }
</script>
