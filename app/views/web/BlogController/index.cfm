<main class="main-bg">
    <!-- Blog filter -->
    <div class="container py-5">
        <div class="row">
            <div class="col-lg-4 col-12">
                <input type="text" placeholder="Search" class="form-control border-0 shadow-sm p-2 fs-16 bg-white" name="" id="">
            </div>
            <div class="col-lg-5 mt-lg-0 mt-3 offset-lg-3 col-12 d-flex justify-content-end gap-3">
            </div>
            <div class="col-lg-5 mt-lg-0 mt-3 offset-lg-3 col-12">
                <div class="d-flex blogs align-items-center justify-content-end gap-3">
                    <button onclick="handleBlogFilter('All', this)"
                        class="active px-4 filter-button fs-16 py-2 d-flex align-items-center gap-2 rounded-3 border--iris bg-transparent text--secondary">
                        All
                        <svg class="d-none" width="16" height="16" viewBox="0 0 16 16" fill="none"
                            xmlns="http://www.w3.org/2000/svg">
                            <path
                                d="M8 0C3.592 0 0 3.592 0 8C0 12.408 3.592 16 8 16C12.408 16 16 12.408 16 8C16 3.592 12.408 0 8 0ZM11.768 6.96797L7.76799 10.968C7.60799 11.12 7.408 11.2 7.2 11.2C6.992 11.2 6.79201 11.12 6.63201 10.968L4.23201 8.56797C3.92001 8.25597 3.92001 7.74403 4.23201 7.43203C4.54401 7.12003 5.05599 7.12003 5.36799 7.43203L7.2 9.27207L10.632 5.83203C10.944 5.52003 11.456 5.52003 11.768 5.83203C12.08 6.14403 12.08 6.65597 11.768 6.96797Z"
                                fill="white" />
                        </svg>
                    </button>
                    <button onclick="handleBlogFilter('Archives', this)"
                        class="px-4 filter-button fs-16 py-2 d-flex align-items-center gap-2 rounded-3 border--iris bg-transparent text--secondary">
                        Archives
                        <svg class="d-none" width="16" height="16" viewBox="0 0 16 16" fill="none"
                            xmlns="http://www.w3.org/2000/svg">
                            <path
                                d="M8 0C3.592 0 0 3.592 0 8C0 12.408 3.592 16 8 16C12.408 16 16 12.408 16 8C16 3.592 12.408 0 8 0ZM11.768 6.96797L7.76799 10.968C7.60799 11.12 7.408 11.2 7.2 11.2C6.992 11.2 6.79201 11.12 6.63201 10.968L4.23201 8.56797C3.92001 8.25597 3.92001 7.74403 4.23201 7.43203C4.54401 7.12003 5.05599 7.12003 5.36799 7.43203L7.2 9.27207L10.632 5.83203C10.944 5.52003 11.456 5.52003 11.768 5.83203C12.08 6.14403 12.08 6.65597 11.768 6.96797Z"
                                fill="white" />
                        </svg>
                    </button>
                    <button onclick="handleBlogFilter('Categories', this)"
                        class="px-4 filter-button fs-16 py-2 d-flex align-items-center gap-2 rounded-3 border--iris bg-transparent text--secondary">
                        Categories
                        <svg class="d-none" width="16" height="16" viewBox="0 0 16 16" fill="none"
                            xmlns="http://www.w3.org/2000/svg">
                            <path
                                d="M8 0C3.592 0 0 3.592 0 8C0 12.408 3.592 16 8 16C12.408 16 16 12.408 16 8C16 3.592 12.408 0 8 0ZM11.768 6.96797L7.76799 10.968C7.60799 11.12 7.408 11.2 7.2 11.2C6.992 11.2 6.79201 11.12 6.63201 10.968L4.23201 8.56797C3.92001 8.25597 3.92001 7.74403 4.23201 7.43203C4.54401 7.12003 5.05599 7.12003 5.36799 7.43203L7.2 9.27207L10.632 5.83203C10.944 5.52003 11.456 5.52003 11.768 5.83203C12.08 6.14403 12.08 6.65597 11.768 6.96797Z"
                                fill="white" />
                        </svg>
                    </button>
                </div>
            </div>
        </div>
        <hr class="my-4">

        <div class="row justify-content-center justify-content-lg-between">
            <div id="blogsContainer" class="row mt-lg-0 mt-3 col-lg-12 col-12 h-max row-cols-lg-2 row-cols-1"
                hx-get="/blog/blogs" hx-trigger="load" hx-target="#blogsContainer" hx-swap="innerHTML">
            </div>
            <div id="filtersContainer" class="col-lg-2 order-lg-0 order-first col-12 p-lg-0 d-none">
                <cfset startYear = 2008>
                <cfset startMonth = 12>

                <cfset currentYear = year(now())>
                <cfset currentMonth = month(now())>

                <cfset months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]>

                <div class="d-none bg-white p-3 text-center rounded-18 no-scrollbar h-70vh overflow-y-auto" id="Archives">
                    <cfoutput>
                        <cfloop index="year" from="#currentYear#" to="#startYear#" step="-1">
                            <cfset monthLimit = (year EQ currentYear) ? currentMonth : 12>
                            <cfset startLimit = (year EQ startYear) ? startMonth : 1>

                            <cfloop index="month" from="#monthLimit#" to="#startLimit#" step="-1">
                                <p class="fs-14 border-bottom mb-0 py-2 cursor-pointer fw-normal text--iris"
                                    hx-get="/blog/blogs"
                                    hx-trigger="click"
                                    hx-target="##blogsContainer"
                                    hx-swap="innerHTML"
                                    hx-vals='{"year": "#year#", "month": "#month#"}'>
                                    #months[month]# #year#
                                </p>
                            </cfloop>
                        </cfloop>
                    </cfoutput>
                </div>

                <div class="d-none bg-white p-3 text-center rounded-18" id="Categories" hx-get="/blog/Categories" hx-trigger="load" hx-target="#Categories" hx-swap="innerHTML">                 
                </div>
            </div>
        </div>
    </div>
</main>