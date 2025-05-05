<div class="bg-white p-4 box-shadow rounded-4 mt-3">
    <div id="testimonials" class="container">
        <div class="row mb-3 gx-6 gy-3 align-items-center">
            <div class="col-auto">
                <h1 class="text-center fs-24 fw-bold">Testimonials</h1>
            </div>
        </div>
        <div class="table-responsive">
            <table id="testimonialTable" class="table table-hover table-striped">
                <thead>
                    <tr>
                        <th class="text-center">No.</th>
                        <th>User</th>
                        <th>Logo</th>
                        <th>Company</th>
                        <th>Experience</th>
                        <th>Testimonial text</th>
                        <th>Rating</th>
                        <th>Status</th>
                        <th></th>
                    </tr>
                </thead>
                <tbody>
                    <cfloop from="1" to="#Testimonial.recordCount#" index="i">
                        <tr>
                            <cfoutput>
                                <cfset TestimonialId = Testimonial.id[i]>
                                <td>#i#</td>
                                <td>#Testimonial.firstname[i]# #Testimonial.lastname[i]#</td>
                                <td>#Testimonial.logoPath[i]#</td>
                                <td>#Testimonial.companyName[i]#</td>
                                <td>#Testimonial.experienceLevel[i]#</td>
                                <td>
                                    <cfset shortText = left(Testimonial.TestimonialText[i], 30) & " ...">
                                    #shortText#
                                </td>
                                <td>
                                    <cfset rating = Testimonial.rating>
                                    <cfset fullStars = Testimonial.rating>
                                    <cfset emptyStars = 5 - fullStars>
                                    <cfloop from="1" to="#fullStars#" index="j">
                                        <i class="bi bi-star-fill text-warning"></i>
                                    </cfloop>

                                    <!-- Empty Stars -->
                                    <cfloop from="1" to="#emptyStars#" index="j">
                                        <i class="bi bi-star text-warning"></i>
                                    </cfloop>
                                </td>
                                <td>
                                    <span class="approval-status-#TestimonialId#">
                                        <cfif Testimonial.status[i] eq 'Approved'>
                                            <span class="badge bg-success">Approved</span>
                                        <cfelseif Testimonial.status[i] eq 'Rejected'>
                                            <span class="badge bg-danger">Rejected</span>
                                        <cfelse>
                                            <span class="badge bg-warning text-dark">Pending</span>
                                        </cfif>
                                    </span>
                                </td>
                                <td>
                                    <div class="dropdown">
                                        <div class="fw-bold cursor-pointer me-2" data-bs-toggle="dropdown" aria-expanded="false">
                                            ...
                                        </div>
                                        <ul class="dropdown-menu">
                                            <li>
                                                <a 
                                                    class="dropdown-item fs-16"
                                                    href="/admin/testimonials/view/#TestimonialId#" 
                                                >View</a>
                                            </li>
                                            <li>
                                                <button 
                                                    class="dropdown-item text-success fs-16"
                                                    hx-post="/admin/testimonials/approve" 
                                                    hx-vals='{"id": "#TestimonialId#"}'
                                                    hx-confirm="Are you sure you want to approve this testimonial?"
                                                    hx-target=".approval-status-#TestimonialId#"
                                                    hx-swap="innerHTML"
                                                >Approve</button>
                                            </li>
                                            <li>
                                                <button 
                                                    class="dropdown-item text-danger fs-16"
                                                    hx-post="/admin/testimonials/reject" 
                                                    hx-vals='{"id": "#TestimonialId#"}'
                                                    hx-confirm="Are you sure you want to reject this testimonial?"
                                                    hx-target=".approval-status-#TestimonialId#"
                                                    hx-swap="innerHTML"
                                                >Reject</button>
                                            </li>
                                        </ul>
                                    </div>
                                </td>
                            </cfoutput>
                        </tr>
                    </cfloop>
                </tbody>
            </table>
        </div>
    </div>
</div>
<script>
    var table = new DataTable('#testimonialTable', {
        columnDefs: [
            {
                targets: [7,8], // Adjust these indexes based on your actual table structure
                orderable: false
            }
        ]
    });
    table.on('draw', function() {
        htmx.process(document.body);
    });
</script>