<main class="main">
    <!-- Hero Section -->
    <div class="hero-section home-section position-relative">
        <div class="container d-flex flex-column justify-content-center w-100 align-items-center">
            <h1 class="fs-64 fw-bolder text--secondary text-center position-relative">Wheels-The Fast &
                Fun<br>CFML Framework!</h1>
            <p class="fs-22 text--secondary fw-medium text-center position-relative">
                Build apps quickly with an
                organized, Ruby on
                Rails-inspired <br>
                structure.
                Get up and
                running in no time!
            </p>
            <div class="row g-3 justify-content-center w-100 mt-1 align-items-center">
                <div class="col-md-auto text-center">
                    <cfoutput>
                        <a href="#urlFor(route='load-Guides')#" class="">
                            <button class="fs-16 fw-semibold bg--primary w-200 py-2 rounded-4 text-white">
                                Get Started
                            </button>
                        </a>
                    </cfoutput>
                </div>
                <div class="col-md-auto text-center">
                    <a href="https://github.com/wheels-dev/wheels/releases" class="" target="_blank">
                        <button
                            class="fs-16 fw-semibold bg--success w-200 py-2 rounded-4 text--secondary">Download</button>
                    </a>
                </div>
            </div>
        </div>
        <div class="row justify-content-center align-items-center mt-5 gy-3 text-center gx-sm-5">
            <cfif testimonials.recordCount GT 0>
                <cfoutput query="testimonials">
                    <cfif len(trim(testimonials.logoPath)) AND testimonials.logoPath NEQ "testi.png">
                        <div class="col-md-auto">
                            <img src="/img/#testimonials.logoPath#" 
                                 alt="#encodeForHtml(testimonials.companyName)#" 
                                 class="img-fluid" 
                                 style="max-height: 60px; max-width: 150px; object-fit: contain; filter: grayscale(100%); opacity: 0.7;"
                                 title="#encodeForHtml(testimonials.companyName)#">
                        </div>
                    </cfif>
                </cfoutput>
            </cfif>
        </div>
    </div>

    <!-- Cards -->
    <div class="container pb-5">
        <div class="row gy-3 gy-sm-5 gx-sm-5" id="features-container">
            <cfoutput query="features">
                <div class="col-lg-4">
                    <a href="#features.card_link#" target="_blank" class="text-decoration-none">
                        <div class="px-4 py-4 bg-white border-transparent border-2 cards rounded-5 cursor-pointer shadow-sm">
                            <div class="icon-container d-flex justify-content-center align-items-center">
                                #features.image#
                            </div>
                            <div class="mt-3">
                                <p class="fw-bold fs-24 text--secondary">#features.title#</p>
                                <p class="fs-18 text--secondary/70 pt-1 line-clamp-2">#features.description#</p>
                            </div>
                        </div>
                    </a>
                </div>
            </cfoutput>
        </div>
    </div>

    <!-- Latest blogs -->
    <div class="pt-5 px-2 blog-main">
        <div class="d-flex align-items-center justify-content-between swiper-buttons position-relative">
            <!-- Left Button -->
            <div class="swiper-button-prev"></div>

            <!-- Heading -->
            <h2 class="text-center fw-bold fs-60 flex-grow-1 mx-5 mb-0">Latest From the Wheels Dev Blog</h2>

            <!-- Right Button -->
            <div class="swiper-button-next"></div>
        </div>

        <div class="swiper py-5 blogSwiper h-max">
            <div class="swiper-wrapper" id="blogs-container">
                <cfoutput query="blogs">
                    <div class="p-4 bg-white rounded-5 shadow-sm swiper-slide">
                        
                            <div>
                                <p class="fs-18 mb-3 text--secondary/70 fw-bold line-clamp-1">#blogs.title#</p>
                                <div class="fs-16 mb-3 text--lightGray line-clamp-2">
                                    #reReplace(blogs.content, "<(img|video|iframe)[^>]*>(.*?)</\1>|<(img)[^>]*>", "", "all")# 
                                </div>
                            </div>

                            <div class="d-flex gap-2 justify-content-between align-items-center">
                                <p class="fs-16 truncate fw-medium text--lightGray">#dateformat(blogs.postDate, 'MMMM DD, YYYY')# by #blogs.fullName#</p>
                                <a href="/blog/#slug#"><button class="bg--primary text-nowrap fs-16 text-white rounded-2 px-3 py-1">Learn more</button></a>
                            </div>
                    </div>
                </cfoutput>
            </div>
        </div>
    </div>


    <!-- welcome community -->
    <cfoutput>
    <div class="container py-5 mt-5">
        <div class="row align-items-center gy-5">
            <div class="col-lg-12 space-y-3 text-center col-12">
                <p class="fs-60 line-height-70 fw-bold">Welcome to Our Community</p>
                <p class="fs-18 fw-medium text-center position-relative">
                    Welcome to Our Community - a place where like-minded people connect, share ideas, <br> and grow
                    together in a positive and supportive environment.
                </p>
                <a href="#urlFor(route='community')#" class="bg--primary d-block w-max mx-auto fs-16 px-3 py-2 rounded-18 text-white">
                    <span>Explore community</span>
                </a>
            </div>
            <div class="text-center col-12">
                    <img src="/img/community.png" class="img-fluid" alt="Wheels.dev Community">
            </div>
        </div>
    </div>
    </cfoutput>
    <!-- Cookie Consent Banner -->
    <div id="cookie-banner" class="cookie-banner">
        <button id="close-cookie-banner" aria-label="Dismiss" class="fs-14" style="position: absolute; top: 4px; right: 8px; border: none; background: transparent; font-size: 18px; cursor: pointer;">
            &times;
        </button>
        <p class="mt-2" style="line-height: 1.4;">
            This website uses essential cookies to improve your experience. By continuing to use the site, you consent to the use of cookies.
        </p>
        <div style="text-align: right;">
            <button id="accept-cookies" class="fs-14 fw-semibold bg--success px-2 py-1 rounded-2 text--secondary">Accept Necessary</button>
        </div>
    </div>
    
    <!-- Testimonials -->
    <cfoutput>
    <cfif testimonials.recordCount GT 0>
    <div class="py-5 mt-5 bg-white">
        <div class="container w-100">
            <div class="row align-items-center gap-5">
                <div class="col-lg-12 space-y-3 text-center col-12">
                    <p class="fs-60 line-height-70 fw-bold">Testimonials</p>
                    <p class="fs-18 fw-medium text-center position-relative">
                        Elevating Customer Interactions
                    </p>
                </div>
                <!-- Swiper container -->
                <div class="col-12 pb-5 px-2 testimonialsSwiper swiper">
                    <div class="w-100 swiper-wrapper">
                        <cfloop query="testimonials">
                            <div class="d-flex mx-5 row swiper-slide">
                                <div class="col-lg-3 col-12 pb-2 pb-sm-0">
                                    <cfset imgSrc = testimonials.logoPath>
                                    <cfif !len(trim(imgSrc))>
                                        <cfset imgSrc = "testi.png">
                                    </cfif>
                                    <img src='/img/#imgSrc#' class="img-fluid" alt=#encodeForHtml(testimonials.companyName)# style="width: 330px; height: 290px;">
                                </div>
                                <div class="col-lg-9 col-12">
                                    <div class="d-flex flex-column justify-content-between h-100">
                                        <p class="text--secondary fs-24 fw-medium">#encodeForHtml(testimonials.title)#</p>
                                        <p class="text--lightGray fs-16 fw-normal">
                                            #encodeForHtml(testimonials.testimonialText)#
                                        </p>
                                        <p class="fs-18 text--secondary fw-medium border-top pt-4">
                                            <cfif structKeyExists(testimonials, "authorName") AND len(trim(testimonials.authorName))>
                                                #encodeForHtml(testimonials.authorName)#
                                            <cfelseif structKeyExists(testimonials, "companyName") AND len(trim(testimonials.companyName))>
                                                #encodeForHtml(testimonials.companyName)#
                                            <cfelse>
                                                Anonymous
                                            </cfif>
                                        </p>
                                    </div>
                                </div>
                            </div>
                        </cfloop>
                    </div>
                    <div class="swiper-pagination"></div>
                </div>
            </div>
        </div>
    </div>
    </cfif>
    </cfoutput>


    <cfif showTestimonialPopup>
        <script src="/js/testimonialPopup.js"></script>
    </cfif>

    <!-- Top contribute -->
    <!---<div class="container py-5 mt-5">
        <div class="text-center">
            <p class="fs-60 mb-2 text--secondary line-height-70 fw-bold">Top Contributors</p>
        </div>
        <div class="d-flex flex-wrap justify-content-center mt-5 gap-3">
            <a href="https://github.com/wheels-dev/wheels/graphs/contributors" target="_blank">
                <img src="https://contrib.rocks/image?repo=wheels-dev/wheels" style="max-width: 100%;" alt="GitHub Contributors for Wheels">
            </a>
        </div>
    </div>--->
    <div <cfif arrayLen(contributors) neq 0> class="container mt-5 py-5"<cfelse> class="d-none container mt-5 py-5"</cfif>>
        <div class="text-center">
            <p class="fs-60 mb-2 text--secondary line-height-70 fw-bold">
                Our Top Contributer
        </p>
        </div>
        <cfoutput>
            <div class="swiper contributorsSwiper mt-5">
                <div class="swiper-wrapper">
                    <cfloop array="#contributors#" index="c">
                        <div class="swiper-slide overflow-hidden rounded-30">
                            <div class="p-5 bg-white overflow-hidden d-flex row">
                                <div class="col-lg-8 col-12 d-flex flex-column justify-content-between">
                                    <div>
                                        <p class="fs-36 fw-bold text--secondary">#c.name#</p>
                                        <p class="fs-18 text--lightGray fw-medium">
                                            Contributed as a #c.role# 
                                        </p>
                                        <p class="col-lg-11 fs-16 pt-4 text--secondary fw-normal text-justify">
                                            #c.description#
                                        </p>
                                    </div>
                                    <cfif c.LinkedInLink neq "">
                                        <div class="mt-2">
                                            <a href="#c.LinkedInLink#" target="_blank" class="text-decoration-none me-3">
                                                <span class="fs-22 fw-medium">Linked </span><i class="bi bi-linkedin fs-24 text-primary"></i>
                                            </a>
                                            <!-- You can add more icons here -->
                                        </div>
                                    </cfif>
                                </div>
                                <div class="col-lg-4 col-12">
                                    <img src="#c.profilePic#" class="rounded-5 contributor-img" alt="#c.name# profile picture"/>
                                </div>
                            </div>
                        </div>
                    </cfloop>
                </div>
            </div>
            <div class="swiper contributorsSwiperThumb mt-5">
                <div class="swiper-wrapper">
                    <cfloop array="#contributors#" index="c">
                        <div class="swiper-slide d-flex justify-content-center align-items-center">
                            <img
                                class="rounded-circle size-100"
                                src="#c.profilePic#"
                            />
                        </div>
                    </cfloop>
                </div>
                <div class="swiper-button-next contributors-swiper-button-next end-0"></div>
                <div class="swiper-button-prev contributors-swiper-button-prev start-0"></div>
                </div>
            </div>
        </cfoutput>
    </div>

    <!-- Testimonial Popup Modal -->
    <cfif settings.enableTestimonial>
        <div class="modal fade" id="testimonialPromptModal" tabindex="-1" aria-labelledby="testimonialPromptModalLabel" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title fw-bold fs-18 text--primary" id="testimonialPromptModalLabel">Share Your Experience!</h5>
                    <button type="button" class="btn-close text--primary" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <p class="mb-2">We'd love to hear about your experience! Would you take a moment to share a testimonial?</p>
                </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                        <button type="button" class="btn bg--primary text-white" 
                        hx-get="<cfoutput>#urlFor(route='new-testimonial')#</cfoutput>"
                        hx-target="main"
                        hx-trigger="click"
                        hx-swap="outerHTML" data-bs-dismiss="modal">Share Now</button>
                        <!--- The submit button will be part of the loaded form --->
                    </div>
                </div>
            </div>
        </div>

        <cfif structKeyExists(session, "promptForTestimonial") AND showTestimonialPopup>
            <script src="/js/testimonial.js"></script>
        </cfif>
    </cfif>
