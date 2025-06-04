<div class="container py-5">
    <div class="row justify-content-center justify-content-lg-between">
        <div class="col-lg-12 col-12">
            <div class="bg-white rounded-5 shadow-sm mt-4 p-4">
                <cfoutput>
                <form method="post"
                    action="#urlFor(route="create-testimonial")#"
                    enctype="multipart/form-data"
                    hx-post="#urlFor(route="create-testimonial")#"
                    hx-target="##form-messages"
                    hx-swap="none"
                    hx-encoding="multipart/form-data"
                    hx-on="htmx:afterOnLoad: handleTestimonialResponse(event)">
                </cfoutput>
                    <div id="form-messages"></div>
                    <div class="text-end">
                        <cfoutput>
                        <a class="cursor-pointer" hx-get="#urlFor(route="home")#" hx-trigger="click" hx-target="body" hx-swap="outerHTML" ><i class='bi bi-x fs-32 text-danger'></i></a>
                        </cfoutput>
                    </div>
                    <h1 class="text-center fs-24 fw-bold mb-4" >Share Your Experience</h1>
                    <div class="mb-3">
                        <label for="companyName" class="form-label fw-bold">Company Name <span class="text-danger">*</span></label>
                        <input type="text"
                            name="companyName"
                            id="companyName"
                            class="form-control form-check-input-primary "
                            required>
                    </div>
                
                    <div class="mb-3">
                        <label for="title" class="form-label fw-bold">Summary <span class="text-danger">*</span></label>
                        <textarea name="title"
                                id="title"
                                class="form-control form-check-input-primary "
                                rows="5"
                                required
                                minlength="20"
                                maxlength="150"></textarea>
                        <div class="form-text">Please write brief summary (20-150 characters).</div>
                    </div>
                
                    <div class="mb-3">
                        <label for="content" class="form-label fw-bold">Your Testimonial <span class="text-danger">*</span></label>
                        <textarea name="content"
                                id="content"
                                class="form-control form-check-input-primary "
                                rows="5"
                                required
                                minlength="20"
                                maxlength="500"></textarea>
                        <div class="form-text">Please share your experience (20-500 characters).</div>
                    </div>
                
                    <div class="mb-3">
                        <label class="form-label fw-bold">Rating (1-5 Stars) <span class="text-danger">*</span></label>
                        <div class="d-flex">
                            <div class="form-check form-check-inline">
                                <input class="form-check-input form-check-input-primary" type="radio" name="rating" id="rating1" value="1" required>
                                <label class="form-check-label" for="rating1">1</label>
                            </div>
                            <div class="form-check form-check-inline">
                                <input class="form-check-input form-check-input-primary" type="radio" name="rating" id="rating2" value="2">
                                <label class="form-check-label" for="rating2">2</label>
                            </div>
                            <div class="form-check form-check-inline">
                                <input class="form-check-input form-check-input-primary" type="radio" name="rating" id="rating3" value="3">
                                <label class="form-check-label" for="rating3">3</label>
                            </div>
                            <div class="form-check form-check-inline">
                                <input class="form-check-input form-check-input-primary" type="radio" name="rating" id="rating4" value="4">
                                <label class="form-check-label" for="rating4">4</label>
                            </div>
                            <div class="form-check form-check-inline">
                                <input class="form-check-input form-check-input-primary" type="radio" name="rating" id="rating5" value="5">
                                <label class="form-check-label" for="rating5">5</label>
                            </div>
                        </div>
                    </div>
                
                    <div class="mb-3">
                        <label for="experienceLevel" class="form-label fw-bold">Your Experience Level with Wheels.dev <span class="text-danger">*</span></label>
                        <select name="experienceLevel"
                                id="experienceLevel"
                                class="form-select form-check-input-primary "
                                required>
                            <option value="" selected disabled>-- Select Level --</option>
                            <option value="Beginner">Beginner</option>
                            <option value="Intermediate">Intermediate</option>
                            <option value="Advanced">Advanced</option>
                            <option value="Expert">Expert</option>
                        </select>
                    </div>
                
                    <div class="mb-3">
                        <label for="websiteUrl" class="form-label fw-bold">Company Website (Optional)</label>
                        <input type="url"
                            name="websiteUrl"
                            id="websiteUrl"
                            class="form-control form-check-input-primary "
                            placeholder="https://...">
                    </div>
                
                    <div class="mb-3">
                        <label for="socialMediaLinks" class="form-label fw-bold">Social Media Link (Optional)</label>
                        <input type="url"
                            name="socialMediaLinks"
                            id="socialMediaLinks"
                            class="form-control form-check-input-primary "
                            placeholder="https://linkedin.com/in/...">
                    </div>
                
                    <div class="mb-3">
                        <label for="logo" class="form-label fw-bold">Company Logo <span class="text-danger">*</span></label>
                        <input type="file"
                            name="logo"
                            id="logo"
                            class="form-control form-check-input-primary "
                            accept="image/jpeg, image/png, image/gif, image/webp" required>
                        <div class="form-text">Upload JPG, PNG, GIF, or WEBP.</div>
                    </div>
                
                    <div class="mb-3 form-check">
                        <input type="checkbox"
                            name="displayPermission"
                            id="displayPermission"
                            class="form-check-input form-check-input-primary">
                        <label class="form-check-label" for="displayPermission">I grant permission to display this testimonial publicly.</label>
                <!---         <input type="hidden" name="displayPermission" value="false"> --->
                    </div>
                
                    <div class="text-end">
                        <button type="submit" class="bg--primary btn--secondary text-white px-3 py-2 rounded fs-14">Submit</button>
                        <cfoutput>
                            <a hx-get="#urlFor(route="home")#" hx-trigger="click" hx-target="body" hx-swap="outerHTML" class="btn btn-secondary px-3 py-2 rounded fs-14 me-2">Cancel</a>
                        </cfoutput>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

<script src="/js/testimonialResponse.js"></script>
<script src="/js/notifier.min.js"></script>