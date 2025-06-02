// This script block only renders if the session flag exists and showTestimonialPopup is true.

// Get modal element immediately
var testimonialModalElement = document.getElementById('testimonialPromptModal');
var testimonialModalInstance = null;
// Flag to ensure the 'shown.bs.modal' listener is attached only once
let formLoadListenerAttached = false;

if (testimonialModalElement) {
    // Get or create the Bootstrap modal instance right away
    testimonialModalInstance = bootstrap.Modal.getOrCreateInstance(testimonialModalElement);

    // Automatically show the modal on page load
    window.addEventListener('DOMContentLoaded', function() {
        console.log('DOM loaded, showing testimonial modal automatically');
        setTimeout(function() {
            if (testimonialModalInstance) {
                testimonialModalInstance.show();
            }
        }, 1000); // Small delay to ensure everything is loaded
    });

    document.body.addEventListener('showTestimonialModal', function handleShowTrigger() {
        console.log('Received showTestimonialModal trigger from backend.');
        if (testimonialModalInstance) {
            testimonialModalInstance.show();
        } else {
            var currentModalInstance = bootstrap.Modal.getInstance(testimonialModalElement);
            if (currentModalInstance) {
                currentModalInstance.show();
            } else {
                console.error("Modal instance not found when trying to show via HX-Trigger.");
            }
        }
    }, { once: true });

    if (!formLoadListenerAttached && testimonialModalInstance) {
        testimonialModalElement.addEventListener('shown.bs.modal', function handleModalShown() {
            var formContainer = testimonialModalElement.querySelector('#testimonial-form-container');
            if (formContainer) {
                var isLoadingIndicatorPresent = formContainer.querySelector('.spinner-border');
                if (isLoadingIndicatorPresent || formContainer.innerHTML.trim() === '') {
                    console.log('Modal shown, processing HTMX for form container.');
                    htmx.process(formContainer); // Trigger the hx-get on the container
                } else {
                    console.log('Modal shown, form container already has content.');
                }
            } else {
                // console.error('Form container #testimonial-form-container not found inside modal.');
            }
        });
        formLoadListenerAttached = true; // Mark that this listener has been attached.
        console.log('Attached shown.bs.modal listener.');
    }
} else {
    console.error("Testimonial prompt modal element not found when initializing script.");
}