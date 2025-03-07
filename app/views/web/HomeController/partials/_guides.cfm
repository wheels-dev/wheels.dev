<cfoutput>
    <div class="row">
                <div class="col-4 border-end">
                    <!-- Vertical Tabs Navigation -->
                    <div class="nav flex-column nav-pills-primary" id="v-pills-tab" role="tablist"
                        aria-orientation="vertical">
                        <button class="nav-link fs-18 text-white fw-bold rounded-2 active" id="v-pills-intro-tab"
                            data-bs-toggle="pill" data-bs-target="##v-pills-introduction" type="button" role="tab"
                            aria-controls="v-pills-introduction" aria-selected="true">Introduction</button>
                        <button class="nav-link fs-18 mt-3 text-white fw-bold rounded-2" id="v-pills-command-tab"
                            data-bs-toggle="pill" data-bs-target="##v-pills-command" type="button" role="tab"
                            aria-controls="v-pills-command" aria-selected="false">Command Line tools</button>
                        <button class="nav-link fs-18 mt-3 text-white fw-bold rounded-2" id="v-pills-working-with-wheels-tab"
                            data-bs-toggle="pill" data-bs-target="##v-working-with-wheels" type="button" role="tab"
                            aria-controls="v-working-with-wheels" aria-selected="false">Working with Wheels</button>
                        <button class="nav-link fs-18 mt-3 text-white fw-bold rounded-2"
                            id="v-pills-handling-request-controllers-tab" data-bs-toggle="pill"
                            data-bs-target="##v-request-controller" type="button" role="tab"
                            aria-controls="v-request-controller" aria-selected="false">Handling Requests with
                            Controllers</button>
                        <button class="nav-link fs-18 mt-3 text-white fw-bold rounded-2" id="v-pills-multiple-format-tab"
                            data-bs-toggle="pill" data-bs-target="##v-multiple-format" type="button" role="tab"
                            aria-controls="v-multiple-format" aria-selected="false">Responding with Multiple
                            Formats</button>
                        <button class="nav-link fs-18 mt-3 text-white fw-bold rounded-2" id="v-pills-displaying-tab"
                            data-bs-toggle="pill" data-bs-target="##v-displaying" type="button" role="tab"
                            aria-controls="v-displaying" aria-selected="false">Displaying Views to Users</button>
                        <button class="nav-link fs-18 mt-3 text-white fw-bold rounded-2" id="v-pills-interaction-tab"
                            data-bs-toggle="pill" data-bs-target="##v-interaction" type="button" role="tab"
                            aria-controls="v-interaction" aria-selected="false">Database Interaction Through
                            Models</button>
                        <button class="nav-link fs-18 mt-3 text-white fw-bold rounded-2" id="v-pills-plugins-tab"
                            data-bs-toggle="pill" data-bs-target="##v-plugins" type="button" role="tab"
                            aria-controls="v-plugins" aria-selected="false">Plugins</button>
                        <button class="nav-link fs-18 mt-3 text-white fw-bold rounded-2" id="v-pills-external-tab"
                            data-bs-toggle="pill" data-bs-target="##v-external" type="button" role="tab"
                            aria-controls="v-external" aria-selected="false">External Links</button>
                    </div>
                </div>
                <div class="col-8">
                    <!-- Vertical Tabs Content -->
                    <div class="tab-content" id="v-pills-tabContent">
                        <div class="tab-pane fade show active" id="v-pills-introduction" role="tabpanel"
                            aria-labelledby="v-pills-intro-tab">
                            <h3 class="fs-24 text--primary fw-semibold">Getting Started</h3>
                            <p class="text-white fs-22">Install Wheels and get a local development server running
                            </p>
                            <p class="fs-18 text-white">
                                By far the quickest way to get started with Wheels is via CommandBox. CommandBox
                                brings a whole host of command line capabilities to the CFML developer. It allows
                                you to write scripts that can be executed at the command line written entirely in
                                CFML. It allows you to start a CFML server from any directory on your machine and
                                wire up the code in that directory as the web root of the server. What's more is,
                                those servers can be either Lucee servers or Adobe ColdFusion servers. You can even
                                specify what version of each server to launch. Lastly, CommandBox is a package
                                manager for CFML. That means you can take some CFML code and package it up into a
                                module, host it on ForgeBox.io, and make it available to other CFML developers. In
                                fact we make extensive use of these capabilities to distribute Wheels plugins and
                                templates. More on that later.
                                One module that we have created is a module that extends CommandBox itself with
                                commands and features specific to the Wheels framework. The Wheels CLI module for
                                CommandBox is modeled after the Ruby on Rails CLI module and gives similar
                                capabilities to developer.By far the quickest way to get started with Wheels is via
                                CommandBox. CommandBox brings a whole host of command line capabilities to the CFML
                                developer. It allows you to write scripts that can be executed at the command line
                                written entirely in CFML. It allows you to start a CFML server from any directory on
                                your machine and wire up the code in that directory as One module that we have
                                created is a module that extends CommandBox itself with commands and features
                                specific to the Wheels framework. The Wheels CLI module for CommandBox is modeled
                                after the Ruby on Rails CLI module and gives similar capabilities to developer.By
                                far the quickest way to get started with Wheels is via CommandBox. CommandBox brings
                                a whole host of command line capabilities to the CFML developer. It allows you to
                                write scripts that can be executed at the command line written entirely in CFML. It
                                allows you to start a CFML server from any directory on your machine and wire up the
                                code in that directory as
                            </p>
                            <div class="d-flex justify-content-end">
                                <button class="bg--primary fs-16 fw-semibold px-3 py-1 rounded text-white">Learn
                                    more</button>
                            </div>
                        </div>
                        <div class="tab-pane fade" id="v-pills-command" role="tabpanel"
                            aria-labelledby="v-pills-command-tab">
                            <h3 class="fs-24 text--primary fw-semibold">Command Line tools</h3>
                            </p>
                                <h4 class="text-white">CLI Commands</h4>
                            <p class="fs-18 text-white">
                                The command line tools extends the functionality of <a href="https://www.ortussolutions.com/products/commandbox">CommandBox</a> with some commands specifically designed for CFWheels development.<a href="https://www.ortussolutions.com/products/commandbox">CommandBox</a> brings a whole host of command line capabilities to the CFML developer. It allows you to write scripts that can be executed at the command line written entirely in CFML. It allows you to start a CFML server from any directory on your machine and wire up the code in that directory as the web root of the server. What's more is, those servers can be either Lucee servers or Adobe ColdFusion servers. You can even specify what version of each server to launch. Lastly, CommandBox is a package manager for CFML. That means you can take some CFML code and package it up into a module, host it on ForgeBox.io, and make it available to other CFML developers. In fact we make extensive use of these capabilities to distribute CFWheels plugins and templates. More on that later.One module that we have created is a module that extends CommandBox itself with commands and features specific to the CFWheels framework. The CFWheels CLI module for CommandBox is modeled after the Ruby on Rails CLI module and gives similar capabilities to the CFWheels developer.
                            </p>
                            <div class="d-flex justify-content-end">
                                <button class="bg--primary fs-16 fw-semibold px-3 py-1 rounded text-white">Learn
                                    more</button>
                            </div>
                        </div>
                        <div class="tab-pane fade" id="v-working-with-wheels" role="tabpanel"
                            aria-labelledby="v-pills-working-with-wheels-tab">
                            <h3 class="fs-24 text--primary fw-semibold">Working with Wheels</h3>
                            <p class="text-white fs-22">Working with Wheels
                            </p>
                            <p class="fs-18 text-white">
                                Lorem ipsum dolor sit amet consectetur adipisicing elit. Tempore repellendus
                                veritatis quod ipsam voluptates sapiente! Quidem, nihil? Nam id natus dolore!
                                Accusamus vel ea error quisquam dolorum deserunt veniam assumenda.
                            </p>
                            <div class="d-flex justify-content-end">
                                <button class="bg--primary fs-16 fw-semibold px-3 py-1 rounded text-white">Learn
                                    more</button>
                            </div>
                        </div>
                        <div class="tab-pane fade" id="v-request-controller" role="tabpanel"
                            aria-labelledby="v-pills-handling-request-controllers-tab">
                            <h3 class="fs-24 text--primary fw-semibold">Handling Requests with Controllers</h3>
                            <p class="text-white fs-22">Handling Requests with Controllers
                            </p>
                            <p class="fs-18 text-white">
                                Lorem ipsum dolor sit amet consectetur adipisicing elit. Tempore repellendus
                                veritatis quod ipsam voluptates sapiente! Quidem, nihil? Nam id natus dolore!
                                Accusamus vel ea error quisquam dolorum deserunt veniam assumenda.
                            </p>
                            <div class="d-flex justify-content-end">
                                <button class="bg--primary fs-16 fw-semibold px-3 py-1 rounded text-white">Learn
                                    more</button>
                            </div>
                        </div>
                        <div class="tab-pane fade" id="v-multiple-format" role="tabpanel"
                            aria-labelledby="v-pills-multiple-format-tab">
                            <h3 class="fs-24 text--primary fw-semibold">Responding with Multiple Formats</h3>
                            <p class="text-white fs-22">Responding with Multiple Formats
                            </p>
                            <p class="fs-18 text-white">
                                Lorem ipsum dolor sit amet consectetur adipisicing elit. Tempore repellendus
                                veritatis quod ipsam voluptates sapiente! Quidem, nihil? Nam id natus dolore!
                                Accusamus vel ea error quisquam dolorum deserunt veniam assumenda.
                            </p>
                            <div class="d-flex justify-content-end">
                                <button class="bg--primary fs-16 fw-semibold px-3 py-1 rounded text-white">Learn
                                    more</button>
                            </div>
                        </div>
                        <div class="tab-pane fade" id="v-displaying" role="tabpanel"
                            aria-labelledby="v-pills-displaying-tab">
                            <h3 class="fs-24 text--primary fw-semibold">Displaying Views to Users</h3>
                            <p class="text-white fs-22">Displaying Views to Users
                            </p>
                            <p class="fs-18 text-white">
                                Lorem ipsum dolor sit amet consectetur adipisicing elit. Tempore repellendus
                                veritatis quod ipsam voluptates sapiente! Quidem, nihil? Nam id natus dolore!
                                Accusamus vel ea error quisquam dolorum deserunt veniam assumenda.
                            </p>
                            <div class="d-flex justify-content-end">
                                <button class="bg--primary fs-16 fw-semibold px-3 py-1 rounded text-white">Learn
                                    more</button>
                            </div>
                        </div>
                        <div class="tab-pane fade" id="v-interaction" role="tabpanel"
                            aria-labelledby="v-pills-interaction-tab">
                            <h3 class="fs-24 text--primary fw-semibold">Database Interaction Through Models</h3>
                            <p class="text-white fs-22">Database Interaction Through Models
                            </p>
                            <p class="fs-18 text-white">
                                Lorem ipsum dolor sit amet consectetur adipisicing elit. Tempore repellendus
                                veritatis quod ipsam voluptates sapiente! Quidem, nihil? Nam id natus dolore!
                                Accusamus vel ea error quisquam dolorum deserunt veniam assumenda.
                            </p>
                            <div class="d-flex justify-content-end">
                                <button class="bg--primary fs-16 fw-semibold px-3 py-1 rounded text-white">Learn
                                    more</button>
                            </div>
                        </div>
                        <div class="tab-pane fade" id="v-plugins" role="tabpanel" aria-labelledby="v-pills-plugins-tab">
                            <h3 class="fs-24 text--primary fw-semibold">Plugins</h3>
                            <p class="text-white fs-22">Plugins
                            </p>
                            <p class="fs-18 text-white">
                                Lorem ipsum dolor sit amet consectetur adipisicing elit. Tempore repellendus
                                veritatis quod ipsam voluptates sapiente! Quidem, nihil? Nam id natus dolore!
                                Accusamus vel ea error quisquam dolorum deserunt veniam assumenda.
                            </p>
                            <div class="d-flex justify-content-end">
                                <button class="bg--primary fs-16 fw-semibold px-3 py-1 rounded text-white">Learn
                                    more</button>
                            </div>
                        </div>
                        <div class="tab-pane fade" id="v-external" role="tabpanel"
                            aria-labelledby="v-pills-external-tab">
                            <h3 class="fs-24 text--primary fw-semibold">External Links</h3>
                            <p class="text-white fs-22">External Links
                            </p>
                            <p class="fs-18 text-white">
                                Lorem ipsum dolor sit amet consectetur adipisicing elit. Tempore repellendus
                                veritatis quod ipsam voluptates sapiente! Quidem, nihil? Nam id natus dolore!
                                Accusamus vel ea error quisquam dolorum deserunt veniam assumenda.
                            </p>
                            <div class="d-flex justify-content-end">
                                <button class="bg--primary fs-16 fw-semibold px-3 py-1 rounded text-white">Learn
                                    more</button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
</cfoutput>
