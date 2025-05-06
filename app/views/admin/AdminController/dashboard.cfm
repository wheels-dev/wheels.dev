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
                        <div class="d-flex align-items-center"><span class="fa-stack" style="min-height: 86px;min-width: 86px;"><span class="fa-solid fa-square fa-stack-2x dark__text-opacity-50 text-success-light" data-fa-transform="down-4 rotate--10 left-4"></span><span class="fa-solid fa-circle fa-stack-2x stack-circle text-stats-circle-success" data-fa-transform="up-4 right-3 grow-2"></span><span class="fa-stack-2x fa-solid fa-user-plus text-success " data-fa-transform="shrink-2 up-8 right-6"></span></span>
                            <div class="ms-3">
                                <h4 class="mb-0">#totalNewUser# new</h4>
                                <p class="text-body-secondary fs-9 mb-0">user signup today</p>
                            </div>
                        </div>
                    </div>
                    <div class="col-12 col-md-auto">
                        <div class="d-flex align-items-center"><span class="fa-stack" style="min-height: 86px;min-width: 86px;"><span class="fa-solid fa-square fa-stack-2x dark__text-opacity-50 text-warning-light" data-fa-transform="down-4 rotate--10 left-4"></span><span class="fa-solid fa-circle fa-stack-2x stack-circle text-stats-circle-warning" data-fa-transform="up-4 right-3 grow-2"></span><span class="fa-stack-2x fa-brands fa-rocketchat text-warning " data-fa-transform="shrink-2 up-8 right-6"></span></span>
                            <div class="ms-3">
                                <h4 class="mb-0">#totalBlogs#</h4>
                                <p class="text-body-secondary fs-9 mb-0">Total Blogs</p>
                            </div>
                        </div>
                    </div>
                    <div class="col-12 col-md-auto">
                        <div class="d-flex align-items-center"><span class="fa-stack" style="min-height: 86px;min-width: 86px;"><span class="fa-solid fa-square fa-stack-2x dark__text-opacity-50 text-danger-light" data-fa-transform="down-4 rotate--10 left-4"></span><span class="fa-solid fa-circle fa-stack-2x stack-circle text-stats-circle-danger" data-fa-transform="up-4 right-3 grow-2"></span><span class="fa-stack-2x fa-solid fa-quote-left text-danger " data-fa-transform="shrink-2 up-8 right-6"></span></span>
                            <div class="ms-3">
                                <h4 class="mb-0">#totalTestimonials#</h4>
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
                                <h4>#last_seven_days_user.recordcount#</h4>
                            </div>
                            <div class="d-flex justify-content-center">
                                <div id="barChart" style="height:300px;width:90%"></div>
                            </div>
                            <div class="mt-2">
                                <div class="d-flex align-items-center mb-2">
                                    <div class="bullet-item bg-primary me-2"></div>
                                    <h6 class="text-body fw-semibold flex-1 mb-0">Total users</h6>
                                    <h6 class="text-body fw-semibold mb-0">#totalUser#</h6>
                                </div>
                                <div class="d-flex align-items-center mb-2">
                                    <div class="bullet-item bg-success me-2"></div>
                                    <h6 class="text-body fw-semibold flex-1 mb-0">Total Active User</h6>
                                    <h6 class="text-body fw-semibold mb-0">#activeUsers#</h6>
                                </div>
                            </div>
                        </div>
                        </div>
                    </div>
                    <div class="col-12 col-md-6">
                        <div class="card h-100">
                        <div class="card-body">
                            <div class="d-flex justify-content-between">
                                <div>
                                    <h5 class="mb-1">Total Comments<span class="badge badge-phoenix badge-phoenix-warning rounded-pill fs-9 ms-2"></h5>
                                    <h6 class="text-body-tertiary">Comments activity in Last 7 days</h6>
                                </div>
                                <h4>#totalComments#</h4>
                            </div>
                            <div class="d-flex justify-content-center">
                                <div id="echarts-comments" style="height:300px;width:90%"></div>
                            </div>
                            <div>
                                <div class="d-flex align-items-center mb-2">
                                    <div class="bullet-item bg-success me-2"></div>
                                    <h6 class="text-body fw-semibold flex-1 mb-0">Approved Comments</h6>
                                    <h6 class="text-body fw-semibold mb-0">#totalPublishComments#</h6>
                                </div>
                                <div class="d-flex align-items-center mb-2">
                                    <div class="bullet-item bg-danger me-2"></div>
                                    <h6 class="text-body fw-semibold flex-1 mb-0">Waiting for Approval Comments</h6>
                                    <h6 class="text-body fw-semibold mb-0">#totalUnPublishComments#</h6>
                                </div>
                            </div>
                        </div>
                        </div>
                    </div>
                    <div class="col-12 col-md-6 col-lg-12">
                        <div class="card h-100">
                        <div class="card-body">
                            <div class="d-flex justify-content-between">
                                <div>
                                    <h5 class="mb-2">Blogs</h5>
                                    <h6 class="text-body-tertiary">Total categories</h6>
                                </div>
                                <h4>#totalCategories#</h4>
                            </div>
                            <div class="d-flex justify-content-center">
                                <div id="echart-blogs" style="height:300px;width:50%;"></div>
                            </div>
                            <div>
                                <div class="d-flex align-items-center mb-2">
                                    <div class="bullet-item bg-primary me-2"></div>
                                    <h6 class="text-body fw-semibold flex-1 mb-0">Total blogs</h6>
                                    <h6 class="text-body fw-semibold mb-0">#totalBlogs#</h6>
                                </div>
                                <div class="d-flex align-items-center mb-2">
                                    <div class="bullet-item bg-success me-2"></div>
                                    <h6 class="text-body fw-semibold flex-1 mb-0">Approved Blogs</h6>
                                    <h6 class="text-body fw-semibold mb-0">#totalApprovedBlogs#</h6>
                                </div>
                                <div class="d-flex align-items-center mb-2">
                                    <div class="bullet-item bg-danger me-2"></div>
                                    <h6 class="text-body fw-semibold flex-1 mb-0">Rejected Blogs</h6>
                                    <h6 class="text-body fw-semibold mb-0">#rejectedBlogs#</h6>
                                </div>
                                <div class="d-flex align-items-center mb-2">
                                    <div class="bullet-item bg-primary-lighter me-2"></div>
                                    <h6 class="text-body fw-semibold flex-1 mb-0">Waiting for Approval</h6>
                                    <h6 class="text-body fw-semibold mb-0">#waitingforApprovalBlogs#</h6>
                                </div>
                            </div>
                        </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script>
        var userChartData = #userJsonData#; // CFML JSON data

        var days = userChartData.map(item => {
            var date = new Date(item.day);
            var day = date.getDate();
            var month = date.toLocaleString('default', { month: 'short' });
            return `${day}-${month}`;
        });
        var values = userChartData.map(item => item.usercount);

        var chart = echarts.init(document.getElementById('barChart'));

        var options = {
            tooltip: { show: true },
            xAxis: { data: days },
            yAxis: {  type: 'value' },
            series: [{
                type: 'bar',
                barMinHeight: 10,
                data: values,
                itemStyle: { color: '##2B6ED8' } // Blue bars
            }],
            tooltip: { trigger: 'axis', formatter: params => `${params[0].name}: ${params[0].value} Users` }
        };

        chart.setOption(options);

        var commentsChartData = #commentJsonData#;  // Inject ColdFusion JSON Data
        
        var days = commentsChartData.map(item => {
            var date = new Date(item.day);
            var day = date.getDate();
            var month = date.toLocaleString('default', { month: 'short' });
            return `${day}-${month}`;
        });
        var commentcount = commentsChartData.map(item => item.commentcount);

        var ipchart = echarts.init(document.getElementById('echarts-comments'));
        var options = {
            xAxis: { data: days },
            yAxis: { type: 'value' }, 
            series: [{ 
                type: 'bar', 
                barMinHeight: 10,
                data: commentcount, 
                itemStyle: { color: '##fc9ad0' } // Set bar color
            }],
            tooltip: { trigger: 'axis', formatter: params => `${params[0].name}: ${params[0].value} Comments` }
        };
        ipchart.setOption(options);


        var blogChartData = #blogJsonData#;  // Inject ColdFusion JSON Data
        
        var days = blogChartData.map(item => {
            var date = new Date(item.day);
            var day = date.getDate();
            var month = date.toLocaleString('default', { month: 'short' });
            return `${day}-${month}`;
        });
        var blogcount = blogChartData.map(item => item.blogcount);

        var logchart = echarts.init(document.getElementById('echart-blogs'));
        var options = {
            xAxis: { data: days},  // Hide axis labels
            yAxis: { type: 'value' },  // Hide axis labels
            series: [{ 
                type: 'bar',
                barMinHeight: 10, 
                data: blogcount, 
                itemStyle: { color: '##57b396' } // Set bar color
            }],
            tooltip: { trigger: 'axis', formatter: params => `${params[0].name}: ${params[0].value} Blogs` }
        };
        logchart.setOption(options);
    </script>
</cfoutput>