</main>

    <script>
        function initUserTable() {
            if (window.jQuery && $.fn.DataTable) {
                if ($.fn.DataTable.isDataTable('#userTable')) {
                    $('#userTable').DataTable().destroy();
                }
                window.userTableInstance = $('#userTable').DataTable({
                    columnDefs: [
                        { targets: [6,7], orderable: false }
                    ]
                });
                window.userTableInstance.on('draw', function() {
                    if (window.htmx) htmx.process(document.body);
                });
            }
        }
        document.addEventListener('htmx:afterSwap', function(evt) {
            if (evt.target && evt.target.id === 'users-container') {
                initUserTable();
            }
        });
        document.addEventListener('DOMContentLoaded', function() {
            initUserTable();
        });
    </script>

    <style>
        .logo-swiper-container {
            width: 100%;
            padding: 20px 0;
        }

        .logoSwiper {
            width: 100%;
            height: 100px;
        }

        .logo-slide {
            display: flex;
            align-items: center;
            justify-content: center;
            height: 100%;
        }

        .logo-image {
            max-height: 60px;
            max-width: 150px;
            object-fit: contain;
            filter: grayscale(100%);
            opacity: 0.7;
            transition: all 0.3s ease;
        }

        .logo-image:hover {
            filter: grayscale(0%);
            opacity: 1;
            transform: scale(1.1);
        }

        /* Swiper pagination styling */
        .logoSwiper .swiper-pagination {
            position: relative;
            margin-top: 20px;
        }

        .logoSwiper .swiper-pagination-bullet {
            width: 10px;
            height: 10px;
            background-color: #ccc;
            opacity: 0.5;
            transition: all 0.3s ease;
        }

        .logoSwiper .swiper-pagination-bullet-active {
            background-color: #007bff;
            opacity: 1;
            transform: scale(1.2);
        }

        /* Responsive adjustments */
        @media (max-width: 768px) {
            .logoSwiper {
                height: 80px;
            }
            
            .logo-image {
                max-height: 50px;
                max-width: 120px;
            }
        }

        @media (max-width: 480px) {
            .logoSwiper {
                height: 70px;
            }
            
            .logo-image {
                max-height: 40px;
                max-width: 100px;
            }
        }
    </style>

    <script>
        // Initialize Swiper logo slider
        document.addEventListener('DOMContentLoaded', function() {
            const logoSwiper = new Swiper('.logoSwiper', {
                slidesPerView: 1,
                spaceBetween: 30,
                loop: true,
                autoplay: {
                    delay: 3000,
                    disableOnInteraction: false,
                },
                pagination: {
                    el: '.swiper-pagination',
                    clickable: true,
                    dynamicBullets: true,
                },
                breakpoints: {
                    640: {
                        slidesPerView: 2,
                        spaceBetween: 20,
                    },
                    768: {
                        slidesPerView: 3,
                        spaceBetween: 30,
                    },
                    1024: {
                        slidesPerView: 4,
                        spaceBetween: 40,
                    },
                    1200: {
                        slidesPerView: 5,
                        spaceBetween: 50,
                    }
                }
            });
        });
        document.addEventListener("DOMContentLoaded", function () {
            <cfif structKeyExists(session, "toastMessage")>
                <cfscript>
                    title = structKeyExists(session.toastMessage, "title") ? session.toastMessage.title : "";
                    message = structKeyExists(session.toastMessage, "message") ? session.toastMessage.message : "";
                    type = structKeyExists(session.toastMessage, "type") ? session.toastMessage.type : "";
                    structDelete(session, "toastMessage");
                </cfscript>
                <cfoutput>
                showNotificationOnce(
                    "#encodeForJavaScript(title)#",
                    "#encodeForJavaScript(message)#",
                    "#encodeForJavaScript(type)#",
                    4000
                );
                </cfoutput>
            </cfif>
        });
    </script>