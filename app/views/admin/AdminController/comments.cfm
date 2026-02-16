<div id="commentResponse" class="bg-white p-4 box-shadow rounded-4 mt-3">
    <cfoutput>
        <div class="container">
            <div class="col-auto">
                <h1 class="fs-24 mb-3 fw-bold">Comments</h1>
            </div>
            <div class="table-responsive">
                <table id="commentsTable" class="table table-hover table-striped">
                    <thead>
                        <th>No.</th>
                        <th>Content</th>
                        <th>Parent Comment</th>
                        <th>Auther</th>
                        <th>Blog</th>
                        <th>Posted at</th>
                        <th>Status</th>
                        <th></th>
                    </thead>
                    <tbody>
                        <cfloop from="1" to="#comments.recordCount#" index="j">
                            <cfset commentId = comments.id[j]>
                            <tr>
                                <td>#j#</td>
                                <td><a hx-get="/admin/commentDetails/#commentId#" 
                                        hx-target="##commentResponse" 
                                        hx-swap="innerHTML"
                                        hx-trigger="click"
                                        class="text-decoration-none text-primary comment-link">
                                        #left(comments.content[j], 30)#
                                    </a></td>
                                <td>
                                    <cfif structKeyExists(parentCommentMap, val(comments.commentParentId[j]))>#left(parentCommentMap[val(comments.commentParentId[j])], 30)#</cfif>
                                </td>
                                <td>#comments.FullName[j]#</td>
                                <td><a href="blog/#comments.slug[j]#" class="cursor-pointer text-primary">#comments.title[j]#</a></td>
                                <td class="comment-date" data-date="#dateTimeFormat(comments.createdAt[j], 'yyyy-mm-dd HH:nn:ss')#">Loading...</td>
                                <td>
                                    <span class="approval-status-#commentId#">
                                        <cfif comments.isPublished[j] eq true>
                                            <span class="badge bg-success">Published</span>
                                        <cfelse>
                                            <span class="badge bg-danger">Hidden</span>
                                        </cfif>
                                    </span>
                                </td>
                                <td>
                                    <div class="dropdown">
                                        <div class="fw-bold cursor-pointer me-2" data-bs-toggle="dropdown" aria-expanded="false">
                                            ...
                                        </div>
                                        <ul class="dropdown-menu">
                                            <li>
                                                <button 
                                                    class="dropdown-item text-success fs-16"
                                                    hx-post="/admin/publish" 
                                                    hx-vals='{"id": "#commentId#"}'
                                                    hx-target=".approval-status-#commentId#"
                                                    hx-swap="innerHTML"
                                                    hx-confirm="Are you sure you want to publish this comment?"
                                                >Publish</button>
                                            </li>
                                            <li>
                                                <button 
                                                    class="dropdown-item text-danger fs-16"
                                                    hx-post="/admin/hide" 
                                                    hx-vals='{"id": "#commentId#"}'
                                                    hx-target=".approval-status-#commentId#"
                                                    hx-swap="innerHTML"
                                                    hx-confirm="Are you sure you want to Hide this comment?"
                                                >Hide</button>
                                            </li>
                                        </ul>
                                    </div>
                                </td>
                            </tr>
                        </cfloop>
                    </tbody>
                </table>
            </div>
        </div>
    </cfoutput>
</div>