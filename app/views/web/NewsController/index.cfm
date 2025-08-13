<main class="main-bg">
  <div class="container py-5 word-break">

    <!-- Filter Buttons -->
    <h1 class="text-center fw-bold fs-60">News<h1>
    <div class="d-flex justify-content-center flex-wrap align-items-center gap-4 mt-4">
      <a href="/news" class="px-4 fs-16 py-2 rounded-3 border border--primary bg--primary text-white active">Everything</a>
      <a href="https://github.com/wheels-dev/wheels/releases" target="_blank" class="px-4 fs-16 py-2 rounded-3 border border--primary hover:bg--primary hover:text-white bg-transparent text--secondary transition">Releases</a>
      <a href="/blog" class="px-4 fs-16 py-2 rounded-3 border border--primary hover:bg--primary hover:text-white bg-transparent text--secondary transition">Blogs</a>
    </div>

    <!-- Loop Over GitHub Releases -->
    <div class="mt-5">
      <cfloop array="#releases#" index="release">
        <div class="items border-2 border--lightGray row border-start-0 border-end-0 border-bottom-0 py-5" style="display: none;">
          <div class="col-lg-3 col-12 mb-3 mb-lg-0">
            <p class="fw-bold text--secondary">
              <cfoutput>#dateFormat(parseDateTime(release.published_at), "mmmm d, yyyy")#</cfoutput>
            </p>
          </div>
          <div class="col-lg-9 col-12">
            <cfoutput>
              <a href="#release.html_url#" class="text-decoration-none" target="_blank">
                <p class="text--primary fs-22 fw-bold text-decoration-underline hover:text--primary-dark transition">
                  #release.name#
                </p>
              </a>
              <p class="text--secondary fs-18 pt-2">
                <cfif structKeyExists(release, "isBlog")>
                  <cfif findNoCase("```", release.body) OR findNoCase("##", release.body) OR findNoCase("**", release.body) OR findNoCase("__", release.body) OR findNoCase(">", release.body)>
                      <div class="markdown-content">
                          <cfoutput>#encodeForHTML(release.body)#</cfoutput>
                      </div>
                  <cfelse>
                      #this.autoLink(release.body,"text--primary")#
                  </cfif>
                <cfelse>
                  <cfif findNoCase("```", release.body) OR findNoCase("##", release.body) OR findNoCase("**", release.body) OR findNoCase("__", release.body) OR findNoCase(">", release.body)>
                      <div class="markdown-content">
                          <cfoutput>#encodeForHTML(release.body)#</cfoutput>
                      </div>
                  <cfelse>
                      #replace(release.body, chr(10), "<br>", "all")#
                  </cfif>
                </cfif>
              </p>

              <!-- Show asset download links if available -->
              <cfif arrayLen(release.assets)>
                <div class="pt-3">
                  <cfloop array="#release.assets#" index="asset">
                    <a href="#asset.browser_download_url#" class="btn btn-sm btn-outline-danger me-2 mb-2" target="_blank">
                      Download #asset.name#
                    </a>
                  </cfloop>
                </div>
              <cfelse>
                <cfif structKeyExists(release, "isBlog")>
                  <div class="pt-3">
                    <a href="#release.html_url#" class="btn btn-sm btn-outline-danger me-2 mb-2">
                      Learn More <i class="bi bi-arrow-right mt-1"></i>
                    </a>
                  </div>
                </cfif>
              </cfif>
            </cfoutput>
          </div>
        </div>
      </cfloop>
    </div>

    <!-- Loader -->
    <div id="loader" class="text-center mt-4">
      <div class="spinner-border text--primary" role="status">
        <span class="visually-hidden">Loading...</span>
      </div>
    </div>

  </div>
</main>