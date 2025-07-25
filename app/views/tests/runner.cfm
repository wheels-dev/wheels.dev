<cfif structKeyExists(url, "format") and url.format eq "json">
    <cfinclude template="../../../tests/testbox/runner.cfm">
    <cfabort>
<cfelse>
    <cfinclude template="../../../tests/testbox/runner.cfm">
</cfif>