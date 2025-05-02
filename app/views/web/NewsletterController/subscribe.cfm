<cfoutput>
<cfset response = data>
<cfif response.success>
    <div class="input-group">
        <div class="alert alert-success mb-2 fs-12" role="alert">
            <i class="fas fa-check-circle me-2"></i>
            #response.message#
        </div>
    </div>
    <script>
        htmx.trigger('body', 'notify', {
            type: 'success',
            message: '#response.message#'
        });
    </script>
<cfelse>
    <div class="input-group">
        <div class="alert alert-danger mb-2 fs-12" role="alert">
            <i class="fas fa-exclamation-circle me-2"></i>
            #response.message#
        </div>
    </div>
    <script>
        htmx.trigger('body', 'notify', {
            type: 'error',
            message: '#response.message#'
        });
    </script>
</cfif>
</cfoutput>