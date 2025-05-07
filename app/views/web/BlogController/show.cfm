<main class="main-bg">
    <cfoutput>
            <!-- Blog filter -->
            <div class="container pt-4 pb-5">
                <a href="/blog" class="py-2 px-3 bg-white shadow-sm rounded-3">
                    <i class="bi bi-arrow-left"></i>
                    <span class="fs-14 text--secondary">
                        Back
                    </span>
                </a>
                <div class="bg-white rounded-5 shadow-sm mt-4 p-4">
                    <div class="row gy-4 pb-3">
                        <div class="col-lg-12 col-12 d-flex flex-column">
                            <!--- <div class="d-flex my-3 align-items-center gap-3">
                                <div>
                                    <cfif structKeyExists(blog.user, "profilePicture") AND len(trim(blog.user.profilePicture))>
                                        <cfoutput>#imageTag(source = '#blog.user.profilePicture#', alt="wheels.dev-user-profile-picture", height="50", width="50", class="bg-body-secondary rounded-5")#</cfoutput>
                                    <cfelse>
                                        <img 
                                            src="/images/avatar-rounded.webp" 
                                            style="width:3rem; height:3rem" 
                                            class="bg-body-secondary rounded-5" 
                                            alt="default-profile-picture"
                                        >
                                    </cfif>
                                </div>

                                <p class="fs-18 text--secondary fw-semibold p-0 m-0">#blog.user.fullName#</p>
                            </div> --->

                            <div class="d-flex justify-content-between align-items-center">
                                <h1 class="fs-36 fw-bold text-center text--secondary mb-0">
                                    #blog.title#
                                </h1>
                                <cfif isLoggedInUser() AND (session.role EQ "Admin" OR session.userID EQ blog.createdBy)>
                                    <a href="/blog/edit/#blog.id#" class="btn btn-primary btn-sm" id="editBlogBtn">
                                        <i class="bi bi-pencil"></i> Edit
                                    </a>
                                </cfif>
                            </div>
                            <div id="editLoader" class="position-fixed top-50 start-50 translate-middle" style="display: none; z-index: 9999;">
                                <div class="spinner-border text-primary" role="status">
                                    <span class="visually-hidden">Loading...</span>
                                </div>
                            </div>

                            <cfif categories.recordCount GT 0 OR tags.recordCount GT 0>
                                <div class="d-flex flex-wrap justify-content-center flex-grow-1 align-items-end gap-lg-5 gap-2 mt-3">
                                    <!-- Blog date -->
                                    <p class="fw-medium fs-12 text--lightGray mb-0">
                                        #dateformat(blog.getDisplayDate(), 'MMMM DD, YYYY')#
                                    </p>

                                    <!-- Post status + Categories -->
                                    <cfif categories.recordCount GT 0>
                                        <p class="fw-medium fs-12 text--lightGray mb-0">
                                            #blog.PostStatus.name# in 
                                            <cfoutput query="categories">
                                                <strong 
                                                    class="text--primary"
                                                    style="cursor: pointer;"
                                                    hx-get="#urlFor(route="blogsFilter", filterType="category", filterValue="#REReplace(name, '\.', '-', 'all')#")#"
                                                    hx-target="body" 
                                                    hx-swap="outerHTML" 
                                                    hx-push-url="true"
                                                >#name#</strong><cfif currentrow LT recordcount>, </cfif>
                                            </cfoutput>
                                        </p>
                                    </cfif>

                                    <!-- Tags -->
                                    <cfif tags.recordCount GT 0>
                                        <p class="fw-medium fs-12 text--lightGray mb-0">
                                            Tags: 
                                            <cfoutput query="tags">
                                                <strong 
                                                    class="text--primary"
                                                    style="cursor: pointer;"
                                                    hx-get="#urlFor(route="blogsFilter", filterType="tag", filterValue="#REReplace(name, '\.', '-', 'all')#")#" 
                                                    hx-target="body"
                                                    hx-push-url="true"
                                                    hx-swap="outerHTML"
                                                >#name#</strong><cfif currentrow LT recordcount>, </cfif>
                                            </cfoutput>
                                        </p>
                                    </cfif>
                                </div>
                            </cfif>

                        </div>
                        <!--- <div class="col-lg-5 col-12 text-lg-end text-center"> 
                            <div class="default-blog default-blog-single">
                                <div class="blog-title-overlay">
                                    #blog.title#
                                </div>
                            </div>
                        </div> --->

                        <div class="col-12">
                            #blog.content#
                        </div>
                    </div>

                    <div class="border-top pt-3">
                        <cfoutput query="comments">
                            <div class="mt-4">
                                <div class="position-relative"> 
                                    <cfif commentParentId eq '' or commentParentId eq 0>                              
                                        <div class="d-flex align-items-start gap-3">                                   
                                            <div>
                                                #imageTag(source='#profilePicture#', style="width:3rem; height:3rem", class="bg-body-secondary rounded-5 flex-shrink-0", alt="profile-picture")#
                                            </div>                                   
                                            <div class="p-3 rounded-4 flex-grow-1 bg-light">
                                                <h6 class="fs-16 fw-bold">#fullName#</h6>
                                                <p class="fs-14 fw-normal text-dark">#content#</p>
                                                <div class="d-flex flex-wrap justify-content-end align-items-center gap-4">
                                                    <cfif isLoggedInUser()>
                                                        <div class="d-flex cursor-pointer align-items-center gap-2">
                                                            <p class="fs-14 text--primary mb-0 reply-btn" data-commentid="#Id#" data-blogid="#blog.Id#">Reply</p>

                                                            <svg width="18" height="14" viewBox="0 0 18 14" fill="none" 
                                                                xmlns="http://www.w3.org/2000/svg">
                                                                <path
                                                                    d="M1.42013 6.05185L5.66612 10.2979C5.76346 10.3952 5.81446 10.5099 5.81912 10.6419C5.82379 10.7745 5.77079 10.8959 5.66013 11.0059C5.55013 11.1125 5.43246 11.1665 5.30712 11.1679C5.18112 11.1699 5.06313 11.1159 4.95312 11.0059L0.565125 6.61685C0.477792 6.53019 0.416458 6.44119 0.381125 6.34985C0.345792 6.25919 0.328125 6.15985 0.328125 6.05185C0.328125 5.94385 0.345792 5.84452 0.381125 5.75385C0.416458 5.66319 0.477792 5.57419 0.565125 5.48685L4.95312 1.09785C5.04646 1.00452 5.16013 0.954521 5.29413 0.947854C5.42812 0.941187 5.55046 0.991187 5.66112 1.09785C5.77112 1.20785 5.82612 1.32685 5.82612 1.45485C5.82612 1.58285 5.77112 1.70185 5.66112 1.81185L1.42013 6.05185ZM6.03612 6.55185L9.78213 10.2979C9.87946 10.3952 9.93046 10.5099 9.93513 10.6419C9.93913 10.7745 9.88612 10.8959 9.77612 11.0059C9.66613 11.1125 9.54813 11.1665 9.42212 11.1679C9.29612 11.1692 9.17812 11.1152 9.06812 11.0059L4.68013 6.61685C4.59279 6.53019 4.53146 6.44119 4.49613 6.34985C4.46079 6.25919 4.44312 6.15985 4.44312 6.05185C4.44312 5.94385 4.46079 5.84452 4.49613 5.75385C4.53146 5.66319 4.59279 5.57419 4.68013 5.48685L9.06812 1.09785C9.16146 1.00452 9.27512 0.954521 9.40912 0.947854C9.54379 0.941187 9.66613 0.991187 9.77612 1.09785C9.88612 1.20785 9.94113 1.32685 9.94113 1.45485C9.94113 1.58285 9.88612 1.70185 9.77612 1.81185L6.03612 5.55185H13.4991C14.7418 5.55185 15.8025 5.99119 16.6811 6.86985C17.5598 7.74852 17.9991 8.80919 17.9991 10.0519V12.5519C17.9991 12.6945 17.9515 12.8135 17.8561 12.9089C17.7608 13.0042 17.6418 13.0519 17.4991 13.0519C17.3565 13.0519 17.2375 13.0042 17.1421 12.9089C17.0468 12.8135 16.9991 12.6945 16.9991 12.5519V10.0519C16.9991 9.09052 16.6561 8.26685 15.9701 7.58085C15.2841 6.89485 14.4605 6.55185 13.4991 6.55185H6.03612Z"
                                                                    fill="var(--primary)" />
                                                            </svg>
                                                        </div>
                                                    </cfif>
                                                    <div class="d-flex cursor-pointer align-items-center gap-2">
                                                        <p class="fs-14 text--primary mb-0">#dateformat(publishedAt, 'MMM DD, YYYY')#</p>
                                                    </div>
                                                     <!-- Reply Form (Hidden by Default) -->
                                                    <div class="reply-form" id="reply-form-#Id#" style="display:none;width:100%;">
                                                        <form hx-target="body" hx-swap="outerHTML" class="replyCommentForm" hx-post="/blog/comment" novalidate hx-validate="true">
                                                            <input type="hidden" name="blogId" value="#blog.Id#">
                                                            <input type="hidden" name="commentParentId" value="#Id#">
                                                            <div class="editor-wrapper">
                                                                <div class="toolbar-container bg-light rounded-top toolbar1">
                                                                    <span class="ql-formats bg-white m-lg-0 my-1 px-3 rounded py-1 border">
                                                                        <button class="ql-bold"></button>
                                                                        <button class="ql-italic"></button>
                                                                        <button class="ql-underline"></button>
                                                                        <button class="ql-strike"></button>
                                                                    </span>
                                                                    <span class="ql-formats bg-white m-lg-0 my-1 px-3 rounded py-1 border">
                                                                        <select class="ql-color"></select>
                                                                        <select class="ql-background"></select>
                                                                    </span>
                                                                    <span class="ql-formats bg-white m-lg-0 my-1 px-3 rounded py-1 border">
                                                                        <button class="ql-list" value="ordered"></button>
                                                                        <button class="ql-list" value="bullet"></button>
                                                                        <button class="ql-indent" value="-1"></button>
                                                                        <button class="ql-indent" value="+1"></button>
                                                                    </span>
                                                                </div>
                                                                <div class="editor editor2 form-control border border-top-0 rounded-top-0" id="editor" style="height: 150px;"></div>
                                                            </div>
                                                            <input required class="form-control" type="hidden" name="content" id="content">
                                                            <div class="mt-3 text-end">
                                                                <button type="button" class="btn btn-light border fs-14 px-3 py-2 rounded-2 cancel-reply" data-commentid="#Id#">Cancel</button>
                                                                <button type="submit" class="bg--primary fs-14 text-white px-3 py-2 rounded-2 flex-shrink-0">Reply</button>
                                                            </div>
                                                        </form>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </cfif>
                                    
                                    <cfif commentParentId neq '' and commentParentId neq 0>
                                        <div class="d-flex align-items-start gap-3 position-relative" style="margin-left: 70px;">
                                            <div>
                                                #imageTag(source='#profilePicture#', style="width:3rem; height:3rem", class="bg-body-secondary rounded-5 flex-shrink-0", alt="profile-picture")#
                                            </div>  
                                            <div class="p-3 rounded-4 bg-light">
                                                <h6 class="fs-16 fw-bold">#fullName#</h6>
                                                <p class="fs-14 fw-normal text-dark">#content#</p>
                                            </div>
                                        </div>
                                    </cfif>
                                </div>
                            </div>
                        </cfoutput>
                        
                        <cfif isLoggedInUser()>
                            <form hx-target="body" hx-swap="outerHTML" id="commentForm" hx-post="/blog/comment" class="pt-3 px-1 needs-validation" novalidate hx-validate="true">
                                <div class="d-flex gap-3 align-items-start">
                                    <div class="bg-body-secondary rounded-5" style="width:3rem; height:3rem"></div>
                                    <div class="flex-grow-1 gap-2 d-flex justify-content-between align-items-center">
                                        <input class="form-control" type="hidden" name="blogId" id="blogId" value="#blog.Id#">
                                        <div class="editor-wrapper w-100">
                                            <div class="toolbar-container bg-light rounded-top toolbar1">
                                                <span class="ql-formats bg-white m-lg-0 my-1 px-3 rounded py-1 border">
                                                    <button class="ql-bold"></button>
                                                    <button class="ql-italic"></button>
                                                    <button class="ql-underline"></button>
                                                    <button class="ql-strike"></button>
                                                </span>
                                                <span class="ql-formats bg-white m-lg-0 my-1 px-3 rounded py-1 border">
                                                    <select class="ql-color"></select>
                                                    <select class="ql-background"></select>
                                                </span>
                                                <span class="ql-formats bg-white m-lg-0 my-1 px-3 rounded py-1 border">
                                                    <button class="ql-list" value="ordered"></button>
                                                    <button class="ql-list" value="bullet"></button>
                                                    <button class="ql-indent" value="-1"></button>
                                                    <button class="ql-indent" value="+1"></button>
                                                </span>
                                            </div>
                                            <div class="editor editor1 form-control border border-top-0 rounded-top-0" id="editor" style="height: 150px;"></div>
                                            <div class="mt-3 text-end">
                                                <input required class="form-control" type="hidden" name="content" id="content">
                                                <button type="submit" class="bg--primary fs-14 text-white px-3 py-2 rounded-2 flex-shrink-0">Comment</button>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </form>
                        <cfelse>
                            <div class="alert alert-primary ms-5 mt-2" role="alert">
                                <p>To join this conversation login first! <u><a class="bold" href="/login">Login</a></u></p>
                            </div>
                        </cfif>
                    </div>
                </div>
            </div>
    </cfoutput>
    
    <div class="pt-5 blog-main">
        <h1 class="text-center fw-bold fs-60">Latest Blog Posts</h1>
        <div class="swiper py-5 blogSwiper h-max">
            <div class="swiper-wrapper" id="blogs-container" hx-get="/home/loadBlogs" hx-trigger="load" hx-target="#blogs-container" hx-swap="innerHTML">
                
            </div>
        </div>
    </div>
</main>

<script>

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
            
            if (document.getElementById("content").value.trim() === "" || document.getElementById("content").value.trim() === "<p><br></p>") { // 
                event.preventDefault();
                editor?.classList.add("border-danger");
                notifier.show("Error!", 'Please enter a comment before submitting.', "", "/images/high_priority-48.png", 0);
                return false;
            } else {
                notifier.show("Success!", 'Comment created successfully.', "", "/images/ok-48.png", 0);
                return true;
            }
        });
    });

    document.addEventListener("DOMContentLoaded", function () {
        document.querySelectorAll(".reply-btn").forEach(button => {
            button.addEventListener("click", function () {
                let commentId = this.getAttribute("data-commentid");
                let replyForm = document.getElementById("reply-form-" + commentId);

                // Toggle the reply form
                replyForm.style.display = replyForm.style.display === "none" ? "block" : "none";
            });
        });
    });

    $(document).on('click', '.cancel-reply', function () {
        var commentId = $(this).data('commentid');
        $('#reply-form-' + commentId).hide();
    });
</script>