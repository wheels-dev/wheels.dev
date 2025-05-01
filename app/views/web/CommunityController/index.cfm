<cfset coreTeam=[]>
    <cfloop from="10" to="27" index="i">
        <cfset member={ name="Member #i#" , country="USA" , image="https://avatar.iran.liara.run/public/#i#" ,
            since="Since 20#i#" }>
            <cfset arrayAppend(coreTeam, member)>
    </cfloop>

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
                    <div>
                        <p class="text-center text--primary fs-32 pb-2 fw-bold">Meet the Core team.</p>
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

                    <div class="mt-5">
                        <p class="text-center text--primary fs-32 pb-2 fw-bold">The Committers.</p>
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

                    <div class="mt-5">
                        <p class="text-center text--primary fs-32 pb-2 fw-bold">The Issues team.</p>
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

                    
                    <div class="mt-5">
                        <p class="text-center text--primary fs-32 pb-2 fw-bold">The Alumni.</p>
                        <p class="fw-normal fs-18 text-center col-lg-9 mx-auto">
                            <strong>We'd like to extend special thanks</strong> to the following Rails Core team members, lovingly known as The Alumni: George Claghorn, Santiago Pastorino, Yves Senn, Godfrey Chan, Michael Koziarski, José Valim, Yehuda Katz, Jon Leighton, Josh Peek, Carl Lerche, Pratik Naik, Jamis Buck, Marcel Molina, Nicholas Seckar, Sam Stephenson, Florian Weber, Scott Barron, Tobias Lütke, Rick Olson
                        </p>
                    </div>
                </div>
            </div>
    </main>