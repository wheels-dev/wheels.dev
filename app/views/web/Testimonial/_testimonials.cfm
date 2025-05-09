<cfoutput>
<div class="testimonials-section py-5">
    <div class="container">
        <div class="row mb-4">
            <div class="col-12 text-center">
                <h2 class="section-title">What Our Users Say</h2>
                <p class="section-subtitle">Read testimonials from developers who use Wheels.dev</p>
            </div>
        </div>
        
        <div class="row">
            <cfif testimonials.recordCount GT 0>
                <cfloop query="testimonials">
                    <div class="col-md-4 mb-4">
                        <div class="testimonial-card h-100 p-4 shadow-sm rounded">
                            <div class="d-flex align-items-center mb-3">
                                <cfif len(testimonials.logoPath)>
                                    <img src="#testimonials.logoPath#" alt="#testimonials.companyName# logo" class="testimonial-logo me-3" style="max-width: 60px; max-height: 60px;">
                                <cfelse>
                                    <div class="testimonial-initials me-3 bg-primary text-white rounded-circle d-flex align-items-center justify-content-center" style="width: 60px; height: 60px;">
                                        #left(testimonials.companyName, 1)#
                                    </div>
                                </cfif>
                                <div>
                                    <h5 class="mb-0">#testimonials.companyName#</h5>
                                    <cfif len(testimonials.websiteUrl)>
                                        <a href="#testimonials.websiteUrl#" target="_blank" class="text-decoration-none">Visit website</a>
                                    </cfif>
                                </div>
                            </div>
                            
                            <div class="testimonial-rating mb-2">
                                <cfloop from="1" to="5" index="i">
                                    <cfif i <= testimonials.rating>
                                        <i class="bi bi-star-fill text-warning"></i>
                                    <cfelse>
                                        <i class="bi bi-star text-warning"></i>
                                    </cfif>
                                </cfloop>
                                <span class="ms-2 text-muted">#testimonials.experienceLevel# user</span>
                            </div>
                            
                            <p class="testimonial-text mb-3">"#testimonials.testimonialText#"</p>
                            
                            <div class="d-flex justify-content-between align-items-center mt-auto">
                                <small class="text-muted">Submitted #dateFormat(testimonials.createdAt, "mmm d, yyyy")#</small>
                                <cfif len(testimonials.socialMediaLinks)>
                                    <a href="#testimonials.socialMediaLinks#" target="_blank" class="btn btn-sm btn-outline-primary">
                                        <i class="bi bi-linkedin"></i>
                                    </a>
                                </cfif>
                            </div>
                        </div>
                    </div>
                </cfloop>
            <cfelse>
                <div class="col-12 text-center py-5">
                    <p>No testimonials available yet. Be the first to share your experience!</p>
                    <cfif structKeyExists(session, "userID")>
                        <a href="#urlFor(controller='web.Testimonial', action='new')#" class="btn btn-primary">
                            Submit a Testimonial
                        </a>
                    <cfelse>
                        <a href="#urlFor(controller='web.Auth', action='login')#" class="btn btn-primary">
                            Login to Submit a Testimonial
                        </a>
                    </cfif>
                </div>
            </cfif>
        </div>
        
        <cfif testimonials.recordCount GT 0>
            <div class="row mt-4">
                <div class="col-12 text-center">
                    <a href="#urlFor(controller='web.Testimonial', action='index')#" class="btn btn-outline-primary">
                        View All Testimonials
                    </a>
                    <cfif structKeyExists(session, "userID")>
                        <a href="#urlFor(controller='web.Testimonial', action='new')#" class="btn btn-primary ms-2">
                            Submit Your Testimonial
                        </a>
                    </cfif>
                </div>
            </div>
        </cfif>
    </div>
</div>
</cfoutput>
