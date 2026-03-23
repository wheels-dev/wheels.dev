
<cfoutput query="comments">
    <div class="mt-4 new-comment-block">
        <div class="position-relative">
            <cfif commentParentId eq '' or commentParentId eq 0>
                <div class="d-flex align-items-start gap-3">
                    <div>
                        <img src="#gravatarUrl(email, 96)#"
                            class="rounded-circle"
                            style="width:3rem; height:3rem;"
                            onerror="this.style.display='none';this.nextElementSibling.style.display='flex';"
                            alt="avatar">
                        <div style="display:none;width:3rem;height:3rem;"
                            class="d-flex align-items-center justify-content-center #getAvatarColorByLetter(ucase(left(listLast(fullName, ' '), 1)))# text-white rounded-circle fw-bold text-uppercase">
                            #encodeForHTML(ucase(left(listLast(fullName, " "), 1)))#
                        </div>
                    </div>
                    <div class="p-3 rounded-4 flex-grow-1 bg-light">
                        <h6 class="fs-16 fw-bold">#encodeForHTML(fullName)#</h6>
                        <p class="fs-14 fw-normal markdown-content text-dark">#encodeForHTML(content)#</p>
                        <div class="d-flex flex-wrap justify-content-end align-items-center gap-4">
                            <cfif isLoggedInUser()>
                                <div class="d-flex cursor-pointer align-items-center gap-2">
                                    <a onclick="handleReply(#Id#)" class="fs-14 text--primary mb-0" data-commentid="#Id#" data-blogid="#blog.Id#">Reply</a>

                                    <svg width="18" height="14" viewBox="0 0 18 14" fill="none"
                                        xmlns="http://www.w3.org/2000/svg">
                                        <path
                                            d="M1.42013 6.05185L5.66612 10.2979C5.76346 10.3952 5.81446 10.5099 5.81912 10.6419C5.82379 10.7745 5.77079 10.8959 5.66013 11.0059C5.55013 11.1125 5.43246 11.1665 5.30712 11.1679C5.18112 11.1699 5.06313 11.1159 4.95312 11.0059L0.565125 6.61685C0.477792 6.53019 0.416458 6.44119 0.381125 6.34985C0.345792 6.25919 0.328125 6.15985 0.328125 6.05185C0.328125 5.94385 0.345792 5.84452 0.381125 5.75385C0.416458 5.66319 0.477792 5.57419 0.565125 5.48685L4.95312 1.09785C5.04646 1.00452 5.16013 0.954521 5.29413 0.947854C5.42812 0.941187 5.55046 0.991187 5.66112 1.09785C5.77112 1.20785 5.82612 1.32685 5.82612 1.45485C5.82612 1.58285 5.77112 1.70185 5.66112 1.81185L1.42013 6.05185ZM6.03612 6.55185L9.78213 10.2979C9.87946 10.3952 9.93046 10.5099 9.93513 10.6419C9.93913 10.7745 9.88612 10.8959 9.77612 11.0059C9.66613 11.1125 9.54813 11.1665 9.42212 11.1679C9.29612 11.1692 9.17812 11.1152 9.06812 11.0059L4.68013 6.61685C4.59279 6.53019 4.53146 6.44119 4.49613 6.34985C4.46079 6.25919 4.44312 6.15985 4.44312 6.05185C4.44312 5.94385 4.46079 5.84452 4.49613 5.75385C4.53146 5.66319 4.59279 5.57419 4.68013 5.48685L9.06812 1.09785C9.16146 1.00452 9.27512 0.954521 9.40912 0.947854C9.54379 0.941187 9.66613 0.991187 9.77612 1.09785C9.88612 1.20785 9.94113 1.32685 9.94113 1.45485C9.94113 1.58285 9.88612 1.70185 9.77612 1.81185L6.03612 5.55185H13.4991C14.7418 5.55185 15.8025 5.99119 16.6811 6.86985C17.5598 7.74852 17.9991 8.80919 17.9991 10.0519V12.5519C17.9991 12.6945 17.9515 12.8135 17.8561 12.9089C17.7608 13.0042 17.6418 13.0519 17.4991 13.0519C17.3565 13.0519 17.2375 13.0042 17.1421 12.9089C17.0468 12.8135 16.9991 12.6945 16.9991 12.5519V10.0519C16.9991 9.09052 16.6561 8.26685 15.9701 7.58085C15.2841 6.89485 14.4605 6.55185 13.4991 6.55185H6.03612Z"
                                            fill="var(--primary)" />
                                    </svg>
                                </div>
                            </cfif>
                            <div class="d-flex cursor-pointer align-items-center gap-2">
                                <p class="fs-14 text--primary mb-0">#dateformat(publishedAt, 'MMM DD, YYYY')#</p>
                            </div>
                            <!-- Reply Form (Hidden by Default) -->
                            <div class="reply-form" id="reply-form-#Id#" style="display:none;width:100%;">
                                <form hx-target="##reply-#Id#" hx-on:htmx:after-request="handleClear()" hx-swap="beforeend" class="replyCommentForm" hx-post="/blog/comment" novalidate hx-validate="true">
                                    <input type="hidden" name="blogId" value="#blog.Id#">
                                    <input type="hidden" name="commentParentId" value="#Id#">
                                    <textarea class="markdown-editor" placeholder="Write a reply..."></textarea>
                                    <input required class="form-control" type="hidden" name="content" id="content">
                                    <div class="mt-3 text-end">
                                        <button type="button" class="btn btn-light border fs-14 px-3 py-2 rounded-2 cancel-reply" data-commentid="#Id#">Cancel</button>
                                        <button type="submit" class="bg--primary fs-14 text-white px-3 py-2 rounded-2 flex-shrink-0">Reply</button>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>
                </div>
                <div id="reply-#Id#"></div>
            </cfif>

            <cfif commentParentId neq '' and commentParentId neq 0>
                <div class="d-flex align-items-start gap-3 position-relative" style="margin-left: 70px;">
                    <div>
                        <img src="#gravatarUrl(email, 96)#"
                            class="rounded-circle"
                            style="width:3rem; height:3rem;"
                            onerror="this.style.display='none';this.nextElementSibling.style.display='flex';"
                            alt="avatar">
                        <div style="display:none;width:3rem;height:3rem;"
                            class="d-flex align-items-center justify-content-center #getAvatarColorByLetter(ucase(left(listLast(fullName, ' '), 1)))# text-white rounded-circle fw-bold text-uppercase">
                            #encodeForHTML(ucase(left(listLast(fullName, " "), 1)))#
                        </div>
                    </div>
                    <div class="p-3 rounded-4 bg-light">
                        <h6 class="fs-16 fw-bold">#encodeForHTML(fullName)#</h6>
                        <p class="fs-14 fw-normal markdown-content text-dark">#encodeForHTML(content)#</p>
                    </div>
                </div>
            </cfif>
        </div>
    </div>
</cfoutput>
