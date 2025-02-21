<main class="main-blog">
    <!-- Blog filter -->
    <div class="container py-5">
        <div class="row">
            <div class="col-lg-4 col-12">
                <input type="text" placeholder="Search" class="form-control border-0 shadow-sm p-2 fs-16 bg-white"
                    name="" id="">
            </div>
            <div class="col-lg-4 mt-lg-0 mt-3 offset-lg-4 col-12">
                <div class="d-flex flex-wrap align-items-center justify-content-end gap-3">
                    <!-- px-4 fs-16 py-2 d-flex align-items-center gap-2 rounded-3 border--iris bg--iris text-white -->
                    <button onclick="handleBlogFilter('All', this)"
                        class="px-4 filter-blog-button fs-16 py-2 d-flex align-items-center gap-2 rounded-3 border--iris bg--iris text-white text--secondary">
                        All
                        <svg width="16" height="16" viewBox="0 0 16 16" fill="none"
                            xmlns="http://www.w3.org/2000/svg">
                            <path
                                d="M8 0C3.592 0 0 3.592 0 8C0 12.408 3.592 16 8 16C12.408 16 16 12.408 16 8C16 3.592 12.408 0 8 0ZM11.768 6.96797L7.76799 10.968C7.60799 11.12 7.408 11.2 7.2 11.2C6.992 11.2 6.79201 11.12 6.63201 10.968L4.23201 8.56797C3.92001 8.25597 3.92001 7.74403 4.23201 7.43203C4.54401 7.12003 5.05599 7.12003 5.36799 7.43203L7.2 9.27207L10.632 5.83203C10.944 5.52003 11.456 5.52003 11.768 5.83203C12.08 6.14403 12.08 6.65597 11.768 6.96797Z"
                                fill="white" />
                        </svg>
                    </button>
                    <button onclick="handleBlogFilter('Archives', this)"
                        class="px-4 filter-blog-button fs-16 py-2 d-flex align-items-center gap-2 rounded-3 border--iris bg-transparent text--secondary">
                        Archives
                        <svg class="d-none" width="16" height="16" viewBox="0 0 16 16" fill="none"
                            xmlns="http://www.w3.org/2000/svg">
                            <path
                                d="M8 0C3.592 0 0 3.592 0 8C0 12.408 3.592 16 8 16C12.408 16 16 12.408 16 8C16 3.592 12.408 0 8 0ZM11.768 6.96797L7.76799 10.968C7.60799 11.12 7.408 11.2 7.2 11.2C6.992 11.2 6.79201 11.12 6.63201 10.968L4.23201 8.56797C3.92001 8.25597 3.92001 7.74403 4.23201 7.43203C4.54401 7.12003 5.05599 7.12003 5.36799 7.43203L7.2 9.27207L10.632 5.83203C10.944 5.52003 11.456 5.52003 11.768 5.83203C12.08 6.14403 12.08 6.65597 11.768 6.96797Z"
                                fill="white" />
                        </svg>
                    </button>
                    <button onclick="handleBlogFilter('Categories', this)"
                        class="px-4 filter-blog-button fs-16 py-2 d-flex align-items-center gap-2 rounded-3 border--iris bg-transparent text--secondary">
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
            <div id="blogsContainer" class="row mt-lg-0 mt-3 col-lg-12 col-12 h-max row-cols-lg-2 row-cols-1">
                <cfoutput>
                    <cfloop query="blogs">
                        <a href="/blog/#id#" class="d-flex px-lg-2 px-0 rounded-4 overflow-hidden mb-3 justify-content-between">
                            <div
                                class="p-3 flex-grow-1 bg-white rounded-start-4 d-flex justify-content-between flex-column ">
                                <div>
                                    <div class="border--iris w-max border-2 rounded-4 px-3 py-2">
                                        <p class="text--iris fw-medium fs-12 m-0">#blogs.name#</p>
                                    </div>
                                    <p class="fs-18 mt-4 text-black fw-bold">#blogs.title#</p>
                                </div>
                                <p class="text--lightGray fs-12 fw-medium">#dateformat(blogs.createdat, 'MMMM DD, YYYY')#</p>
                            </div>
                            <div class="d-lg-block d-none position-relative">
                                <img src="/images/blogs.jpg" width="320" class="rounded-end-4">
                            </div>
                        </a>
                    </cfloop>
                </cfoutput>
            </div>
            <div id="filtersContainer" class="col-lg-2 order-lg-0 order-first col-12 p-lg-0 d-none">
                <div class="d-none bg-white p-3 text-center rounded-18 no-scrollbar h-70vh overflow-y-auto"
                    id="Archives">
                    <p class="fs-14 border-bottom mb-0 py-2 cursor-pointer fw-normal text--iris">January 2025</p>
                    <p class="fs-14 border-bottom mb-0 py-2 cursor-pointer fw-normal text--iris">November 2023</p>
                    <p class="fs-14 border-bottom mb-0 py-2 cursor-pointer fw-normal text--iris">October 2022</p>
                    <p class="fs-14 border-bottom mb-0 py-2 cursor-pointer fw-normal text--iris">September 2022</p>
                    <p class="fs-14 border-bottom mb-0 py-2 cursor-pointer fw-normal text--iris">August 2022</p>
                    <p class="fs-14 border-bottom mb-0 py-2 cursor-pointer fw-normal text--iris">June 2022</p>
                    <p class="fs-14 border-bottom mb-0 py-2 cursor-pointer fw-normal text--iris">May 2022</p>
                    <p class="fs-14 border-bottom mb-0 py-2 cursor-pointer fw-normal text--iris">April 2022</p>
                    <p class="fs-14 border-bottom mb-0 py-2 cursor-pointer fw-normal text--iris">March 2022</p>
                    <p class="fs-14 border-bottom mb-0 py-2 cursor-pointer fw-normal text--iris">November 2020</p>
                    <p class="fs-14 border-bottom mb-0 py-2 cursor-pointer fw-normal text--iris">April 2020</p>
                    <p class="fs-14 border-bottom mb-0 py-2 cursor-pointer fw-normal text--iris">March 2020</p>
                    <p class="fs-14 border-bottom mb-0 py-2 cursor-pointer fw-normal text--iris">February 2020</p>
                    <p class="fs-14 border-bottom mb-0 py-2 cursor-pointer fw-normal text--iris">October 2019</p>
                    <p class="fs-14 border-bottom mb-0 py-2 cursor-pointer fw-normal text--iris">February 2019</p>
                    <p class="fs-14 border-bottom mb-0 py-2 cursor-pointer fw-normal text--iris">September 2018</p>
                    <p class="fs-14 border-bottom mb-0 py-2 cursor-pointer fw-normal text--iris">May 2018</p>
                    <p class="fs-14 border-bottom mb-0 py-2 cursor-pointer fw-normal text--iris">March 2018</p>
                    <p class="fs-14 border-bottom mb-0 py-2 cursor-pointer fw-normal text--iris">February 2018</p>
                    <p class="fs-14 border-bottom mb-0 py-2 cursor-pointer fw-normal text--iris">January 2018</p>
                    <p class="fs-14 border-bottom mb-0 py-2 cursor-pointer fw-normal text--iris">October 2017</p>
                    <p class="fs-14 border-bottom mb-0 py-2 cursor-pointer fw-normal text--iris">September 2017</p>
                    <p class="fs-14 border-bottom mb-0 py-2 cursor-pointer fw-normal text--iris">June 2017</p>
                    <p class="fs-14 border-bottom mb-0 py-2 cursor-pointer fw-normal text--iris">May 2017</p>
                    <p class="fs-14 border-bottom mb-0 py-2 cursor-pointer fw-normal text--iris">March 2016</p>
                    <p class="fs-14 border-bottom mb-0 py-2 cursor-pointer fw-normal text--iris">December 2015</p>
                    <p class="fs-14 border-bottom mb-0 py-2 cursor-pointer fw-normal text--iris">October 2015</p>
                    <p class="fs-14 border-bottom mb-0 py-2 cursor-pointer fw-normal text--iris">August 2015</p>
                    <p class="fs-14 border-bottom mb-0 py-2 cursor-pointer fw-normal text--iris">May 2015</p>
                    <p class="fs-14 border-bottom mb-0 py-2 cursor-pointer fw-normal text--iris">February 2015</p>
                    <p class="fs-14 border-bottom mb-0 py-2 cursor-pointer fw-normal text--iris">November 2014</p>
                    <p class="fs-14 border-bottom mb-0 py-2 cursor-pointer fw-normal text--iris">August 2014</p>
                    <p class="fs-14 border-bottom mb-0 py-2 cursor-pointer fw-normal text--iris">April 2013</p>
                    <p class="fs-14 border-bottom mb-0 py-2 cursor-pointer fw-normal text--iris">May 2012</p>
                    <p class="fs-14 border-bottom mb-0 py-2 cursor-pointer fw-normal text--iris">December 2011</p>
                    <p class="fs-14 border-bottom mb-0 py-2 cursor-pointer fw-normal text--iris">October 2011</p>
                    <p class="fs-14 border-bottom mb-0 py-2 cursor-pointer fw-normal text--iris">August 2011</p>
                    <p class="fs-14 border-bottom mb-0 py-2 cursor-pointer fw-normal text--iris">July 2011</p>
                    <p class="fs-14 border-bottom mb-0 py-2 cursor-pointer fw-normal text--iris">May 2011</p>
                    <p class="fs-14 border-bottom mb-0 py-2 cursor-pointer fw-normal text--iris">March 2011</p>
                    <p class="fs-14 border-bottom mb-0 py-2 cursor-pointer fw-normal text--iris">February 2011</p>
                    <p class="fs-14 border-bottom mb-0 py-2 cursor-pointer fw-normal text--iris">January 2011</p>
                    <p class="fs-14 border-bottom mb-0 py-2 cursor-pointer fw-normal text--iris">December 2010</p>
                    <p class="fs-14 border-bottom mb-0 py-2 cursor-pointer fw-normal text--iris">December 2009</p>
                    <p class="fs-14 border-bottom mb-0 py-2 cursor-pointer fw-normal text--iris">December 2008</p>

                </div>
                <div class="d-none bg-white p-3 text-center rounded-18" id="Categories">
                    <p class="fs-14 border-bottom mb-0 py-2 cursor-pointer fw-normal text--iris">CLI</p>
                    <p class="fs-14 border-bottom mb-0 py-2 cursor-pointer fw-normal text--iris">Community</p>
                    <p class="fs-14 border-bottom mb-0 py-2 cursor-pointer fw-normal text--iris">Contributions</p>
                    <p class="fs-14 border-bottom mb-0 py-2 cursor-pointer fw-normal text--iris">Documentation</p>
                    <p class="fs-14 border-bottom mb-0 py-2 cursor-pointer fw-normal text--iris">Events</p>
                    <p class="fs-14 border-bottom mb-0 py-2 cursor-pointer fw-normal text--iris">Inspiration</p>
                    <p class="fs-14 border-bottom mb-0 py-2 cursor-pointer fw-normal text--iris">Plugin</p>
                    <p class="fs-14 border-bottom mb-0 py-2 cursor-pointer fw-normal text--iris">Releases</p>
                    <p class="fs-14 border-bottom mb-0 py-2 cursor-pointer fw-normal text--iris">Tips & Tricks</p>
                    <p class="fs-14 border-bottom mb-0 py-2 cursor-pointer fw-normal text--iris">Tutorials</p>
                    <p class="fs-14 border-bottom mb-0 py-2 cursor-pointer fw-normal text--iris">Website</p>
                </div>
            </div>
        </div>
    </div>
</main>