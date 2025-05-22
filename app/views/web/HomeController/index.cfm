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
                    <a href="https://github.com/cfwheels/cfwheels/releases" class="" target="_blank">
                        <button
                            class="fs-16 fw-semibold bg--success w-200 py-2 rounded-4 text--secondary">Download</button>
                    </a>
                </div>
            </div>
        </div>
        <div class="row justify-content-center align-items-center mt-5 gy-3 text-center gx-5">
            <div class="col-md-auto">
            </div>
        </div>
    </div>

    <!-- Cards -->
    <div class="container pb-5">
        <div class="row g-5" id="features-container" hx-get="/home/loadFeatures" hx-trigger="load"
            hx-target="#features-container" hx-swap="innerHTML">
            <!-- Features will be loaded here via HTMX -->
        </div>
    </div>

    <!-- Latest blogs -->
    <div class="pt-5 blog-main">
        <h1 class="text-center fw-bold fs-60">Latest Blog Posts</h1>
        <div class="swiper py-5 blogSwiper h-max">
            <div class="swiper-wrapper" id="blogs-container" hx-get="/home/loadBlogs" hx-trigger="load"
                hx-target="#blogs-container" hx-swap="innerHTML">
                <!-- Blogs will be loaded here via HTMX -->
            </div>
        </div>
    </div>

    <!-- our guide  -->
    <div class="gudie-main py-5 d-none">
        <h1 class="text-center text-white fs-60 fw-bold">Our Guide</h1>
        <div class="container mt-5" id="guides-container" hx-get="/home/loadGuides" hx-trigger="load"
            hx-target="#guides-container" hx-swap="innerHTML">
            <!-- Guides will be loaded here via HTMX -->
        </div>
    </div>

    <!-- welcome community -->
    <div class="container py-5 mt-5">
        <div class="row align-items-center gy-5">
            <div class="col-lg-12 space-y-3 text-center col-12">
                <p class="fs-60 line-height-70 fw-bold">Welcome to Our Community</p>
                <p class="fs-18 fw-medium text-center position-relative">
                    Welcome to Our Community - a place where like-minded people connect, share ideas, <br> and grow
                    together in a positive and supportive environment.
                </p>
                <a href="/community" class="bg--primary d-block w-max mx-auto fs-16 px-3 py-2 rounded-18 text-white">
                    <span>Explore community</span>
                </a>
            </div>
            <div class="text-center col-12">
                <img src="/images/community.png" class="img-fluid" alt="Community">
            </div>
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
                <div class="col-12 pb-5 testimonialsSwiper swiper">
                    <div class="w-100 gap-lg-5 gap-0 swiper-wrapper">
                        <cfloop query="testimonials">
                            <div class="d-flex row swiper-slide">
                                <div class="col-lg-3 col-12">
                                    <img src="#len(testimonials.logoPath) gt 0 ? testimonials.logoPath : '/images/testi.png'#" class="img-fluid" alt="#encodeForHtml(testimonials.companyName)#" style="width: 330px; height: 290px;">
                                </div>
                                <div class="col-lg-9 col-12">
                                    <div class="d-flex flex-column justify-content-between h-100">
                                        <p class="text--secondary fs-24 fw-medium">#encodeForHtml(testimonials.title)#</p>
                                        <p class="text--lightGray fs-16 fw-normal">
                                            #encodeForHtml(testimonials.testimonialText)#
                                        </p>
                                        <p class="fs-18 text--secondary fw-medium border-top pt-4">
                                            <cfif structKeyExists(variables, "user_fullName") AND len(trim(user_fullName))>
                                                #encodeForHtml(user_fullName)#
                                            <cfelseif len(trim(testimonials.companyName))>
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
        <script>
            document.addEventListener('DOMContentLoaded', function() {
                var testimonialModalElement = document.getElementById('testimonialPromptModal');
                if (testimonialModalElement) {
                    var testimonialModalInstance = bootstrap.Modal.getOrCreateInstance(testimonialModalElement);
                    testimonialModalInstance.show();
                }
            });
        </script>
    </cfif>

    <!-- Top contribute -->
    <div class="container py-5 mt-5">
        <div class="text-center">
            <p class="fs-60 mb-2 text--secondary line-height-70 fw-bold">Top Contributors</p>
        </div>
        <div class="d-flex flex-wrap justify-content-center mt-5 gap-3">
            <a href="https://github.com/cfwheels/cfwheels/graphs/contributors" target="_blank">
                <img src="https://contrib.rocks/image?repo=cfwheels/cfwheels" style="max-width: 100%;">
            </a>
        </div>
    </div>

    <div class="container d-none mt-5 py-5">
        <div class="text-center">
            <p class="fs-60 mb-2 text--secondary line-height-70 fw-bold">Our Top Contributer</p>
        </div>
        <div class="swiper contributorsSwiper mt-5">
            <div class="swiper-wrapper">
                <div class="swiper-slide overflow-hidden rounded-30">
                    <div class="p-5 bg-white overflow-hidden d-flex row">
                        <div class="col-lg-8 col-12">
                            <p class="fs-36 fw-bold text--secondary">Alex John</p>
                            <p class="fs-18 text--lightGray fw-medium">Contributed as a Software Developer</p>
                            <p class="fs-16 pt-4 text--secondary fw-normal">
                                Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum
                                has been the industry's standard dummy text ever since the 1500s, when an unknown
                                printer took a galley of type and scrambled it to make a type specimen book. It has
                                survived not only five centuries, but also the leap into electronic typesetting,
                                remaining essentially unchanged.
                            </p>
                        </div>
                        <div class="col-lg-4 col-12">
                            <img src="/images/testi.png">
                        </div>
                    </div>
                </div>
                <div class="swiper-slide overflow-hidden rounded-30">
                    <div class="p-5 bg-white overflow-hidden d-flex row">
                        <div class="col-lg-8 col-12">
                            <p class="fs-36 fw-bold text--secondary">Alex John</p>
                            <p class="fs-18 text--lightGray fw-medium">Contributed as a Software Developer</p>
                            <p class="fs-16 pt-4 text--secondary fw-normal">
                                Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum
                                has been the industry's standard dummy text ever since the 1500s, when an unknown
                                printer took a galley of type and scrambled it to make a type specimen book. It has
                                survived not only five centuries, but also the leap into electronic typesetting,
                                remaining essentially unchanged.
                            </p>
                        </div>
                        <div class="col-lg-4 col-12">
                            <img src="/images/testi.png">
                        </div>
                    </div>
                </div>
                <div class="swiper-slide overflow-hidden rounded-30">
                    <div class="p-5 bg-white overflow-hidden d-flex row">
                        <div class="col-lg-8 col-12">
                            <p class="fs-36 fw-bold text--secondary">Alex John</p>
                            <p class="fs-18 text--lightGray fw-medium">Contributed as a Software Developer</p>
                            <p class="fs-16 pt-4 text--secondary fw-normal">
                                Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum
                                has been the industry's standard dummy text ever since the 1500s, when an unknown
                                printer took a galley of type and scrambled it to make a type specimen book. It has
                                survived not only five centuries, but also the leap into electronic typesetting,
                                remaining essentially unchanged.
                            </p>
                        </div>
                        <div class="col-lg-4 col-12">
                            <img src="/images/testi.png">
                        </div>
                    </div>
                </div>
                <div class="swiper-slide overflow-hidden rounded-30">
                    <div class="p-5 bg-white overflow-hidden d-flex row">
                        <div class="col-lg-8 col-12">
                            <p class="fs-36 fw-bold text--secondary">Alex John</p>
                            <p class="fs-18 text--lightGray fw-medium">Contributed as a Software Developer</p>
                            <p class="fs-16 pt-4 text--secondary fw-normal">
                                Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum
                                has been the industry's standard dummy text ever since the 1500s, when an unknown
                                printer took a galley of type and scrambled it to make a type specimen book. It has
                                survived not only five centuries, but also the leap into electronic typesetting,
                                remaining essentially unchanged.
                            </p>
                        </div>
                        <div class="col-lg-4 col-12">
                            <img src="/images/testi.png">
                        </div>
                    </div>
                </div>
                <div class="swiper-slide overflow-hidden rounded-30">
                    <div class="p-5 bg-white overflow-hidden d-flex row">
                        <div class="col-lg-8 col-12">
                            <p class="fs-36 fw-bold text--secondary">Alex John</p>
                            <p class="fs-18 text--lightGray fw-medium">Contributed as a Software Developer</p>
                            <p class="fs-16 pt-4 text--secondary fw-normal">
                                Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum
                                has been the industry's standard dummy text ever since the 1500s, when an unknown
                                printer took a galley of type and scrambled it to make a type specimen book. It has
                                survived not only five centuries, but also the leap into electronic typesetting,
                                remaining essentially unchanged.
                            </p>
                        </div>
                        <div class="col-lg-4 col-12">
                            <img src="/images/testi.png">
                        </div>
                    </div>
                </div>
                <div class="swiper-slide overflow-hidden rounded-30">
                    <div class="p-5 bg-white overflow-hidden d-flex row">
                        <div class="col-lg-8 col-12">
                            <p class="fs-36 fw-bold text--secondary">Alex John</p>
                            <p class="fs-18 text--lightGray fw-medium">Contributed as a Software Developer</p>
                            <p class="fs-16 pt-4 text--secondary fw-normal">
                                Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum
                                has been the industry's standard dummy text ever since the 1500s, when an unknown
                                printer took a galley of type and scrambled it to make a type specimen book. It has
                                survived not only five centuries, but also the leap into electronic typesetting,
                                remaining essentially unchanged.
                            </p>
                        </div>
                        <div class="col-lg-4 col-12">
                            <img src="/images/testi.png">
                        </div>
                    </div>
                </div>
                <div class="swiper-slide overflow-hidden rounded-30">
                    <div class="p-5 bg-white overflow-hidden d-flex row">
                        <div class="col-lg-8 col-12">
                            <p class="fs-36 fw-bold text--secondary">Alex John</p>
                            <p class="fs-18 text--lightGray fw-medium">Contributed as a Software Developer</p>
                            <p class="fs-16 pt-4 text--secondary fw-normal">
                                Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum
                                has been the industry's standard dummy text ever since the 1500s, when an unknown
                                printer took a galley of type and scrambled it to make a type specimen book. It has
                                survived not only five centuries, but also the leap into electronic typesetting,
                                remaining essentially unchanged.
                            </p>
                        </div>
                        <div class="col-lg-4 col-12">
                            <img src="/images/testi.png">
                        </div>
                    </div>
                </div>
                <div class="swiper-slide overflow-hidden rounded-30">
                    <div class="p-5 bg-white overflow-hidden d-flex row">
                        <div class="col-lg-8 col-12">
                            <p class="fs-36 fw-bold text--secondary">Alex John</p>
                            <p class="fs-18 text--lightGray fw-medium">Contributed as a Software Developer</p>
                            <p class="fs-16 pt-4 text--secondary fw-normal">
                                Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum
                                has been the industry's standard dummy text ever since the 1500s, when an unknown
                                printer took a galley of type and scrambled it to make a type specimen book. It has
                                survived not only five centuries, but also the leap into electronic typesetting,
                                remaining essentially unchanged.
                            </p>
                        </div>
                        <div class="col-lg-4 col-12">
                            <img src="/images/testi.png">
                        </div>
                    </div>
                </div>
                <div class="swiper-slide overflow-hidden rounded-30">
                    <div class="p-5 bg-white overflow-hidden d-flex row">
                        <div class="col-lg-8 col-12">
                            <p class="fs-36 fw-bold text--secondary">Alex John</p>
                            <p class="fs-18 text--lightGray fw-medium">Contributed as a Software Developer</p>
                            <p class="fs-16 pt-4 text--secondary fw-normal">
                                Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum
                                has been the industry's standard dummy text ever since the 1500s, when an unknown
                                printer took a galley of type and scrambled it to make a type specimen book. It has
                                survived not only five centuries, but also the leap into electronic typesetting,
                                remaining essentially unchanged.
                            </p>
                        </div>
                        <div class="col-lg-4 col-12">
                            <img src="/images/testi.png">
                        </div>
                    </div>
                </div>
                <div class="swiper-slide overflow-hidden rounded-30">
                    <div class="p-5 bg-white overflow-hidden d-flex row">
                        <div class="col-lg-8 col-12">
                            <p class="fs-36 fw-bold text--secondary">Alex John</p>
                            <p class="fs-18 text--lightGray fw-medium">Contributed as a Software Developer</p>
                            <p class="fs-16 pt-4 text--secondary fw-normal">
                                Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum
                                has been the industry's standard dummy text ever since the 1500s, when an unknown
                                printer took a galley of type and scrambled it to make a type specimen book. It has
                                survived not only five centuries, but also the leap into electronic typesetting,
                                remaining essentially unchanged.
                            </p>
                        </div>
                        <div class="col-lg-4 col-12">
                            <img src="/images/testi.png">
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="swiper contributorsSwiperThumb mt-5">
            <div class="swiper-wrapper">
                <div class="swiper-slide d-flex justify-content-center align-items-center">
                    <img class="rounded-circle size-100" src="https://swiperjs.com/demos/images/nature-1.jpg" />
                </div>
                <div class="swiper-slide d-flex justify-content-center align-items-center">
                    <img class="rounded-circle size-100" src="https://swiperjs.com/demos/images/nature-2.jpg" />
                </div>
                <div class="swiper-slide d-flex justify-content-center align-items-center">
                    <img class="rounded-circle size-100" src="https://swiperjs.com/demos/images/nature-3.jpg" />
                </div>
                <div class="swiper-slide d-flex justify-content-center align-items-center">
                    <img class="rounded-circle size-100" src="https://swiperjs.com/demos/images/nature-4.jpg" />
                </div>
                <div class="swiper-slide d-flex justify-content-center align-items-center">
                    <img class="rounded-circle size-100" src="https://swiperjs.com/demos/images/nature-5.jpg" />
                </div>
                <div class="swiper-slide d-flex justify-content-center align-items-center">
                    <img class="rounded-circle size-100" src="https://swiperjs.com/demos/images/nature-6.jpg" />
                </div>
                <div class="swiper-slide d-flex justify-content-center align-items-center">
                    <img class="rounded-circle size-100" src="https://swiperjs.com/demos/images/nature-7.jpg" />
                </div>
                <div class="swiper-slide d-flex justify-content-center align-items-center">
                    <img class="rounded-circle size-100" src="https://swiperjs.com/demos/images/nature-8.jpg" />
                </div>
                <div class="swiper-slide d-flex justify-content-center align-items-center">
                    <img class="rounded-circle size-100" src="https://swiperjs.com/demos/images/nature-9.jpg" />
                </div>
                <div class="swiper-slide d-flex justify-content-center align-items-center">
                    <img class="rounded-circle size-100" src="https://swiperjs.com/demos/images/nature-10.jpg" />
                </div>
            </div>
            <div class="swiper-button-next end-0"></div>
            <div class="swiper-button-prev start-0"></div>
        </div>
    </div>
    <!-- Testimonial Popup Modal -->
    <cfif settings.enableTestimonial>
        <div class="modal fade" id="testimonialPromptModal" tabindex="-1" aria-labelledby="testimonialPromptModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-dialog-scrollable">
                <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title fw-bold fs-18 text--primary" id="testimonialPromptModalLabel">Share Your Experience!</h5>
                    <button type="button" class="btn-close text--primary" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <p class="mb-2">We'd love to hear about your experience! Would you take a moment to share a testimonial?</p>

                    <!--- HTMX Target Area --->
                    <div id="testimonial-form-container"
                        hx-get="<cfoutput>#urlFor(route='new-testimonial')#</cfoutput>"
                        hx-target="this"
                        hx-trigger="load"
                        hx-swap="innerHTML">
                        <!--- Optional: Loading indicator --->
                        <div class="text-center p-3">
                            <div class="spinner-border text-primary" role="status">
                                <span class="visually-hidden">Loading form...</span>
                            </div>
                            <p class="mt-2">Loading form...</p>
                        </div>
                        <!--- The form content from TestimonialController::new will be loaded here --->
                    </div>

                </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                        <!--- The submit button will be part of the loaded form --->
                    </div>
                </div>
            </div>
        </div>

        <cfif structKeyExists(session, "promptForTestimonial") AND showTestimonialPopup>
            <script>
                // This script block only renders if the session flag exists and showTestimonialPopup is true.

                // Get modal element immediately
                var testimonialModalElement = document.getElementById('testimonialPromptModal');
                var testimonialModalInstance = null;
                // Flag to ensure the 'shown.bs.modal' listener is attached only once
                let formLoadListenerAttached = false;

                if (testimonialModalElement) {
                    // Get or create the Bootstrap modal instance right away
                    testimonialModalInstance = bootstrap.Modal.getOrCreateInstance(testimonialModalElement);

                    // Automatically show the modal on page load
                    window.addEventListener('DOMContentLoaded', function() {
                        console.log('DOM loaded, showing testimonial modal automatically');
                        setTimeout(function() {
                            if (testimonialModalInstance) {
                                testimonialModalInstance.show();
                            }
                        }, 1000); // Small delay to ensure everything is loaded
                    });

                    document.body.addEventListener('showTestimonialModal', function handleShowTrigger() {
                        console.log('Received showTestimonialModal trigger from backend.');
                        if (testimonialModalInstance) {
                            testimonialModalInstance.show();
                        } else {
                            var currentModalInstance = bootstrap.Modal.getInstance(testimonialModalElement);
                            if (currentModalInstance) {
                                currentModalInstance.show();
                            } else {
                                console.error("Modal instance not found when trying to show via HX-Trigger.");
                            }
                        }
                    }, { once: true });

                    if (!formLoadListenerAttached && testimonialModalInstance) {
                        testimonialModalElement.addEventListener('shown.bs.modal', function handleModalShown() {
                            var formContainer = testimonialModalElement.querySelector('#testimonial-form-container');
                            if (formContainer) {
                                var isLoadingIndicatorPresent = formContainer.querySelector('.spinner-border');
                                if (isLoadingIndicatorPresent || formContainer.innerHTML.trim() === '') {
                                    console.log('Modal shown, processing HTMX for form container.');
                                    htmx.process(formContainer); // Trigger the hx-get on the container
                                } else {
                                    console.log('Modal shown, form container already has content.');
                                }
                            } else {
                                console.error('Form container #testimonial-form-container not found inside modal.');
                            }
                        });
                        formLoadListenerAttached = true; // Mark that this listener has been attached.
                        console.log('Attached shown.bs.modal listener.');
                    }
                } else {
                    console.error("Testimonial prompt modal element not found when initializing script.");
                }
            </script>
        </cfif>
    </cfif>
</main>
