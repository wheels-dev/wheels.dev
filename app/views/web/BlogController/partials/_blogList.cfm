<cfoutput>
    <cfloop query="blogs">
        <div class="pb-4 items">
            <div class="d-flex flex-column rounded-bottom-4 shadow-sm bg-white px-0 overflow-hidden justify-content-between">
                <a href="/blog/#slug#">
                    <div class="default-blog rounded-top-4">
                        <p class="blog-title-overlay">#blogs.title#</p>
                    </div>
                </a>
                <div class="p-3 flex-grow-1 d-flex justify-content-between flex-column">
                    <p class="fs-18 text-black fw-bold line-clamp-1">#blogs.title#</p>
                    <div class="d-flex align-items-center gap-2 mt-3">
                        <a href="javascript:void(0)" hx-trigger="click" hx-post="/blog/author-profile" hx-vals='{"author": "#blogs.createdby#"}' hx-target="body" hx-swap="innerHTML">
                            #imageTag(source='#profilePicture#', style="width:2.5rem; height:2.5rem",
                            class="bg-body-secondary rounded-5 flex-shrink-0", alt="profile-picture")#
                        </a>
                        <div>
                            <p class="text--secondary fw-bold fs-14 m-0">#blogs.firstname# #blogs.lastname#</p>
                            <p class="text--lightGray fs-12 fw-medium" hx-trigger="click" hx-get="/blog/list/#DateFormat(blogs.postDate, "yyyy")#/#DateFormat(blogs.postDate, "mm")#" hx-target="##blogsContainer" hx-swap="innerHTML" style="cursor: pointer;">
                                #dateformat(blogs.postDate, 'MMMM DD, YYYY')#
                            </p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </cfloop>
</cfoutput>
<script>
    $(document).ready(function () {
        let items = $('.items');
        let itemsPerPage = 6;
        let currentIndex = 0;
        let loading = false;

        if (items.length <= itemsPerPage) {
            items.show(); // Show items if they are 4 or fewer
            $('#loader').hide();
            return;
        }
        // Hide all items initially
        items.hide();

        // Function to show next set of items
        function showNextItems() {
            let nextItems = items.slice(currentIndex, currentIndex + itemsPerPage);
            nextItems.fadeIn();
            currentIndex += itemsPerPage;

            if (currentIndex >= items.length) {
                $(window).off('scroll', onScroll); // All items shown, stop scroll
            }
            loading = false;
        }

        // Scroll handler
        function onScroll() {
            if (loading) return;
            if ($(window).scrollTop() + $(window).height() >= $(document).height() - 500) {
                loading = true;
                $('#loader').show();
                setTimeout(() => {
                    showNextItems();
                    $('#loader').hide();
                }, 1000); // Simulate a brief delay
            }
        }

        // Initial load
        showNextItems();

        // Attach scroll event
        $(window).on('scroll', onScroll);
    });
</script>