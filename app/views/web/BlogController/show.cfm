<main class="main-blog">
    <cfoutput>
        <cfset tagList = "">
        <cfloop query="tags">
            <cfif tagList EQ "">
                <cfset tagList = name>
            <cfelse>
                <cfset tagList = tagList & ", " & name>
            </cfif>
        </cfloop>
        <!-- Blog filter -->
        <div class="container pt-4 pb-5">
            <a href="/blog" class="py-2 px-3 bg-white shadow-sm rounded-3">
                <i class="bi bi-arrow-left"></i>
                <span class="fs-14 text--secondary">
                    Back
                </span>
            </a>
            <div class="bg-white rounded-5 shadow-sm mt-4 p-4">
                <div class="row gy-4">
                        <div class="col-lg-7 col-12 d-flex flex-column">
                            <div class="d-flex my-3 align-items-center gap-3">
                                <div class="bg-body-secondary rounded-5" style="width:3rem; height:3rem"></div>
                                <p class="fs-18 text--secondary fw-semibold p-0 m-0">#blog.user.name#</p>
                            </div>
                            <h1 class="fs-36 fw-bold text--secondary">
                                #blog.title#
                            </h1>
                            <div class="d-flex flex-wrap flex-grow-1 align-items-end gap-lg-5 gap-2 mt-lg-0 mt-3">
                                <p class="fw-medium fs-12 text--lightGray">#dateformat(blogs.createdat, 'MMMM DD, YYYY')#</p>
                                <p class="fw-medium fs-12 text--lightGray">#blog.PostStatus.name# in #blog.Category.name#</p>
                                <p class="fw-medium fs-12 text--lightGray">Tags: #tagList#</p>
                            </div>
                        </div>
                        <div class="col-lg-5 col-12 text-lg-end text-center">
                            <img src="#attachments.path#" class="img-fluid size-320 mx-auto rounded-4" alt="blog-detail">
                        </div>

                        <div class="col-12">
                            #blog.content#
                        </div>
                </div>
            </div>
        </div>
        
        <!-- recent blogs -->
        <div class="pt-5 blog-main">
            <h1 class="text-center fw-bold fs-60">Recent Blogs</h1>
            <div class="swiper py-5 blogSwiper">
                <div class="swiper-wrapper">
                    <cfloop query= "blogs">
                        <div class="p-4 bg-white rounded-5 shadow-sm swiper-slide">
                            <div>
                                <p class="fs-18 text--secondary/70 fw-bold line-clamp-1">#blogs.title#</p>
                            </div>
                            <div class="d-flex justify-content-between align-items-center">
                                <p class="fs-16 fw-medium text--lightGray">#dateformat(blogs.createdat, 'MMMM DD, YYYY')# by #blogs.name#</p>
                                <button class="bg--iris fs-16 text-white rounded-2 px-3 py-1">Learn more</button>
                            </div>
                        </div>
                    </cfloop>
                </div>
            </div>
        </div>
    </cfoutput>
</main>