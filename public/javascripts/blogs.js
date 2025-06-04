const loader = document.getElementById("loader-wrapper");
    let isLoading = false;

    document.body.addEventListener("htmx:beforeRequest", function (evt) {
        isLoading = true;
        loader.classList.remove("d-none"); // show loader by removing d-none
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

        const feature = document.getElementById("featureBlogHeading");
        const heading = document.getElementById("blogAuthorHeading");
        const subheading = document.getElementById("blogAuthorSubheading");
        const searchInput = document.getElementById("blogSearchInput");

        // Default values
        const defaultHeading = "Wheels The Fast & Fun CFML Framework!";
        const defaultSubheading = "Build apps quickly with an organized, Ruby on Rails-inspired structure. Get up and running in no time!";
        const defaultPlaceholder = "Search by author name, post title, year or category";

        if (authorInfo) {
            const fullName = authorInfo.dataset.authorName;
            const totalComments = authorInfo.dataset.totalComments;
            const totalPosts = authorInfo.dataset.totalPosts;
            const profilePicture = authorInfo.dataset.profilePicture;

            if(feature) {
                // add class display-none to the feature element
                feature.classList.add('d-none');
            }

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
            if(feature) {
                // remove class display-none to the feature element
                feature.classList.remove('d-none');
            }
            if (heading) heading.textContent = defaultHeading;
            if (subheading) subheading.textContent = defaultSubheading;
            if (searchInput){
                const rawPath = evt.detail.pathInfo.finalRequestPath;
                const path = rawPath.split('?')[0]; // remove query params
                const parts = path.split('/').filter(Boolean);
                let result = "";

                if (path.includes("blog/list/category")) {
                    // Category path: get last part
                    const category = parts[parts.length - 1];
                    result = category;
                } else if (!isNaN(parts[parts.length - 1]) && !isNaN(parts[parts.length - 2])) {
                    // Numeric path: get year and month
                    const month = parseInt(parts[parts.length - 1]);
                    const year = parts[parts.length - 2];
                    const monthName = getMonthName(month);
                    result = `${monthName} ${year}`;
                }

                if (!rawPath.includes("searchTerm=") && !rawPath.includes("page")) {
                    searchInput.value = result;
                }else{
                    removeActive();
                }
                if (path === "/blog/list") {
                    removeActive();
                }
                searchInput.placeholder = defaultPlaceholder;
            }
        }

        if(authorInfo && authorInfo.dataset.page === 1) {
            // Scroll to top after content swap
            window.scrollTo({ top: 50, behavior: "smooth" });
        }
    }
});
function getMonthName(monthNumber) {
    const months = [
        "January", "February", "March", "April", "May", "June",
        "July", "August", "September", "October", "November", "December"
    ];
    return months[monthNumber - 1] || "Invalid Month";
}
function setActive(clickedElement) {
    removeActive();
    // Add 'active' to the clicked one
    clickedElement.classList.add('active');

}
function removeActive(){
    // Remove 'active' from all category items
    document.querySelectorAll('.category-item').forEach(function(el) {
        el.classList.remove('active');
    });
    // Remove 'active' from all archive items
    document.querySelectorAll('.archive-item').forEach(function(el) {
        el.classList.remove('active');
    });
}