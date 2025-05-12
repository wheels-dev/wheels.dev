<cfparam name="testimonials" default="#[]#">
<cfparam name="pagination" default="#{}#">
<cfparam name="filter" default="all">

<div class="container mx-auto py-6">
    <h1 class="text-2xl font-bold mb-6">Manage Testimonials</h1>
    
    <div class="mb-6 flex justify-between items-center">
        <div class="flex space-x-4">
            <a href="#urlFor(action='index', params='filter=all')#" 
               class="px-4 py-2 rounded #filter == 'all' ? 'bg-blue-600 text-white' : 'bg-gray-200'#">
                All
            </a>
            <a href="#urlFor(action='index', params='filter=pending')#" 
               class="px-4 py-2 rounded #filter == 'pending' ? 'bg-blue-600 text-white' : 'bg-gray-200'#">
                Pending
            </a>
            <a href="#urlFor(action='index', params='filter=approved')#" 
               class="px-4 py-2 rounded #filter == 'approved' ? 'bg-blue-600 text-white' : 'bg-gray-200'#">
                Approved
            </a>
            <a href="#urlFor(action='index', params='filter=featured')#" 
               class="px-4 py-2 rounded #filter == 'featured' ? 'bg-blue-600 text-white' : 'bg-gray-200'#">
                Featured
            </a>
        </div>
    </div>
    
    <div class="bg-white shadow rounded-lg">
        <cfif testimonials.recordCount GT 0>
            <table class="min-w-full divide-y divide-gray-200">
                <thead class="bg-gray-50">
                    <tr>
                        <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                            <a href="#urlFor(action='index', params='sort=personName&order=#params.order == "ASC" ? "DESC" : "ASC"#&filter=#filter#')#">
                                Name 
                                <cfif params.sort == "personName">
                                    <i class="fas fa-sort-#params.order == 'ASC' ? 'up' : 'down'#"></i>
                                </cfif>
                            </a>
                        </th>
                        <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                            <a href="#urlFor(action='index', params='sort=companyName&order=#params.order == "ASC" ? "DESC" : "ASC"#&filter=#filter#')#">
                                Company
                                <cfif params.sort == "companyName">
                                    <i class="fas fa-sort-#params.order == 'ASC' ? 'up' : 'down'#"></i>
                                </cfif>
                            </a>
                        </th>
                        <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                            <a href="#urlFor(action='index', params='sort=createdAt&order=#params.order == "ASC" ? "DESC" : "ASC"#&filter=#filter#')#">
                                Date
                                <cfif params.sort == "createdAt">
                                    <i class="fas fa-sort-#params.order == 'ASC' ? 'up' : 'down'#"></i>
                                </cfif>
                            </a>
                        </th>
                        <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Status</th>
                        <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Actions</th>
                    </tr>
                </thead>
                <tbody class="bg-white divide-y divide-gray-200">
                    <cfloop query="testimonials">
                        <tr>
                            <td class="px-6 py-4 whitespace-nowrap">
                                <div class="text-sm font-medium text-gray-900">#encodeForHTML(testimonials.personName)#</div>
                                <div class="text-sm text-gray-500">#encodeForHTML(testimonials.jobTitle)#</div>
                            </td>
                            <td class="px-6 py-4 whitespace-nowrap">
                                <div class="text-sm text-gray-900">#encodeForHTML(testimonials.companyName)#</div>
                            </td>
                            <td class="px-6 py-4 whitespace-nowrap">
                                <div class="text-sm text-gray-500">#dateFormat(testimonials.createdAt, "mmm d, yyyy")#</div>
                            </td>
                            <td class="px-6 py-4 whitespace-nowrap">
                                <span class="px-2 inline-flex text-xs leading-5 font-semibold rounded-full 
                                    #testimonials.isApproved ? 'bg-green-100 text-green-800' : 'bg-yellow-100 text-yellow-800'#">
                                    #testimonials.isApproved ? 'Approved' : 'Pending'#
                                </span>
                                <cfif testimonials.isFeatured>
                                    <span class="ml-2 px-2 inline-flex text-xs leading-5 font-semibold rounded-full bg-purple-100 text-purple-800">
                                        Featured
                                    </span>
                                </cfif>
                            </td>
                            <td class="px-6 py-4 whitespace-nowrap text-sm font-medium">
                                <div class="flex space-x-2">
                                    <button type="button" 
                                        hx-post="#urlFor(action='approve', key=testimonials.id)#"
                                        hx-swap="none"
                                        hx-target="closest tr"
                                        class="text-#testimonials.isApproved ? 'yellow' : 'green'#-600 hover:text-#testimonials.isApproved ? 'yellow' : 'green'#-900">
                                        #testimonials.isApproved ? 'Unapprove' : 'Approve'#
                                    </button>
                                    <button type="button" 
                                        hx-post="#urlFor(action='feature', key=testimonials.id)#"
                                        hx-swap="none"
                                        hx-target="closest tr"
                                        class="text-purple-600 hover:text-purple-900">
                                        #testimonials.isFeatured ? 'Unfeature' : 'Feature'#
                                    </button>
                                    <button type="button" 
                                        hx-delete="#urlFor(action='delete', key=testimonials.id)#"
                                        hx-confirm="Are you sure you want to delete this testimonial?"
                                        hx-swap="outerHTML"
                                        hx-target="closest tr"
                                        class="text-red-600 hover:text-red-900">
                                        Delete
                                    </button>
                                </div>
                            </td>
                        </tr>
                    </cfloop>
                </tbody>
            </table>
            
            <!--- Pagination --->
            <cfif pagination.totalPages GT 1>
                <div class="px-6 py-4 border-t border-gray-200">
                    <div class="flex items-center justify-between">
                        <div>
                            <p class="text-sm text-gray-700">
                                Showing <span class="font-medium">#pagination.currentPage#</span> of <span class="font-medium">#pagination.totalPages#</span> pages
                            </p>
                        </div>
                        <div>
                            <nav class="relative z-0 inline-flex rounded-md shadow-sm -space-x-px" aria-label="Pagination">
                                <cfif pagination.currentPage GT 1>
                                    <a href="#urlFor(action='index', params='page=#pagination.currentPage-1#&filter=#filter#&sort=#params.sort#&order=#params.order#')#" 
                                       class="relative inline-flex items-center px-2 py-2 rounded-l-md border border-gray-300 bg-white text-sm font-medium text-gray-500 hover:bg-gray-50">
                                        <span class="sr-only">Previous</span>
                                        <i class="fas fa-chevron-left h-5 w-5"></i>
                                    </a>
                                </cfif>
                                
                                <cfloop from="1" to="#pagination.totalPages#" index="i">
                                    <a href="#urlFor(action='index', params='page=#i#&filter=#filter#&sort=#params.sort#&order=#params.order#')#" 
                                       class="relative inline-flex items-center px-4 py-2 border border-gray-300 bg-white text-sm font-medium 
                                              #i == pagination.currentPage ? 'z-10 bg-blue-50 border-blue-500 text-blue-600' : 'text-gray-500 hover:bg-gray-50'#">
                                        #i#
                                    </a>
                                </cfloop>
                                
                                <cfif pagination.currentPage LT pagination.totalPages>
                                    <a href="#urlFor(action='index', params='page=#pagination.currentPage+1#&filter=#filter#&sort=#params.sort#&order=#params.order#')#" 
                                       class="relative inline-flex items-center px-2 py-2 rounded-r-md border border-gray-300 bg-white text-sm font-medium text-gray-500 hover:bg-gray-50">
                                        <span class="sr-only">Next</span>
                                        <i class="fas fa-chevron-right h-5 w-5"></i>
                                    </a>
                                </cfif>
                            </nav>
                        </div>
                    </div>
                </div>
            </cfif>
        <cfelse>
            <div class="p-6 text-center">
                <p class="text-gray-500">No testimonials found</p>
            </div>
        </cfif>
    </div>
</div>