<cfoutput query="features">
    <div class="col-lg-4">
        <div class="px-4 py-4 bg-white border-transparent border-2 cards rounded-5 cursor-pointer shadow-sm">
            <div class="icon-container d-flex justify-content-center align-items-center">
                #features.image#
            </div>
            <div class="mt-3">
                <p class="fw-bold fs-24 text--secondary">#features.title#</p>
                <p class="fs-18 text--secondary/70 pt-1 line-clamp-2">#features.description#</p>
            </div>
        </div>
    </div>
</cfoutput>
