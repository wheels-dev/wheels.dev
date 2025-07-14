<cfoutput>
<div class="container py-5">
    <div class="row mb-4">
        <div class="col-12">
            <h1 class="mb-3">Testimonial Management</h1>
            <p class="lead">Review and manage user testimonials</p>
        </div>
    </div>

    <!--- Flash Messages --->
    <cfif flashKeyExists("success")>
        <div class="alert alert-success alert-dismissible fade show" role="alert">
            #flash("success")#
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
    </cfif>
    <cfif flashKeyExists("error")>
        <div class="alert alert-danger alert-dismissible fade show" role="alert">
            #flash("error")#
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
    </cfif>

    <!--- Testimonials Table --->
    <div class="card shadow-sm">
        <div class="card-header bg-light d-flex justify-content-between align-items-center">
            <h5 class="mb-0">All Testimonials</h5>
            <div class="btn-group">
                <button class="btn btn-sm btn-outline-secondary dropdown-toggle" type="button" data-bs-toggle="dropdown">
                    Filter
                </button>
                <ul class="dropdown-menu">
                    <li><a class="dropdown-item" href="#urlFor(controller='admin.Testimonial', action='index')#">All</a></li>
                    <li><a class="dropdown-item" href="#urlFor(controller='admin.Testimonial', action='index', params='filter=pending')#">Pending</a></li>
                    <li><a class="dropdown-item" href="#urlFor(controller='admin.Testimonial', action='index', params='filter=approved')#">Approved</a></li>
                    <li><a class="dropdown-item" href="#urlFor(controller='admin.Testimonial', action='index', params='filter=featured')#">Featured</a></li>
                </ul>
            </div>
        </div>
        <div class="card-body p-0">
            <div class="table-responsive">
                <table class="table table-hover mb-0">
                    <thead class="table-light">
                        <tr>
                            <th>ID</th>
                            <th>Company</th>
                            <th>User</th>
                            <th>Rating</th>
                            <th>Status</th>
                            <th>Featured</th>
                            <th>Date</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <cfif isDefined("testimonials") AND testimonials.recordCount GT 0>
                            <cfloop query="testimonials">
                                <tr>
                                    <td>#testimonials.id#</td>
                                    <td>
                                        <div class="d-flex align-items-center">
                                            <cfif len(testimonials.logoPath)>
                                                <img src="/img/#testimonials.logoPath#" alt="wheels.dev testimonial logo" class="me-2" style="width: 30px; height: 30px; object-fit: contain;">
                                            </cfif>
                                            #testimonials.companyName#
                                        </div>
                                    </td>
                                    <td>#testimonials.userName#</td>
                                    <td>
                                        <div class="testimonial-rating">
                                            <cfloop from="1" to="5" index="i">
                                                <cfif i <= testimonials.rating>
                                                    <i class="bi bi-star-fill text-warning"></i>
                                                <cfelse>
                                                    <i class="bi bi-star text-warning"></i>
                                                </cfif>
                                            </cfloop>
                                        </div>
                                    </td>
                                    <td>
                                        <cfif testimonials.isApproved>
                                            <span class="badge bg-success">Approved</span>
                                        <cfelse>
                                            <span class="badge bg-warning">Pending</span>
                                        </cfif>
                                    </td>
                                    <td>
                                        <cfif testimonials.isFeatured>
                                            <span class="badge bg-primary">Featured</span>
                                        <cfelse>
                                            <span class="badge bg-secondary">Not Featured</span>
                                        </cfif>
                                    </td>
                                    <td>#dateFormat(testimonials.createdAt, "yyyy-mm-dd")#</td>
                                    <td>
                                        <div class="btn-group">
                                            <button type="button" class="btn btn-sm btn-outline-primary dropdown-toggle" data-bs-toggle="dropdown" aria-expanded="false">
                                                Actions
                                            </button>
                                            <ul class="dropdown-menu">
                                                <li>
                                                    <button type="button" class="dropdown-item" data-bs-toggle="modal" data-bs-target="##viewTestimonialModal#testimonials.id#">
                                                        <i class="bi bi-eye me-2"></i> View
                                                    </button>
                                                </li>
                                                <cfif testimonials.isApproved>
                                                    <li>
                                                        <a class="dropdown-item" href="#urlFor(controller='admin.Testimonial', action='unapprove', key=testimonials.id)#">
                                                            <i class="bi bi-x-circle me-2"></i> Unapprove
                                                        </a>
                                                    </li>
                                                <cfelse>
                                                    <li>
                                                        <a class="dropdown-item" href="#urlFor(controller='admin.Testimonial', action='approve', key=testimonials.id)#">
                                                            <i class="bi bi-check-circle me-2"></i> Approve
                                                        </a>
                                                    </li>
                                                </cfif>
                                                <cfif testimonials.isFeatured>
                                                    <li>
                                                        <a class="dropdown-item" href="#urlFor(controller='admin.Testimonial', action='unfeature', key=testimonials.id)#">
                                                            <i class="bi bi-star me-2"></i> Unfeature
                                                        </a>
                                                    </li>
                                                <cfelse>
                                                    <li>
                                                        <a class="dropdown-item" href="#urlFor(controller='admin.Testimonial', action='feature', key=testimonials.id)#">
                                                            <i class="bi bi-star-fill me-2"></i> Feature
                                                        </a>
                                                    </li>
                                                </cfif>
                                                <li><hr class="dropdown-divider"></li>
                                                <li>
                                                    <a class="dropdown-item text-danger" href="#urlFor(controller='admin.Testimonial', action='delete', key=testimonials.id)#" onclick="return confirm('Are you sure you want to delete this testimonial?');">
                                                        <i class="bi bi-trash me-2"></i> Delete
                                                    </a>
                                                </li>
                                            </ul>
                                        </div>
                                    </td>
                                </tr>
                                
                                <!-- View Testimonial Modal -->
                                <div class="modal fade" id="viewTestimonialModal#testimonials.id#" tabindex="-1" aria-labelledby="viewTestimonialModalLabel#testimonials.id#" aria-hidden="true">
                                    <div class="modal-dialog modal-lg">
                                        <div class="modal-content">
                                            <div class="modal-header">
                                                <h5 class="modal-title" id="viewTestimonialModalLabel#testimonials.id#">Testimonial Details</h5>
                                                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                            </div>
                                            <div class="modal-body">
                                                <div class="row mb-3">
                                                    <div class="col-md-6">
                                                        <h6>Company Information</h6>
                                                        <p><strong>Company Name:</strong> #testimonials.companyName#</p>
                                                        <p><strong>Website:</strong> <cfif len(testimonials.websiteUrl)><a href="#testimonials.websiteUrl#" target="_blank">#testimonials.websiteUrl#</a><cfelse>Not provided</cfif></p>
                                                        <p><strong>Experience Level:</strong> #testimonials.experienceLevel#</p>
                                                    </div>
                                                    <div class="col-md-6">
                                                        <h6>User Information</h6>
                                                        <p><strong>User:</strong> #testimonials.userName#</p>
                                                        <p><strong>Submitted:</strong> #dateFormat(testimonials.createdAt, "yyyy-mm-dd")# #timeFormat(testimonials.createdAt, "HH:mm:ss")#</p>
                                                        <p><strong>Rating:</strong> 
                                                            <span class="testimonial-rating">
                                                                <cfloop from="1" to="5" index="i">
                                                                    <cfif i <= testimonials.rating>
                                                                        <i class="bi bi-star-fill text-warning"></i>
                                                                    <cfelse>
                                                                        <i class="bi bi-star text-warning"></i>
                                                                    </cfif>
                                                                </cfloop>
                                                            </span>
                                                        </p>
                                                    </div>
                                                </div>
                                                <div class="row mb-3">
                                                    <div class="col-12">
                                                        <h6>Testimonial</h6>
                                                        <div class="card">
                                                            <div class="card-body">
                                                                <p class="mb-0">#testimonials.testimonialText#</p>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                                <cfif len(testimonials.socialMediaLinks)>
                                                    <div class="row">
                                                        <div class="col-12">
                                                            <h6>Social Media</h6>
                                                            <p>#testimonials.socialMediaLinks#</p>
                                                        </div>
                                                    </div>
                                                </cfif>
                                            </div>
                                            <div class="modal-footer">
                                                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                                                <cfif testimonials.isApproved>
                                                    <a href="#urlFor(controller='admin.Testimonial', action='unapprove', key=testimonials.id)#" class="btn btn-warning">Unapprove</a>
                                                <cfelse>
                                                    <a href="#urlFor(controller='admin.Testimonial', action='approve', key=testimonials.id)#" class="btn btn-success">Approve</a>
                                                </cfif>
                                                <cfif testimonials.isFeatured>
                                                    <a href="#urlFor(controller='admin.Testimonial', action='unfeature', key=testimonials.id)#" class="btn btn-primary">Unfeature</a>
                                                <cfelse>
                                                    <a href="#urlFor(controller='admin.Testimonial', action='feature', key=testimonials.id)#" class="btn btn-primary">Feature</a>
                                                </cfif>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </cfloop>
                        <cfelse>
                            <tr>
                                <td colspan="8" class="text-center py-4">
                                    <p class="mb-0 text-muted">No testimonials found</p>
                                </td>
                            </tr>
                        </cfif>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>
</cfoutput>
