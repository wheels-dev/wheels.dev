<main class="main">
    <!-- Hero Section -->
    <div class="hero-section position-relative">
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
                        <button class="fs-16 fw-semibold bg--primary w-200 py-1 rounded-2 text-white">
                            Get Started
                        </button>
                    </a>
                </div>
                <div class="col-md-auto text-center">
                    <a href="https://github.com/cfwheels/cfwheels/releases" class="" target="_blank">
                        <button
                            class="fs-16 fw-semibold bg--secondary w-200 py-1 rounded-2 text-white">Download</button>
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
    <div class="gudie-main py-5">
        <h1 class="text-center text-white fs-60 fw-bold">Our Guide</h1>
        <div class="container mt-5" id="guides-container" hx-get="/home/loadGuides" hx-trigger="load"
            hx-target="#guides-container" hx-swap="innerHTML">
            <!-- Guides will be loaded here via HTMX -->
        </div>
    </div>

    <!-- welcome community -->
    <div class="container py-5 mt-5">
        <div class="row align-items-center gy-5">
            <div class="col-lg-6 text-center col-12">
                <p class="fs-60 mb-3 line-height-70 fw-bold">Welcome to our community</p>
                <a href="/blog">
                    <button class="bg--primary fs-16 px-3 py-2 rounded text-white">Explore community</button>
                </a>
            </div>
            <div class="col-lg-6 text-center col-12">
                <img src="/images/community.png" class="img-fluid" alt="Community" width="428" height="428">
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

    <div class="d-none">
        <div class="text-center">
            <p class="fs-60 mb-2 text--secondary line-height-70 fw-bold">Top Contributors</p>
        </div>
        <div class="swiper contributorsSwiper">
            <div class="swiper-wrapper">
                <div class="p-5 swiper-slide">
                    <img src="/images/contribute.png" width="150" height="207" alt="">
                </div>
                <div class="p-5 swiper-slide mt-5">
                    <img src="/images/contribute.png" width="150" height="207" alt="">
                </div>
                <div class="p-5 swiper-slide">
                    <img src="/images/contribute.png" width="150" height="207" alt="">
                </div>
                <div class="p-5 swiper-slide mt-5">
                    <img src="/images/contribute.png" width="150" height="207" alt="">
                </div>
                <div class="p-5 swiper-slide">
                    <img src="/images/contribute.png" width="150" height="207" alt="">
                </div>
                <div class="p-5 swiper-slide mt-5">
                    <img src="/images/contribute.png" width="150" height="207" alt="">
                </div>
                <div class="p-5 swiper-slide">
                    <img src="/images/contribute.png" width="150" height="207" alt="">
                </div>
                <div class="p-5 swiper-slide mt-5">
                    <img src="/images/contribute.png" width="150" height="207" alt="">
                </div>
                <div class="p-5 swiper-slide">
                    <img src="/images/contribute.png" width="150" height="207" alt="">
                </div>
                <div class="p-5 swiper-slide mt-5">
                    <img src="/images/contribute.png" width="150" height="207" alt="">
                </div>
                <div class="p-5 swiper-slide">
                    <img src="/images/contribute.png" width="150" height="207" alt="">
                </div>
                <div class="p-5 swiper-slide mt-5">
                    <img src="/images/contribute.png" width="150" height="207" alt="">
                </div>
                <div class="p-5 swiper-slide">
                    <img src="/images/contribute.png" width="150" height="207" alt="">
                </div>
                <div class="p-5 swiper-slide mt-5">
                    <img src="/images/contribute.png" width="150" height="207" alt="">
                </div>
                <div class="p-5 swiper-slide">
                    <img src="/images/contribute.png" width="150" height="207" alt="">
                </div>
                <div class="p-5 swiper-slide mt-5">
                    <img src="/images/contribute.png" width="150" height="207" alt="">
                </div>
                <div class="p-5 swiper-slide">
                    <img src="/images/contribute.png" width="150" height="207" alt="">
                </div>
                <div class="p-5 swiper-slide mt-5">
                    <img src="/images/contribute.png" width="150" height="207" alt="">
                </div>
                <div class="p-5 swiper-slide">
                    <img src="/images/contribute.png" width="150" height="207" alt="">
                </div>
                <div class="p-5 swiper-slide mt-5">
                    <img src="/images/contribute.png" width="150" height="207" alt="">
                </div>
                <div class="p-5 swiper-slide">
                    <img src="/images/contribute.png" width="150" height="207" alt="">
                </div>
                <div class="p-5 swiper-slide mt-5">
                    <img src="/images/contribute.png" width="150" height="207" alt="">
                </div>
                <div class="p-5 swiper-slide">
                    <img src="/images/contribute.png" width="150" height="207" alt="">
                </div>
                <div class="p-5 swiper-slide mt-5">
                    <img src="/images/contribute.png" width="150" height="207" alt="">
                </div>
                <div class="p-5 swiper-slide">
                    <img src="/images/contribute.png" width="150" height="207" alt="">
                </div>
                <div class="p-5 swiper-slide mt-5">
                    <img src="/images/contribute.png" width="150" height="207" alt="">
                </div>
                <div class="p-5 swiper-slide">
                    <img src="/images/contribute.png" width="150" height="207" alt="">
                </div>
                <div class="p-5 swiper-slide mt-5">
                    <img src="/images/contribute.png" width="150" height="207" alt="">
                </div>
                <div class="p-5 swiper-slide">
                    <img src="/images/contribute.png" width="150" height="207" alt="">
                </div>
                <div class="p-5 swiper-slide mt-5">
                    <img src="/images/contribute.png" width="150" height="207" alt="">
                </div>

            </div>
        </div>
    </div>
</main>