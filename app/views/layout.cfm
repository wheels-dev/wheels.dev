<!--- Place HTML here that should be used as the default layout of your application. --->
<!--- This condition prevents the content to be wrapped in HTML for the Junit, TXT and JSON formats when they are passed in the URL as "format=json","format=txt" and "format=junit" as these formats shouldn't have html wrapped around them --->

<cfset pathInfo = trim(cgi.path_info)>
<cfset isBlog = find("/blog", pathInfo)>
<cfset isApi = find("/api", pathInfo)>
<cfset isLogin = find("/login", pathInfo)>
<cfset isRegister = find("/register", pathInfo)>
<cfset isForgotPassword = find("/forgot-password", pathInfo)>
<cfset isResetPassword = find("/reset-password", pathInfo)>
<cfset isDocs = find("/docs", pathInfo) or isApi>
<cfset isCommunity = find("/community", pathInfo)>
<cfset isNews = find("/news", pathInfo) or isBlog and !find("/blog/create", pathInfo)>
<cfset isAuthPage = (isLogin OR isRegister OR isForgotPassword OR isResetPassword)>

<cfset pageTitle = "Wheels - an open source CFML framework inspired by Ruby on Rails">
<cfset ogTitle = "Wheels - an open source CFML framework inspired by Ruby on Rails">
<cfset metaDescription = "Build apps quickly with an organized, Ruby on Rails-inspired structure. Get up and running in no time!">
<cfset ogDescription = "Build apps quickly with an organized, Ruby on Rails-inspired structure. Get up and running in no time!">

<cfif isBlog>
    <cfset blogSlug = listLast(pathInfo, "/")>

    <!--- Fetch the blog post by slug --->
    <cfset post = model("Blog").findOne(where="slug = '#blogSlug#'")>

    <cfif isStruct(post) && structKeyExists(post, "id")>
		<cfset metaDescription = this.generateMetaDescription(post.content)>

        <cfset pageTitle = post.title & " - Wheels">
		<cfset ogTitle = post.title>
		<cfset ogDescription = metaDescription>
		<cfset ogImage = ''>
    <cfelse>
        <cfset pageTitle = "Blogs - Wheels">
        <cfset metaDescription = "Explore our latest blogs on Wheels.">
        <cfset ogTitle = pageTitle>
        <cfset ogDescription = metaDescription>
    </cfif>
</cfif>

<cfif isApi>
    <cfset apiPath = listLast(pathInfo, "/")>
    <cfset pageTitle = apiPath & " - Wheels API ">
</cfif>

<cfif isDocs>
	<cfset docsPath = listLast(pathInfo, "/")>
	<cfset docsPath = uCase(left(docsPath, 1)) & mid(docsPath, 2)>
	<cfset pageTitle = docsPath & " - Wheels ">
</cfif>

<cfif isCommunity>
	<cfset communityPath = listLast(pathInfo, "/")>
	<cfset communityPath = uCase(left(communityPath, 1)) & mid(communityPath, 2)>
	<cfset pageTitle = communityPath & " - Wheels ">
</cfif>

<cfif isNews>
	<cfset newsPath = listLast(pathInfo, "/")>
	<cfset newsPath = uCase(left(newsPath, 1)) & mid(newsPath, 2)>
	<cfset pageTitle = newsPath & " - Wheels ">
</cfif>

<cfif application.contentOnly>
	<cfoutput>
		#flashMessages()#
		#includeContent()#
	</cfoutput>
