<html lang="en">
<head>
    <cfoutput>#csrfMetaTags()#</cfoutput>
    <meta charset="UTF-8">
    <title>Admin Panel</title>
    <mta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="icon" href="/img/favicon.ico" type="image/x-icon">		
	<link rel="shortcut icon" href="/img/favicon.ico" type="image/x-icon">
    <!-- Bootstrap CSS -->
    <link href="/css/font.css" rel="stylesheet">
    <link href="/css/icons/bootstrap-icons.min.css" rel="stylesheet">
    <script src="/js/bootstrap.js" type="text/javascript"></script>
    <link rel="stylesheet" href="https://unicons.iconscout.com/release/v4.0.8/css/line.css">
    <link href="/css/bootstrap.css" rel="stylesheet">
    <link href="/css/color.css" rel="stylesheet">
    <link href="/css/style.css" rel="stylesheet">
    <link href="/css/utils.css" rel="stylesheet">
    <link href="/css/dataTables.min.css" rel="stylesheet">
    <link href="/css/notifier.min.css" rel="stylesheet">
    <link href="/css/quill.snow.css" rel="stylesheet">
    <link href="/css/select2.min.css" rel="stylesheet">
    <link href="/css/select2-bootstrap-min.css" rel="stylesheet">
    <link href="/css/simplebar.min.css" rel="stylesheet">
    <link rel="stylesheet" href="/css/lib/easymde.min.css">
    <link href="/css/theme-rtl.min.css" id="style-rtl" rel="stylesheet">
    <link href="/css/theme.min.css" id="style-default" rel="stylesheet">
    <link href="/css/user-rtl.min.css" id="user-style-rtl" rel="stylesheet">
    <link href="/css/user.min.css" id="user-style-default" rel="stylesheet">
    
    <script src="/js/notifier.min.js"></script>
    <script src="/js/htmx.min.js"></script>
    <script src="/js/highlighter.min.js"></script>
    <script src="/js/echarts.min.js"></script>
    <script src="/js/simplebar.min.js"></script>
    <script src="/js/config.js"></script>
    <script src="/js/lib/easymde.min.js"></script>
    <script src="/js/lib/marked.min.js"></script>

    
    <script>
        var phoenixIsRTL = window.config.config.phoenixIsRTL;
        if (phoenixIsRTL) {
            var linkDefault = document.getElementById('style-default');
            var userLinkDefault = document.getElementById('user-style-default');
            linkDefault.setAttribute('disabled', true);
            userLinkDefault.setAttribute('disabled', true);
            document.querySelector('html').setAttribute('dir', 'rtl');
        } else {
            var linkRTL = document.getElementById('style-rtl');
            var userLinkRTL = document.getElementById('user-style-rtl');
            linkRTL.setAttribute('disabled', true);
            userLinkRTL.setAttribute('disabled', true);
        }
    </script>
    <!-- Bootstrap JS -->
    <script src="/js/quill.min.js"></script>
    <script src="/js/jquery.min.js"></script>
    <script src="/js/select2.min.js"></script>
    <script src="/js/dataTables.min.js"></script>
