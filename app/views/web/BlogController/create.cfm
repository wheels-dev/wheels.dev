<main class="main-blog">
<cfoutput>
    <div class="container py-5">
        <div class="row justify-content-center justify-content-lg-between">
            <div class="col-lg-12 col-12">
                <div class="bg-white rounded-5 shadow-sm mt-4 p-4">
                    <h1 class="text-center fs-24 fw-bold">#isEdit ? 'Edit' : 'Create'# Blog Post</h1>
                    <cfif isEdit>
                        <div id="editLoader" class="position-fixed top-50 start-50 translate-middle" style="display: none; z-index: 9999;">
                            <div class="spinner-border text-primary" role="status">
                                <span class="visually-hidden">Saving...</span>
                            </div>
                        </div>
                    </cfif>
                    <form id="blogForm" hx-post="#isEdit ? '/blog/update/#blog.id#' : '/blog/store'#" hx-swap="none" class="needs-validation" novalidate hx-validate="true" enctype="multipart/form-data">
                        #authenticityTokenField()#
                        <input type="hidden" name="_method" value="#isEdit ? 'PUT' : 'POST'#">
                        <input class="form-control" type="hidden" name="id" id="id" value="#isEdit ? blog.id : ''#">
                        <input type="hidden" name="content" id="content" value="">
    
                        <div class="mb-3">
                            <label class="form-label mb-1 fs-14 fw-medium">
                                Title <span class="text-danger">*</span>
                            </label>
                            <input placeholder="Enter your article title" class="form-control fs-14" type="text" name="title" id="title" value="#isEdit ? blog.title : ''#" maxlength="160" required>
                            <small id="title-message" class="text-muted mt-1 d-block fs-13">Maximum 160 characters</small>
                            <input type="hidden" id="titleExists" name="titleExists" value="0">
                        </div>
    
                        <div class="mb-3">
                            <label class="form-label mb-1 fs-14 fw-medium">
                                Post Category <span class="text-danger">*</span>
                            </label>
                            <select class="form-select fs-14" name="categoryId" id="categoryId" required multiple="multiple">
                                <option value="">Select Categories</option>
                                <cfif isEdit>
                                    <cfloop query="categories">
                                        <option value="#categories.id#" <cfif arrayFind(blog.categories, val(categories.id))>selected</cfif>>#categories.name#</option>
                                    </cfloop>
                                <cfelse>
                                    <option value="" disabled>Loading categories...</option>
                                    <cfloop query="categories">
                                        <option value="#categories.id#">#categories.name#</option>
                                    </cfloop>
                                </cfif>
                            </select>
                        </div>
    
                        <div class="mb-3">
                            <label class="form-label mb-1 fs-14 fw-medium">
                                Post Type <span class="text-danger">*</span>
                            </label>
                            <select class="form-control fs-14" name="posttypeId" id="posttypeId" required>
                                <option value="">Select Post Type</option>
                                <cfif isEdit>
                                    <cfloop query="postTypes">
                                        <option value="#postTypes.id#" <cfif blog.posttypeId EQ postTypes.id>selected</cfif>>#postTypes.name#</option>
                                    </cfloop>
                                <cfelse>
                                    <option value="" disabled>Loading post types...</option>
                                    <cfloop query="postTypes">
                                        <option value="#postTypes.id#">#postTypes.name#</option>
                                    </cfloop>
                                </cfif>
                            </select>
                        </div>
                        
                        <div class="mb-3">
                            <label class="form-label mb-1 fs-14 fw-medium">
                                Post Tags <span class="text-danger">*</span>
                            </label>
                            <div class="d-flex form-control p-0 flex-wrap gap-1" id="tagContainer">
                                <input type="text" onblur="document.getElementById('tagContainer').classList.remove('parent-focus'); this.classList.remove('shadow-none');" onfocus="document.getElementById('tagContainer').classList.add('parent-focus'); this.classList.add('shadow-none');" class="fs-14 border-0 form-control" id="tagInput" placeholder="Enter tags and press comma (,)" value="<cfif isEdit>#blog.tags#</cfif>">
                            </div>
                            <input type="hidden" name="postTags" id="postTags" value="<cfif isEdit>#blog.tags#</cfif>">
                        </div>
    
                        <div class="mb-3">
                            <label class="form-label mb-1 fs-14 fw-medium">
                                Publish Date
                            </label>
                            <input class="form-control fs-14" type="datetime-local" name="postCreatedDate" id="postCreatedDate" value="<cfif isEdit>#dateFormat(blog.postCreatedDate, 'yyyy-mm-dd')#T#timeFormat(blog.postCreatedDate, 'HH:mm')#</cfif>" data-utc-value="<cfif isEdit>#dateFormat(blog.postCreatedDate, 'yyyy-mm-dd')#T#timeFormat(blog.postCreatedDate, 'HH:mm:ss')#</cfif>">
                            <small class="text-muted mt-1 d-block fs-13">Leave empty to use the current date and time</small>
                        </div>
    
                        <div class="mb-3">
                            <label class="form-label mb-1 fs-14 fw-medium">
                                Content <span class="text-danger">*</span>
                            </label>
                            <textarea id="editor" name="editor_content"><cfif isEdit>#blog.content#</cfif></textarea>
                        </div>
    
                        <input type="hidden" name="isDraft" id="isDraft" value="0">
                        <div class="text-end">
                            <a href="#urlFor(route='blog')#" class="btn btn-secondary px-3 py-2 rounded fs-14 me-2">
                                Cancel
                            </a>
                            <button type="button" class="btn btn-dark px-3 py-2 rounded fs-14 me-2" id="saveDraftBtn">
                                Save as Draft
                            </button>
                            <button type="submit" class="bg--primary btn--secondary text-white px-3 py-2 rounded fs-14">#isEdit ? 'Update' : 'Submit'#</button>
                        </div>
                    </form>
                    <div id="message"></div>
                </div>
            </div>
        </div>
    </div>
