<cfoutput>
    <cfloop query="blogs">
        <div class="pb-4 items">
            <a href="/blog/#slug#" class="d-flex bg-white px-0 rounded-4 overflow-hidden justify-content-between">
                <div class="p-3 flex-grow-1 rounded-start-4 d-flex justify-content-between flex-column">
                    <div>
                        <div class="border--primary w-max border-2 rounded-4 px-3 py-2">
                            <p class="text--primary fw-medium fs-12 m-0">#blogs.firstname# #blogs.lastname#</p>
                        </div>
                        <p class="fs-18 mt-4 text-black fw-bold">#blogs.title#</p>
                    </div>
                    <p class="text--lightGray fs-12 fw-medium">
                        <cfif blogs.postcreateddate neq ''>
                            #dateformat(blogs.postcreateddate, 'MMMM DD, YYYY')#
                        <cfelse>
                            #dateformat(blogs.createdAt, 'MMMM DD, YYYY')#
                        </cfif>
                    </p>
                </div>
                <div class="d-lg-block d-none position-relative">
                    <div class="default-blog rounded-end-4">
                        <div class="blog-title-overlay">#blogs.title#</div>
                    </div>
                </div>
            </a>
        </div>
    </cfloop>
</cfoutput>
<script>
    $(document).ready(function(){
        let items = $('.items');
        let itemsPerPage = 4;
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
            if ($(window).scrollTop() + $(window).height() >= $(document).height() - 300) {
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