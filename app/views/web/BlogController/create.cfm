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
                    <form id="blogForm" hx-post="#isEdit ? '/blog/update/#blog.id#' : '/blog/store'#" hx-target="body" hx-swap="outerHTML" hx-push-url="/blog" class="needs-validation" novalidate hx-validate="true" enctype="multipart/form-data" onsubmit="if (document.getElementById('editLoader')) { document.getElementById('editLoader').style.display = 'block'; }">
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
                                        <option value="#categories.id#" <cfif arrayFind(blog.categories, categories.id)>selected</cfif>>#categories.name#</option>
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
    
                        <input class="form-control fs-14" type="hidden" name="postCreatedDate" id="postCreatedDate" value="<cfif isEdit>#dateFormat(blog.postCreatedDate, 'yyyy-mm-dd')#</cfif>">
    
                        <div class="mb-3">
                            <label class="form-label mb-1 fs-14 fw-medium">
                                Content <span class="text-danger">*</span>
                            </label>
                            <textarea id="editor" name="editor_content"><cfif isEdit>#blog.content#</cfif></textarea>
                        </div>
    
                        <input type="hidden" name="isDraft" id="isDraft" value="0">
                        <div class="text-end">
                            <a href="/blog" class="btn btn-secondary px-3 py-2 rounded fs-14 me-2">
                                Cancel
                            </a>
                            <button type="button" class="btn btn-dark px-3 py-2 rounded fs-14" id="saveDraftBtn">
                                Save as Draft
                            </button>
                            <button type="submit" class="bg--primary btn--secondary text-white px-3 py-2 rounded fs-14">Submit</button>
                        </div>
                    </form>
                    <div id="message"></div>
                </div>
            </div>
        </div>
    </div>
</cfoutput>
    <script src="/javascripts/createBlog.js"></script>
</main>