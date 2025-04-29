<div class="error-message">
</div>

<cfif structKeyExists(rc, "errorMessage")>
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            notifier.show('Error', '#jsStringFormat(rc.errorMessage)#', 'danger', '', 5000);
        });
    </script>
</cfif>