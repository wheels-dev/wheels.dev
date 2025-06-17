<div class="bg-white p-4 box-shadow rounded-4 mt-3">
    <div class="container py-5">
        <div class="row mb-4 gx-6 gy-3 align-items-center">
            <div class="col-auto">
                <h2 class="mb-0 fs-24 mb-3 fw-bold">Testimonial Detail</h2>
            </div>
        </div>
        <cfoutput>
            <div class="table-responsive scrollbar">
                <table class="table fs-9 mb-0 border-top border-translucent">
                    <tr>
                        <th>User Name:</th>
                        <td>#Testimonial.firstname# #Testimonial.lastname#</td>
                    </tr>
                    <tr>
                        <th>Logo:</th>
                        <td>
                            <cfif Testimonial.logoPath neq "" AND !isNull(Testimonial.logoPath) >
                                <img src="/img/#Testimonial.logoPath#" alt=encodeForHtml(testimonial.companyName) style="width: 200px;">
                            <cfelse>
                                #Testimonial.logoPath#
                            </cfif>
                        </td>
                    </tr>
                    <tr>
                        <th>Company:</th>
                        <td>#Testimonial.companyName#</td>
                    </tr>
                    <tr>
                        <th>Display Permission:</th>
                        <td>
                            <cfif Testimonial.displayPermission>
                                Yes
                            <cfelse>
                                No
                            </cfif>
                        </td>
                    </tr>
                    <tr>
                        <th>Experience Level:</th>
                        <td>#Testimonial.ExperienceLevel#</td>
                    </tr>
                    <tr>
                        <th>Title</th>
                        <td>#Testimonial.Title#<td>
                    </tr>
                    <tr>
                        <th>Testimonial Content:</th>
                        <td>#Testimonial.TestimonialText#</td>
                    </tr>
                    <tr>
                        <th>Rating:</th>
                        <td>
                            <cfset rating = Testimonial.rating>
                            <cfset fullStars = Testimonial.rating>
                            <cfset emptyStars = 5 - fullStars>
                            <cfloop from="1" to="#fullStars#" index="i">
                                <i class="bi bi-star-fill text-warning"></i>
                            </cfloop>

                            <!-- Empty Stars -->
                            <cfloop from="1" to="#emptyStars#" index="i">
                                <i class="bi bi-star text-warning"></i>
                            </cfloop>
                        </td>
                    </tr>
                    <tr>
                        <th>WebSite URL:</th>
                        <td>#Testimonial.websiteUrl#</td>
                    </tr>
                </table>
            </div>
            <div class="text-end">
                <div class="col-auto mt-4">
                    <a class="btn bg--primary text-white px-5" href="/admin/testimonial">Back</a>
                </div>
            </div>
        </cfoutput>
    </div>
</div>
