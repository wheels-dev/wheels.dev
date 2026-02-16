<!---
	404 Handler - Page Not Found

	This template is displayed when a requested page cannot be found.
	Sets HTTP 404 status code for proper SEO and browser handling.
--->
<cfheader statuscode="404" statustext="Not Found">
<cfcontent type="text/html; charset=utf-8">

<!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<title>Page Not Found - Wheels</title>
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
				<div class="error-icon">&#128270;</div>
				<h1 class="h3 mb-3">Page Not Found</h1>
				<p class="text-muted mb-4">
					Sorry, the page you requested could not be found.<br>
					Please verify the address.
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
