<cfoutput>
    <div class="container-fluid px-4 py-4 admin-newsletter">
        <!-- Header Section -->
        <div class="d-flex justify-content-between align-items-center mb-4">
            <div>
                <h2 class="mb-1">Newsletter Dashboard</h2>
                <p class="text-body-secondary mb-0">Manage newsletter subscribers and campaigns</p>
            </div>
            <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="##sendNewsletterModal">
                <i class="bi bi-envelope-plus me-2"></i>Send Newsletter
            </button>
        </div>

        <!-- Stats Cards -->
        <div class="row g-4 mb-4">
            <!-- Total Subscribers -->
            <div class="col-sm-6 col-xl-3">
                <div class="card h-100" 
                     hx-get="/admin/newsletter/filterByType?type=all" 
                     hx-target="##subscribersTable"
                     hx-trigger="click"
                     style="cursor: pointer;">
                    <div class="card-body">
                        <div class="d-flex align-items-start">
                            <div class="flex-shrink-0 me-3">
                                <div class="avatar avatar-lg">
                                    <div class="avatar-name rounded-circle bg-primary-subtle p-3 d-flex align-items-center justify-content-center">
                                        <i class="bi bi-people-fill fs-4 text-primary"></i>
                                    </div>
                                </div>
                            </div>
                            <div class="flex-grow-1 ms-5">
                                <h4 class="mb-1">#stats.totalSubscribers#</h4>
                                <p class="text-body-secondary mb-0">Total Subscribers</p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- User Subscribers -->
            <div class="col-sm-6 col-xl-3">
                <div class="card h-100"
                     hx-get="/admin/newsletter/filterByType?type=user" 
                     hx-target="##subscribersTable"
                     hx-trigger="click"
                     style="cursor: pointer;">
                    <div class="card-body">
                        <div class="d-flex align-items-start">
                            <div class="flex-shrink-0 me-3">
                                <div class="avatar avatar-lg">
                                    <div class="avatar-name rounded-circle bg-success-subtle p-3 d-flex align-items-center justify-content-center">
                                        <i class="bi bi-person-check-fill fs-4 text-success"></i>
                                    </div>
                                </div>
                            </div>
                            <div class="flex-grow-1 ms-5">
                                <h4 class="mb-1">#stats.userSubscribers#</h4>
                                <p class="text-body-secondary mb-0">User Subscribers</p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Pending Verifications -->
            <div class="col-sm-6 col-xl-3">
                <div class="card h-100"
                     hx-get="/admin/newsletter/filterByType?type=pending" 
                     hx-target="##subscribersTable"
                     hx-trigger="click"
                     style="cursor: pointer;">
                    <div class="card-body">
                        <div class="d-flex align-items-start">
                            <div class="flex-shrink-0 me-3">
                                <div class="avatar avatar-lg">
                                    <div class="avatar-name rounded-circle bg-warning-subtle p-3 d-flex align-items-center justify-content-center">
                                        <i class="bi bi-clock-fill fs-4 text-warning"></i>
                                    </div>
                                </div>
                            </div>
                            <div class="flex-grow-1 ms-5">
                                <h4 class="mb-1">#stats.pendingSubscribers#</h4>
                                <p class="text-body-secondary mb-0">Pending Verifications</p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Inactive Subscribers -->
            <div class="col-sm-6 col-xl-3">
                <div class="card h-100"
                     hx-get="/admin/newsletter/filterByType?type=inactive" 
                     hx-target="##subscribersTable"
                     hx-trigger="click"
                     style="cursor: pointer;">
                    <div class="card-body">
                        <div class="d-flex align-items-start">
                            <div class="flex-shrink-0 me-3">
                                <div class="avatar avatar-lg">
                                    <div class="avatar-name rounded-circle bg-danger-subtle p-3 d-flex align-items-center justify-content-center">
                                        <i class="bi bi-person-x-fill fs-4 text-danger"></i>
                                    </div>
                                </div>
                            </div>
                            <div class="flex-grow-1 ms-5">
                                <h4 class="mb-1">#stats.inactiveSubscribers#</h4>
                                <p class="text-body-secondary mb-0">Inactive Subscribers</p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Subscribers List -->
        <div class="card">
            <div class="card-header bg-transparent">
                <div class="d-flex justify-content-between align-items-center">
                    <h5 class="mb-0">Subscribers List</h5>
                    <div class="d-flex gap-2">
                        <div class="input-group">
                            <span class="input-group-text"><i class="bi bi-search"></i></span>
                            <input type="text" class="form-control" placeholder="Search subscribers..." 
                                   hx-get="/admin/newsletter/search" 
                                   hx-trigger="keyup changed delay:500ms" 
                                   hx-target="##subscribersTable"
                                   name="searchTerm">
                        </div>
                        <form action="/admin/newsletter/export" method="get" style="display: inline;">
                            <button type="submit" class="btn btn-outline-secondary">
                                <i class="bi bi-download me-2"></i>Export
                            </button>
                        </form>
                    </div>
                </div>
            </div>
            <div class="card-body">
                <div class="table-responsive" id="subscribersTable"
                     hx-get="/admin/newsletter/filterByType?type=all"
                     hx-trigger="load">
                </div>
            </div>
        </div>
    </div>

    <!-- Send Newsletter Modal -->
    <div class="modal fade" id="sendNewsletterModal" tabindex="-1">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Send Newsletter to Subscribers</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <form hx-post="/admin/newsletter/send" 
                          hx-target="##newsletterResponse"
                          hx-swap="innerHTML">
                        <div class="mb-3">
                            <label for="subject" class="form-label">Newsletter Subject</label>
                            <input type="text" class="form-control" id="subject" name="subject" placeholder="Enter newsletter subject" required>
                        </div>
                        <div class="mb-3">
                            <label for="content" class="form-label">Newsletter Content</label>
                            <textarea class="form-control" id="content" name="content" rows="10" placeholder="Write your newsletter content here..." required></textarea>
                        </div>
                        <div id="newsletterResponse"></div>
                        <div class="text-end">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                            <button type="submit" class="btn btn-primary">
                                <i class="bi bi-send me-2"></i>Send Newsletter
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</cfoutput> 