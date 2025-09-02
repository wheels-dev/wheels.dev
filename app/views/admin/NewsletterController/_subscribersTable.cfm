<cfoutput>
    <table class="table table-hover" id="subscribersListTable">
        <thead>
            <tr>
                <th>Email</th>
                <th>Name</th>
                <th>Type</th>
                <th>Subscribed Since</th>
                <th>Actions</th>
            </tr>
        </thead>
        <tbody>
            <cfloop array="#data.subscribers#" index="subscriber">
                <tr>
                    <td>#subscriber.email#</td>
                    <td>#subscriber.name#</td>
                    <td>
                        <span class="badge bg-#subscriber.type == 'user' ? 'primary' : (subscriber.type == 'pending' ? 'warning' : (subscriber.type == 'inactive' ? 'danger' : 'secondary'))#">
                            #subscriber.type#
                        </span>
                    </td>
                    <td>#dateFormat(subscriber.subscribedAt, "mmm d, yyyy")#</td>
                    <td>
                        <cfif subscriber.type != "inactive">
                            <button class="btn btn-sm btn-outline-danger"
                                    hx-post="/admin/newsletter/unsubscribe"
                                    hx-confirm="Are you sure you want to unsubscribe this user?"
                                    hx-vals='{"email": "#subscriber.email#", "type": "#subscriber.type#"}'
                                    hx-target="closest tr"
                                    hx-swap="delete"
                                    >
                                <i class="bi bi-person-x"></i> Unsubscribe
                            </button>
                        </cfif>
                    </td>
                </tr>
            </cfloop>
        </tbody>
    </table>
</cfoutput> 
<script>
    var table = new DataTable('#subscribersListTable',{
        "searching": false,
        "lengthChange": false
    });
</script>