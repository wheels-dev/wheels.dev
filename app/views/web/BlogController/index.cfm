<div>
    <!-- Blog filter -->
    <div class="w-100 h-600 position-relative feature-blog">
        <div class="position-absolute mx-auto container start-0 end-0 bottom-50px">
            <p class="text-white fs-18 pb-2">Featured</p>
            <p id="blogAuthorHeading" class="text-white fw-bold fs-36 pb-3 line-height-100">Wheels The Fast & Fun CFML Framework!</p>
            <p id="blogAuthorSubheading" class="text-white opacity-50 fs-18">Build apps quickly with an organized, Ruby on Rails-inspired
            structure. Get up and running in no time!</p>
        </div>
    </div>
    <main class="main-bg">
        <div class="container">
            <div class="pt-5">
                <div class="row">
                    <div class="col-lg-4 col-12">
                        <input id="blogSearchInput" placeholder="Search" type="text" hx-get="/blog/Search" hx-trigger="keyup changed delay:500ms" hx-target="#blogsContainer" hx-swap="innerHTML" name="searchTerm" class="fs-14 flex-grow-1 form-control form-check-input-primary py-2 px-3 rounded-18">
                    </div>
                    <div class="col-lg-5 mt-lg-0 mt-3 offset-lg-3 col-12">
                        <div class="d-flex blogs align-items-center justify-content-end gap-3 flex-wrap">

                            <cfif isLoggedInUser()>
                                <a href="/blog/create"
                                    class="bg--primary text-white text-center d-none py-2 fs-16 rounded-3 col-4">Create
                                    Blog</a>
                            </cfif>

                            <button onclick="handleBlogFilter('All', this)" hx-swap="innerHTML"
                                hx-get="/blog/list" hx-target="#blogsContainer"
                                class="active px-4 hover:bg--primary hover:text-white filter-button fs-16 py-2 d-flex align-items-center gap-2 rounded-3 border border--primary bg-transparent text--secondary">
                                All
                                <svg class="d-none" width="16" height="16" viewBox="0 0 16 16" fill="none"
                                    xmlns="http://www.w3.org/2000/svg">
                                    <path
                                        d="M8 0C3.592 0 0 3.592 0 8C0 12.408 3.592 16 8 16C12.408 16 16 12.408 16 8C16 3.592 12.408 0 8 0ZM11.768 6.96797L7.76799 10.968C7.60799 11.12 7.408 11.2 7.2 11.2C6.992 11.2 6.79201 11.12 6.63201 10.968L4.23201 8.56797C3.92001 8.25597 3.92001 7.74403 4.23201 7.43203C4.54401 7.12003 5.05599 7.12003 5.36799 7.43203L7.2 9.27207L10.632 5.83203C10.944 5.52003 11.456 5.52003 11.768 5.83203C12.08 6.14403 12.08 6.65597 11.768 6.96797Z"
                                        fill="white" />
                                </svg>
                            </button>
                            <button onclick="handleBlogFilter('Archives', this)"
                                class="px-4 hover:bg--primary hover:text-white filter-button fs-16 py-2 d-flex align-items-center gap-2 rounded-3 border border--primary bg-transparent text--secondary">
                                Archives
                                <svg class="d-none" width="16" height="16" viewBox="0 0 16 16" fill="none"
                                    xmlns="http://www.w3.org/2000/svg">
                                    <path
                                        d="M8 0C3.592 0 0 3.592 0 8C0 12.408 3.592 16 8 16C12.408 16 16 12.408 16 8C16 3.592 12.408 0 8 0ZM11.768 6.96797L7.76799 10.968C7.60799 11.12 7.408 11.2 7.2 11.2C6.992 11.2 6.79201 11.12 6.63201 10.968L4.23201 8.56797C3.92001 8.25597 3.92001 7.74403 4.23201 7.43203C4.54401 7.12003 5.05599 7.12003 5.36799 7.43203L7.2 9.27207L10.632 5.83203C10.944 5.52003 11.456 5.52003 11.768 5.83203C12.08 6.14403 12.08 6.65597 11.768 6.96797Z"
                                        fill="white" />
                                </svg>
                            </button>
                            <button onclick="handleBlogFilter('Categories', this)"
                                class="px-4 hover:bg--primary hover:text-white filter-button fs-16 py-2 d-flex align-items-center gap-2 rounded-3 border border--primary bg-transparent text--secondary">
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
            </div>
            <div class="pt-4">
                <p class="fs-22 pb-4 fw-medium">Recent blog posts</p>
                <!-- Loader Element -->
                <div class="d-flex justify-content-center" id="loader-wrapper">
                    <div style="width: 2rem; height: 2rem;" class="spinner-border my-5 text--primary" role="status">
                        <span class="visually-hidden">Loading...</span>
                    </div>
                </div>
                <div class="row justify-content-center justify-content-lg-between">
                    <cfoutput>
                        <!-- Detect if filtering via route (e.g. blog/year/month or blog/category/tag) -->
                        <cfif isDefined("params.filterType") and isDefined("params.filterValue")>
                            <cfset blogUrl="/blog/list/#params.filterType#/#params.filterValue#">
                            <cfelse>
                            <cfset blogUrl="/blog/list">
                        </cfif>
                        <!-- wrapper that triggers the HTMX call -->
                        <div id="hxLoader" hx-get="#blogUrl#" hx-trigger="load" hx-target="##blogsContainer"
                            hx-swap="innerHTML"  hx-indicator="##loader-wrapper">
                        </div>
                        <!-- blog list container -->
                        <div id="blogsContainer" class="row mt-lg-0 mt-3 col-lg-12 col-12 h-max row-cols-lg-3 row-cols-1">
                        </div>
                    </cfoutput>
                    <div id="filtersContainer" class="col-lg-2 order-lg-0 order-first col-12 p-lg-0 d-none">
                        <cfset startYear=2000>
                        <cfset startMonth=12>
                        <cfset currentYear=year(now())>
                        <cfset currentMonth=month(now())>
                        <cfset months=["January", "February" , "March" , "April" , "May" , "June" , "July" , "August" , "September" , "October" , "November" , "December" ]>

                        <div class="d-none bg-white p-3 text-center rounded-18 no-scrollbar h-70vh overflow-y-auto" id="Archives">
                            <!-- Archives Button -->
                            <cfoutput>
                                <cfloop index="year" from="#currentYear#" to="#startYear#" step="-1">
                                    <cfset monthLimit=(year EQ currentYear) ? currentMonth : 12>
                                    <cfset startLimit=(year EQ startYear) ? startMonth : 1>

                                    <cfloop index="month" from="#monthLimit#" to="#startLimit#"
                                        step="-1">
                                        <p hx-get="/blog/list/#year#/#NumberFormat(month, '00')#"
                                            hx-target="##blogsContainer" hx-swap="innerHTML"
                                            class="fs-14 border-bottom mb-0 py-2 cursor-pointer fw-normal text--secondary">
                                            #months[month]# #year#
                                        </p>
                                    </cfloop>
                                </cfloop>
                            </cfoutput>
                        </div>
                        <div class="d-none bg-white p-3 text-center rounded-18" id="Categories"
                            hx-get="/blog/Categories" hx-trigger="load" hx-target="#Categories"
                            hx-swap="innerHTML">
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<script>
    const loader = document.getElementById("loader-wrapper");

    let isLoading = false;

    document.body.addEventListener("htmx:beforeRequest", function (evt) {
        if (evt.target.id === "hxLoader" && !isLoading) {
            isLoading = true;
            loader.classList.remove("d-none"); // show loader by removing d-none
        }
    });

    document.body.addEventListener("htmx:afterSwap", function (evt) {
        if (evt.target.id === "blogsContainer" && isLoading) {
            isLoading = false;
            loader.classList.add("d-none"); // hide loader by adding d-none
        }
    });

    document.body.addEventListener("htmx:responseError", function (evt) {
        isLoading = false; // Reset loading flag on error
        loader.classList.add("d-none"); // hide loader on error by adding d-none
        alert("Failed to load blogs.");
    });

    const handleBlogFilter = (type, button) => {
    const blogsContainer = document.getElementById('blogsContainer');
    const filtersContainer = document.getElementById('filtersContainer');
    const archives = document.getElementById('Archives');
    const categories = document.getElementById('Categories');

    blogsContainer.classList.remove('col-lg-12', 'col-lg-10');
    blogsContainer.classList.add(type === 'All' ? 'col-lg-12' : 'col-lg-10');
    filtersContainer.classList.remove('d-none');

    const buttons = document.querySelectorAll('.filter-button');
    buttons.forEach(btn => {
        btn.classList.remove('active');
    });
    button.classList.add('active');

    Array.from(filtersContainer.children).forEach(child => child.classList.add('d-none'));

    if (type === 'All') {
        filtersContainer.classList.add('d-none');
    } else if (type === 'Archives') {
        archives.classList.remove('d-none');
        categories.classList.add('d-none');
    } else {
        archives.classList.add('d-none');
        document.getElementById(type).classList.remove('d-none');
    }
}
document.body.addEventListener("htmx:afterSwap", function(evt) {
    if (evt.target.id === "blogsContainer") {
        const authorInfo = document.getElementById("blogAuthorInfo");

        const heading = document.getElementById("blogAuthorHeading");
        const subheading = document.getElementById("blogAuthorSubheading");
        const searchInput = document.getElementById("blogSearchInput");

        // Default values
        const defaultHeading = "Wheels The Fast & Fun CFML Framework!";
        const defaultSubheading = "Build apps quickly with an organized, Ruby on Rails-inspired structure. Get up and running in no time!";
        const defaultPlaceholder = "Search in blog...";

        if (authorInfo) {
        const fullName = authorInfo.dataset.authorName;
        const totalComments = authorInfo.dataset.totalComments;
        const totalPosts = authorInfo.dataset.totalPosts;
        const profilePicture = authorInfo.dataset.profilePicture;

        if (heading) {
            heading.innerHTML = profilePicture + ' <span>' + fullName + '</span>';
        }

        if (subheading) {
            subheading.textContent = totalPosts + ' blog posts' +' - ' + totalComments +' comments';
        }

        if (searchInput) {
            searchInput.value = `${fullName}`;
        }
        } else {
        // Revert to original content
        if (heading) heading.textContent = defaultHeading;
        if (subheading) subheading.textContent = defaultSubheading;
            if (searchInput){
                searchInput.value = "";
                searchInput.placeholder = defaultPlaceholder;
            }
        }

        // Scroll to top after content swap
        window.scrollTo({ top: 50, behavior: "smooth" });
    }
});
</script>
