<cfoutput>
    <div class="pb-5">
        <div class="row g-4">
            <div class="col-12 col-xxl-12">
                <div class="mb-8">
                    <h2 class="mb-2">Dashboard</h2>
                    <h5 class="text-body-tertiary fw-semibold">Here is what is happening at Wheels right now</h5>
                </div>
                <div class="row align-items-center g-4">
                    <div class="col-12 col-md-auto">
                        <div class="d-flex align-items-center"><span class="fa-stack" style="min-height: 46px;min-width: 46px;"><span class="fa-solid fa-square fa-stack-1x dark__text-opacity-50 text-success-light" data-fa-transform="down-4 rotate--10 left-4"></span><span class="fa-solid fa-circle fa-stack-1x stack-circle text-stats-circle-success" data-fa-transform="up-4 right-3 grow-2"></span><span class="fa-stack-1x fa-solid fa-star text-success " data-fa-transform="shrink-2 up-8 right-6"></span></span>
                            <div class="ms-3">
                                <h4 class="mb-0">#total_new_user# new</h4>
                                <p class="text-body-secondary fs-9 mb-0">user signup today</p>
                            </div>
                        </div>
                    </div>
                    <div class="col-12 col-md-auto">
                        <div class="d-flex align-items-center"><span class="fa-stack" style="min-height: 46px;min-width: 46px;"><span class="fa-solid fa-square fa-stack-1x dark__text-opacity-50 text-warning-light" data-fa-transform="down-4 rotate--10 left-4"></span><span class="fa-solid fa-circle fa-stack-1x stack-circle text-stats-circle-warning" data-fa-transform="up-4 right-3 grow-2"></span><span class="fa-stack-1x fa-solid fa-pause text-warning " data-fa-transform="shrink-2 up-8 right-6"></span></span>
                            <div class="ms-3">
                                <h4 class="mb-0">#total_blogs#</h4>
                                <p class="text-body-secondary fs-9 mb-0">Total Blogs</p>
                            </div>
                        </div>
                    </div>
                    <div class="col-12 col-md-auto">
                        <div class="d-flex align-items-center"><span class="fa-stack" style="min-height: 46px;min-width: 46px;"><span class="fa-solid fa-square fa-stack-1x dark__text-opacity-50 text-danger-light" data-fa-transform="down-4 rotate--10 left-4"></span><span class="fa-solid fa-circle fa-stack-1x stack-circle text-stats-circle-danger" data-fa-transform="up-4 right-3 grow-2"></span><span class="fa-stack-1x fa-solid fa-xmark text-danger " data-fa-transform="shrink-2 up-8 right-6"></span></span>
                            <div class="ms-3">
                                <h4 class="mb-0">#total_testimonials#</h4>
                                <p class="text-body-secondary fs-9 mb-0">Total Testimonials</p>
                            </div>
                        </div>
                    </div>
                </div>
                <hr class="bg-body-secondary mb-6 mt-4" />
            </div>
            <div class="col-12 col-xxl-12">
                <div class="row g-3">
                    <div class="col-12 col-md-6">
                        <div class="card h-100">
                        <div class="card-body">
                            <div class="d-flex justify-content-between">
                                <div>
                                    <h5 class="mb-1">User<span class="badge badge-phoenix badge-phoenix-warning rounded-pill fs-9 ms-2"></h5>
                                    <h6 class="text-body-tertiary">Last 7 days</h6>
                                </div>
                                <h4>3</h4>
                            </div>
                            <div class="d-flex justify-content-center px-4 py-6">
                                <div id="barChart" style="height:85px;width:115px"></div>
                            </div>
                            <div class="mt-2">
                                <div class="d-flex align-items-center mb-2">
                                    <div class="bullet-item bg-primary me-2"></div>
                                    <h6 class="text-body fw-semibold flex-1 mb-0">Total users</h6>
                                    <h6 class="text-body fw-semibold mb-0">#total_user#</h6>
                                </div>
                            </div>
                        </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</cfoutput>