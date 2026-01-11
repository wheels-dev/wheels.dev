<!---
	Error Handler - Production Mode

	This template is displayed when an error occurs in production mode.
	Sets HTTP 500 status code so load balancers can detect unhealthy backends.

	Error Capture Flow:
	1. ErrorService.captureException() sends error to Sentry
	2. User sees friendly error page below
--->
<cfscript>
// Capture error to Sentry via ErrorService
// This runs silently - failures don't affect the error page display

try {
	// Wheels passes exception as local 'exception' variable
	if (isDefined('exception') && isStruct(exception)) {
		errorService = new app.models.services.ErrorService();

		// Build context from request scope
		errorContext = {
			request = {
				url = cgi.REQUEST_URL,
				httpMethod = cgi.REQUEST_METHOD
			}
		};

		// Add controller/action if available in params
		if (structKeyExists(variables, "params")) {
			if (structKeyExists(params, "controller")) {
				errorContext.request.controller = params.controller;
			}
			if (structKeyExists(params, "action")) {
				errorContext.request.action = params.action;
			}
		}

		// Add user context if available from session
		if (structKeyExists(session, "USERID") && len(session.USERID)) {
			errorContext.user = {
				id = session.USERID
			};
			if (structKeyExists(session, "email")) {
				errorContext.user.email = session.email;
			}
			if (structKeyExists(session, "role")) {
				errorContext.user.role = session.role;
			}
		}

		// Capture the exception - ErrorService handles Sentry submission
		errorService.captureException(
			exception = exception,
			context = errorContext
		);
	}
} catch (any e) {
	// Log failure silently to application log - don't break error page
	writeLog(file="application", text="ErrorService.captureException failed: #e.message#", type="error");
}
</cfscript>

<cfheader statuscode="500" statustext="Internal Server Error">
<cfcontent type="text/html; charset=utf-8">

<!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<title>Error - Wheels</title>
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
	<style>
		body {
			background-color: #f8f9fa;
			min-height: 100vh;
			display: flex;
			align-items: center;
			justify-content: center;
		}
		.error-card {
			max-width: 500px;
			text-align: center;
		}
		.error-icon {
			font-size: 4rem;
			margin-bottom: 1rem;
		}
	</style>
</head>
<body>
	<div class="container">
		<div class="card error-card shadow-sm mx-auto">
			<div class="card-body p-5">
				<div class="error-icon">&#9888;</div>
				<h1 class="h3 mb-3">Something went wrong</h1>
				<p class="text-muted mb-4">
					Sorry, that caused an unexpected error.<br>
					Please try again later.
				</p>
				<div class="d-flex gap-2 justify-content-center">
					<a href="/" class="btn btn-primary">Return Home</a>
					<button onclick="history.back()" class="btn btn-outline-secondary">Go Back</button>
				</div>
			</div>
		</div>
	</div>
</body>
</html>
