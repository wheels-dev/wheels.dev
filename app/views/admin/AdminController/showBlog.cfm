<main class="main-bg">
    <cfoutput>
        <cfset tagList="">
        <cfset categoryList="">
            <cfloop query="tags">
                <cfif tagList EQ "">
                    <cfset tagList=name>
                <cfelse>
                    <cfset tagList=tagList & ", " & name>
                </cfif>
            </cfloop>
            <cfloop query="categories">
                <cfif categoryList EQ "">
                    <cfset categoryList=name>
                <cfelse>
                    <cfset categoryList=categoryList & ", " & name>
                </cfif>
            </cfloop>
            <!-- Blog filter -->
            <div class="container pt-4 pb-5">
                <a href="javascript:void(0);" class="py-2 px-3 bg-white shadow-sm rounded-3" 
                    onclick="window.history.back();">
                    <i class="bi bi-arrow-left"></i>
                    <span class="fs-14 text--secondary">
                        Back
                    </span>
                </a>

                <div class="bg-white rounded-5 shadow-sm mt-4 p-4">
                    <div class="row gy-4">
                        <div class="col-12 d-flex flex-column">
                            <div class="d-flex my-3 align-items-center gap-3">
                                <div>
                                    <img src="#gravatarUrl(blog.user.email, 96)#"
                                        class="rounded-circle"
                                        style="width:3rem; height:3rem;"
                                        onerror="this.style.display='none';this.nextElementSibling.style.display='flex';"
                                        alt="avatar">
                                    <div style="display:none;width:3rem;height:3rem;"
                                        class="d-flex align-items-center justify-content-center #getAvatarColorByLetter(ucase(left(listLast(blog.user.fullName, ' '), 1)))# text-white rounded-circle fw-bold text-uppercase">
                                        #ucase(left(listLast(blog.user.fullName, " "), 1))#
                                    </div>
                                </div>
                                <p class="fs-18 text--secondary fw-semibold p-0 m-0">#blog.user.fullName#</p>
                            </div>
                            <h1 class="fs-36 fw-bold text--secondary mb-2">
                                #blog.title#
                            </h1>
                            <div class="d-flex flex-wrap flex-grow-1 align-items-end gap-lg-5 gap-2 mt-lg-0">
                                <p class="fw-medium fs-12 text--lightGray">
                                    <cfif blog.postcreateddate neq ''>
                                        #dateformat(blog.postcreateddate, 'MMMM DD, YYYY')#
                                    <cfelse>
                                        #dateformat(blog.createdAt, 'MMMM DD, YYYY')#
                                    </cfif>
                                </p>
                                    <p class="fw-medium fs-12 text--lightGray" 
                                    hx-push-url="/blog"
                                    hx-get="/blog"
                                    hx-trigger="click"
                                    hx-swap="innerHTML"
                                    hx-target=".main"
<!---                                     hx-vals='{"category_id": "#blog.Category.id#"}' --->
                                    >
                                    #blog.PostStatus.name# in <span class="text--primary">#categoryList#</span>
                                 </p>
                                <p class="fw-medium fs-12 text--lightGray">Tags: <span class="text--primary">#tagList#</span></p>
                            </div>
                        </div>

                        <div class="col-12">
                            <cfif findNoCase("```", blog.content) OR findNoCase("##", blog.content) OR findNoCase("**", blog.content) OR findNoCase("__", blog.content) OR findNoCase(">", blog.content)>
                                <div class="markdown-content">
                                    <cfoutput>#encodeForHTML(blog.content)#</cfoutput>
                                </div>
                            <cfelse>
                                #this.autoLink(blog.content,"text--primary")#
                            </cfif>
                        </div>
                    </div>
                </div>
            </div>
    </cfoutput>
</main>