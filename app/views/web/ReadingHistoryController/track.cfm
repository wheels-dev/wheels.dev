<cfoutput>
<cfset response = data>
<cfif response.success>
    <div class="alert alert-success mb-2 fs-12" role="alert">
        <i class="fas fa-check-circle me-2"></i>
        #response.message#
    </div>
<cfelse>
    <div class="alert alert-danger mb-2 fs-12" role="alert">
        <i class="fas fa-exclamation-circle me-2"></i>
        #response.message#
    </div>
</cfif>
</cfoutput>
