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
                    <form id="blogForm" method="post" action='/admin/blog/blogUpdate/#blog.id#' class="needs-validation" novalidate hx-validate="true" enctype="multipart/form-data" onsubmit="document.getElementById('editLoader').style.display = 'block';">
                        <input type="hidden" name="_method" value="#isEdit ? 'PUT' : 'POST'#">
                        <input class="form-control" type="hidden" name="id" id="id" value="#isEdit ? blog.id : ''#">
    
                        <div class="mb-3">
                            <label class="form-label mb-1 fs-14 fw-medium">
                                Title <span class="text-danger">*</span>
                            </label>
                            <input placeholder="Enter the title" class="form-control fs-14" type="text" name="title" id="title" value="#isEdit ? blog.title : ''#" maxlength="159" required>
                            <small id="title-message" class="text-muted mt-1 d-block fs-13"></small>
                            <input type="hidden" id="titleExists" name="titleExists" value="0">
                        </div>
    
                        <div class="mb-3">
                            <label class="form-label mb-1 fs-14 fw-medium">
                                Post Category <span class="text-danger">*</span>
                            </label>
                            <select class="form-select fs-14" name="categoryId" id="categoryId" required multiple="multiple">
                                <option value="">Select Category</option>
                                <cfif isEdit>
                                    <cfloop query="categories">
                                        <option value="#categories.id#" <cfif arrayFind(blog.categories, categories.id)>selected</cfif>>#categories.name#</option>
                                    </cfloop>
                                <cfelse>
                                    <option value="" disabled>Loading categories...</option>
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
    
                        <!---<div class="mb-3">
                            <label class="form-label mb-1 fs-14 fw-medium">
                                Post Create Date
                            </label>
                            <input class="form-control fs-14" type="date" name="postCreatedDate" id="postCreatedDate" value="<cfif isEdit>#dateFormat(blog.postCreatedDate, 'yyyy-mm-dd')#</cfif>">
                        </div>--->
    
                        <div class="mb-3">
                            <textarea id="editor" name="editor_content"><cfif isEdit>#blog.content#</cfif></textarea>
                            <input class="form-control" type="hidden" name="content" id="content" value="<cfif isEdit>#htmlEditFormat(blog.content)#</cfif>">
                        </div>
    
                        <input type="hidden" name="isDraft" id="isDraft" value="0">
                        <div class="text-end">
                            <a href="#urlFor(route='blog')#" type="button" class="btn btn-dark px-sm-5 fs-14">
                                Cancel
                            </a>
                            <button type="submit" class="btn bg--primary text-white px-sm-5 fs-14">Submit</button>
                        </div>
                    </form>
                    <div id="message"></div>
                </div>
            </div>
            <!---<div class="col-lg-4 col-12">
                <h4 class="mb-3">Live Preview</h4>
                <div id="previewContent" class="p-3 border rounded bg-white">
                    <h2 id="previewTitle" class="fs-20 fw-bold mb-3"></h2>
                    <div id="previewMeta" class="mb-3">
                        <div id="previewCategories" class="mb-1"></div>
                        <div id="previewTags"></div>
                    </div>
                    <div id="previewBody" class="border p-3 rounded bg-light"></div>
                </div>
            </div>--->
        </div>
    </div>
</cfoutput>
</main>