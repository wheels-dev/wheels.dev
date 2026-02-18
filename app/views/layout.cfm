<cfsilent>
	<!--- Place HTML here that should be used as the default layout of your application. --->
	<!--- This condition prevents the content to be wrapped in HTML for the Junit, TXT and JSON formats when they are passed in the URL as "format=json","format=txt" and "format=junit" as these formats shouldn't have html wrapped around them --->
	<cfset pathInfo = trim(cgi.path_info)>
	<cfset isHome = (pathInfo EQ "" OR pathInfo EQ "/" OR pathInfo EQ "/index.cfm")>
	<cfset isBlog = find("/blog", pathInfo)>
	<cfset isApi = find("/api", pathInfo)>
	<cfset isGuideDocs = find("/guides", pathInfo)>
	<cfset isLogin = find("/login", pathInfo)>
	<cfset isRegister = find("/register", pathInfo)>
	<cfset isForgotPassword = find("/forgot-password", pathInfo)>
	<cfset isResetPassword = find("/reset-password", pathInfo)>
	<cfset isDocs = find("/docs", pathInfo) or isApi>
	<cfset isCommunity = find("/community", pathInfo)>
	<cfset isNews = find("/news", pathInfo) or isBlog and !find("/blog/create", pathInfo)>
	<cfset isAuthPage = (isLogin OR isRegister OR isForgotPassword OR isResetPassword)>

	<cfset pageTitle = "Wheels - An open source CFML framework inspired by Ruby on Rails">
	<cfset ogTitle = "Wheels - An open source CFML framework inspired by Ruby on Rails">
	<cfset metaDescription = "Modern CFML web framework inspired by Rails. Build powerful, fast, and clean web apps with Wheels.dev's intuitive MVC architecture.">
	<cfset ogDescription = "Modern CFML web framework inspired by Rails. Build powerful, fast, and clean web apps with Wheels.dev's intuitive MVC architecture.">

	<cfif isBlog>
		<cfset blogSlug = listLast(pathInfo, "/")>
		<cfset isSingleBlogPost = (listLen(pathInfo, "/") GT 1 AND blogSlug NEQ "blog" AND blogSlug NEQ "create" AND blogSlug NEQ "feed" AND NOT find("/blog/category/", pathInfo) AND NOT find("/blog/author/", pathInfo) AND NOT find("/blog/tag/", pathInfo))>

		<!--- Use blog post data set by the controller instead of querying in the view --->
		<cfif isSingleBlogPost AND structKeyExists(request, "blogPostForMeta")>
			<cfset post = request.blogPostForMeta>
		</cfif>

		<cfif isDefined("post") AND isStruct(post) AND structKeyExists(post, "id")>
			<cfset metaDescription = this.generateMetaDescription(post.content)>

			<cfset pageTitle = post.title & " - Wheels">
			<cfset ogTitle = post.title>
			<cfset ogDescription = metaDescription>
			<cfset ogImage = "#getBaseUrl()#/img/wheels-logo.png">
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

	<cfif isGuideDocs>
		<cfif structKeyExists(url, "version")>
			<cfset version = url.version>
		<cfelse>
			<cfset version = "3.0.0">
		</cfif>
		<cfif structKeyExists(url, "filePath") AND len(trim(url.filePath))>
			<!--- Split the path and clean it up --->
			<cfset pathParts = listToArray(url.filePath, "/")>
			
			<!--- Remove any blank or readme entries --->
			<cfset cleanedParts = []>
			<cfloop array="#pathParts#" index="part">
				<cfif len(trim(part)) GT 0 AND lcase(part) NEQ "readme">
					<cfset arrayAppend(cleanedParts, part)>
				</cfif>
			</cfloop>

			<!--- Check if we have at least 1 usable segment --->
			<cfif arrayLen(cleanedParts)>
				<!--- Use last valid segment --->
				<cfset lastPart = cleanedParts[arrayLen(cleanedParts)]>
				<cfset cleanTitle = replace(lastPart, "-", " ", "all")>
				<cfset cleanTitle = reReplace(cleanTitle, "\b(\w)", "\u\1", "all")>

				<cfset pageTitle = "Wheels #cleanTitle# | App Development Guide #version#">
				<cfset metaDescription = "Wheels #cleanTitle# guide for version #version#. Learn how to implement and understand this part of the framework with practical examples.">
			<cfelse>
				<!--- Fallback if only readme or empty path --->
				<cfset pageTitle = "Getting Started with Wheels | App Development Guide #version#">
				<cfset metaDescription = "Quickly set up and build applications with the Wheels framework. This guide covers CommandBox integration, Wheels CLI, and efficient development for version #version#">
			</cfif>
		<cfelse>
			<!--- No filePath provided --->
			<cfset pageTitle = "Getting Started with Wheels | App Development Guide #version#">
			<cfset metaDescription = "Quickly set up and build applications with the Wheels framework. This guide covers CommandBox integration, Wheels CLI, and efficient development for version #version#">
		</cfif>

		<!--- Set OG tags --->
		<cfset ogTitle = pageTitle>
		<cfset ogDescription = metaDescription>
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
	
	<cfif isLogin>
		<cfset pageTitle = "Login to Your Account | Wheels.dev - CFML Framework Access">
		<cfset ogTitle = pageTitle>
		<cfset metaDescription = "Access your Wheels.dev account to manage and contribute to the community, and explore documentation. Secure login for developers.">
		<cfset ogDescription = metaDescription>
	</cfif>

	<cfif isRegister>
		<cfset pageTitle = "Sign Up for Wheels.dev | Free Account for Wheels Community">
		<cfset ogTitle = pageTitle>
		<cfset metaDescription = "Create your free account on Wheels.dev and start building web applications with our powerful CFML framework. Join the community today!">
		<cfset ogDescription = metaDescription>
	</cfif>

	<cfif isResetPassword or isForgotPassword>
		<cfset pageTitle = "Reset Your Password | Wheels.dev - CFML Web Framework">
		<cfset ogTitle = pageTitle>
		<cfset metaDescription = "Forgot your password? Quickly reset it and regain access to your Wheels.dev account, the modern CFML framework for rapid web development.">
		<cfset ogDescription = metaDescription>
	</cfif>

	<cfif find("/blog/1-1-1-released", pathInfo)>
		<cfset pageTitle = "Wheels 1.1.1 Released: Bug Fixes & Enhancements">
		<cfset ogTitle = pageTitle>
		<cfset metaDescription = "Discover the latest updates in Wheels 1.1.1, including bug fixes and improvements. Upgrade now to enhance your CFML development experience">
		<cfset ogDescription = metaDescription>
	</cfif>
	<cfif find("/api/v3.0.0", pathInfo)>
		<cfset pageTitle = "Wheels 3.0.0 API Reference | CFML Framework">
		<cfset ogTitle = pageTitle>
		<cfset metaDescription = "Explore the comprehensive Wheels 3.0.0 API documentation—your go-to resource for mastering CFML development with detailed functions, examples, and best practices.">
		<cfset ogDescription = metaDescription>
	</cfif>
	<cfif find("/api/v3.0.0/migration.addForeignKey", pathInfo)>
		<cfset pageTitle = "Wheels 3.0: addForeignKey Migration Guide">
		<cfset ogTitle = pageTitle>
		<cfset metaDescription = "Master foreign key constraints in Wheels 3.0 with the addForeignKey function. Learn how to link tables effectively in your CFML applications.">
		<cfset ogDescription = metaDescription>
	</cfif>
	<cfif find("/api/v3.0.0/migration.addColumn", pathInfo)>
		<cfset pageTitle = "Wheels 3.0: addColumn Migration Function">
		<cfset ogTitle = pageTitle>
		<cfset metaDescription = "Learn how to use the addColumn function in Wheels 3.0 to add new columns to your database tables with ease. Enhance your CFML applications today.">
		<cfset ogDescription = metaDescription>
	</cfif>
	<cfif find("/api/v3.0.0/model.accessibleProperties", pathInfo)>
		<cfset pageTitle = "Wheels 3.0: accessible Properties Explained">
		<cfset ogTitle = pageTitle>
		<cfset metaDescription = "Understand how to use accessibleProperties in Wheels 3.0 to manage model property accessibility. Enhance your CFML application's security and flexibility.">
		<cfset ogDescription = metaDescription>
	</cfif>
	<cfif find("/community", pathInfo)>
		<cfset pageTitle = "Join the Wheels CFML Community">
		<cfset ogTitle = pageTitle>
		<cfset metaDescription = "Connect with developers on Wheels.dev. Join our Slack, contribute on GitHub, and collaborate with the Core team to enhance the Wheels framework.">
		<cfset ogDescription = metaDescription>
	</cfif>
	<cfif find("/api/v3.0.0/controller.controller", pathInfo)>
		<cfset pageTitle = "Wheels 3.0: controller() Function Guide">
		<cfset ogTitle = pageTitle>
		<cfset metaDescription = "Explore the controller() function in Wheels 3.0 to create controller instances with custom names and parameters. Ideal for testing and dynamic routing.">
		<cfset ogDescription = metaDescription>
	</cfif>
	<cfif find("/news", pathInfo)>
		<cfset pageTitle = "Latest News & Updates | Wheels CFML Framework">
		<cfset ogTitle = pageTitle>
		<cfset metaDescription = "Stay informed with the latest Wheels CFML framework news, including version releases, tutorials, and community updates to enhance your development journey.">
		<cfset ogDescription = metaDescription>
	</cfif>
	<cfif find("/api/v3.0.0/model.addError", pathInfo)>
		<cfset pageTitle = "Wheels 3.0: addError Function Guide">
		<cfset ogTitle = pageTitle>
		<cfset metaDescription = "Learn how to use the addError function in Wheels 3.0 to add validation errors to your models. Enhance data integrity and user feedback in your CFML applications.">
		<cfset ogDescription = metaDescription>
	</cfif>
	<cfif find("/api/v3.0.0/model.addErrorToBase", pathInfo)>
		<cfset pageTitle = "Wheels 3.0: addErrorToBase Function Guide">
		<cfset ogTitle = pageTitle>
		<cfset metaDescription = "Learn how to use addErrorToBase in CFWheels 3.0 to add model-level validation errors. Enhance your CFML application's data integrity and user feedback.">
		<cfset ogDescription = metaDescription>
	</cfif>
	<cfif find("/api/v3.0.0/controller.model", pathInfo)>
		<cfset pageTitle = "Wheels 3.0: model() Function Overview">
		<cfset ogTitle = pageTitle>
		<cfset metaDescription = "Explore how to use the model() function in Wheels 3.0 to interact with your application's models efficiently. Enhance your CFML development skills today.">
		<cfset ogDescription = metaDescription>
	</cfif>
	<cfif find("/docs", pathInfo)>
		<cfset pageTitle = "Wheels Documentation | Framework Guide">
		<cfset ogTitle = pageTitle>
		<cfset metaDescription = "Explore comprehensive guides, tutorials, and API references for the Wheels framework. Start building modern web applications with ease.">
		<cfset ogDescription = metaDescription>
	</cfif>
	<cfif find("/blog/version-1-1-2-released-today", pathInfo)>
		<cfset pageTitle = "Wheels 1.1.2 Released: Bug Fixes & Enhancem">
		<cfset ogTitle = pageTitle>
		<cfset metaDescription = "Discover the latest updates in Wheels 1.1.2, including bug fixes and improvements. Upgrade now to enhance your CFML development experience.">
		<cfset ogDescription = metaDescription>
	</cfif>
	<cfif find("/blog/cfwheels-1-4-2-maintenance-release", pathInfo)>
		<cfset pageTitle = "Wheels 1.4.2 Maintenance Release: Bug Fixes">
		<cfset ogTitle = pageTitle>
		<cfset metaDescription = "Explore the Wheels 1.4.2 maintenance release, addressing bugs and improving functionality. Download now to enhance your CFML development experience.">
		<cfset ogDescription = metaDescription>
	</cfif>
	<cfif find("/blog/cfwheels-1-4-3-maintenance-release", pathInfo)>
		<cfset pageTitle = "Wheels 1.4.3 Maintenance Release: Bug Fixes">
		<cfset ogTitle = pageTitle>
		<cfset metaDescription = "Explore the Wheels 1.4.3 maintenance release, featuring bug fixes and improvements. Download now to enhance your CFML development experience.">
		<cfset ogDescription = metaDescription>
	</cfif>
	<cfif find("/blog/cfwheels-1-4-4-maintenance-release", pathInfo)>
		<cfset pageTitle = "Wheels 1.4.4 Maintenance Release: Bug Fixes">
		<cfset ogTitle = pageTitle>
		<cfset metaDescription = "Explore the Wheels 1.4.4 maintenance release, featuring bug fixes and improvements. Download now to enhance your CFML development experience.">
		<cfset ogDescription = metaDescription>
	</cfif>
	<cfif find("/blog/cfwheels-1-4-5-maintenance-release", pathInfo)>
		<cfset pageTitle = "Wheels 1.4.5 Maintenance Release: Bug Fixes">
		<cfset ogTitle = pageTitle>
		<cfset metaDescription = "Explore the Wheels 1.4.5 maintenance release, featuring bug fixes and improvements. Download now to enhance your CFML development experience.">
		<cfset ogDescription = metaDescription>
	</cfif>
