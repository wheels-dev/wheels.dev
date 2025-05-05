<cfoutput>
    <table class="table table-hover" id="subscribersTable">
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
                        <div class="btn-group">
                            <button class="btn btn-sm btn-outline-danger"
                                    hx-post="/admin/newsletter/unsubscribe"
                                    hx-vals='{"email": "#subscriber.email#", "type": "#subscriber.type#"}'
                                    hx-confirm="Are you sure you want to unsubscribe this user?"
                                    hx-target="closest tr"
                                    hx-swap="outerHTML swap:1s">
                                <i class="bi bi-envelope-x me-1"></i>Unsubscribe
                            </button>
                        </div>
                    </td>
                </tr>
            </cfloop>
        </tbody>
    </table>
</cfoutput> 