<cfoutput>
    <div class="container py-5">
        <div class="col-auto">
            <h1 class="fs-24 mb-5 fw-bold">Comments</h1>
        </div>
        <table id="commentsTable" class="table table-hover">
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
                        <td>#trim(comments.content[j])#</td>
                        <td>
                            <cfset  parentComment= model("comment").findAll(select="content", where="id='#comments.commentParentId[j]#'")>
                            #parentComment.content#
                        </td>
                        <td>#comments.FullName[j]#</td>
                        <td><a href="blog/#comments.slug[j]#" class="cursor-pointer text-primary">#comments.title[j]#</a></td>
                        <td>#datetimeFormat(comments.createdAt[j], "dd-MMM-YYYY HH:MM")#</td>
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
                                <div class="fw-bold cursor-pointer" data-bs-toggle="dropdown" aria-expanded="false">
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
</cfoutput>
<script>
    var table = new DataTable('#commentsTable', {
        columnDefs: [
            {
                targets: [6,7], // Adjust these indexes based on your actual table structure
                orderable: false
            }
        ]
    });
    table.on('draw', function() {
        htmx.process(document.body);
    });
</script>