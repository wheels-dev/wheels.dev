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
                    <button class="fs-16 fw-semibold bg--primary w-200 py-1 rounded-2 text-white">
                        Get Started
                    </button>
                </div>
                <div class="col-md-auto text-center">
                    <button class="fs-16 fw-semibold bg--secondary w-200 py-1 rounded-2 text-white">Download</button>
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
        <div class="row g-5">
            <cfloop query = "features">
                <div class="col-lg-4">
                    <div
                        class="px-4 pt-4 pb-2 bg-white border-transparent border-2 cards rounded-5 cursor-pointer shadow-sm">
                        <cfoutput> 
                            <div class="icon-container d-flex justify-content-center align-items-center">
                                #features.image#
                            </div>
                            <div class="mt-3">
                                <p class="fw-bold fs-24 text--secondary">#features.title#</p>
                                <p class="fs-18 text--secondary/70 pt-1 line-clamp-2">#features.description#</p>
                            </div>
                        </cfoutput>
                    </div>
                </div>
            </cfloop>
        </div>
    </div>

    <!-- Latest blogs -->
    <div class="pt-5 blog-main">
        <h1 class="text-center fw-bold fs-60">Latest Blog Posts</h1>
        <div class="swiper py-5 blogSwiper">
            <div class="swiper-wrapper">
                <cfloop query= "blogs">
                    <div class="p-4 bg-white rounded-5 shadow-sm swiper-slide">
                        <cfoutput>
                            <div>
                                <p class="fs-18 text--secondary/70 fw-bold line-clamp-1">#blogs.title#</p>
                                <p class="fs-16 fw-medium text--lightGray line-clamp-2">#blogs.content#</p>
                            </div>
                            <div class="d-flex justify-content-between align-items-center">
                                <p class="fs-16 fw-medium text--lightGray">#dateformat(blogs.createdat, 'MMMM DD, YYYY')# by #blogs.name#</p>
                                <button class="bg--iris fs-16 text-white rounded-2 px-3 py-1">Learn more</button>
                            </div>
                        </cfoutput>
                    </div>
                </cfloop>
                <!---<div class="p-4 bg-white rounded-5 shadow-sm swiper-slide">
                    <div>
                        <p class="fs-18 text--secondary/70 fw-bold line-clamp-1">Celebrating 20 Years of Wheels: A Look Back and a Step Forward
                            as Wheels.dev</p>
                        <p class="fs-16 fw-medium text--lightGray line-clamp-2">As we ring in the new year, we’re thrilled to celebrate a
                            monumental milestone: 20 years
                            of Wheels!</p>
                    </div>
                    <div class="d-flex justify-content-between align-items-center">
                        <p class="fs-16 fw-medium text--lightGray">January 3rd, 2025 by Peter Amiri</p>
                        <button class="bg--iris fs-16 text-white rounded-2 px-3 py-1">Learn more</button>
                    </div>
                </div>
                <div class="p-4 bg-white rounded-5 shadow-sm swiper-slide">
                    <div>
                        <p class="fs-18 text--secondary/70 fw-bold line-clamp-1">Celebrating 20 Years of Wheels: A Look Back and a Step Forward
                            as Wheels.dev</p>
                        <p class="fs-16 fw-medium text--lightGray line-clamp-2">As we ring in the new year, we’re thrilled to celebrate a
                            monumental milestone: 20 years
                            of Wheels!</p>
                    </div>
                    <div class="d-flex justify-content-between align-items-center">
                        <p class="fs-16 fw-medium text--lightGray">January 3rd, 2025 by Peter Amiri</p>
                        <button class="bg--iris fs-16 text-white rounded-2 px-3 py-1">Learn more</button>
                    </div>
                </div>
                <div class="p-4 bg-white rounded-5 shadow-sm swiper-slide">
                    <div>
                        <p class="fs-18 text--secondary/70 fw-bold line-clamp-1">Celebrating 20 Years of Wheels: A Look Back and a Step Forward
                            as Wheels.dev</p>
                        <p class="fs-16 fw-medium text--lightGray line-clamp-2">As we ring in the new year, we’re thrilled to celebrate a
                            monumental milestone: 20 years
                            of Wheels!</p>
                    </div>
                    <div class="d-flex justify-content-between align-items-center">
                        <p class="fs-16 fw-medium text--lightGray">January 3rd, 2025 by Peter Amiri</p>
                        <button class="bg--iris fs-16 text-white rounded-2 px-3 py-1">Learn more</button>
                    </div>
                </div>
                <div class="p-4 bg-white rounded-5 shadow-sm swiper-slide">
                    <div>
                        <p class="fs-18 text--secondary/70 fw-bold line-clamp-1">Celebrating 20 Years of Wheels: A Look Back and a Step Forward
                            as Wheels.dev</p>
                        <p class="fs-16 fw-medium text--lightGray line-clamp-2">As we ring in the new year, we’re thrilled to celebrate a
                            monumental milestone: 20 years
                            of Wheels!</p>
                    </div>
                    <div class="d-flex justify-content-between align-items-center">
                        <p class="fs-16 fw-medium text--lightGray">January 3rd, 2025 by Peter Amiri</p>
                        <button class="bg--iris fs-16 text-white rounded-2 px-3 py-1">Learn more</button>
                    </div>
                </div>
                <div class="p-4 bg-white rounded-5 shadow-sm swiper-slide">
                    <div>
                        <p class="fs-18 text--secondary/70 fw-bold line-clamp-1">Celebrating 20 Years of Wheels: A Look Back and a Step Forward
                            as Wheels.dev</p>
                        <p class="fs-16 fw-medium text--lightGray line-clamp-2">As we ring in the new year, we’re thrilled to celebrate a
                            monumental milestone: 20 years
                            of Wheels!</p>
                    </div>
                    <div class="d-flex justify-content-between align-items-center">
                        <p class="fs-16 fw-medium text--lightGray">January 3rd, 2025 by Peter Amiri</p>
                        <button class="bg--iris fs-16 text-white rounded-2 px-3 py-1">Learn more</button>
                    </div>
                </div>
                <div class="p-4 bg-white rounded-5 shadow-sm swiper-slide">
                    <div>
                        <p class="fs-18 text--secondary/70 fw-bold line-clamp-1">Celebrating 20 Years of Wheels: A Look Back and a Step Forward
                            as Wheels.dev</p>
                        <p class="fs-16 fw-medium text--lightGray line-clamp-2">As we ring in the new year, we’re thrilled to celebrate a
                            monumental milestone: 20 years
                            of Wheels!</p>
                    </div>
                    <div class="d-flex justify-content-between align-items-center">
                        <p class="fs-16 fw-medium text--lightGray">January 3rd, 2025 by Peter Amiri</p>
                        <button class="bg--iris fs-16 text-white rounded-2 px-3 py-1">Learn more</button>
                    </div>
                </div>
                <div class="p-4 bg-white rounded-5 shadow-sm swiper-slide">
                    <div>
                        <p class="fs-18 text--secondary/70 fw-bold line-clamp-1">Celebrating 20 Years of Wheels: A Look Back and a Step Forward
                            as Wheels.dev</p>
                        <p class="fs-16 fw-medium text--lightGray line-clamp-2">As we ring in the new year, we’re thrilled to celebrate a
                            monumental milestone: 20 years
                            of Wheels!</p>
                    </div>
                    <div class="d-flex justify-content-between align-items-center">
                        <p class="fs-16 fw-medium text--lightGray">January 3rd, 2025 by Peter Amiri</p>
                        <button class="bg--iris fs-16 text-white rounded-2 px-3 py-1">Learn more</button>
                    </div>
                </div>
                <div class="p-4 bg-white rounded-5 shadow-sm swiper-slide">
                    <div>
                        <p class="fs-18 text--secondary/70 fw-bold line-clamp-1">Celebrating 20 Years of Wheels: A Look Back and a Step Forward
                            as Wheels.dev</p>
                        <p class="fs-16 fw-medium text--lightGray line-clamp-2">As we ring in the new year, we’re thrilled to celebrate a
                            monumental milestone: 20 years
                            of Wheels!</p>
                    </div>
                    <div class="d-flex justify-content-between align-items-center">
                        <p class="fs-16 fw-medium text--lightGray">January 3rd, 2025 by Peter Amiri</p>
                        <button class="bg--iris fs-16 text-white rounded-2 px-3 py-1">Learn more</button>
                    </div>
                </div>--->
            </div>
        </div>
    </div>

    <!-- our guide  -->
    <div class="gudie-main py-5">
        <h1 class="text-center text-white fs-60 fw-bold">Our Guide</h1>
        <div class="container mt-5">
            <div class="row">
                <div class="col-4 border-end">
                    <!-- Vertical Tabs Navigation -->
                    <div class="nav flex-column nav-pills-primary" id="v-pills-tab" role="tablist"
                        aria-orientation="vertical">
                        <button class="nav-link fs-18 text-white fw-bold rounded-2 active" id="v-pills-intro-tab"
                            data-bs-toggle="pill" data-bs-target="#v-pills-introduction" type="button" role="tab"
                            aria-controls="v-pills-introduction" aria-selected="true">Home</button>
                        <button class="nav-link fs-18 mt-3 text-white fw-bold rounded-2" id="v-pills-command-tab"
                            data-bs-toggle="pill" data-bs-target="#v-pills-command" type="button" role="tab"
                            aria-controls="v-pills-command" aria-selected="false">Command Line tools</button>
                        <button class="nav-link fs-18 mt-3 text-white fw-bold rounded-2" id="v-pills-working-with-wheels-tab"
                            data-bs-toggle="pill" data-bs-target="#v-working-with-wheels" type="button" role="tab"
                            aria-controls="v-working-with-wheels" aria-selected="false">Working with Wheels</button>
                        <button class="nav-link fs-18 mt-3 text-white fw-bold rounded-2"
                            id="v-pills-handling-request-controllers-tab" data-bs-toggle="pill"
                            data-bs-target="#v-request-controller" type="button" role="tab"
                            aria-controls="v-request-controller" aria-selected="false">Handling Requests with
                            Controllers</button>
                        <button class="nav-link fs-18 mt-3 text-white fw-bold rounded-2" id="v-pills-multiple-format-tab"
                            data-bs-toggle="pill" data-bs-target="#v-multiple-format" type="button" role="tab"
                            aria-controls="v-multiple-format" aria-selected="false">Responding with Multiple
                            Formats</button>
                        <button class="nav-link fs-18 mt-3 text-white fw-bold rounded-2" id="v-pills-displaying-tab"
                            data-bs-toggle="pill" data-bs-target="#v-displaying" type="button" role="tab"
                            aria-controls="v-displaying" aria-selected="false">Displaying Views to Users</button>
                        <button class="nav-link fs-18 mt-3 text-white fw-bold rounded-2" id="v-pills-interaction-tab"
                            data-bs-toggle="pill" data-bs-target="#v-interaction" type="button" role="tab"
                            aria-controls="v-interaction" aria-selected="false">Database Interaction Through
                            Models</button>
                        <button class="nav-link fs-18 mt-3 text-white fw-bold rounded-2" id="v-pills-plugins-tab"
                            data-bs-toggle="pill" data-bs-target="#v-plugins" type="button" role="tab"
                            aria-controls="v-plugins" aria-selected="false">Plugins</button>
                        <button class="nav-link fs-18 mt-3 text-white fw-bold rounded-2" id="v-pills-external-tab"
                            data-bs-toggle="pill" data-bs-target="#v-external" type="button" role="tab"
                            aria-controls="v-external" aria-selected="false">External Links</button>
                    </div>
                </div>
                <div class="col-8">
                    <!-- Vertical Tabs Content -->
                    <div class="tab-content" id="v-pills-tabContent">
                        <div class="tab-pane fade show active" id="v-pills-introduction" role="tabpanel"
                            aria-labelledby="v-pills-intro-tab">
                            <h3 class="fs-24 text--primary fw-semibold">Getting Started</h3>
                            <p class="text-white fs-22">Install Wheels and get a local development server running
                            </p>
                            <p class="fs-18 text-white">
                                By far the quickest way to get started with Wheels is via CommandBox. CommandBox
                                brings a whole host of command line capabilities to the CFML developer. It allows
                                you to write scripts that can be executed at the command line written entirely in
                                CFML. It allows you to start a CFML server from any directory on your machine and
                                wire up the code in that directory as the web root of the server. What's more is,
                                those servers can be either Lucee servers or Adobe ColdFusion servers. You can even
                                specify what version of each server to launch. Lastly, CommandBox is a package
                                manager for CFML. That means you can take some CFML code and package it up into a
                                module, host it on ForgeBox.io, and make it available to other CFML developers. In
                                fact we make extensive use of these capabilities to distribute Wheels plugins and
                                templates. More on that later.
                                One module that we have created is a module that extends CommandBox itself with
                                commands and features specific to the Wheels framework. The Wheels CLI module for
                                CommandBox is modeled after the Ruby on Rails CLI module and gives similar
                                capabilities to developer.By far the quickest way to get started with Wheels is via
                                CommandBox. CommandBox brings a whole host of command line capabilities to the CFML
                                developer. It allows you to write scripts that can be executed at the command line
                                written entirely in CFML. It allows you to start a CFML server from any directory on
                                your machine and wire up the code in that directory as One module that we have
                                created is a module that extends CommandBox itself with commands and features
                                specific to the Wheels framework. The Wheels CLI module for CommandBox is modeled
                                after the Ruby on Rails CLI module and gives similar capabilities to developer.By
                                far the quickest way to get started with Wheels is via CommandBox. CommandBox brings
                                a whole host of command line capabilities to the CFML developer. It allows you to
                                write scripts that can be executed at the command line written entirely in CFML. It
                                allows you to start a CFML server from any directory on your machine and wire up the
                                code in that directory as
                            </p>
                            <div class="d-flex justify-content-end">
                                <button class="bg--primary fs-16 fw-semibold px-3 py-1 rounded text-white">Learn
                                    more</button>
                            </div>
                        </div>
                        <div class="tab-pane fade" id="v-pills-command" role="tabpanel"
                            aria-labelledby="v-pills-command-tab">
                            <h3 class="fs-24 text--primary fw-semibold">Command Line tools</h3>
                            <p class="text-white fs-22">Command Line tools
                            </p>
                            <p class="fs-18 text-white">
                                Lorem ipsum dolor sit amet consectetur adipisicing elit. Tempore repellendus
                                veritatis quod ipsam voluptates sapiente! Quidem, nihil? Nam id natus dolore!
                                Accusamus vel ea error quisquam dolorum deserunt veniam assumenda.
                            </p>
                            <div class="d-flex justify-content-end">
                                <button class="bg--primary fs-16 fw-semibold px-3 py-1 rounded text-white">Learn
                                    more</button>
                            </div>
                        </div>
                        <div class="tab-pane fade" id="v-working-with-wheels" role="tabpanel"
                            aria-labelledby="v-pills-working-with-wheels-tab">
                            <h3 class="fs-24 text--primary fw-semibold">Working with Wheels</h3>
                            <p class="text-white fs-22">Working with Wheels
                            </p>
                            <p class="fs-18 text-white">
                                Lorem ipsum dolor sit amet consectetur adipisicing elit. Tempore repellendus
                                veritatis quod ipsam voluptates sapiente! Quidem, nihil? Nam id natus dolore!
                                Accusamus vel ea error quisquam dolorum deserunt veniam assumenda.
                            </p>
                            <div class="d-flex justify-content-end">
                                <button class="bg--primary fs-16 fw-semibold px-3 py-1 rounded text-white">Learn
                                    more</button>
                            </div>
                        </div>
                        <div class="tab-pane fade" id="v-request-controller" role="tabpanel"
                            aria-labelledby="v-pills-handling-request-controllers-tab">
                            <h3 class="fs-24 text--primary fw-semibold">Handling Requests with Controllers</h3>
                            <p class="text-white fs-22">Handling Requests with Controllers
                            </p>
                            <p class="fs-18 text-white">
                                Lorem ipsum dolor sit amet consectetur adipisicing elit. Tempore repellendus
                                veritatis quod ipsam voluptates sapiente! Quidem, nihil? Nam id natus dolore!
                                Accusamus vel ea error quisquam dolorum deserunt veniam assumenda.
                            </p>
                            <div class="d-flex justify-content-end">
                                <button class="bg--primary fs-16 fw-semibold px-3 py-1 rounded text-white">Learn
                                    more</button>
                            </div>
                        </div>
                        <div class="tab-pane fade" id="v-multiple-format" role="tabpanel"
                            aria-labelledby="v-pills-multiple-format-tab">
                            <h3 class="fs-24 text--primary fw-semibold">Responding with Multiple Formats</h3>
                            <p class="text-white fs-22">Responding with Multiple Formats
                            </p>
                            <p class="fs-18 text-white">
                                Lorem ipsum dolor sit amet consectetur adipisicing elit. Tempore repellendus
                                veritatis quod ipsam voluptates sapiente! Quidem, nihil? Nam id natus dolore!
                                Accusamus vel ea error quisquam dolorum deserunt veniam assumenda.
                            </p>
                            <div class="d-flex justify-content-end">
                                <button class="bg--primary fs-16 fw-semibold px-3 py-1 rounded text-white">Learn
                                    more</button>
                            </div>
                        </div>
                        <div class="tab-pane fade" id="v-displaying" role="tabpanel"
                            aria-labelledby="v-pills-displaying-tab">
                            <h3 class="fs-24 text--primary fw-semibold">Displaying Views to Users</h3>
                            <p class="text-white fs-22">Displaying Views to Users
                            </p>
                            <p class="fs-18 text-white">
                                Lorem ipsum dolor sit amet consectetur adipisicing elit. Tempore repellendus
                                veritatis quod ipsam voluptates sapiente! Quidem, nihil? Nam id natus dolore!
                                Accusamus vel ea error quisquam dolorum deserunt veniam assumenda.
                            </p>
                            <div class="d-flex justify-content-end">
                                <button class="bg--primary fs-16 fw-semibold px-3 py-1 rounded text-white">Learn
                                    more</button>
                            </div>
                        </div>
                        <div class="tab-pane fade" id="v-interaction" role="tabpanel"
                            aria-labelledby="v-pills-interaction-tab">
                            <h3 class="fs-24 text--primary fw-semibold">Database Interaction Through Models</h3>
                            <p class="text-white fs-22">Database Interaction Through Models
                            </p>
                            <p class="fs-18 text-white">
                                Lorem ipsum dolor sit amet consectetur adipisicing elit. Tempore repellendus
                                veritatis quod ipsam voluptates sapiente! Quidem, nihil? Nam id natus dolore!
                                Accusamus vel ea error quisquam dolorum deserunt veniam assumenda.
                            </p>
                            <div class="d-flex justify-content-end">
                                <button class="bg--primary fs-16 fw-semibold px-3 py-1 rounded text-white">Learn
                                    more</button>
                            </div>
                        </div>
                        <div class="tab-pane fade" id="v-plugins" role="tabpanel" aria-labelledby="v-pills-plugins-tab">
                            <h3 class="fs-24 text--primary fw-semibold">Plugins</h3>
                            <p class="text-white fs-22">Plugins
                            </p>
                            <p class="fs-18 text-white">
                                Lorem ipsum dolor sit amet consectetur adipisicing elit. Tempore repellendus
                                veritatis quod ipsam voluptates sapiente! Quidem, nihil? Nam id natus dolore!
                                Accusamus vel ea error quisquam dolorum deserunt veniam assumenda.
                            </p>
                            <div class="d-flex justify-content-end">
                                <button class="bg--primary fs-16 fw-semibold px-3 py-1 rounded text-white">Learn
                                    more</button>
                            </div>
                        </div>
                        <div class="tab-pane fade" id="v-external" role="tabpanel"
                            aria-labelledby="v-pills-external-tab">
                            <h3 class="fs-24 text--primary fw-semibold">External Links</h3>
                            <p class="text-white fs-22">External Links
                            </p>
                            <p class="fs-18 text-white">
                                Lorem ipsum dolor sit amet consectetur adipisicing elit. Tempore repellendus
                                veritatis quod ipsam voluptates sapiente! Quidem, nihil? Nam id natus dolore!
                                Accusamus vel ea error quisquam dolorum deserunt veniam assumenda.
                            </p>
                            <div class="d-flex justify-content-end">
                                <button class="bg--primary fs-16 fw-semibold px-3 py-1 rounded text-white">Learn
                                    more</button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- welcome community -->
    <div class="container py-5 mt-5">
        <div class="row align-items-center gy-5">
            <div class="col-lg-6 text-center col-12">
                <p class="fs-60 line-height-70 fw-bold">Welcome to our community</p>
                <button class="bg--primary fs-16 px-3 py-2 rounded text-white">Explore community</button>
            </div>
            <div class="col-lg-6 text-center col-12">
                <img src="/images/community.png" class="img-fluid" alt="Community" width="428" height="428">
            </div>
        </div>
    </div>

    <!-- Top contribute -->
    <div class="container py-5 mt-5">
        <div class="text-center">
            <p class="fs-60 text--secondary line-height-70 fw-bold">Top Contribute</p>
            <p class="fs-22 text--secondary/70">7 individuals are supporting WHEELS.FW <br> Contribute on Open
                Collective</p>
        </div>
        <div class="d-flex flex-wrap justify-content-center mt-5 gap-3">
            <img src="/images/person1.png" alt="" height="271" width="146">
            <img src="/images/person2.png" class="mt-5" alt="" height="271" width="146">
            <img src="/images/person3.png" alt="" height="271" width="146">
            <img src="/images/person4.png" class="mt-5" alt="" height="271" width="146">
            <img src="/images/person5.png" alt="" height="271" width="146">
            <img src="/images/person6.png" class="mt-5" alt="" height="271" width="146">
            <img src="/images/person7.png" alt="" height="271" width="146">
        </div>
    </div>
</main>