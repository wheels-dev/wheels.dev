document.addEventListener('DOMContentLoaded', function () {
    const buttons = document.querySelectorAll('.category');

    buttons.forEach(button => {
        button.addEventListener('click', function () {
            // Remove 'active' class from all buttons
            buttons.forEach(btn => btn.classList.remove('active'));

            // Add 'active' class to the clicked button
            this.classList.add('active');
        });
    });

    const contentImages = document.querySelectorAll('.guides-docs-content img');

    contentImages.forEach(img => {
        const src = img.getAttribute('src');
        if (src && src.startsWith('.gitbook')) {
            // Extract filename (after last slash)
            const filename = src.split('/').pop();
            img.setAttribute('src', `/img/${filename}`);
        }
    });

    // 3. Convert {% hint %} to Bootstrap alerts
    const guidesContent = document.querySelector('.guides-docs-content');
    if (guidesContent) {
        let html = guidesContent.innerHTML;

        html = html.replace(/{%\s*hint\s+style=["']?(\w+)["']?\s*%}/gi, function (match, style) {
            return `<div class="alert alert-${style}">`;
        });

        html = html.replace(/{%\s*endhint\s*%}/gi, '</div>');

        guidesContent.innerHTML = html;
    };
});