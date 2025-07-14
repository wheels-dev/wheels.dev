<div class="modal fade" id="searchModal" tabindex="-1" aria-labelledby="searchModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content search-modal overflow-auto">
            <div class="search-modal-header mt-2">
                <div class="d-flex align-items-center rounded-3 mx-2 px-2 py-2 border gap-2 transition-all hover:border-primary">
                    <i class="bi bi-search"></i>
                    <input type="text" class="fs-14 flex-grow-1 outline-none bg-transparent input-autofill" name="searchQuery" id="searchDocs" placeholder="Search content or ask a question." aria-label="searchDocs">
                </div>
            </div>
            <div class="modal-body">
                <div id="result">
                    <div class="d-flex justify-content-center align-content-center align-items-baseline">
                        <i class="bi bi-search-heart text--primary"> Search...</i>
                    </div>
                </div>
                <div class="d-flex py-2 justify-content-center">
                    <div id="search-loader" style="display:none; width: 2rem; height: 2rem;" class="spinner-border text--primary" role="status">
                        <span class="visually-hidden">Loading...</span>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>