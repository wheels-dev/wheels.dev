<div class="row mb-4 gx-6 gy-3 align-items-center">
    <div class="col-auto">
        <h2 class="mb-0">Testimonial Detail</h2>
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
                        #imageTag(source = '#Testimonial.logoPath#', alt="Testimonial logo", height="60", width="60")#
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
                <th>Experience Level:</th>
                <td>#Testimonial.ExperienceLevel#</td>
            </tr>
            <tr>
                <th>Testimonial Text:</th>
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
            <a class="btn btn-primary px-5" href="/admin/testimonial">Back</a>
        </div>
    </div>
</cfoutput>
