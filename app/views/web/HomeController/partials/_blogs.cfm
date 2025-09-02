<cfoutput query= "blogs">
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
