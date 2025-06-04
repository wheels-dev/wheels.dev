<cfif structKeyExists(url, "errorMessage")>
    <script>
        document.addEventListener("DOMContentLoaded", function () {
            notifier.show("Error!", "#jsStringFormat(url.errorMessage)#", "", "/img/high_priority-48.png", 0);
        });
    </script>
<cfelse>
    <script>
        document.addEventListener("DOMContentLoaded", function () {
            notifier.show("Error!", "An unexpected error has occurred. Please try again later.", "", "/img/high_priority-48.png", 0);
        });
    </script>
</cfif>