</cfsilent>

<cfif application.contentOnly>
	<cfoutput>
		#flashMessages()#
		#includeContent()#
	</cfoutput>
<cfelse>
	<!DOCTYPE html>
	<html lang="en">
		<head>
			<cfoutput>#csrfMetaTags()#</cfoutput>
			<meta charset="UTF-8">
			<meta name="viewport" content="width=device-width, initial-scale=1.0">
			<title><cfoutput>#encodeForHTML(pageTitle)#</cfoutput></title>
			<link rel="icon" href="/img/favicon.ico" type="image/x-icon">
			<link rel="shortcut icon" href="/img/favicon.ico" type="image/x-icon">
			<meta name="keywords" content="cfwheels,cfml,ruby,framework">
			<cfoutput><meta name="description" content="#encodeForHTMLAttribute(metaDescription)#">
			<!--- Open Graph Tags --->
			<meta property="og:title" content="#encodeForHTMLAttribute(ogTitle)#">
			<meta property="og:description" content="#encodeForHTMLAttribute(ogDescription)#">
			<meta property="og:type" content="<cfif isBlog>article<cfelse>website</cfif>">
			<meta property="og:url" content="#encodeForHTMLAttribute(getBaseUrl() & cgi.path_info)#<cfif len(cgi.query_string)>?#encodeForHTMLAttribute(cgi.query_string)#</cfif>">
			<meta property="og:site_name" content="Wheels">
			<cfif isDefined("ogImage")><meta property="og:image" content="#ogImage#"><cfelse><meta property="og:image" content="#getBaseUrl()#/images/wheels-logo.png"></cfif>
			<meta property="og:locale" content="en_US">
			<link rel="canonical" href="#encodeForHTMLAttribute(getBaseUrl() & cgi.path_info)#<cfif len(cgi.query_string)>?#encodeForHTMLAttribute(cgi.query_string)#</cfif>">
			<link rel="alternate" hreflang="en" href="#getBaseUrl()##cgi.path_info#">
			</cfoutput>

			<script type="application/ld+json"><cfoutput>
			{
				"@context": "https://schema.org",
				"@type": "Organization",
				"name": "Wheels.dev",
				"url": "https://wheels.dev",
				"logo": "https://wheels.dev/img/wheels-logo.png",
				"description": "Modern CFML web framework inspired by Rails. Build powerful, fast, and clean web apps with Wheels.dev's intuitive MVC architecture.",
				"sameAs": [
					"https://github.com/wheels-dev/wheels",
					"https://twitter.com/CFonWheels",
					"https://www.facebook.com/cfwheels",
					"https://github.com/wheels-dev/wheels/discussions"
				]
			}
			</cfoutput></script>

			<script type="application/ld+json"><cfoutput>
			{
				"@context": "https://schema.org",
				"@type": "WebSite",
				"name": "Wheels.dev",
				"url": "https://wheels.dev",
				"potentialAction": {
					"@type": "SearchAction",
					"target": "https://wheels.dev/search?q={search_term_string}",
					"query-input": "required name=search_term_string"
				}
			}
			</cfoutput></script>
			<cfif isBlog and isDefined("post") and isStruct(post) and structKeyExists(post, "id")><script type="application/ld+json"><cfoutput>
			{
				"@context": "https://schema.org",
				"@type": "BlogPosting",
				"headline": "#encodeForJavaScript(post.title)#",
				"description": "#encodeForJavaScript(metaDescription)#",
				"image": "<cfif isDefined("ogImage")>#ogImage#<cfelse>#getBaseUrl()#/img/wheels-logo.png</cfif>",
				"datePublished": "#dateFormat(post.postDate, "yyyy-mm-dd")#",
				"dateModified": "#dateFormat(post.updatedAt, "yyyy-mm-dd")#",
				"author": {
					"@type": "Person",
					"name": "#post.user.fullName#"
				},
				"publisher": {
					"@type": "Organization",
					"name": "Wheels.dev",
					"logo": {
						"@type": "ImageObject",
						"url": "https://wheels.dev/img/wheels-logo.png"
					}
				},
				"mainEntityOfPage": {
					"@type": "WebPage",
					"@id": "#encodeForJavaScript(getBaseUrl() & cgi.path_info)#"
				}
			}
			</cfoutput></script></cfif>

			<cfif isDocs><script type="application/ld+json"><cfoutput>
			{
				"@context": "https://schema.org",
				"@type": "SoftwareSourceCode",
				"name": "Wheels.dev",
				"alternateName": "Wheels",
				"url": "https://wheels.dev",
				"codeRepository": "https://github.com/wheels-dev/wheels",
				"license": "https://opensource.org/license/apache-2-0",
				"version": "3.0.0",
				"programmingLanguage": {
					"@type": "ComputerLanguage",
					"name": "CFML",
					"url": "https://en.wikipedia.org/wiki/ColdFusion_Markup_Language"
				},
				"isAccessibleForFree": true,
				"description": "Wheels.dev is a free, open-source web application framework for CFML, inspired by Ruby on Rails. It offers a modern MVC structure, clean syntax, and developer-friendly features to rapidly build maintainable web applications.",
				"keywords": [
					"CFML",
					"ColdFusion",
					"MVC Framework",
					"Web Development",
					"Open Source",
					"Wheels.dev",
					"CFWheels"
				],
				"dateCreated": "2005-01-01",
				"dateModified": "2025-06-03",
				"creator": {
					"@type": "Organization",
					"name": "Wheels Community",
					"url": "https://wheels.dev"
				},
				"targetProduct": {
					"@type": "SoftwareApplication",
					"name": "CFML Framework",
					"operatingSystem": "Cross-platform",
					"applicationCategory": "Web development",
					"aggregateRating": {
						"@type": "AggregateRating",
						"ratingValue": "4.9",
						"reviewCount": "100"
					},
					"offers": {
						"@type": "Offer",
						"price": "0.00",
						"priceCurrency": "USD"
					}
				}
			}
			</cfoutput></script></cfif>

			<script type="application/ld+json"><cfoutput>
			{
				"@context": "https://schema.org",
				"@type": "BreadcrumbList",
				"itemListElement": [
					{
						"@type": "ListItem",
						"position": 1,
						"name": "Home",
						"item": "https://wheels.dev"
					}
					<cfif isBlog>
					,{
						"@type": "ListItem",
						"position": 2,
						"name": "Blog",
						"item": "https://wheels.dev/blog"
					}
					<cfif isDefined("post") and isStruct(post) and structKeyExists(post, "id")>
					,{
						"@type": "ListItem",
						"position": 3,
						"name": "#encodeForJavaScript(post.title)#",
						"item": "#encodeForJavaScript(getBaseUrl() & cgi.path_info)#"
					}
					</cfif>
					<cfelseif isApi>
					,{
						"@type": "ListItem",
						"position": 2,
						"name": "API",
						"item": "https://wheels.dev/api"
					}
					,{
						"@type": "ListItem",
						"position": 3,
						"name": "#encodeForJavaScript(apiPath)#",
						"item": "#encodeForJavaScript(getBaseUrl() & cgi.path_info)#"
					}
					<cfelseif isDocs>
					,{
						"@type": "ListItem",
						"position": 2,
						"name": "Documentation",
						"item": "https://wheels.dev/docs"
					}
					,{
						"@type": "ListItem",
						"position": 3,
						"name": "#encodeForJavaScript(docsPath)#",
						"item": "#encodeForJavaScript(getBaseUrl() & cgi.path_info)#"
					}
					</cfif>
				]
			}
			</cfoutput></script>

			<link rel="preload" href="/css/Montserrat.woff2" as="font" type="font/woff2" crossorigin="anonymous">
			<link rel="preload" href="/css/fonts/Sora-Thin.ttf" as="font" type="font/ttf" crossorigin="anonymous">
			<link rel="preload" href="/css/fonts/Sora-ExtraLight.ttf" as="font" type="font/ttf" crossorigin="anonymous">
			<link rel="preload" href="/css/fonts/Sora-Light.ttf" as="font" type="font/ttf" crossorigin="anonymous">
			<link rel="preload" href="/css/fonts/Sora-Regular.ttf" as="font" type="font/ttf" crossorigin="anonymous">
			<link rel="preload" href="/css/fonts/Sora-Medium.ttf" as="font" type="font/ttf" crossorigin="anonymous">
			<link rel="preload" href="/css/fonts/Sora-SemiBold.ttf" as="font" type="font/ttf" crossorigin="anonymous">
			<link rel="preload" href="/css/fonts/Sora-Bold.ttf" as="font" type="font/ttf" crossorigin="anonymous">

			<link href="/css/bootstrap.css" rel="stylesheet">
			<link href="/css/style.css" rel="stylesheet">
			<link href="/css/swiper.css" rel="stylesheet">
			<link href="/css/icons/bootstrap-icons.min.css" rel="stylesheet">
			<link href="/css/notifier.min.css" rel="stylesheet">
			<cfif !isHome>
			<link href="/css/quill.snow.css" rel="stylesheet">
			<link href="/css/select2-bootstrap-min.css" rel="stylesheet">
			<link href="/css/select2.min.css" rel="stylesheet">
			<link rel="stylesheet" href="/css/lib/easymde.min.css">
			</cfif>

			<script src="/js/jquery.min.js"></script>
			<script src="/js/htmx.min.js"></script>
			<script src="/js/highlighter.min.js"></script>
			<script src="/js/bootstrap.js"></script>
			<script src="/js/all.min.js"></script>
			<cfif isBlog or isNews or isGuideDocs>
			<script src="/js/lunr.min.js"></script>
			<script src="/js/quill.min.js"></script>
			<script src="/js/lib/easymde.min.js"></script>
			<script src="/js/lib/marked.min.js"></script>			
			<script src="/js/select2.min.js"></script>
			</cfif>

			<script>
				(function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
				(i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
				m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
				})(window,document,'script','https://www.google-analytics.com/analytics.js','ga');

				ga('create', 'UA-3914949-1', 'auto');
				ga('send', 'pageview');
			</script>
		</head>
		<cfoutput><body data-scope="#encodeForHTMLAttribute(cgi.path_info)#"></cfoutput>

			<nav class="navbar <cfif isAuthPage>d-none</cfif> sticky-top shadow-sm navbar-expand-xl py-2 nav-bg">
				<div class="container">
					<a class="navbar-brand" href="/">
						<img src="/img/wheels-logo.png" alt="Wheels.dev Logo" width="200">
					</a>
					<div class="d-flex align-items-center justify-content-end flex-xl-grow-0 flex-grow-1 gap-2">
						<cfif isLoggedInUser()>
							<div class="dropdown d-xl-none d-block navHandlers">
								<a href="javascript:void(0)" class="nav-link bg--primary rounded-5 size-40 d-flex justify-content-center align-items-center" id="profilePicDropdown" data-bs-toggle="dropdown" aria-expanded="false">
									<i class="bi bi-plus-circle text--secondary fs-5 text-white"></i>
								</a>
								<ul class="dropdown-menu dropdown-menu-end" aria-labelledby="profilePicDropdown">
								<cfif hasEditorAccess()>
									<cfoutput>
										<li><a class="dropdown-item fw-normal text--secondary" href="#urlFor(route='blog-create')#">Add a Blog</a></li>
									</cfoutput>
								</cfif>
									<li><a class="dropdown-item fw-normal text--secondary" target="_blank" href="https://github.com/wheels-dev/wheels/issues/new/choose">Report an issue</a></li>
									<li><a class="dropdown-item fw-normal text--secondary" target="_blank" href="https://github.com/wheels-dev/wheels/discussions/new/choose">Start new Disscussion</a></li>
								</ul>
							</div>
							<div class="nav-item d-xl-none d-block dropdown navHandlers">
								<a href="javascript:void(0)" class="nav-link p-0" id="profilePicDropdown" data-bs-toggle="dropdown" aria-expanded="false">
									<cfoutput>
										<img src="#gravatarUrl(session.email, 80)#"
											class="rounded-circle"
											style="width:2.5rem; height:2.5rem;"
											onerror="this.style.display='none';this.nextElementSibling.style.display='flex';"
											alt="avatar">
										<div style="display:none;width:2.5rem;height:2.5rem;"
											class="align-items-center justify-content-center #getAvatarColorByLetter(ucase(left(listLast(session.username, ' '), 1)))# text-white rounded-circle fw-bold text-uppercase">
											#ucase(left(listLast(session.username, " "), 1))#
										</div>
									</cfoutput>
								</a>
								<ul class="dropdown-menu dropdown-menu-end" aria-labelledby="profilePicDropdown">
									<!-- Profile (expandable section) -->
									<li class="dropdown-item-text fw-bold">Profile</li>
									<cfoutput>
										<li><a class="dropdown-item fw-normal ps-4" href="#urlFor(route='adminuser-changePassword')#">Change Password</a></li>
										<li><a class="dropdown-item fw-normal ps-4" href="https://gravatar.com" target="_blank" rel="noopener noreferrer">Update Profile Pic</a></li>
										<li><a class="dropdown-item fw-normal ps-4" href="#urlFor(route='readingHistory')#">Reading History</a></li>
										<li><a class="dropdown-item fw-normal ps-4" href="#urlFor(route='bookmarks')#">Bookmarks</a></li>
										
									</cfoutput>
								</ul>
							</div>
						</cfif>
					</div>
					<cfoutput><button class="navbar-toggler d-xl-none border-0" type="button" data-bs-toggle="collapse"
						data-bs-target="##navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false"
						aria-label="Toggle navigation">
						<span class="navbar-toggler-icon"></span>
					</button></cfoutput>
					<div class="collapse navbar-collapse" id="navbarSupportedContent">
						<ul class="navbar-nav divide-x-primary ms-auto mb-2 mb-lg-0 align-items-center">
							<cfoutput>
							<li class="nav-item px-3">
								<a class="nav-link py-2 fw-normal px-3 nav-link-hover rounded fs-16 text--secondary" aria-current="page" target="_blank" href="https://github.com/wheels-dev/wheels/releases">Source</a>
							</li>
							<li class="nav-item px-3">
								<a class="nav-link py-2 fw-normal px-3 nav-link-hover rounded fs-16 text--secondary <cfif isDocs or isGuideDocs>active</cfif>" aria-current="page" href="#urlFor(route='docs')#">Docs</a>
							</li>
							<li class="nav-item px-3">
								<a class="nav-link py-2 fw-normal px-3 nav-link-hover rounded fs-16 text--secondary <cfif isCommunity>active</cfif>" aria-current="page" href="#urlFor(route='community')#">Community</a>
							</li>
							<li class="nav-item px-3">
								<a class="nav-link py-2 fw-normal px-3 nav-link-hover rounded fs-16 text--secondary <cfif isNews>active</cfif>" aria-current="page" href="#urlFor(route='news')#">News</a>
							</li>
							<cfif isCurrentUserAdmin() and isLoggedInUser()>
								<li class="nav-item px-3">
									<a class="nav-link px-3 fw-normal py-2 nav-link-hover rounded fs-16 text--secondary" aria-current="page" href="#urlFor(route='adminDashboard')#">Dashboard</a>
								</li>
							</cfif>
							<cfif isLoggedInUser()>
								<li class="nav-item d-xl-block d-none dropdown px-3 mb-lg-0 mb-3 navHandlers">
									<a href="javascript:void(0)" class="nav-link bg--primary rounded-5 size-40 d-flex justify-content-center align-items-center" id="profilePicDropdown" data-bs-toggle="dropdown" aria-expanded="false">
										<i class="bi bi-plus-circle text--secondary fs-5 text-white"></i>
									</a>
									<ul class="dropdown-menu dropdown-menu-end" aria-labelledby="profilePicDropdown">
									<cfif hasEditorAccess()>
										<li><a class="dropdown-item fw-normal text--secondary" href="#urlFor(route='blog-create')#">Add a Blog</a></li>
									</cfif>
										<li><a class="dropdown-item fw-normal text--secondary" target="_blank" href="https://github.com/wheels-dev/wheels/issues/new/choose">Report an issue</a></li>
										<li><a class="dropdown-item fw-normal text--secondary" target="_blank" href="https://github.com/wheels-dev/wheels/discussions/new/choose">Start new Disscussion</a></li>
									</ul>
								</li>
								<li class="nav-item d-xl-block d-none dropdown px-3 navHandlers">
									<a href="javascript:void(0)" class="nav-link p-0" id="profilePicDropdown" data-bs-toggle="dropdown" aria-expanded="false">
										<cfoutput>
											<img src="#gravatarUrl(session.email, 80)#"
												class="rounded-circle"
												style="width:2.5rem; height:2.5rem;"
												onerror="this.style.display='none';this.nextElementSibling.style.display='flex';"
												alt="avatar">
											<div style="display:none;width:2.5rem;height:2.5rem;"
												class="align-items-center justify-content-center #getAvatarColorByLetter(ucase(left(listLast(session.username, ' '), 1)))# text-white rounded-circle fw-bold text-uppercase">
												#ucase(left(listLast(session.username, " "), 1))#
											</div>
										</cfoutput>
									</a>
									<ul class="dropdown-menu dropdown-menu-end" aria-labelledby="profilePicDropdown">
										<!-- Profile (expandable section) -->
										<li class="dropdown-item-text fw-bold">Profile</li>
										<cfoutput>
											<li><a class="dropdown-item fw-normal ps-4" href="#urlFor(route='adminuser-changePassword')#">Change Password</a></li>
											<li><a class="dropdown-item fw-normal ps-4" href="https://gravatar.com" target="_blank" rel="noopener noreferrer">Update Profile Pic</a></li>
											<li><hr class="dropdown-divider"></li>
											<li><a class="dropdown-item fw-normal ps-4" href="#urlFor(route='readingHistory')#">Reading History</a></li>
											<li><hr class="dropdown-divider"></li>
											<li><a class="dropdown-item fw-normal ps-4" href="#urlFor(route='bookmarks')#">Bookmarks</a></li>
										</cfoutput>

										<li><hr class="dropdown-divider"></li>
										<li><a class="dropdown-item fw-normal" href="#urlFor(route='auth-logout')#">Logout</a></li>
									</ul>
								</li>
								<cfelse>
								<li class="nav-item px-3">
									<a class="nav-link fw-normal px-3 py-2 nav-link-hover rounded fs-16 text--secondary" aria-current="page" href="#urlFor(route='auth-login')#">
										Login
									</a>
								</li>
							</cfif>
							</cfoutput>
						</ul>
					</div>
				</div>
			</nav>
			<script src="/js/notifier.min.js"></script>
			<cfoutput>
				<cfif flashMessages() neq "">
					<script>
						const html = '#jsStringFormat(flashMessages())#';
					</script>
					<script src="/js/flashMessage.js"></script>
				</cfif>
				#includeContent()#
			</cfoutput>

			<footer class="bg-white <cfif isAuthPage>d-none</cfif> pt-5 pb-3 border-top">
					<div class="container">
						<div class="row gy-lg-0 gy-3 gx-sm-5">
							<div class="col-lg-4">
								<img src="/img/wheels-logo.png" width="284" alt="wheels.dev Logo">
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
							<div class="col-lg-2 text-lg-start text-center">
								<h6 class="fw-bold fs-16 text--secondary">Docs</h6>
								<ul class="list-unstyled">
									<li class="mt-2"><a href="/3.0.0/guides/introduction/frameworks-and-wheels" target="_blank"
											class="text--secondary fs-14 text-decoration-none cursor-pointer">Introduction</a>
									</li>
									<li class="mt-2"><a href="/3.0.0/guides/command-line-tools/cli-overview" target="_blank"
											class="text--secondary fs-14 text-decoration-none cursor-pointer">Command Line
											Tools</a></li>
									<li class="mt-2"><a href="https://www.youtube.com/@wheels-dev" target="_blank"
											class="text--secondary fs-14 text-decoration-none cursor-pointer">Follow a Tutorial</a></li>
									<li class="mt-2"><a href="/guides" target="_blank"
											class="text--secondary fs-14 text-decoration-none cursor-pointer">Read the Guides</a></li>
									<li class="mt-2"><cfoutput><a href="#urlFor(route='docVersion', version='v3.0.0')#"
											class="text--secondary fs-14 text-decoration-none cursor-pointer">API Documentation</a></cfoutput></li>
									<li class="mt-2"><a href="https://github.com/wheels-dev/wheels/discussions" target="_blank"
											class="text--secondary fs-14 text-decoration-none cursor-pointer">Join the Conversation</a></li>
									<li class="mt-2"><a href="https://github.com/wheels-dev/wheels" target="_blank"
											class="text--secondary fs-14 text-decoration-none cursor-pointer">Contribute to Wheels</a></li>
								</ul>
							</div>
							<div class="col-lg-2 text-lg-start text-center">
								<h6 class="fw-bold fs-16 text--secondary">Meta</h6>
								<ul class="list-unstyled">
									<cfoutput>
									<cfif isLoggedInUser()>
										<li class="mt-2">
											<a class="text--secondary fs-14 text-decoration-none cursor-pointer">
												<cfoutput>#session.username#</cfoutput>
											</a>
										</li>
										<li class="mt-2"><a href="#urlFor(route ='auth-logout')#"
												class="text--secondary fs-14 text-decoration-none cursor-pointer">Logout</a>
										</li>
									<cfelse>
										<li class="mt-2"><a href="#urlFor(route='auth-login')#"
											class="text--secondary fs-14 text-decoration-none cursor-pointer">Login</a>
										</li>
										<li class="mt-2"><a href="#urlFor(route='auth-register')#"
												class="text--secondary fs-14 text-decoration-none cursor-pointer">Register</a>
										</li>
									</cfif>

									<li class="mt-2"><a href="#urlFor(route='blogFeed')#"
											class="text--secondary fs-14 text-decoration-none cursor-pointer">RSS Blog Feed</a>
									</li>
									<li class="mt-2"><a href="#urlFor(route='commentFeed')#"
											class="text--secondary fs-14 text-decoration-none cursor-pointer">RSS Comments
											Feed</a>
									</li>
									<li class="mt-2"><a
											class="text--secondary fs-14 text-decoration-none cursor-pointer"></a>
									</li>
									</cfoutput>
								</ul>
							</div>
							<div class="col-lg-2 text-lg-start text-center">
								<h6 class="fw-bold fs-16 text--secondary">Plugins</h6>
								<ul class="list-unstyled">
									<li class="mt-2"><a href="https://www.forgebox.io/type/cfwheels-plugins" target="_blank"
											class="text--secondary fs-14 text-decoration-none cursor-pointer">Plugins</a></li>
								</ul>
								<h6 class="fw-bold fs-16 text--secondary">Downloads</h6>
								<cfoutput>
									<ul class="list-unstyled">
										<li class="mt-2"><a href="#urlFor(route='downloads')#"
											class="text--secondary fs-14 text-decoration-none cursor-pointer">Download Wheels
											</a></li>
										<li class="mt-2"><a href="https://marketplace.visualstudio.com/items?itemName=wheels-dev.wheels-vscode" target="_blank"
											class="text--secondary fs-14 text-decoration-none cursor-pointer">VS Code Extension</a></li>
									</ul>
								</cfoutput>
							</div>
							<div class="col-lg-2 text-lg-start text-center">
								<h6 class="fw-bold fs-16 text--secondary">External Links</h6>
								<ul class="list-unstyled">
									<li class="mt-2"><a href="https://github.com/wheels-dev/wheels/releases"
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
									<cfoutput>
										<li class="mt-2"><a href="#urlFor(route='community')#"
												class="text--secondary fs-14 text-decoration-none cursor-pointer">Community</a>
										</li>
									</cfoutput>
								</ul>
							</div>
						</div>
						<hr>
						<div
							class="text-muted d-flex flex-wrap gap-2 justify-content-lg-between justify-content-center align-items-center">
							<div>
								<p class="p-0 m-0 fs-12 text--secondary text-lg-start text-center">
										&copy; 2005-<cfoutput>#Year(Now())#</cfoutput> Wheels.Dev. All rights are reserved.<br>
										Wheels is licensed under the Apache License, Version 2.0.
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
			<script src="/js/swiper.js"></script>
			<script src="/js/infinite-scroll.pkgd.min.js"></script>
			<script src="/js/global.js"></script>
			<script>
				// Convert UTC dates to local timezone for elements with data-utc attribute
				document.addEventListener("DOMContentLoaded", function() {
					var utcElements = document.querySelectorAll('[data-utc]');
					utcElements.forEach(function(el) {
						var utcDate = el.getAttribute('data-utc');
						if (utcDate) {
							var date = new Date(utcDate);
							if (!isNaN(date.getTime())) {
								el.textContent = date.toLocaleString();
							}
						}
					});
				});
			</script>
		</body>
	</html>
</cfif>