</cfoutput>
    <script src="/js/createBlog.js"></script>
    <script>
        // Convert UTC datetime from server to local time for display in datetime-local input
        document.addEventListener("DOMContentLoaded", function() {
            var postCreatedDateInput = document.getElementById('postCreatedDate');
            if (postCreatedDateInput) {
                var utcValue = postCreatedDateInput.getAttribute('data-utc-value');
                if (utcValue) {
                    // Parse the UTC value from server and convert to local time
                    var utcDate = new Date(utcValue + 'Z');
                    if (!isNaN(utcDate.getTime())) {
                        // Convert to local datetime-local format (YYYY-MM-DDTHH:mm)
                        var localDate = new Date(utcDate.getTime() - (utcDate.getTimezoneOffset() * 60000));
                        postCreatedDateInput.value = localDate.toISOString().slice(0, 16);
                    }
                }
            }
            // Set user's timezone in a hidden field for server-side use
            var tzField = document.getElementById('userTimezone');
            if (!tzField) {
                tzField = document.createElement('input');
                tzField.type = 'hidden';
                tzField.name = 'userTimezone';
                tzField.id = 'userTimezone';
                document.getElementById('blogForm').appendChild(tzField);
            }
            tzField.value = Intl.DateTimeFormat().resolvedOptions().timeZone;
        });

        // Convert local datetime to UTC before form submission via HTMX
        document.addEventListener("htmx:configRequest", function(event) {
            var postCreatedDateInput = document.getElementById('postCreatedDate');
            if (postCreatedDateInput && postCreatedDateInput.value) {
                // Parse the local datetime and convert to UTC
                var localDate = new Date(postCreatedDateInput.value);
                if (!isNaN(localDate.getTime())) {
                    // Convert to ISO string (which is in UTC) and update the form parameter
                    event.detail.parameters.postCreatedDate = localDate.toISOString();
                }
            }
            // Always send user's timezone
            var tzField = document.getElementById('userTimezone');
            if (tzField) {
                event.detail.parameters.userTimezone = tzField.value;
            }
        });
    </script>
</main>
