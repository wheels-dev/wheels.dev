<cfoutput>
<cfset response = data>
<cfif response.success>
    <div class="input-group">
        <div class="alert alert-success mb-2 fs-12" role="alert">
            <i class="fas fa-check-circle me-2"></i>
            #response.message#
        </div>
    </div>
<cfelse>
    <div class="input-group">
        <div class="alert alert-danger mb-2 fs-12" role="alert">
            <i class="fas fa-exclamation-circle me-2"></i>
            #response.message#
        </div>
    </div>
</cfif>
</cfoutput>