document.body.addEventListener('htmx:afterSwap', function(evt) {
    const xhr = evt.detail.xhr;
    // Check if it's for the responseMessage target
    if (evt.detail.target.id === "form-messages") {
        notifier.show('Success!', xhr.responseText, 'success', '', 4000);
        setTimeout(function() {
            window.location.href = "/"; 
        }, 4000); // 4 seconds delay
    }
});
