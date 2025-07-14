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
                    <a href="https://guides.cfwheels.org/cfwheels-guides/introduction/readme" class="" target="_blank">
                        <button class="fs-16 fw-semibold bg--primary w-200 py-2 rounded-4 text-white">
                            Get Started
                        </button>
                    </a>
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
            <div class="col-md-auto">
            </div>
        </div>
    </div>

    <!-- Cards -->
    <div class="container pb-5">
        <div class="row gy-3 gy-sm-5 gx-sm-5" id="features-container">
            <cfoutput query="features">
                <div class="col-lg-4">
                    <div class="px-4 py-4 bg-white border-transparent border-2 cards rounded-5 cursor-pointer shadow-sm">
                        <div class="icon-container d-flex justify-content-center align-items-center">
                            #features.image#
                        </div>
                        <div class="mt-3">
                            <p class="fw-bold fs-24 text--secondary">#features.title#</p>
                            <p class="fs-18 text--secondary/70 pt-1 line-clamp-2">#features.description#</p>
                        </div>
                    </div>
                </div>
            </cfoutput>
        </div>
    </div>

    <!-- Latest blogs -->
    <div class="pt-5 px-2 blog-main">
        <h2 class="text-center fw-bold fs-60">Latest From the Wheels Dev Blog</h2>
        <div class="swiper py-5 blogSwiper h-max">
            <div class="swiper-wrapper" id="blogs-container">
                <cfoutput query= "blogs">
                    <div class="p-4 bg-white rounded-5 shadow-sm swiper-slide">
                        <a href="/blog/#slug#" class="">
                            <div>
                                <p class="fs-18 mb-3 text--secondary/70 fw-bold line-clamp-1">#blogs.title#</p>
                            </div>
                        
                            <div class="d-flex gap-2 justify-content-between align-items-center">
                                <p class="fs-16 truncate fw-medium text--lightGray">#dateformat(blogs.postDate, 'MMMM DD, YYYY')# by #blogs.fullName#</p>
                                <button class="bg--primary text-nowrap fs-16 text-white rounded-2 px-3 py-1">Learn more</button>
                            </div>
                        </a>
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
                    <div class="w-100 gap-lg-5 gap-0 swiper-wrapper">
                        <cfloop query="testimonials">
                            <div class="d-flex row swiper-slide">
                                <div class="col-lg-3 col-12 pb-2 pb-sm-0">
                                    <cfset imgSrc = testimonials.logoPath>
                                    <cfif !len(trim(imgSrc))>
                                        <cfset imgSrc = "testi.png">
                                    </cfif>
                                    <img src='/img/#imgSrc#' class="img-fluid" alt=encodeForHtml(testimonials.companyName) style="width: 330px; height: 290px;">
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
    <div class="container py-5 mt-5">
        <div class="text-center">
            <p class="fs-60 mb-2 text--secondary line-height-70 fw-bold">Top Contributors</p>
        </div>
        <div class="d-flex flex-wrap justify-content-center mt-5 gap-3">
            <a href="https://github.com/wheels-dev/wheels/graphs/contributors" target="_blank">
                <img src="https://contrib.rocks/image?repo=wheels-dev/wheels" style="max-width: 100%;" alt="GitHub Contributors for Wheels">
            </a>
        </div>
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
                        <button type="button" class="btn bg--primary text-white" 
                        hx-get="<cfoutput>#urlFor(route='new-testimonial')#</cfoutput>"
                        hx-target="main"
                        hx-trigger="click"
                        hx-swap="outerHTML" data-bs-dismiss="modal">Share Now</button>
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
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