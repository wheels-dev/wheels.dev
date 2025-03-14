<cfoutput>
    <cfloop query="blogs">
        <div class="pb-4">
            <a href="/blog/#slug#" class="d-flex bg-white px-0 rounded-4 overflow-hidden justify-content-between">
                <div class="p-3 flex-grow-1 rounded-start-4 d-flex justify-content-between flex-column">
                    <div>
                        <div class="border--iris w-max border-2 rounded-4 px-3 py-2">
                            <p class="text--iris fw-medium fs-12 m-0">#blogs.firstname# #blogs.lastname#</p>
                        </div>
                        <p class="fs-18 mt-4 text-black fw-bold">#blogs.title#</p>
                    </div>
                    <p class="text--lightGray fs-12 fw-medium">#dateformat(blogs.createdAt, 'MMMM DD, YYYY')#</p>
                </div>
                <div class="d-lg-block d-none position-relative">
                    <img src="#blogs.coverImagePath#" class="rounded-end-4 size-320 object-fit-cover">
                </div>
            </a>
        </div>
    </cfloop>
</cfoutput>
