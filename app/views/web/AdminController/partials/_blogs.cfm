<cfscript>
    for (var i = 1; i <= blogs.recordCount; i++) {
        var blogId = blogs.id[i]; // Store ID in a variable to reuse
        writeOutput('<tr id="blog-' & blogId & '">');
        writeOutput('<td>' & blogId & '</td>');
        writeOutput('<td>' & blogs.title[i] & '</td>');
        writeOutput('<td>' & blogs.slug[i] & '</td>');
        writeOutput('<td>' & blogs.name[i] & '</td>');
        writeOutput('<td>' & blogs.POSTSTATUSNAME[i] & '</td>');
        writeOutput('<td>' & blogs.POSTTYPENAME[i] & '</td>');
        writeOutput('<td>' & blogs.fullName[i] & '</td>');
        writeOutput('<td>' & blogs.content[i] & '</td>');
        writeOutput('<td>' & blogs.status[i] & '</td>');

        writeOutput('<td>');

        // Approve Button
        writeOutput('<button 
            hx-post="approve" 
            hx-vals=''{"id": "#blogId#"}''
            hx-target="##blog-' & blogId & '"
            hx-confirm="Are you sure you want to approve this blog?"
        >Approve</button>');

        writeOutput('&nbsp;&nbsp; | &nbsp;&nbsp;');

        // Reject Button
        writeOutput('<button 
            hx-post="reject" 
            hx-vals=''{"id": "#blogId#"}''
            hx-target="##blog-' & blogId & '"
            hx-confirm="Are you sure you want to reject this blog?"
        >Reject</button>');

        writeOutput('</td>');
        writeOutput('</tr>');
    }
</cfscript>