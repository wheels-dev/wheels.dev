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
                <img src="/images/github.png" class="img-fluid" width="174">
            </div>
            <div class="col-md-auto">
                <img src="/images/google.png" class="img-fluid" width="151">
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
                    Welcome to Our Community - a place where hike-minded people connect, share ideas, <br> and grow
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
    <div class="py-5 mt-5 bg-white">
        <div class="container w-100">
            <div class="row align-items-center gap-5">
                <div class="col-lg-12 space-y-3 text-center col-12">
                    <p class="fs-60 line-height-70 fw-bold">Testimonials</p>
                    <p class="fs-18 fw-medium text-center position-relative">
                        Elevating Customer Interactions
                    </p>
                </div>
                <div class="col-12 pb-5 testimonialsSwiper swiper">
                    <div class="w-100 gap-lg-5 gap-0 swiper-wrapper">
                        <div class="d-flex row swiper-slide">
                            <div class="col-lg-3 col-12">
                                <img src="/images/testi.png" class="img-fluid" alt="Community">
                            </div>
                            <div class="col-lg-9 col-12">
                                <div class="d-flex flex-column justify-content-between h-100">
                                    <p class="text--secondary fs-24 fw-medium">It helps companies create visually
                                        stunning and strategically sound digital experiences that captivate audiences.
                                        Our experts works closely with you to ensure every detail aligns with your
                                        goals.</p>
                                    <p class="text--lightGray fs-16 fw-normal">From concept to launch, we craft digital
                                        solutions that not only look exceptional but also drive results, building
                                        connections that last.</p>
                                    <p class="fs-18 text--secondary fw-medium border-top pt-4">Annie Bassett</p>
                                </div>
                            </div>
                        </div>
                        <div class="d-flex row swiper-slide">
                            <div class="col-lg-3 col-12">
                                <img src="/images/testi.png" class="img-fluid" alt="Community">
                            </div>
                            <div class="col-lg-9 col-12">
                                <div class="d-flex flex-column justify-content-between h-100">
                                    <p class="text--secondary fs-24 fw-medium">It helps companies create visually
                                        stunning and strategically sound digital experiences that captivate audiences.
                                        Our experts works closely with you to ensure every detail aligns with your
                                        goals.</p>
                                    <p class="text--lightGray fs-16 fw-normal">From concept to launch, we craft digital
                                        solutions that not only look exceptional but also drive results, building
                                        connections that last.</p>
                                    <p class="fs-18 text--secondary fw-medium border-top pt-4">Bassett</p>
                                </div>
                            </div>
                        </div>
                        <div class="d-flex row swiper-slide">
                            <div class="col-lg-3 col-12">
                                <img src="/images/testi.png" class="img-fluid" alt="Community">
                            </div>
                            <div class="col-lg-9 col-12">
                                <div class="d-flex flex-column justify-content-between h-100">
                                    <p class="text--secondary fs-24 fw-medium">It helps companies create visually
                                        stunning and strategically sound digital experiences that captivate audiences.
                                        Our experts works closely with you to ensure every detail aligns with your
                                        goals.</p>
                                    <p class="text--lightGray fs-16 fw-normal">From concept to launch, we craft digital
                                        solutions that not only look exceptional but also drive results, building
                                        connections that last.</p>
                                    <p class="fs-18 text--secondary fw-medium border-top pt-4">Annie</p>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="swiper-pagination"></div>
                </div>
            </div>
        </div>
    </div>

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
</main>