<cfelse>
	<!DOCTYPE html>
	<html>
		<head>
			<cfoutput>#csrfMetaTags()#</cfoutput>
			<meta charset="UTF-8">
			<meta name="viewport" content="width=device-width, initial-scale=1.0">
			<title><cfoutput>#pageTitle#</cfoutput></title>
			<link rel="icon" href="/images/favicon.ico" type="image/x-icon">
			<link rel="shortcut icon" href="/images/favicon.ico" type="image/x-icon">
			<meta name="keywords" content="cfwheels,cfml,ruby,framework">
			<cfoutput>
			<meta name="description" content="#metaDescription#">
			<meta property="og:title" content="#ogTitle#">
			<meta property="og:description" content="#ogDescription#">
			<cfif isDefined("ogImage")>
				<meta property="og:image" content="#ogImage#">
			</cfif>
			</cfoutput>
			<meta property="og:description" content="Build apps quickly with an organized, Ruby on Rails-inspired structure. Get up and running in no time!">
			<meta property="og:url" content="https://wheels.dev/">
			<meta property="og:site_name" content="Wheels">
			<!-- Bootstrap CSS -->
			<link rel="preload" href="/stylesheets/Montserrat.woff2" as="font" type="font/woff2" crossorigin="anonymous">
			<link rel="preload" href="/stylesheets/fonts/Sora-Thin.ttf" as="font" type="font/ttf" crossorigin="anonymous">
			<link rel="preload" href="/stylesheets/fonts/Sora-ExtraLight.ttf" as="font" type="font/ttf" crossorigin="anonymous">
			<link rel="preload" href="/stylesheets/fonts/Sora-Light.ttf" as="font" type="font/ttf" crossorigin="anonymous">
			<link rel="preload" href="/stylesheets/fonts/Sora-Regular.ttf" as="font" type="font/ttf" crossorigin="anonymous">
			<link rel="preload" href="/stylesheets/fonts/Sora-Medium.ttf" as="font" type="font/ttf" crossorigin="anonymous">
			<link rel="preload" href="/stylesheets/fonts/Sora-SemiBold.ttf" as="font" type="font/ttf" crossorigin="anonymous">
			<link rel="preload" href="/stylesheets/fonts/Sora-Bold.ttf" as="font" type="font/ttf" crossorigin="anonymous">

			<link href="/stylesheets/font.css" rel="stylesheet">
			<link href="/stylesheets/bootstrap.css" rel="stylesheet">
			<link href="/stylesheets/color.css" rel="stylesheet">
			<link href="/stylesheets/style.css" rel="stylesheet">
			<link href="/stylesheets/utils.css" rel="stylesheet">
			<link href="/stylesheets/swiper.css" rel="stylesheet">
			<link href="/stylesheets/quill.snow.css" rel="stylesheet">
			<link href="/stylesheets/select2.min.css" rel="stylesheet">
			<link href="/stylesheets/icons/bootstrap-icons.min.css" rel="stylesheet">
			<link href="/stylesheets/select2-bootstrap-min.css" rel="stylesheet">
			<link href="/stylesheets/notifier.min.css" rel="stylesheet">
			<link href="/stylesheets/dataTables.min.css" rel="stylesheet">

			<script src="/javascripts/echarts.min.js"></script>
			<script src="/javascripts/jquery.min.js"></script>
			<script src="/javascripts/dataTables.min.js"></script>
			<script src="/javascripts/htmx.min.js"></script>
			<script src="/javascripts/highlighter.min.js"></script>
			<script src="/javascripts/quill.min.js"></script>
			<script src="/javascripts/bootstrap.js"></script>
			<script src="/javascripts/config.js"></script>
			<cfoutput>
				#javascriptIncludeTag(source="anchor.min.js")#
				#javascriptIncludeTag(source="all.min.js")#
				#javascriptIncludeTag(source="lodash.min.js")#
				#javascriptIncludeTag(source="phoenix.js")#
			</cfoutput>

			<script>
				(function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
				(i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
				m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
				})(window,document,'script','https://www.google-analytics.com/analytics.js','ga');

				ga('create', 'UA-3914949-1', 'auto');
				ga('send', 'pageview');
			</script>
		</head>
		<body>

			<nav class="navbar <cfif isAuthPage>d-none</cfif> sticky-top shadow-sm navbar-expand-xl py-2 nav-bg">
				<div class="container">
					<a class="navbar-brand" href="/">
						<img src="/images/wheels-logo.png" alt="Bootstrap" width="200">
					</a>
					<div class="d-flex align-items-center justify-content-end flex-xl-grow-0 flex-grow-1 gap-2">
						<cfif isLoggedInUser()>
							<div class="dropdown d-xl-none d-block navHandlers">
								<a href="javascript:void(0)" class="nav-link bg--primary rounded-5 size-40 d-flex justify-content-center align-items-center" id="profilePicDropdown" data-bs-toggle="dropdown" aria-expanded="false">
									<i class="bi bi-plus-circle text--secondary fs-5 text-white"></i>
								</a>
								<ul class="dropdown-menu dropdown-menu-end" aria-labelledby="profilePicDropdown">
								<cfif hasEditorAccess()>
									<li><a class="dropdown-item fw-normal text--secondary" href="/blog/create">Add Blog</a></li>
								</cfif>
									<li><a class="dropdown-item fw-normal text--secondary" target="_blank" href="https://github.com/wheels-dev/wheels/issues">Add Issue</a></li>
									<li><a class="dropdown-item fw-normal text--secondary" target="_blank" href="https://github.com/wheels-dev/wheels/discussions/new/choose">Add Disscussion</a></li>
								</ul>
							</div>
							<div class="nav-item d-xl-none d-block dropdown navHandlers">
								<a href="javascript:void(0)" class="nav-link p-0" id="profilePicDropdown" data-bs-toggle="dropdown" aria-expanded="false">
									<cfif !structKeyExists(session, "profilePic") OR session.profilePic == "">
										<cfset session.profilePic = "avatar-rounded.webp">
									</cfif>
									<cfoutput>
										#imageTag(source = '#session.profilePic#', alt="user profile pic", height="40", width="40", class="rounded-circle")#
									</cfoutput>
								</a>
								<ul class="dropdown-menu dropdown-menu-end" aria-labelledby="profilePicDropdown">
									<!-- Profile (expandable section) -->
									<li class="dropdown-item-text fw-bold">Profile</li>
									<cfoutput>
										<li><a class="dropdown-item fw-normal ps-4" href="#urlFor(route='adminuser-changePassword')#">Change Password</a></li>
										<li><a class="dropdown-item fw-normal ps-4" href="#urlfor(route="adminUser-update-profile-pic")#">Update Profile Pic</a></li>
									</cfoutput>

									<li><hr class="dropdown-divider"></li>
									<li><a class="dropdown-item fw-normal" href="/logout">Logout</a></li>
								</ul>
							</div>
						</cfif>
						<button class="navbar-toggler" type="button" data-bs-toggle="collapse"
							data-bs-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false"
							aria-label="Toggle navigation">
							<span class="navbar-toggler-icon"></span>
						</button>
					</div>
					<div class="collapse navbar-collapse" id="navbarSupportedContent">
						<ul class="navbar-nav divide-x-primary ms-auto mb-2 mb-lg-0 align-items-center">
							<li class="nav-item px-3">
								<a class="nav-link py-2 fw-normal px-3 nav-link-hover rounded fs-16 text--secondary" aria-current="page" target="_blank" href="https://github.com/wheels-dev/wheels/releases/tag/v2.5.1">Source</a>
							</li>
							<li class="nav-item px-3">
								<a class="nav-link py-2 fw-normal px-3 nav-link-hover rounded fs-16 text--secondary <cfif isDocs>active</cfif>" aria-current="page" href="/docs">Docs</a>
							</li>
							<li class="nav-item px-3">
								<a class="nav-link py-2 fw-normal px-3 nav-link-hover rounded fs-16 text--secondary <cfif isCommunity>active</cfif>" aria-current="page" href="/community">Community</a>
							</li>
							<li class="nav-item px-3">
								<a class="nav-link py-2 fw-normal px-3 nav-link-hover rounded fs-16 text--secondary <cfif isNews>active</cfif>" aria-current="page" href="/news">News</a>
							</li>
							<cfif isCurrentUserAdmin() and isLoggedInUser()>
								<li class="nav-item px-3">
									<a class="nav-link px-3 fw-normal py-2 nav-link-hover rounded fs-16 text--secondary" aria-current="page" href="/admin">Dashboard</a>
								</li>
							</cfif>
							<cfif isLoggedInUser()>
								<li class="nav-item d-xl-block d-none dropdown px-3 mb-lg-0 mb-3 navHandlers">
									<a href="javascript:void(0)" class="nav-link bg--primary rounded-5 size-40 d-flex justify-content-center align-items-center" id="profilePicDropdown" data-bs-toggle="dropdown" aria-expanded="false">
										<i class="bi bi-plus-circle text--secondary fs-5 text-white"></i>
									</a>
									<ul class="dropdown-menu dropdown-menu-end" aria-labelledby="profilePicDropdown">
									<cfif hasEditorAccess()>
										<li><a class="dropdown-item fw-normal text--secondary" href="/blog/create">Add Blog</a></li>
									</cfif>
										<li><a class="dropdown-item fw-normal text--secondary" target="_blank" href="https://github.com/wheels-dev/wheels/issues">Add Issue</a></li>
										<li><a class="dropdown-item fw-normal text--secondary" target="_blank" href="https://github.com/wheels-dev/wheels/discussions/new/choose">Add Disscussion</a></li>
									</ul>
								</li>
								<li class="nav-item d-xl-block d-none dropdown px-3 navHandlers">
									<a href="javascript:void(0)" class="nav-link p-0" id="profilePicDropdown" data-bs-toggle="dropdown" aria-expanded="false">
										<cfif !structKeyExists(session, "profilePic") OR session.profilePic == "">
											<cfset session.profilePic = "avatar-rounded.webp">
										</cfif>
										<cfoutput>
											#imageTag(source = '#session.profilePic#', alt="user profile pic", height="40", width="40", class="rounded-circle")#
										</cfoutput>
									</a>
									<ul class="dropdown-menu dropdown-menu-end" aria-labelledby="profilePicDropdown">
										<!-- Profile (expandable section) -->
										<li class="dropdown-item-text fw-bold">Profile</li>
										<cfoutput>
											<li><a class="dropdown-item fw-normal ps-4" href="#urlFor(route='adminuser-changePassword')#">Change Password</a></li>
											<li><a class="dropdown-item fw-normal ps-4" href="#urlfor(route="adminUser-update-profile-pic")#">Update Profile Pic</a></li>
										</cfoutput>

										<li><hr class="dropdown-divider"></li>
										<li><a class="dropdown-item fw-normal" href="/logout">Logout</a></li>
									</ul>
								</li>
								<cfelse>
								<li class="nav-item px-3">
									<a class="nav-link fw-normal px-3 py-2 nav-link-hover rounded fs-16 text--secondary" aria-current="page" href="/login">
										Login
									</a>
								</li>
							</cfif>
						</ul>
					</div>
				</div>
			</nav>

			<cfoutput>
				#flashMessages()#
				#includeContent()#
			</cfoutput>

			<footer class="bg-white <cfif isAuthPage>d-none</cfif> pt-5 pb-3 border-top">
					<div class="container">
						<div class="row gy-lg-0 gy-3 gx-sm-5">
							<div class="col-lg-4">
								<img src="/images/wheels-logo.png" width="284" alt="">
								<div class="mt-3">
									<p class="fs-18 fw-semibold p-0 m-0">Let's Keep in touch</p>
									<p class="fs-12 fw-semibold">Enter your email to stay up to date with the
										latest updates from
										Wheels.Dev</p>
								</div>
								<div class="pt-3">
								<cfoutput>
									<form hx-post="#URLFor(route='newsletter-subscribe')#" hx-swap="outerHTML">
										<div class="input-group">
											#authenticityTokenField()#
											<input type="email" name="email" class="form-control form-check-input-primary py-2 rounded-2 mb-2 fs-12" placeholder="Enter your email" required>
											<button type="submit" class="text-white fw-medium py-2 fs-12 rounded-2 bg--primary w-100">Subscribe to newsletter</button>
										</div>
									</form>
								</cfoutput>
								</div>
							</div>
							<div class="col-lg-2">
								<h6 class="fw-bold fs-16 text--secondary">Docs</h6>
								<ul class="list-unstyled">
									<li class="mt-2"><a href="https://guides.cfwheels.org/cfwheels-guides/3.0.0-snapshot" target="_blank"
											class="text--secondary fs-14 text-decoration-none cursor-pointer">Introduction</a>
									</li>
									<li class="mt-2"><a href="https://github.com/wheels-dev/wheels-cli" target="_blank"
											class="text--secondary fs-14 text-decoration-none cursor-pointer">Command Line
											Tools</a></li>
									<li class="mt-2"><a href="https://github.com/wheels-dev/wheels/releases/tag/v2.5.1" target="_blank"
											class="text--secondary fs-14 text-decoration-none cursor-pointer">Download Wheels</a></li>
									<li class="mt-2"><a href="https://www.youtube.com/@wheels-dev" target="_blank"
											class="text--secondary fs-14 text-decoration-none cursor-pointer">Follow a Tutorial</a></li>
									<li class="mt-2"><a href="https://guides.cfwheels.org/cfwheels-guides" target="_blank"
											class="text--secondary fs-14 text-decoration-none cursor-pointer">Read the Guides</a></li>
									<li class="mt-2"><a href="/api/v3.0.0"
											class="text--secondary fs-14 text-decoration-none cursor-pointer">API Documentation</a></li>
									<li class="mt-2"><a href="https://github.com/wheels-dev/wheels/discussions" target="_blank"
											class="text--secondary fs-14 text-decoration-none cursor-pointer">Join the Conversation</a></li>
									<li class="mt-2"><a href="https://github.com/wheels-dev/wheels" target="_blank"
											class="text--secondary fs-14 text-decoration-none cursor-pointer">Contribute to Wheels</a></li>
								</ul>
							</div>
							<div class="col-lg-2">
								<h6 class="fw-bold fs-16 text--secondary">Meta</h6>
								<ul class="list-unstyled">
									<cfif isLoggedInUser()>
										<li class="mt-2">
											<a href="#" class="text--secondary fs-14 text-decoration-none cursor-pointer">
												<cfoutput>
													#session.username#
												</cfoutput>
											</a>
										</li>
										<li class="mt-2"><a href="/logout"
												class="text--secondary fs-14 text-decoration-none cursor-pointer">Logout</a>
										</li>
									<cfelse>
										<li class="mt-2"><a href="/login"
											class="text--secondary fs-14 text-decoration-none cursor-pointer">Login</a>
										</li>
										<li class="mt-2"><a href="/register"
												class="text--secondary fs-14 text-decoration-none cursor-pointer">Register</a>
										</li>
									</cfif>

									<li class="mt-2"><a href="/blog/feed"
											class="text--secondary fs-14 text-decoration-none cursor-pointer">RSS Blog Feed</a>
									</li>
									<li class="mt-2"><a href="/comment/feed"
											class="text--secondary fs-14 text-decoration-none cursor-pointer">RSS Comments
											Feed</a>
									</li>
									<li class="mt-2"><a href="#"
											class="text--secondary fs-14 text-decoration-none cursor-pointer"></a>
									</li>
								</ul>
							</div>
							<div class="col-lg-2">
								<h6 class="fw-bold fs-16 text--secondary">Plugins</h6>
								<ul class="list-unstyled">
									<li class="mt-2"><a href="https://www.forgebox.io/type/cfwheels-plugins" target="_blank"
											class="text--secondary fs-14 text-decoration-none cursor-pointer">Plugins</a></li>
								</ul>
							</div>
							<div class="col-lg-2">
								<h6 class="fw-bold fs-16 text--secondary">External Links</h6>
								<ul class="list-unstyled">
									<li class="mt-2"><a href="https://github.com/wheels-dev/wheels/releases/tag/v2.5.1"
											class="text--secondary fs-14 text-decoration-none cursor-pointer" target="_blank">Source
											Code</a></li>
									<li class="mt-2"><a href="https://github.com/wheels-dev/wheels/issues"
											class="text--secondary fs-14 text-decoration-none cursor-pointer" target="_blank">Issue
											Tracker</a>
									</li>
									<li class="mt-2"><a href="https://opencollective.com/wheels-dev"
											class="text--secondary fs-14 text-decoration-none cursor-pointer" target="_blank">Sponsor
											Us</a>
									</li>
									<li class="mt-2"><a href="/community"
											class="text--secondary fs-14 text-decoration-none cursor-pointer">Community</a>
									</li>
								</ul>
							</div>
						</div>
						<hr>
						<div
							class="text-muted d-flex flex-wrap gap-2 justify-content-between align-items-center">
							<div>
								<p class="p-0 m-0 fs-12 text--secondary">
										&copy; 2005-2025 Wheels.Dev. All rights are reserved.<br>
										Wheels is licensed under the Apache License, Version 3.0.
								</p>
							</div>
							<div class="d-flex justify-content-center gap-3">
								<a href="https://github.com/wheels-dev/" class="text-dark" target="_blank">
									<svg width="25" height="24" viewBox="0 0 25 24" fill="none"
										xmlns="http://www.w3.org/2000/svg">
										<path
											d="M12.2852 0.248535C10.6719 0.248535 9.07436 0.56256 7.58385 1.17268C6.09334 1.7828 4.73904 2.67707 3.59825 3.80442C1.29433 6.08121 0 9.16921 0 12.3891C0 17.7552 3.52585 22.3079 8.40307 23.9226C9.01733 24.0197 9.21389 23.6434 9.21389 23.3156V21.2638C5.8109 21.9923 5.08607 19.637 5.08607 19.637C4.52095 18.2287 3.72241 17.8523 3.72241 17.8523C2.60446 17.0996 3.80841 17.1239 3.80841 17.1239C5.03693 17.2089 5.68804 18.3744 5.68804 18.3744C6.75686 20.2197 8.56278 19.6734 9.26303 19.382C9.3736 18.5929 9.69302 18.0587 10.037 17.7552C7.30969 17.4517 4.44724 16.4076 4.44724 11.7821C4.44724 10.4345 4.91408 9.35395 5.71261 8.49197C5.58976 8.18845 5.15978 6.92584 5.83547 5.28686C5.83547 5.28686 6.86742 4.95907 9.21389 6.5252C10.1844 6.25811 11.241 6.12456 12.2852 6.12456C13.3294 6.12456 14.386 6.25811 15.3565 6.5252C17.703 4.95907 18.7349 5.28686 18.7349 5.28686C19.4106 6.92584 18.9806 8.18845 18.8578 8.49197C19.6563 9.35395 20.1231 10.4345 20.1231 11.7821C20.1231 16.4197 17.2484 17.4396 14.5088 17.7431C14.9511 18.1194 15.3565 18.86 15.3565 19.9891V23.3156C15.3565 23.6434 15.5531 24.0319 16.1796 23.9226C21.0568 22.2958 24.5704 17.7552 24.5704 12.3891C24.5704 10.7948 24.2526 9.21605 23.6352 7.7431C23.0178 6.27014 22.1129 4.93177 20.9721 3.80442C19.8313 2.67707 18.477 1.7828 16.9865 1.17268C15.496 0.56256 13.8985 0.248535 12.2852 0.248535Z"
											fill="#0C1620" />
									</svg>
								</a>
								<a href="https://github.com/wheels-dev/wheels/discussions" class="text-dark" target="_blank">
									<svg width="22" height="22" viewBox="0 0 22 22" fill="none"
										xmlns="http://www.w3.org/2000/svg">
										<path
											d="M10.5201 0.248536C8.69846 0.247922 6.90798 0.721253 5.32461 1.62202C3.74124 2.52279 2.41945 3.81999 1.48913 5.38619C0.558809 6.95238 0.0519596 8.73366 0.0183855 10.555C-0.0151887 12.3764 0.425667 14.1751 1.29764 15.7745L0.0551367 20.132C0.011417 20.285 0.0102522 20.4471 0.051768 20.6007C0.0932837 20.7543 0.175908 20.8937 0.290748 21.0039C0.405588 21.114 0.548296 21.1908 0.703512 21.2259C0.858728 21.261 1.02058 21.2531 1.17164 21.203L5.26313 19.8398C6.65763 20.6456 8.21882 21.1199 9.82592 21.2258C11.433 21.3317 13.043 21.0666 14.5312 20.4508C16.0194 19.835 17.346 18.8851 18.4084 17.6745C19.4708 16.464 20.2404 15.0253 20.6578 13.4698C21.0753 11.9142 21.1292 10.2835 20.8156 8.70372C20.5019 7.12397 19.8291 5.63754 18.849 4.35943C17.869 3.08132 16.6081 2.04579 15.1638 1.33295C13.7196 0.620115 12.1307 0.249074 10.5201 0.248536ZM7.02013 8.99854C7.02013 8.76647 7.11232 8.54391 7.27641 8.37982C7.4405 8.21572 7.66306 8.12354 7.89513 8.12354H13.1451C13.3772 8.12354 13.5997 8.21572 13.7638 8.37982C13.9279 8.54391 14.0201 8.76647 14.0201 8.99854C14.0201 9.2306 13.9279 9.45316 13.7638 9.61725C13.5997 9.78135 13.3772 9.87354 13.1451 9.87354H7.89513C7.66306 9.87354 7.4405 9.78135 7.27641 9.61725C7.11232 9.45316 7.02013 9.2306 7.02013 8.99854ZM7.89513 11.6235H11.3951C11.6272 11.6235 11.8497 11.7157 12.0138 11.8798C12.1779 12.0439 12.2701 12.2665 12.2701 12.4985C12.2701 12.7306 12.1779 12.9532 12.0138 13.1173C11.8497 13.2814 11.6272 13.3735 11.3951 13.3735H7.89513C7.66306 13.3735 7.4405 13.2814 7.27641 13.1173C7.11232 12.9532 7.02013 12.7306 7.02013 12.4985C7.02013 12.2665 7.11232 12.0439 7.27641 11.8798C7.4405 11.7157 7.66306 11.6235 7.89513 11.6235Z"
											fill="#0C1620" />
									</svg>

								</a>
								<a href="https://twitter.com/CFonWheels" class="text-dark" target="_blank">
									<svg width="25" height="24" viewBox="0 0 25 24" fill="none"
										xmlns="http://www.w3.org/2000/svg">
										<mask id="mask0_129_385" style="mask-type:luminance"
											maskUnits="userSpaceOnUse" x="0" y="0" width="25" height="24">
											<path d="M0.845703 0.248535H24.5386V23.9414H0.845703V0.248535Z"
												fill="white" />
										</mask>
										<g mask="url(#mask0_129_385)">
											<path
												d="M19.5038 1.35693H23.1373L15.2002 10.4516L24.5386 22.8295H17.2276L11.4973 15.3239L4.94795 22.8295H1.3111L9.79992 13.0985L0.845703 1.35863H8.3428L13.5146 8.21772L19.5038 1.35693ZM18.2261 20.6497H20.24L7.24278 3.42329H5.08334L18.2261 20.6497Z"
												fill="#0C1620" />
										</g>
									</svg>
								</a>
								<a href="https://www.facebook.com/cfwheels" class="text-dark" target="_blank">
									<svg width="13" height="24" viewBox="0 0 13 24" fill="none"
										xmlns="http://www.w3.org/2000/svg">
										<path
											d="M8.71454 13.8719H11.6396L12.8096 9.13336H8.71454V6.76407C8.71454 5.54389 8.71454 4.39479 11.0546 4.39479H12.8096V0.414385C12.4282 0.363446 10.9879 0.248535 9.46686 0.248535C6.29026 0.248535 4.03447 2.21149 4.03447 5.81636V9.13336H0.524414V13.8719H4.03447V23.9414H8.71454V13.8719Z"
											fill="#0C1620" />
									</svg>
								</a>
							</div>
						</div>
					</div>
				</div>
			</footer>

			<script src="/javascripts/swiper.js"></script>
			<script src="/javascripts/custom.js"></script>
			<script src="/javascripts/infinite-scroll.pkgd.min.js"></script>
			<link href="/stylesheets/select2.min.css" rel="stylesheet">
			<script src="/javascripts/select2.min.js"></script>
			<script src="/javascripts/notifier.min.js"></script>
		</body>
	</html>
</cfif>
