<cfoutput>
<div class="bg-white p-4 box-shadow rounded-4 mt-3">
    <div class="rolesResponce container">
        <div class="d-flex mb-3 justify-content-between align-items-center">
            <div class="col-auto">
                <h1 class="fs-24 fw-bold">Settings</h1>
            </div>
        </div>
        <div class="m-4">
            <div>
                <div class="form-check mt-2 align-items-center">
                    <input hx-post="/admin/enableTestimonials" hx-trigger="change" hx-include="[name='enableTestimonials']" hx-swap="none" name="enableTestimonials" type="checkbox" class="form-check-input form-check-input-primary permission-checkbox" id="enableTestimonials" <cfif settings.enableTestimonial>checked</cfif>>
                    <label class="form-check-label fs-18" for="enableTestimonials">Enable Testimonials</label>
                </div>
            </div>
        </div>
    </div>
</div>
</cfoutput>
<script>
    document.body.addEventListener("htmx:afterRequest", function(event) {
        const xhr = event.detail.xhr;
        if (xhr.status === 500 && xhr.responseURL.includes("/admin/enableTestimonials")) {
            notifier.show('Error', 'Something went wrong!', 'danger', '', 5000);
        }
        if (xhr.status === 200 && xhr.responseURL.includes("/admin/enableTestimonials")) {
            notifier.show('Success', xhr.responseText, 'success', '', 5000);
        }
    });
</script>