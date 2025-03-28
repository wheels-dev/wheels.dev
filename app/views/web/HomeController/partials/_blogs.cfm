<cfoutput query= "blogs">
    <div class="p-4 bg-white rounded-5 shadow-sm swiper-slide">
        <a href="/blog/#slug#" class="">
            <div>
                <p class="fs-18 mb-3 text--secondary/70 fw-bold line-clamp-1">#blogs.title#</p>
            </div>
        
            <div class="d-flex justify-content-between align-items-center">
                <p class="fs-16 fw-medium text--lightGray">#dateformat(blogs.postCreatedDate, 'MMMM DD, YYYY')# by #blogs.fullName#</p>
                <button class="bg--iris fs-16 text-white rounded-2 px-3 py-1">Learn more</button>
            </div>
        </a>
    </div>
</cfoutput>
