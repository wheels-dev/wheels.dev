document.querySelectorAll('.editor-wrapper').forEach((wrapper) => {
    const toolbar = wrapper.querySelector('.toolbar-container');
    const editor = wrapper.querySelector('.editor');

    const quill = new Quill(editor, {
        modules: {
            syntax: true,
            toolbar: toolbar,
        },
        placeholder: 'Add a comment...',
        theme: 'snow',
    });

    // Store the Quill instance on the editor element for later use
    editor.quillInstance = quill;
});

// Handle form submission
document.querySelectorAll("#commentForm, .replyCommentForm").forEach(form => {
    form.addEventListener("submit", function (event) {
        const contentField = form.querySelector('input[name="content"]');
        const editor = form.querySelector(".editor");
        const quill = editor ? Quill.find(editor) : null;

        if (quill) {
            contentField.value = quill.root.innerHTML.trim();
            document.getElementById("content").value = quill.root.innerHTML.trim();
        }
        
        if (document.getElementById("content").value.trim() === "" || document.getElementById("content").value.trim() === "<p> </p>" || document.getElementById("content").value.trim() === "<p><br></p>") { // 
            event.preventDefault();
            editor?.classList.add("border-danger");
            notifier.show("Error!", 'Please enter a comment before submitting.', "", "/img/high_priority-48.png", 5000);
            return false;
        } else {
            notifier.show("Success!", 'Comment created successfully.', "", "/img/ok-48.png", 5000);
            return true;
        }
    });
});

const handleClear = ()=>{
    document.querySelectorAll("#commentForm, .replyCommentForm").forEach(form => {
        const contentField = form.querySelector('input[name="content"]');
        const editor = form.querySelector(".editor");
        const quill = editor ? Quill.find(editor) : null;

        quill.setContents([]);
        contentField.value = "";
        document.getElementById("content").value = "";
    });
}

const handleReply = (commentid)=>{
    console.log(commentid);
    let replyForm = document.getElementById("reply-form-" + commentid);
    replyForm.style.display = replyForm.style.display === "none" ? "block" : "none";
}

$(document).on('click', '.cancel-reply', function () {
    var commentId = $(this).data('commentid');
    $('#reply-form-' + commentId).hide();
});

document.addEventListener('DOMContentLoaded', function() {
    // Initialize marked with GitHub-like options
    marked.setOptions({
        gfm: true,
        breaks: true,
        headerIds: true,
        mangle: false
    });

    // Render markdown content
    const markdownContent = document.querySelector('.markdown-content');
    if (markdownContent) {
        const content = markdownContent.textContent.trim();
        markdownContent.innerHTML = marked.parse(content);
    }
});