</head>
<body <cfoutput> data-scope="#cgi.path_info#" </cfoutput>>
    <cfset isUserAuth = find("/user/", cgi.path_info)>
    <main class="main" id="top">
        <nav class="navbar navbar-vertical navbar-expand-lg">
            <div class="collapse navbar-collapse" id="navbarVerticalCollapse">
                <!-- scrollbar removed-->
                <div class="navbar-vertical-content">
                    <ul class="navbar-nav flex-column" id="navbarVerticalNav">
                        <li class="nav-item">
                            <div class="nav-item-wrapper mb-3">
                            <cfoutput>
                                <a class="nav-link label-1" href="#urlFor(route='adminDashboard')#" role="button" data-bs-toggle="" aria-expanded="false">
                                    <div class="d-flex align-items-center"><span class="nav-link-icon"><i class="bi bi-bar-chart-fill fs-18"></i></span><span class="nav-link-text-wrapper"><span class="nav-link-text fs-14">Dashboard</span></span>
                                    </div>
                                </a>
                            </cfoutput>
                            </div>
                            <div class="nav-item-wrapper mb-3">
                                <a class="nav-link label-1" href="/admin/user" role="button" data-bs-toggle="" aria-expanded="false">
                                    <div class="d-flex align-items-center"><span class="nav-link-icon"><i class="bi bi-people-fill fs-18"></i></span><span class="nav-link-text-wrapper"><span class="nav-link-text fs-14">Users</span></span>
                                    </div>
                                </a>
                            </div>
                            <div class="nav-item-wrapper mb-3">
                                <a class="nav-link label-1" href="/admin/blog" role="button" data-bs-toggle="" aria-expanded="false">
                                    <div class="d-flex align-items-center"><span class="nav-link-icon"><i class="bi bi-chat-left-text-fill fs-18"></i></span><span class="nav-link-text-wrapper"><span class="nav-link-text fs-14">Blogs</span></span>
                                    </div>
                                </a>
                            </div>
                            <div class="nav-item-wrapper mb-3">
                                <a class="nav-link label-1" href="/admin/comment" role="button" data-bs-toggle="" aria-expanded="false">
                                    <div class="d-flex align-items-center"><span class="nav-link-icon"><i class="bi bi-chat-dots-fill fs-18"></i></span><span class="nav-link-text-wrapper"><span class="nav-link-text fs-14">Comments</span></span>
                                    </div>
                                </a>
                            </div>
                            <div class="nav-item-wrapper mb-3">
                                <a class="nav-link label-1" href="/admin/newsletter" role="button" data-bs-toggle="" aria-expanded="false">
                                    <div class="d-flex align-items-center"><span class="nav-link-icon"><i class="bi bi-envelope-fill fs-18"></i></span><span class="nav-link-text-wrapper"><span class="nav-link-text fs-14">Newsletter</span></span>
                                    </div>
                                </a>
                            </div>
                            <div class="nav-item-wrapper mb-3">
                                <a class="nav-link label-1" href="/admin/testimonial" role="button" data-bs-toggle="" aria-expanded="false">
                                    <div class="d-flex align-items-center"><span class="nav-link-icon"><i class="bi bi-person-lines-fill fs-18"></i></span><span class="nav-link-text-wrapper"><span class="nav-link-text fs-14">Testimonials</span></span>
                                    </div>
                                </a>
                            </div>
                            <div class="nav-item-wrapper mb-3">
                                <a class="nav-link label-1" href="/admin/category" role="button" data-bs-toggle="" aria-expanded="false">
                                    <div class="d-flex align-items-center"><span class="nav-link-icon"><i class="bi bi-boxes fs-18"></i></span><span class="nav-link-text-wrapper"><span class="nav-link-text fs-14">Categories</span></span>
                                    </div>
                                </a>
                            </div>
                            <div class="nav-item-wrapper mb-3">
                                <a class="nav-link label-1" href="/admin/role" role="button" data-bs-toggle="" aria-expanded="false">
                                    <div class="d-flex align-items-center"><span class="nav-link-icon"><i class="bi bi-person-fill-gear fs-18"></i></span><span class="nav-link-text-wrapper"><span class="nav-link-text fs-14">Roles</span></span>
                                    </div>
                                </a>
                            </div>
                            <div class="nav-item-wrapper mb-3">
                                <a class="nav-link dropdown-indicator label-1" href="#nv-setting" role="button" data-bs-toggle="collapse" aria-expanded="false" aria-controls="nv-setting">
                                    <div class="d-flex align-items-center">
                                        <div class="dropdown-indicator-icon-wrapper"><span class="fas fa-caret-right dropdown-indicator-icon"></span></div><span class="nav-link-icon"><i class="bi bi-gear-fill fs-18 ms-1"></i></span><span class="nav-link-text fs-14">Settings</span>
                                    </div>
                                </a>
                                <div class="parent-wrapper label-1">
                                    <ul class="nav collapse parent" data-bs-parent="#navbarVerticalCollapse" id="nv-setting">
                                        <li class="nav-item">
                                            <cfoutput>
                                                <a class="nav-link" href="#urlFor(route="adminemail-templates")#">
                                                    <div class="d-flex align-items-center"><span class="nav-link-text fs-14">Email Templates</span></span></div>
                                                </a>
                                            </cfoutput>
                                        </li>
                                        <li class="nav-item">
                                            <a class="nav-link" href="/admin/settings">
                                                <div class="d-flex align-items-center"><span class="nav-link-text fs-14">General Setting</span></span></div>
                                            </a>
                                        </li>
                                    </ul>
                                </div>
                            </div>
                            <div class="nav-item-wrapper mb-3">
                            </div>
                        </li>
                    </ul>
                </div>
            </div>
            <div class="navbar-vertical-footer">
                <button class="btn navbar-vertical-toggle border-0 fw-semibold w-100 white-space-nowrap d-flex align-items-center"><span class="uil uil-left-arrow-to-left fs-14"></span><span class="uil uil-arrow-from-right fs-14"></span><span class="navbar-vertical-footer-text ms-2 fs-14">Collapsed View</span></button>
            </div>
        </nav>
        <nav class="navbar navbar-top fixed-top navbar-expand" id="topNavSlim">
            <div class="collapse navbar-collapse justify-content-between">
                <div class="navbar-logo">
                    <button class="btn navbar-toggler navbar-toggler-humburger-icon hover-bg-transparent" type="button" data-bs-toggle="collapse" data-bs-target="#navbarVerticalCollapse" aria-controls="navbarVerticalCollapse" aria-expanded="false" aria-label="Toggle Navigation"><span class="navbar-toggle-icon"><span class="toggle-line"></span></span></button>
                    <a class="navbar-brand me-1 me-sm-3" href="/admin">
                        <div class="d-flex align-items-center">
                            <div class="d-flex align-items-center">
                                <cfoutput>
                                    <img src = '/img/wheels-logo.png' alt="wheels-logo" width="200" height="30">
                                </cfoutput>
                            </div>
                        </div>
                    </a>
                </div>
                <div class="d-flex align-items-center gap-5">
                    <a class="nav-link label-1 fs-24 mt-1" href="/" role="button" data-bs-toggle="" aria-expanded="false">
                        Back to Wheels.dev
                    </a>
                    <ul class="navbar-nav navbar-nav-icons flex-row">
                        <cfif !structKeyExists(session, "profilePic") OR session.profilePic == "">
                            <cfset session.profilePic = "avatar-rounded.webp">
                        </cfif>
                        <div class="nav-item dropdown">
                            <a class="nav-link lh-1 pe-0" id="navbarDropdownUser" href="javascript:void(0)" role="button" data-bs-toggle="dropdown" data-bs-auto-close="outside" aria-haspopup="true" aria-expanded="false">
                                <div class="avatar avatar-l ">
                                    <cfoutput>
                                        <cfif !len(session.profilePic) OR findNoCase("avatar-rounded", session.profilePic)>
											<div 
												class="d-flex align-items-center justify-content-center #getAvatarColorByLetter(ucase(left(listLast(session.username, " "), 1)))# text-white rounded-circle fw-bold text-uppercase" 
												style="width:40px; height:40px;">
												#ucase(left(listLast(session.username, " "), 1))#
											</div>
										<cfelse>
                                            <img src = '/img/#session.profilePic#' class="rounded-circle" alt="user profile picture">
										</cfif>
                                    </cfoutput>
                                </div>
                            </a>
                            <div class="dropdown-menu dropdown-menu-end navbar-dropdown-caret py-0 dropdown-profile shadow border" aria-labelledby="navbarDropdownUser">
                                <div class="card position-relative border-0">
                                <div class="card-body p-0">
                                    <div class="text-center pt-4 pb-3">
                                    <div class="avatar avatar-xl ">
                                        <cfoutput>
                                            <cfif !len(session.profilePic) OR findNoCase("avatar-rounded", session.profilePic)>
                                                <div 
                                                    class="d-flex align-items-center fs-24 justify-content-center #getAvatarColorByLetter(ucase(left(listLast(session.username, " "), 1)))# text-white rounded-circle fw-bold text-uppercase" 
                                                    style="width:3rem; height:3rem;">
                                                    #ucase(left(listLast(session.username, " "), 1))#
                                                </div>
                                            <cfelse>
                                                <img src = '/img/#session.profilePic#' class="rounded-circle" alt="profile-picture">
                                            </cfif>
                                        </cfoutput>
                                    </div>
                                    <h6 class="mt-2 text-body-emphasis"><cfoutput>#session.username#</cfoutput></h6>
                                    </div>
                                    <div class="mb-3 mx-3">
                                    <input class="form-control form-control-sm" id="statusUpdateInput" type="text" placeholder="Update your status" />
                                    </div>
                                </div>
                                <div class="overflow-auto scrollbar" style="height: 3rem;">
                                    <ul class="nav d-flex flex-column mb-2 pb-1">
                                    <li class="nav-item"><a class="nav-link px-3 d-block" href="/admin"><span class="me-2 text-body align-bottom" height="16px" width="16px" data-feather="pie-chart"></span>Dashboard</a></li>
                                    </ul>
                                </div>
                                <div class="card-footer p-0 border-top border-translucent">
                                    <div class="px-3 my-3"> <a class="btn btn-phoenix-secondary d-flex flex-center w-100" href="/logout"> <span class="me-2" data-feather="log-out"> </span>Sign out</a></div>
                                    <div class="my-2 text-center fw-bold fs-10 text-body-quaternary"><a class="text-body-quaternary me-1" href="javascript:void(0)">Privacy policy</a>&bull;<a class="text-body-quaternary mx-1" href="javascript:void(0)">Terms</a>&bull;<a class="text-body-quaternary ms-1" href="javascript:void(0)">Cookies</a></div>
                                </div>
                                </div>
                            </div>
                        </div>
                    </ul>
                </div>
            </div>
        </nav>        
        <!-- Content will be dynamically loaded here -->
        <cfoutput>
            <div class="content">
				<div class="mb-9">
                    <cfif flashKeyExists("error")>
                        <div class="alert alert-subtle-success alert-dismissible fade show" role="alert">
                            #flash("error")#
                            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                        </div>
                    </cfif>	
                    <cfif flashKeyExists("success")>
                        <div class="alert alert-subtle-success alert-dismissible fade show" role="alert">
                            #flash("success")#
                            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                        </div>
                    </cfif>
                    #includeContent()#
                </div>
            </div>
        </cfoutput>
    <script src="/js/adminLayout.js"></script>
    </main>
    <script src="/js/anchor.min.js"></script>
    <script src="/js/all.min.js"></script>
    <script src="/js/lodash.min.js"></script>
    <script src="/js/phoenix.js"></script>
    <script src="/js/adminglobal.js"></script>
</body>
</html>