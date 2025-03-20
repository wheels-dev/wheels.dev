<cfparam name="versions">
<cfoutput>
	<div class="container">
		<div class="well">
			<h3>CFWheels API reference</h3>
			<h4>Select Version</h4>
			<ul>
				<cfloop from="1" to="#arraylen(versions)#" index="v">
					<li>#linkTo(route="docVersion", text=versions[v], version="v" & versions[v])#</li>
				</cfloop>
			</ul>
		</div>
	</div>
</cfoutput>
