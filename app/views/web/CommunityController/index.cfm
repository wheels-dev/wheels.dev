<cfset coreTeam=[]>
    <cfloop from="10" to="27" index="i">
        <cfset member={ name="Member #i#" , country="USA" , image="https://avatar.iran.liara.run/public/#i#" ,
            since="Since 20#i#" }>
            <cfset arrayAppend(coreTeam, member)>
    </cfloop>

    <cfoutput>
    <main class="main-bg">
        <div class="container py-5">
            <h1 class="text-center fw-bold fs-60">We make Wheels better</h1>
            <p class="text--secondary fs-18 text-center fw-medium">
                Wheels continues to improve each year thanks to the efforts of thousands of volunteers, contributing in
                both
                big and small ways. Whether you're a longtime user or just getting started, everyone has something
                valuable
                to offer in making this framework better.
            </p>

            <div class="mt-5">
                <div class="bg-white rounded-18 px-4 py-5 mt-lg-5 mt-3">
                    <!-- Community Engagement Section -->
                    <div class="row mt-lg-5 mt-3">
                        <div class="col-lg-6 col-12 mt-lg-0 mt-5">
                            <a class="position-relative d-block docs-container bg-white border-2 px-4 py-5 cursor-pointer rounded-4 border--lightGray hover:border--primary"
                                href="#settings.slackInviteLink#" target="_blank">
                                <div class="docs-badge d-flex align-items-center gap-2 bg--primary px-3 py-2 text-white">
                                    <p class="fw-bold text-uppercase fs-12">Community</p>
                                    <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5"
                                        stroke="currentColor" width="20" height="20">
                                        <path stroke-linecap="round" stroke-linejoin="round" d="m8.25 4.5 7.5 7.5-7.5 7.5" />
                                    </svg>
                                </div>
                                <div class="text-center">
                                    <p class="fw-bold pb-2 fs-22 text-decoration-underline">Join Our Slack</p>
                                    <p class="text--secondary fw-normal">
                                        Connect with other Wheels developers, get help, and share your projects in our active Slack community.
                                    </p>
                                </div>
                            </a>
                        </div>

                        <div class="col-lg-6 col-12 mt-lg-0 mt-5">
                            <a class="position-relative d-block docs-container bg-white border-2 px-4 py-5 cursor-pointer rounded-4 border--lightGray hover:border--primary"
                                href="https://github.com/wheels-dev/wheels/discussions" target="_blank">
                                <div class="docs-badge d-flex align-items-center gap-2 bg--primary px-3 py-2 text-white">
                                    <p class="fw-bold text-uppercase fs-12">Discussions</p>
                                    <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5"
                                        stroke="currentColor" width="20" height="20">
                                        <path stroke-linecap="round" stroke-linejoin="round" d="m8.25 4.5 7.5 7.5-7.5 7.5" />
                                    </svg>
                                </div>
                                <div class="text-center">
                                    <p class="fw-bold pb-2 fs-22 text-decoration-underline">GitHub Discussions</p>
                                    <p class="text--secondary fw-normal">
                                        Join the conversation, share ideas, and participate in the ongoing development of Wheels.
                                    </p>
                                </div>
                            </a>
                        </div>
                    </div>

                    <!-- Top Contributors Section -->
                    <div class="mt-5">
                        <p class="text-center text--primary fs-32 pb-2 fw-bold">Top Contributors</p>
                        <div class="d-flex flex-wrap justify-content-center gap-3 mt-3">
                            <a href="https://github.com/wheels-dev/wheels/graphs/contributors" target="_blank">
                                <img src="https://contrib.rocks/image?repo=wheels-dev/wheels" alt="Wheels.dev contributors" style="max-width: 100%;">
                            </a>
                        </div>
                    </div>

                    <!-- Financial Contributors Section -->
                    <div class="mt-5 text-center">
                        <p class="text-center text--primary fs-32 fw-bold">Financial Contributors</p>
                        <script src='https://opencollective.com/wheels-dev/banner.js?style={"a":{"color":"rgb(191, 40, 33)"},"h2":{"fontWeight":"medium","fontSize":"18px"}}'></script>
                    </div>

                    <div class="mt-5 d-none">
                        <p class="text-center text--primary fs-32 pb-2 fw-bold">Meet the Core team</p>
                        <p class="fw-normal fs-18 text-center col-lg-9 mx-auto">
                            <strong>The direction of the framework is stewarded by the
                                Wheels Core.</strong> This group of long-term contributors
                            manages releases, evaluates pull-requests, handles conduct complaints, and does a lot of the
                            groundwork on major new features.
                        </p>

                        <div
                            class="row row-cols-lg-6 text-center row-cols-md-3 row-cols-1 mt-3 gy-5 align-items-center justify-content-center">
                            <cfloop array="#coreTeam#" index="member">
                                <cfoutput>
                                    <div>
                                        <div
                                            class="p-2 mx-auto size-100 border-2 border--lightGray hover:border--primary rounded-circle">
                                            <img src="#member.image#" alt="#member.name#" width="80" height="80"><br>
                                        </div>
                                        <p class="pt-2 fw-bold text-decoration-underline fs-18">
                                            #member.name#
                                        </p>
                                        <p class="fw-semibold fs-16">
                                            #member.country#
                                        </p>
                                        <p class="fst-italic">#member.since#</p>
                                    </div>
                                </cfoutput>
                            </cfloop>
                        </div>
                    </div>

                    <div class="mt-5 d-none">
                        <p class="text-center text--primary fs-32 pb-2 fw-bold">The Committers</p>
                        <p class="fw-normal fs-18 text-center col-lg-9 mx-auto">
                            <strong>The Committer team assists with processing pull requests and making changes to the
                                framework</strong>, but does not have the keys to make final releases or set policy. All
                            members of the Core team came up through working on this team:
                        </p>

                        <div
                            class="row row-cols-lg-6 text-center row-cols-md-3 row-cols-1 mt-3 gy-5 align-items-center justify-content-center">
                            <cfloop array="#coreTeam#" index="member">
                                <cfoutput>
                                    <div>
                                        <div
                                            class="p-2 mx-auto size-100 border-2 border--lightGray hover:border--primary rounded-circle">
                                            <img src="#member.image#" alt="#member.name# - wheels.dev" width="80" height="80"><br>
                                        </div>
                                        <p class="pt-2 fw-bold text-decoration-underline fs-18">
                                            #member.name#
                                        </p>
                                        <p class="fw-semibold fs-16">
                                            #member.country#
                                        </p>
                                        <p class="fst-italic">#member.since#</p>
                                    </div>
                                </cfoutput>
                            </cfloop>
                        </div>
                    </div>

                    <div class="mt-5 d-none">
                        <p class="text-center text--primary fs-32 pb-2 fw-bold">The Issues team</p>
                        <p class="fw-normal fs-18 text-center col-lg-9 mx-auto">
                            <strong>The Issues team assists with issues triage, pull request reviews, and documentation
                                improvements.</strong> They are often the first point of interaction of users with the
                            Rails team: <br>
                            <cfoutput>
                                <cfloop from="1" to="#arrayLen(coreTeam)#" index="i">
                                    <a class="text-decoration-underline text--primary fw-bold fs-18" href="/community">
                                        #coreTeam[i].name#
                                    </a>
                                    <cfif i LT arrayLen(coreTeam)>
                                        ,
                                    </cfif>
                                </cfloop>
                            </cfoutput>
                        </p>
                    </div>

                    <div class="mt-5 d-none">
                        <p class="text-center text--primary fs-32 pb-2 fw-bold">The Alumni</p>
                        <p class="fw-normal fs-18 text-center col-lg-9 mx-auto">
                            <strong>We'd like to extend special thanks</strong> to the following Rails Core team members, lovingly known as The Alumni: George Claghorn, Santiago Pastorino, Yves Senn, Godfrey Chan, Michael Koziarski, José Valim, Yehuda Katz, Jon Leighton, Josh Peek, Carl Lerche, Pratik Naik, Jamis Buck, Marcel Molina, Nicholas Seckar, Sam Stephenson, Florian Weber, Scott Barron, Tobias Lütke, Rick Olson
                        </p>
                    </div>
                </div>
            </div>
    </main>
    </cfoutput>
