<cfoutput>
    <cfscript>
        // writeDump(blogs); abort;
    </cfscript>

        <cfloop from="1" to="#blogs.recordCount#" index="i">
            <cfset blogId = blogs.id[i]>
            <cfset truncatedContent = left(blogs.content[i], 100) & "...">

            <tr id="blog-#blogId#">
                <td>#blogId#</td>
                <td>#blogs.title[i]#</td>
                <td>#blogs.slug[i]#</td>
                <td>#blogs.name[i]#</td>
                <td>#blogs.NAME[i]#</td>
                <td>#blogs.POSTTYPENAME[i]#</td>
                <td>#blogs.fullName[i]#</td>
                
                <!-- Truncated content with "View More" link -->
                <td>#truncatedContent#</td>
                
                <td>
                    <!-- Approve Button -->
                    <button 
                        hx-post="approve" 
                        hx-vals='{"id": "#blogId#"}'
                        hx-target="##blog-#blogId#"
                        hx-confirm="Are you sure you want to approve this blog?"
                        class="fw-semibold bg--iris py-1 rounded-2 text-white"
                    >Approve</button>

                    &nbsp;&nbsp; | &nbsp;&nbsp;

                    <!-- Reject Button -->
                    <button 
                        class="fw-semibold bg--primary py-1 rounded-2 text-white"
                        hx-post="reject" 
                        hx-vals='{"id": "#blogId#"}'
                        hx-target="##blog-#blogId#"
                        hx-confirm="Are you sure you want to reject this blog?"
                    >Reject</button>
                </td>
                <td>
                    <a href="blog/#blogs.slug[i]#">
                        <button class="fw-semibold bg--secondary py-1 rounded-2 text-white">
                            View More
                        </button>
                    </a>
                </td>
            </tr>
        </cfloop>
    </table>
</cfoutput>