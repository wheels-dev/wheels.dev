<cfoutput>
<div class="col-xl-9 bg-white p-4 box-shadow rounded-4 mt-3">
    <div class="row gx-6 align-items-center">
        <div class="col-auto">
            <h1 class="fs-24 fw-bold">
                Edit "#email.title#" Email 
            </h1>
        </div>
    </div>
    <div class="row">
        <form class="row g-3 mb-6 needs-validation" id="emailForm" novalidate method="POST" action="#urlFor(route="adminemail-save")#">
            <input name="id" type="hidden" id="id" value="#email.id#">
            <input name="title" type="hidden" id="title" value="#email.title#">

            <span class="text-danger fs-18">*Note: Leave any field blank to exclude it from the email.</span>
            <div class="col-sm-6 col-md-6 mb-3">
                <div class="form-floating">
                    <input name="subject" type="text" placeholder="Enter email subject" class="form-control fs-18" id="subject"
                    aria-describedby="SubjectHelp" required minlength="3" maxlength="50" value="#email.subject#">
                    <label for="subject" class="form-label fs-18 fw-medium">Subject <span class="text-danger">*</span></label>
                    <div class="invalid-feedback">subject must be between 2 and 50 characters.</div>
                </div>
            </div>
            <div class="col-sm-6 col-md-6 col-lg-12 mb-3">
                <div class="form-floating">
                    <textarea name="message" type="textArea" placeholder="Enter email message" class="form-control fs-14" id="message"
                    aria-describedby="messageHelp" required minlength="9" maxlength="999" style="height: 80px">#email.message#</textArea>
                    <label for="message" class="form-label fs-18 fw-medium">Message <span class="text-danger">*</span></label>
                    <div class="invalid-feedback">email message must be between 9 and 999 characters.</div>
                </div>
            </div>

            <div class="col-sm-6 col-md-6 col-lg-12 mb-3">
                <div class="form-floating">
                    <textarea name="footerNote" type="textArea" placeholder="Enter footer note" class="form-control fs-14" id="footerNote"
                    aria-describedby="footerNoteHelp" minlength="9" maxlength="999" style="height: 80px">#email.footerNote#</textArea>
                    <label for="footerNote" class="form-label fs-18 fw-medium">Footer Note</label>
                    <div class="invalid-feedback">email footer note must be between 9 and 999 characters.</div>
                </div>
            </div>

            <div class="col-sm-6 col-md-6 mb-3">
                <div class="form-floating">
                    <input name="welcomeMessage" type="text" placeholder="Enter Welcome Message" class="form-control fs-18" id="welcomeMessage"
                    aria-describedby="welcomeMessageHelp" minlength="5" maxlength="50" value="#email.welcomeMessage#">
                    <label for="welcomeMessage" class="form-label fs-18 fw-medium">Welcome Message</label>
                    <div class="invalid-feedback">subject must be between 2 and 50 characters.</div>
                </div>
            </div>
            <div class="col-sm-6 col-md-6 mb-3">
                <div class="form-floating">
                    <input name="buttonTitle" type="text" placeholder="Enter button title" class="form-control fs-18" id="buttonTitle"
                    aria-describedby="buttonTitleHelp" minlength="2" maxlength="20" value="#email.buttonTitle#">
                    <label for="buttonTitle" class="form-label fs-18 fw-medium">Button Title</label>
                    <div class="invalid-feedback">Button title must be between 2 and 20 characters.</div>
                </div>
            </div>

            <div class="col-sm-6 col-md-6 mb-3">
                <div class="form-floating">
                    <input name="footerGreating" type="text" placeholder="Enter footer greating" class="form-control fs-18" id="footerGreating"
                    aria-describedby="footerGreatingHelp" minlength="2" maxlength="50" value="#email.footerGreating#">
                    <label for="footerGreating" class="form-label fs-18 fw-medium">Footer Greating</label>
                    <div class="invalid-feedback">Button title must be between 2 and 20 characters.</div>
                </div>
            </div>
            <div class="col-sm-6 col-md-6 mb-3">
                <div class="form-floating">
                    <input name="closingRemark" type="text" placeholder="Enter closing remarks" class="form-control fs-18" id="closingRemark"
                    aria-describedby="closingRemarkHelp" minlength="2" maxlength="30" value="#email.closingRemark#">
                    <label for="closingRemark" class="form-label fs-18 fw-medium">Closing Remarks</label>
                    <div class="invalid-feedback">Closing Remarks must be between 2 and 30 characters.</div>
                </div>
            </div>
            <div class="col-sm-6 col-md-6 mb-3">
                <div class="form-floating">
                    <input name="teamSignature" type="text" placeholder="Enter team signature" class="form-control fs-18" id="teamSignature"
                    aria-describedby="welcomeMessageHelp" minlength="3" maxlength="30" value="#email.teamSignature#">
                    <label for="teamSignature" class="form-label fs-18 fw-medium">Team signatre</label>
                    <div class="invalid-feedback">Team signature must be between 3 and 30 characters.</div>
                </div>
            </div>
            <div class="col-12 gy-6">
                <div class="row g-3 justify-content-end">
                    <div class="col-auto">
                        <button type="submit" class="btn bg--primary text-white px-sm-5 fs-14">Save</button>
                    </div>
                    <div class="col-auto">
                        <a hx-get="#urlFor(route="adminemail-templates")#" hx-target="body" hx-push-url="true" class="btn btn-dark px-sm-5 fs-14">Cancel</a>
                    </div>
                </div>
            </div>
        </form>
    </div>
</div>
    <script>
        (function () {
            'use strict'
            var form = document.querySelector('.needs-validation')
            form.addEventListener('submit', function (event) {
                if (!form.checkValidity()) {
                    event.preventDefault()
                    event.stopPropagation()
                }
                form.classList.add('was-validated')
            }, false)
        })();
        document.body.addEventListener("htmx:afterRequest", function(event) {
            const xhr = event.detail.xhr;
            if (xhr.status === 500 && xhr.responseURL.includes("/admin/email/save")) {
                notifier.show('Error', 'Something went wrong!', 'danger', '', 5000);
            }
            if (xhr.status === 200 && xhr.responseURL.includes("/admin/email/save")) {
                notifier.show('Success', 'email save successfully!', 'success', '', 5000);
            }
        });

        // checked all permissions
        document.getElementById('selectAllPermissions').addEventListener('change', function() {
            const isChecked = this.checked;
            document.querySelectorAll('.permission-checkbox').forEach(function(checkbox) {
                checkbox.checked = isChecked;
            });
        });
    </script>
</cfoutput>