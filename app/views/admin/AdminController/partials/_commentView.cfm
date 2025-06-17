<div id="commentResponse">
    <cfoutput>
        <div class="container py-5">
            <div class="col-auto">
                <h1 class="fs-24 mb-5 fw-bold">Comment Details</h1>
            </div>

            <div class="table-responsive scrollbar">
                <table class="table fs-9 mb-0 border-top border-translucent">
                    <tr>
                        <th>Comment Content:</th>
                        <td>#Comments.Content#</td>
                    </tr>
                    <tr>
                        <th>Parent comment:</th>
                        <td>
                            <cfset  parentComment= model("comment").findAll(select="content", where="id='#comments.commentparentId#'")>
                            #left(parentComment.content, 30)#
                        </td>
                    </tr>
                    <tr>
                        <th>Author</th>
                        <td>#comments.User.FullName#</td>
                    </tr>
                    <tr>
                        <th>Blog title</th>
                        <td><a href="/admin/blog/#comments.blog.slug#" class="cursor-pointer text-primary">#comments.blog.title#</a></td>
                    </tr>
                    <tr>
                        <th>Posted At</th>
                        <td>#datetimeFormat(comments.createdAt, "dd-MMM-YYYY HH:MM")#</td>
                    </tr>
                </table>
            </div>
            <div class="text-end">
                <div class="col-auto mt-4">
                    <a class="btn btn-primary bg--primary px-5" href="/admin/comment">Back</a>
                </div>
            </div>
        </div>
    </cfoutput>
</div>
