<cfscript>
// statuses is passed from the controller as an instance variable

function statusLabel(statusId) {
	if (statusId == statuses.DRAFT) return "Draft";
	if (statusId == statuses.POSTED) return "Published";
	if (statusId == statuses.PENDING_REVIEW) return "Pending Review";
	if (statusId == statuses.ARCHIVED) return "Archived";
	if (statusId == statuses.PRIVATE) return "Private";
	return "Unknown";
}

function statusBadgeClass(statusId) {
	if (statusId == statuses.DRAFT) return "bg-secondary";
	if (statusId == statuses.POSTED) return "bg-success";
	if (statusId == statuses.PENDING_REVIEW) return "bg-warning text-dark";
	if (statusId == statuses.ARCHIVED) return "bg-info";
	if (statusId == statuses.PRIVATE) return "bg-dark";
	return "bg-secondary";
}
</cfscript>

<main class="main-bg">
	<div class="container py-5">
		<cfoutput>
			<div class="d-flex justify-content-between align-items-center mb-4">
				<h1 class="fs-24 fw-bold mb-0">My Posts</h1>
				<a href="#urlFor(route = 'blog-create')#" class="btn bg--primary text-white">Create New Article</a>
			</div>

			<!--- Status filter tabs --->
			<ul class="nav nav-pills mb-4 gap-2">
				<li class="nav-item">
					<a
						href="#urlFor(route = 'my-posts')#"
						class="nav-link<cfif statusFilter eq 'all'>active bg--primary<cfelse>text--secondary border border--primary</cfif>"
					>
						All <span class="badge bg-white text-dark ms-1">#statusCounts.all#</span>
					</a>
				</li>
				<li class="nav-item">
					<a
						href="#urlFor(route = 'my-posts')#?status=draft"
						class="nav-link<cfif statusFilter eq 'draft'>active bg--primary<cfelse>text--secondary border border--primary</cfif>"
					>
						Drafts <span class="badge bg-white text-dark ms-1">#statusCounts.draft#</span>
					</a>
				</li>
				<li class="nav-item">
					<a
						href="#urlFor(route = 'my-posts')#?status=published"
						class="nav-link<cfif statusFilter eq 'published'>active bg--primary<cfelse>text--secondary border border--primary</cfif>"
					>
						Published <span class="badge bg-white text-dark ms-1">#statusCounts.published#</span>
					</a>
				</li>
				<li class="nav-item">
					<a
						href="#urlFor(route = 'my-posts')#?status=pending"
						class="nav-link<cfif statusFilter eq 'pending'>active bg--primary<cfelse>text--secondary border border--primary</cfif>"
					>
						Pending Review <span class="badge bg-white text-dark ms-1">#statusCounts.pending#</span>
					</a>
				</li>
			</ul>

			<cfif myBlogs.recordCount>
				<div class="bg-white p-4 rounded-4 box-shadow">
					<div class="table-responsive">
						<table class="table table-hover">
							<thead>
								<tr>
									<th>Title</th>
									<th>Status</th>
									<th>Last Updated</th>
									<th></th>
								</tr>
							</thead>
							<tbody>
								<cfloop query="myBlogs">
									<tr>
										<td>
											<cfif myBlogs.statusId eq statuses.POSTED>
												<a href="#urlFor(route = 'blog-detail', slug = myBlogs.slug)#" class="text-primary">#myBlogs.title#</a>
											<cfelse>
												<a href="#urlFor(route = 'blogEdit', id = myBlogs.id)#" class="text-primary">#myBlogs.title#</a>
											</cfif>
										</td>
										<td>
											<span class="badge #statusBadgeClass(myBlogs.statusId)#">#statusLabel(myBlogs.statusId)#</span>
										</td>
										<td>#DateFormat(myBlogs.updatedAt, "mmm d, yyyy")# #TimeFormat(myBlogs.updatedAt, "h:mm tt")#</td>
										<td>
											<a
												href="#urlFor(route = 'blogEdit', id = myBlogs.id)#"
												class="btn btn-sm border border--primary text--secondary"
											>Edit</a>
										</td>
									</tr>
								</cfloop>
							</tbody>
						</table>
					</div>
				</div>
			<cfelse>
				<div class="bg-white p-5 rounded-4 box-shadow text-center">
					<p class="text--secondary fs-18 mb-3">
						<cfif statusFilter eq "all">
							You haven't created any posts yet.
							<cfelse>
							No #statusFilter# posts found.
						</cfif>
					</p>
					<a href="#urlFor(route = 'blog-create')#" class="btn bg--primary text-white">Create Your First Article</a>
				</div>
			</cfif>
		</cfoutput>
	</div>
</main>
