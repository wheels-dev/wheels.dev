document.addEventListener('DOMContentLoaded', function() {
    var testimonialModalElement = document.getElementById('testimonialPromptModal');
    if (testimonialModalElement) {
        var testimonialModalInstance = bootstrap.Modal.getOrCreateInstance(testimonialModalElement);
        testimonialModalInstance.show();
    }
});