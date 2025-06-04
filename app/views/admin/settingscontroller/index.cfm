<cfoutput>
<div class="container-fluid">
    <div class="row">
        <div class="col-12">
            <div class="card">
                <div class="card-header">
                    <h5 class="mb-0">Settings</h5>
                </div>
                <div class="card-body">
                    <!-- Testimonials Setting -->
                    <div class="mb-4">
                        <h6 class="mb-3">Testimonials</h6>
                        <div class="form-check form-switch">
                            <input class="form-check-input" type="checkbox" id="enableTestimonials" 
                                hx-post="/admin/settings/enableTestimonials"
                                hx-trigger="change"
                                hx-include="[name='enableTestimonials']"
                                hx-swap="none"
                                name="enableTestimonials"
                                <cfif settings.enableTestimonial>checked</cfif>>
                            <label class="form-check-label" for="enableTestimonials">Enable Testimonials</label>
                        </div>
                    </div>

                    <!-- Slack Invite Link Setting -->
                    <div class="mb-4">
                        <h6 class="mb-3">Slack Community</h6>
                        <form hx-post="/admin/settings/updateSlackInvite" hx-swap="none">
                            <div class="row g-3">
                                <div class="col-md-8">
                                    <input type="text" class="form-control" name="slackInviteLink" 
                                        placeholder="Enter Slack Invite Link" 
                                        value="#settings.slackInviteLink#">
                                </div>
                                <div class="col-md-4">
                                    <button type="submit" class="btn btn-primary">
                                        Update Slack Link
                                    </button>
                                </div>
                            </div>
                        </form>
                        <small class="text-muted mt-2 d-block">
                            The Slack invite link expires after 30 days. Make sure to update it regularly.
                        </small>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
document.body.addEventListener("htmx:afterRequest", function(event) {
    const xhr = event.detail.xhr;
    if (xhr.status === 500) {
        notifier.show('Error', 'Something went wrong!', 'danger', '', 5000);
    }
    if (xhr.status === 200) {
        notifier.show('Success', xhr.responseText, 'success', '', 5000);
    }
});
</script>
</cfoutput>