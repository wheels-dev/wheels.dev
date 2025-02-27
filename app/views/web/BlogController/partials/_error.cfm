<div class="error-message">
    <cfif structKeyExists(url, "errorMessage")>
        <p>#url.errorMessage#</p>
    <cfelse>
        <p>An unexpected error has occurred. Please try again later.</p>
    </cfif>
</div>

<style>
    .error-message {
        color: red;
        background-color: #f8d7da;
        border: 1px solid #f5c6cb;
        padding: 10px;
        margin: 10px 0;
        border-radius: 5px;
    }
</style>