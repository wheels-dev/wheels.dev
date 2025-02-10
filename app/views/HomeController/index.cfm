<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Wheels.dev</title>
    <!-- Bootstrap CSS -->
    <link href="stylesheets/bootstrap.css" rel="stylesheet">
    <link href="stylesheets/style.css" rel="stylesheet">
    <link href="stylesheets/swiper.css" rel="stylesheet">
</head>

<body>
    <!-- Navigation -->
    <nav class="navbar navbar-expand-lg py-2">
        <div class="container">
            <a class="navbar-brand" href="#">
                <img src="images/wheels-logo.png" alt="Bootstrap" width="260">
            </a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse"
                data-bs-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false"
                aria-label="Toggle navigation">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarSupportedContent">
                <ul class="navbar-nav divide-x-primary mx-auto mb-2 mb-lg-0">
                    <li class="nav-item px-3">
                        <a class="nav-link py-0 active" aria-current="page" href="#">Home</a>
                    </li>
                    <li class="nav-item px-3">
                        <a class="nav-link py-0" aria-current="page" href="#">API</a>
                    </li>
                    <li class="nav-item px-3">
                        <a class="nav-link py-0" aria-current="page" href="#">Discussions</a>
                    </li>
                    <li class="nav-item px-3">
                        <a class="nav-link py-0" aria-current="page" href="#">Issue Tracker</a>
                    </li>
                    <li class="nav-item px-3">
                        <a class="nav-link py-0" aria-current="page" href="#">Plugins</a>
                    </li>
                </ul>
                <div>
                    <svg width="40" height="40" viewBox="0 0 40 40" fill="none" xmlns="http://www.w3.org/2000/svg">
                        <rect width="40" height="39.4186" rx="10" fill="#EF3B2D" />
                        <path
                            d="M20 8C18.4241 8 16.8637 8.31039 15.4078 8.91345C13.9519 9.5165 12.629 10.4004 11.5147 11.5147C9.26428 13.7652 8 16.8174 8 20C8 25.304 11.444 29.804 16.208 31.4C16.808 31.496 17 31.124 17 30.8V28.772C13.676 29.492 12.968 27.164 12.968 27.164C12.416 25.772 11.636 25.4 11.636 25.4C10.544 24.656 11.72 24.68 11.72 24.68C12.92 24.764 13.556 25.916 13.556 25.916C14.6 27.74 16.364 27.2 17.048 26.912C17.156 26.132 17.468 25.604 17.804 25.304C15.14 25.004 12.344 23.972 12.344 19.4C12.344 18.068 12.8 17 13.58 16.148C13.46 15.848 13.04 14.6 13.7 12.98C13.7 12.98 14.708 12.656 17 14.204C17.948 13.94 18.98 13.808 20 13.808C21.02 13.808 22.052 13.94 23 14.204C25.292 12.656 26.3 12.98 26.3 12.98C26.96 14.6 26.54 15.848 26.42 16.148C27.2 17 27.656 18.068 27.656 19.4C27.656 23.984 24.848 24.992 22.172 25.292C22.604 25.664 23 26.396 23 27.512V30.8C23 31.124 23.192 31.508 23.804 31.4C28.568 29.792 32 25.304 32 20C32 18.4241 31.6896 16.8637 31.0866 15.4078C30.4835 13.9519 29.5996 12.629 28.4853 11.5147C27.371 10.4004 26.0481 9.5165 24.5922 8.91345C23.1363 8.31039 21.5759 8 20 8Z"
                            fill="white" />
                    </svg>

                </div>
            </div>
        </div>
    </nav>

    <main class="main">
        <!-- Hero Section -->
        <div class="hero-section position-relative">
            <div class="container d-flex flex-column justify-content-center w-100 align-items-center h-100">
                <h1 class="main-title text-center position-relative">Wheels-The Fast & Fun<br>CFML Framework!</h1>
                <p class="subtitle text-center position-relative">Build apps quickly with an organized, Ruby on
                    Rails-inspired <br>
                    structure.
                    Get up and
                    running in no time!</p>
                <div class="row g-3 justify-content-center w-100 mt-1 align-items-center">
                    <div class="col-md-auto text-center">
                        <button class="btn-started text-white">Get Started</button>
                    </div>
                    <div class="col-md-auto text-center">
                        <button class="btn-download text-white">Download</button>
                    </div>
                </div>
            </div>
            <div class="row justify-content-center align-items-center mt-5 gy-3 text-center gx-5">
                <div class="col-md-auto">
                    <img src="images/github.png" class="img-fluid" width="174">
                </div>
                <div class="col-md-auto">
                    <img src="images/google.png" class="img-fluid" width="151">
                </div>
                <div class="col-md-auto">
                    <img src="images/github.png" class="img-fluid" width="174">
                </div>
                <div class="col-md-auto">
                    <img src="images/google.png" class="img-fluid" width="151">
                </div>
            </div>
        </div>

        <!-- Cards -->
        <div class="container pb-5">
            <div class="row g-5">
                <div class="col-lg-4">
                    <div class="p-4 bg-white rounded-5 shadow-sm">
                        <div class="icon-container d-flex justify-content-center align-items-center">
                            <svg width="37" height="34" viewBox="0 0 37 34" fill="none"
                                xmlns="http://www.w3.org/2000/svg">
                                <path
                                    d="M18.063 5.35858C13.4356 4.45069 8.50347 6.38426 5.00102 10.6559C4.7621 10.9471 4.78801 11.3634 5.06136 11.6253L8.69516 15.1069C11.1313 11.3084 14.3125 7.99802 18.063 5.35858Z"
                                    fill="#FEDC5A" />
                                <path
                                    d="M21.7714 27.4172L25.4784 30.837C25.7558 31.0929 26.1967 31.1171 26.5051 30.8935C31.0575 27.5931 33.107 22.9414 32.1004 18.5864C29.3014 22.1126 25.795 25.1104 21.7714 27.4172Z"
                                    fill="#FEDC5A" />
                                <path fill-rule="evenodd" clip-rule="evenodd"
                                    d="M36.1129 0.497156C36.3311 0.48545 36.5438 0.564557 36.6948 0.713556C36.8478 0.857634 36.9291 1.056 36.9183 1.25961C35.7293 20.9643 17.4709 27.7932 17.2857 27.8603C17.1982 27.892 17.1053 27.9082 17.0116 27.9079C16.8085 27.9078 16.6138 27.8318 16.4702 27.6965L8.04814 19.7618C7.83535 19.5616 7.76676 19.2624 7.87281 18.9972C7.94325 18.8227 15.102 1.53083 36.1129 0.497156ZM18.5436 14.9238C18.5436 16.5174 19.9147 17.8092 21.6061 17.8092C23.2976 17.8092 24.6687 16.5174 24.6687 14.9238C24.6687 13.3303 23.2976 12.0385 21.6061 12.0385C19.9147 12.0385 18.5436 13.3303 18.5436 14.9238Z"
                                    fill="#FEDC5A" />
                                <path
                                    d="M10.0212 26.2524C8.11302 24.6824 5.02356 24.6824 3.11535 26.2524C1.35999 27.6992 0.918098 32.5339 0.871711 33.0808C0.856594 33.2665 0.93561 33.4489 1.0899 33.5847C1.24418 33.7204 1.45989 33.7972 1.68551 33.7968L1.74003 33.7968C2.40328 33.7593 8.26669 33.3942 10.0212 31.9481C11.9264 30.3745 11.9264 27.826 10.0212 26.2524Z"
                                    fill="#FEDC5A" />
                            </svg>
                        </div>
                        <div class="mt-3">
                            <p class="fw-bold card-title">A Complete Package</p>
                            <p class="card-subtitle pt-1">A full framework with tonnes of functionality - once ...</p>
                        </div>
                    </div>
                </div>
                <div class="col-lg-4">
                    <div class="p-4 bg-white rounded-5 shadow-sm">
                        <div class="icon-container d-flex justify-content-center align-items-center">
                            <svg width="32" height="36" viewBox="0 0 32 36" fill="none"
                                xmlns="http://www.w3.org/2000/svg">
                                <path
                                    d="M12.4571 20.6429H0.787724C0.358291 20.6429 0.00976562 20.2994 0.00976562 19.8762V1.4738C0.00976562 1.05054 0.358291 0.707031 0.787724 0.707031H12.4571C12.8865 0.707031 13.2351 1.05054 13.2351 1.4738V19.8762C13.2351 20.2994 12.8865 20.6429 12.4571 20.6429Z"
                                    fill="#F04037" />
                                <path
                                    d="M12.4571 35.5949H0.787724C0.358291 35.5949 0.00976562 35.236 0.00976562 34.7939V25.1819C0.00976562 24.7398 0.358291 24.3809 0.787724 24.3809H12.4571C12.8865 24.3809 13.2351 24.7398 13.2351 25.1819V34.7939C13.2351 35.236 12.8865 35.5949 12.4571 35.5949Z"
                                    fill="#F04037" />
                                <path
                                    d="M30.9724 11.921H19.3031C18.8736 11.921 18.5251 11.5621 18.5251 11.12V1.50803C18.5251 1.06588 18.8736 0.707031 19.3031 0.707031H30.9724C31.4019 0.707031 31.7504 1.06588 31.7504 1.50803V11.12C31.7504 11.5621 31.4019 11.921 30.9724 11.921Z"
                                    fill="#F04037" />
                                <path
                                    d="M30.9722 35.5949H19.3029C18.8734 35.5949 18.5249 35.2514 18.5249 34.8281V16.4257C18.5249 16.0025 18.8734 15.659 19.3029 15.659H30.9722C31.4017 15.659 31.7502 16.0025 31.7502 16.4257V34.8281C31.7502 35.2514 31.4017 35.5949 30.9722 35.5949Z"
                                    fill="#F04037" />
                            </svg>
                        </div>
                        <div class="mt-3">
                            <p class="fw-bold card-title">RESTful Routing</p>
                            <p class="card-subtitle pt-1">Resource based routing for GET, POST, PUT, PATCH & DELETE</p>
                        </div>
                    </div>
                </div>
                <div class="col-lg-4">
                    <div class="p-4 bg-white rounded-5 shadow-sm">
                        <div class="icon-container d-flex justify-content-center align-items-center">
                            <svg width="46" height="36" viewBox="0 0 46 36" fill="none"
                                xmlns="http://www.w3.org/2000/svg">
                                <path
                                    d="M23.9227 35.5949H2.97385C1.39616 35.5949 0.117188 34.3617 0.117188 32.8406V3.46133C0.117187 1.94017 1.39616 0.707031 2.97385 0.707031H23.9227V2.54323H2.97385C2.44795 2.54323 2.02163 2.95428 2.02163 3.46133V32.8406C2.02163 33.3476 2.44795 33.7587 2.97385 33.7587H23.9227V35.5949Z"
                                    fill="#5454D4" />
                                <path fill-rule="evenodd" clip-rule="evenodd"
                                    d="M26.5679 0.707031H42.1598C43.7744 0.707031 45.0833 1.94017 45.0833 3.46133V32.8406C45.0833 34.3617 43.7744 35.5949 42.1598 35.5949H26.5679V0.707031ZM32.4151 26.4139H39.2365C39.7747 26.4139 40.211 26.0028 40.211 25.4958C40.211 24.9887 39.7747 24.5777 39.2365 24.5777H32.4151C31.8769 24.5777 31.4406 24.9887 31.4406 25.4958C31.4406 26.0028 31.8769 26.4139 32.4151 26.4139ZM39.2365 19.069H32.4151C31.8769 19.069 31.4406 18.658 31.4406 18.1509C31.4406 17.6439 31.8769 17.2328 32.4151 17.2328H39.2365C39.7747 17.2328 40.211 17.6439 40.211 18.1509C40.211 18.658 39.7747 19.069 39.2365 19.069ZM32.4151 11.7242H39.2365C39.7747 11.7242 40.211 11.3132 40.211 10.8061C40.211 10.2991 39.7747 9.88802 39.2365 9.88802H32.4151C31.8769 9.88802 31.4406 10.2991 31.4406 10.8061C31.4406 11.3132 31.8769 11.7242 32.4151 11.7242Z"
                                    fill="#5454D4" />
                            </svg>
                        </div>
                        <div class="mt-3">
                            <p class="fw-bold card-title">Database Migrations</p>
                            <p class="card-subtitle pt-1">Built in database migration system even across different...
                            </p>
                        </div>
                    </div>
                </div>
                <div class="col-lg-4">
                    <div class="p-4 bg-white rounded-5 shadow-sm">
                        <div class="icon-container d-flex justify-content-center align-items-center">
                            <svg width="39" height="43" viewBox="0 0 39 43" fill="none"
                                xmlns="http://www.w3.org/2000/svg">
                                <path
                                    d="M27.8364 0.931152H11.2231C3.95483 0.931152 0.839844 5.08447 0.839844 11.3144V32.081C0.839844 38.311 3.95483 42.4643 11.2231 42.4643H27.8364C35.1047 42.4643 38.2197 38.311 38.2197 32.081V11.3144C38.2197 5.08447 35.1047 0.931152 27.8364 0.931152ZM11.2231 22.2169H19.5298C20.3812 22.2169 21.0873 22.923 21.0873 23.7744C21.0873 24.6258 20.3812 25.3319 19.5298 25.3319H11.2231C10.3717 25.3319 9.66564 24.6258 9.66564 23.7744C9.66564 22.923 10.3717 22.2169 11.2231 22.2169ZM27.8364 33.6385H11.2231C10.3717 33.6385 9.66564 32.9324 9.66564 32.081C9.66564 31.2296 10.3717 30.5235 11.2231 30.5235H27.8364C28.6878 30.5235 29.3939 31.2296 29.3939 32.081C29.3939 32.9324 28.6878 33.6385 27.8364 33.6385ZM33.028 15.9869H28.8747C25.7182 15.9869 23.1639 13.4326 23.1639 10.2761V6.12279C23.1639 5.27137 23.87 4.5653 24.7214 4.5653C25.5728 4.5653 26.2789 5.27137 26.2789 6.12279V10.2761C26.2789 11.709 27.4418 12.8719 28.8747 12.8719H33.028C33.8795 12.8719 34.5855 13.578 34.5855 14.4294C34.5855 15.2809 33.8795 15.9869 33.028 15.9869Z"
                                    fill="#5454D4" />
                            </svg>

                        </div>
                        <div class="mt-3">
                            <p class="fw-bold card-title">Automatic Doc</p>
                            <p class="card-subtitle pt-1">A full framework with tonnes of functionality - once ...</p>
                        </div>
                    </div>
                </div>
                <div class="col-lg-4">
                    <div class="p-4 bg-white rounded-5 shadow-sm">
                        <div class="icon-container d-flex justify-content-center align-items-center">
                            <svg width="39" height="38" viewBox="0 0 39 38" fill="none"
                                xmlns="http://www.w3.org/2000/svg">
                                <path
                                    d="M0.749191 18.8651C0.749191 15.4047 0.735162 11.9396 0.753867 8.4792C0.777249 4.42957 3.49415 1.14685 7.45493 0.351883C7.94593 0.253682 8.45097 0.211596 8.95132 0.211596C15.933 0.202243 22.9099 0.183539 29.8915 0.211596C33.9178 0.225625 37.1865 2.97058 37.9674 6.92201C38.075 7.47848 38.1077 8.05366 38.1077 8.62416C38.1171 15.4655 38.1171 22.3115 38.1124 29.1529C38.1077 33.3054 35.4423 36.5975 31.4254 37.4158C30.939 37.514 30.4293 37.5608 29.929 37.5608C22.938 37.5701 15.9423 37.5935 8.95132 37.5561C4.93911 37.5374 1.69379 34.8065 0.903507 30.8691C0.786601 30.2892 0.763219 29.6813 0.758543 29.0874C0.744514 25.6831 0.749191 22.2741 0.749191 18.8651ZM21.5211 11.3224C20.9365 11.3224 20.4596 11.6965 20.2445 12.3371C19.211 15.4328 18.1776 18.5331 17.1441 21.6288C16.8027 22.6576 16.4473 23.6817 16.1153 24.7151C15.9049 25.3698 16.1855 26.0151 16.756 26.305C17.3078 26.5856 17.9858 26.4453 18.3599 25.9403C18.5002 25.7486 18.5937 25.5148 18.6686 25.2856C19.7675 21.9982 20.8617 18.7061 21.9606 15.4141C22.2178 14.6425 22.4891 13.8756 22.7322 13.0993C23.0221 12.1921 22.4189 11.3224 21.5211 11.3224ZM10.8359 18.8838C11.9348 17.7896 12.9963 16.7421 14.0484 15.6806C14.6096 15.1148 14.6143 14.3105 14.0905 13.7914C13.5621 13.2723 12.7671 13.2911 12.2013 13.8569C10.8452 15.2083 9.48909 16.5597 8.13766 17.9205C7.54378 18.5191 7.54845 19.2626 8.14233 19.8705C8.73154 20.4691 9.3301 21.063 9.92866 21.6569C10.7049 22.4331 11.4765 23.2187 12.2621 23.9856C12.683 24.3971 13.2675 24.4766 13.7679 24.2241C14.2589 23.9763 14.5628 23.4666 14.4506 22.9101C14.3851 22.6015 14.2027 22.2741 13.983 22.045C12.9635 20.9835 11.9114 19.9594 10.8359 18.8838ZM28.0164 18.8792C27.8901 19.0101 27.8013 19.1083 27.7031 19.2065C26.7444 20.1698 25.7811 21.1238 24.8225 22.0917C24.2613 22.6622 24.2426 23.4525 24.7664 23.981C25.2854 24.5047 26.0898 24.4953 26.6556 23.9342C28.0164 22.5874 29.3678 21.2313 30.7192 19.8752C31.3272 19.2626 31.3178 18.5238 30.7005 17.8972C30.1862 17.3734 29.6624 16.859 29.148 16.34C28.3016 15.4936 27.4693 14.6378 26.6088 13.8101C25.884 13.1087 24.7196 13.4033 24.4484 14.3479C24.2941 14.8763 24.4484 15.3299 24.8412 15.718C25.8934 16.7515 26.9362 17.799 28.0164 18.8792Z"
                                    fill="#FEDC5A" />
                            </svg>
                        </div>
                        <div class="mt-3">
                            <p class="fw-bold card-title">Hybrid Development</p>
                            <p class="card-subtitle pt-1">Switch in and out of Wheels conventions - it's your call;...
                            </p>
                        </div>
                    </div>
                </div>
                <div class="col-lg-4">
                    <div class="p-4 bg-white rounded-5 shadow-sm">
                        <div class="icon-container d-flex justify-content-center align-items-center">
                            <svg width="46" height="21" viewBox="0 0 46 21" fill="none"
                                xmlns="http://www.w3.org/2000/svg">
                                <path
                                    d="M36.4369 4.29427C33.2384 4.29427 27.907 7.92712 22.2638 11.7738C17.3087 15.1515 11.6919 18.9798 9.06625 18.9798C5.29399 18.9798 2.2236 16.0969 2.2236 12.5549C2.2236 9.01293 5.29399 6.12997 9.06625 6.12997C9.72706 6.12997 10.6215 6.36586 11.6938 6.79816L9.23438 11.0212C9.05061 11.3351 9.07994 11.7206 9.30672 12.0079C9.49245 12.2447 9.78571 12.3787 10.0917 12.3787C10.1572 12.3787 10.2256 12.3723 10.2921 12.3594L19.0409 10.6421C19.3185 10.587 19.558 10.4227 19.6958 10.1887C19.8337 9.95464 19.8561 9.67654 19.7574 9.42688L16.6362 1.48015C16.5032 1.14238 16.1728 0.908329 15.7906 0.882629C15.4153 0.853258 15.0448 1.04233 14.862 1.35807L12.6323 5.18734C11.2178 4.60267 10.0184 4.29427 9.06625 4.29427C4.21481 4.29427 0.268555 7.99963 0.268555 12.5549C0.268555 17.1102 4.21481 20.8155 9.06625 20.8155C12.3263 20.8155 17.7115 17.1451 23.4124 13.2598C28.3146 9.91793 33.8728 6.12997 36.4369 6.12997C40.2091 6.12997 43.2795 9.01293 43.2795 12.5549C43.2795 16.0969 40.2091 18.9798 36.4369 18.9798C34.8885 18.9798 32.0752 17.7307 28.515 15.4617C28.0693 15.1754 27.4613 15.2873 27.1572 15.7059C26.8532 16.1253 26.9705 16.6962 27.4173 16.9808C31.4095 19.5251 34.4447 20.8155 36.4369 20.8155C41.2883 20.8155 45.2346 17.1102 45.2346 12.5549C45.2346 7.99963 41.2883 4.29427 36.4369 4.29427Z"
                                    fill="#5454D4" />
                            </svg>
                        </div>
                        <div class="mt-3">
                            <p class="fw-bold card-title">Full Documentation</p>
                            <p class="card-subtitle pt-1">Switch in and out of Wheels conventions - it's your call; ...
                            </p>
                        </div>
                    </div>
                </div>
                <div class="col-lg-4">
                    <div class="p-4 bg-white rounded-5 shadow-sm">
                        <div class="icon-container d-flex justify-content-center align-items-center">
                            <svg width="39" height="38" viewBox="0 0 39 38" fill="none"
                                xmlns="http://www.w3.org/2000/svg">
                                <path
                                    d="M6.47793 29.2181C2.36642 28.2201 0.412581 24.6568 0.742907 21.4238C1.04512 18.5211 2.99896 15.8926 6.44981 15.0633C6.45684 14.9016 6.4709 14.7259 6.4709 14.5572C6.4709 12.3152 6.48495 10.0662 6.46387 7.8242C6.45684 7.14949 6.78717 6.72077 7.34239 6.43964C7.5181 6.34828 7.743 6.33422 7.94682 6.33422C10.1748 6.32719 12.4027 6.32719 14.6377 6.32719C14.8134 6.32719 14.9961 6.32719 15.214 6.32719C15.6568 4.35929 16.704 2.82012 18.3767 1.72372C19.7823 0.80302 21.3356 0.423497 22.9872 0.592174C25.4681 0.845189 28.413 2.49682 29.3477 6.30611C29.5094 6.31314 29.6851 6.32719 29.8608 6.32719C32.1028 6.32719 34.3518 6.33422 36.5938 6.32016C37.2685 6.31314 37.6902 6.65049 37.9784 7.20572C38.0486 7.34628 38.0768 7.52199 38.0838 7.67661C38.0908 10.5793 38.0908 13.4819 38.0838 16.3846C38.0838 17.2279 37.4723 17.7972 36.6289 17.8183C34.5275 17.8745 32.8267 19.3294 32.4261 21.3605C31.9903 23.5744 33.5436 25.964 35.905 26.3435C36.1862 26.3857 36.4673 26.449 36.7484 26.4279C37.3388 26.3787 38.1119 27.1939 38.1049 27.7984C38.0768 30.687 38.0978 33.5756 38.0908 36.4641C38.0908 37.3356 37.4864 37.933 36.6219 37.933C27.0635 37.933 17.4982 37.933 7.93979 37.933C7.08235 37.933 6.48495 37.3216 6.48495 36.4571C6.48495 34.2151 6.48495 31.9661 6.48495 29.7241C6.47792 29.5554 6.47793 29.3797 6.47793 29.2181Z"
                                    fill="#FEDC5A" />
                            </svg>
                        </div>
                        <div class="mt-3">
                            <p class="fw-bold card-title">Stay Relevant</p>
                            <p class="card-subtitle pt-1">Wheels uses industry established concepts, such as ...
                            </p>
                        </div>
                    </div>
                </div>
                <div class="col-lg-4">
                    <div class="p-4 bg-white rounded-5 shadow-sm">
                        <div class="icon-container d-flex justify-content-center align-items-center">
                            <svg width="41" height="36" viewBox="0 0 41 36" fill="none"
                                xmlns="http://www.w3.org/2000/svg">
                                <path fill-rule="evenodd" clip-rule="evenodd"
                                    d="M35.8418 0.685791H4.79111C2.40933 0.685791 0.478516 2.54527 0.478516 4.83906V23.1134C0.478516 24.215 0.932877 25.2714 1.74165 26.0502C2.55041 26.8291 3.64734 27.2667 4.79111 27.2667H13.0023L19.6437 35.2617C19.8074 35.4589 20.0552 35.5736 20.3173 35.5736C20.5794 35.5736 20.8273 35.4589 20.9909 35.2617L27.6306 27.2667H35.8418C38.2236 27.2667 40.1544 25.4072 40.1544 23.1134V4.83906C40.1544 2.54527 38.2236 0.685791 35.8418 0.685791ZM22.1349 18.1298H10.5628C10.1063 18.1298 9.73619 17.8509 9.73619 17.5068C9.73619 17.1628 10.1063 16.8839 10.5628 16.8839H22.1349C22.5914 16.8839 22.9615 17.1628 22.9615 17.5068C22.9615 17.8509 22.5914 18.1298 22.1349 18.1298ZM10.6009 10.6538H31.3545C31.832 10.6538 32.2192 10.3748 32.2192 10.0308C32.2192 9.6867 31.832 9.40777 31.3545 9.40777H10.6009C10.1233 9.40777 9.73619 9.6867 9.73619 10.0308C9.73619 10.3748 10.1233 10.6538 10.6009 10.6538Z"
                                    fill="#F04037" />
                            </svg>

                        </div>
                        <div class="mt-3">
                            <p class="fw-bold card-title">A Helpful Community</p>
                            <p class="card-subtitle pt-1">Get in touch via our GitHub Discussions - we're newbie ...
                            </p>
                        </div>
                    </div>
                </div>
                <div class="col-lg-4">
                    <div class="p-4 bg-white rounded-5 shadow-sm">
                        <div class="icon-container d-flex justify-content-center align-items-center">
                            <svg width="38" height="38" viewBox="0 0 38 38" fill="none"
                                xmlns="http://www.w3.org/2000/svg">
                                <path
                                    d="M38.0052 6.09267C38.0052 14.8518 38.0052 23.611 38.0052 32.3701C37.9856 32.4092 37.9563 32.4581 37.9367 32.4972C37.7314 33.1718 37.3208 33.6801 36.6756 33.9831C36.0598 34.2764 35.4439 34.5697 34.828 34.8727C33.2834 35.6255 31.7291 36.3685 30.1845 37.1212C29.7543 37.3265 29.3242 37.5318 28.8941 37.7273C27.9263 38.177 26.802 37.8348 26.2644 37.2287C25.8049 36.7106 25.3357 36.2023 24.8664 35.6841C24.2897 35.0585 23.7129 34.4231 23.1361 33.7974C22.8428 33.4748 22.5398 33.1522 22.2465 32.8296C21.6306 32.1453 21.0147 31.4512 20.3891 30.7669C20.1154 30.4638 19.8319 30.1608 19.5484 29.848C18.7565 28.9584 17.9647 28.0688 17.1631 27.1792C16.5863 26.534 15.99 25.9083 15.4132 25.2631C15.0906 24.9014 14.7778 24.5299 14.4454 24.1682C14.2401 23.9434 14.025 23.7381 13.8099 23.5132C13.2918 23.9434 12.7933 24.3442 12.2947 24.7548C11.5908 25.3315 10.8772 25.9083 10.1733 26.4851C9.38149 27.1303 8.58965 27.7853 7.80758 28.4305C7.28946 28.8606 6.79089 29.3005 6.27277 29.7209C6.0577 29.8968 5.84263 30.0826 5.59824 30.2097C5.11922 30.4541 4.63043 30.3856 4.15141 30.1803C3.29114 29.8089 2.43086 29.4276 1.56081 29.0855C0.974264 28.8606 0.505023 28.2056 0.514798 27.5604C0.544126 25.8399 0.524575 24.1193 0.524575 22.3988C0.524575 18.5666 0.53435 14.7345 0.514798 10.9024C0.514798 10.2963 0.984041 9.62175 1.52171 9.42623C1.73678 9.34802 1.95185 9.25027 2.16692 9.16228C2.89033 8.86901 3.60397 8.54641 4.33715 8.28246C4.93348 8.06739 5.51026 8.12604 6.00882 8.56596C6.39008 8.88856 6.78111 9.20138 7.16237 9.51421C8.19861 10.3647 9.22508 11.225 10.2613 12.0755C11.1998 12.8478 12.1383 13.6201 13.0865 14.3924C13.3309 14.5879 13.5753 14.7736 13.8197 14.9691C14.0641 14.7345 14.289 14.5292 14.4943 14.3044C15.2959 13.4148 16.0877 12.5252 16.8796 11.6356C17.4563 10.9904 18.0527 10.3647 18.6294 9.71951C18.8836 9.44578 19.1378 9.16228 19.392 8.87878C20.1642 8.01851 20.9268 7.14846 21.6991 6.28818C22.3052 5.62343 22.921 4.95867 23.5271 4.29391C23.7618 4.02996 23.9964 3.76602 24.2408 3.51185C24.9251 2.74933 25.5898 1.97704 26.3035 1.24385C26.9682 0.569319 27.7894 0.393353 28.6888 0.696404C29.0016 0.803938 29.2949 0.9408 29.5979 1.08744C30.8199 1.67399 32.0419 2.25076 33.2541 2.84709C34.3979 3.40431 35.5319 3.96154 36.6756 4.51876C37.1742 4.76315 37.5457 5.12486 37.7803 5.6332C37.8585 5.80917 37.9367 5.94603 38.0052 6.09267ZM19.0107 19.2705C22.2269 21.91 25.4041 24.5104 28.6301 27.1596C28.6301 21.9589 28.6301 16.8168 28.6301 11.6747C28.6301 11.6062 28.6008 11.5378 28.5812 11.4107C25.3748 14.0404 22.2172 16.6408 19.0107 19.2705ZM5.26586 14.0111C5.18765 14.6563 5.21698 24.2073 5.28541 24.4615C5.64712 24.1584 9.80185 19.5051 9.95826 19.2118C8.41368 17.5011 6.85932 15.7805 5.26586 14.0111Z"
                                    fill="#5454D4" />
                            </svg>
                        </div>
                        <div class="mt-3">
                            <p class="fw-bold card-title">Good Organization</p>
                            <p class="card-subtitle pt-1">Stop thinking about how to organize your code and deal ...
                            </p>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Latest blogs -->
        <div class="pt-5 blog-main">
            <h1 class="text-center fw-bold fs-60px">Latest Blog Posts</h1>
            <div class="swiper py-5 blogSwiper">
                <div class="swiper-wrapper">
                    <div class="p-4 bg-white rounded-5 shadow-sm swiper-slide">
                        <div>
                            <p class="fs-18px fw-bold">Celebrating 20 Years of Wheels: A Look Back and a Step Forward
                                as Wheels.dev</p>
                            <p class="blog-description">As we ring in the new year, we’re thrilled to celebrate a
                                monumental milestone: 20 years
                                of Wheels!</p>
                        </div>
                        <div class="d-flex justify-content-between align-items-center">
                            <p class="blog-date">January 3rd, 2025 by Peter Amiri</p>
                            <button class="bg--iris fs-18px text-white rounded-2 px-3 py-1">Learn more</button>
                        </div>
                    </div>
                    <div class="p-4 bg-white rounded-5 shadow-sm swiper-slide">
                        <div>
                            <p class="fs-18px fw-bold">Celebrating 20 Years of Wheels: A Look Back and a Step Forward
                                as Wheels.dev</p>
                            <p class="blog-description">As we ring in the new year, we’re thrilled to celebrate a
                                monumental milestone: 20 years
                                of Wheels!</p>
                        </div>
                        <div class="d-flex justify-content-between align-items-center">
                            <p class="blog-date">January 3rd, 2025 by Peter Amiri</p>
                            <button class="bg--iris fs-18px text-white rounded-2 px-3 py-1">Learn more</button>
                        </div>
                    </div>
                    <div class="p-4 bg-white rounded-5 shadow-sm swiper-slide">
                        <div>
                            <p class="fs-18px fw-bold">Celebrating 20 Years of Wheels: A Look Back and a Step Forward
                                as Wheels.dev</p>
                            <p class="blog-description">As we ring in the new year, we’re thrilled to celebrate a
                                monumental milestone: 20 years
                                of Wheels!</p>
                        </div>
                        <div class="d-flex justify-content-between align-items-center">
                            <p class="blog-date">January 3rd, 2025 by Peter Amiri</p>
                            <button class="bg--iris fs-18px text-white rounded-2 px-3 py-1">Learn more</button>
                        </div>
                    </div>
                    <div class="p-4 bg-white rounded-5 shadow-sm swiper-slide">
                        <div>
                            <p class="fs-18px fw-bold">Celebrating 20 Years of Wheels: A Look Back and a Step Forward
                                as Wheels.dev</p>
                            <p class="blog-description">As we ring in the new year, we’re thrilled to celebrate a
                                monumental milestone: 20 years
                                of Wheels!</p>
                        </div>
                        <div class="d-flex justify-content-between align-items-center">
                            <p class="blog-date">January 3rd, 2025 by Peter Amiri</p>
                            <button class="bg--iris fs-18px text-white rounded-2 px-3 py-1">Learn more</button>
                        </div>
                    </div>
                    <div class="p-4 bg-white rounded-5 shadow-sm swiper-slide">
                        <div>
                            <p class="fs-18px fw-bold">Celebrating 20 Years of Wheels: A Look Back and a Step Forward
                                as Wheels.dev</p>
                            <p class="blog-description">As we ring in the new year, we’re thrilled to celebrate a
                                monumental milestone: 20 years
                                of Wheels!</p>
                        </div>
                        <div class="d-flex justify-content-between align-items-center">
                            <p class="blog-date">January 3rd, 2025 by Peter Amiri</p>
                            <button class="bg--iris fs-18px text-white rounded-2 px-3 py-1">Learn more</button>
                        </div>
                    </div>
                    <div class="p-4 bg-white rounded-5 shadow-sm swiper-slide">
                        <div>
                            <p class="fs-18px fw-bold">Celebrating 20 Years of Wheels: A Look Back and a Step Forward
                                as Wheels.dev</p>
                            <p class="blog-description">As we ring in the new year, we’re thrilled to celebrate a
                                monumental milestone: 20 years
                                of Wheels!</p>
                        </div>
                        <div class="d-flex justify-content-between align-items-center">
                            <p class="blog-date">January 3rd, 2025 by Peter Amiri</p>
                            <button class="bg--iris fs-18px text-white rounded-2 px-3 py-1">Learn more</button>
                        </div>
                    </div>
                    <div class="p-4 bg-white rounded-5 shadow-sm swiper-slide">
                        <div>
                            <p class="fs-18px fw-bold">Celebrating 20 Years of Wheels: A Look Back and a Step Forward
                                as Wheels.dev</p>
                            <p class="blog-description">As we ring in the new year, we’re thrilled to celebrate a
                                monumental milestone: 20 years
                                of Wheels!</p>
                        </div>
                        <div class="d-flex justify-content-between align-items-center">
                            <p class="blog-date">January 3rd, 2025 by Peter Amiri</p>
                            <button class="bg--iris fs-18px text-white rounded-2 px-3 py-1">Learn more</button>
                        </div>
                    </div>
                    <div class="p-4 bg-white rounded-5 shadow-sm swiper-slide">
                        <div>
                            <p class="fs-18px fw-bold">Celebrating 20 Years of Wheels: A Look Back and a Step Forward
                                as Wheels.dev</p>
                            <p class="blog-description">As we ring in the new year, we’re thrilled to celebrate a
                                monumental milestone: 20 years
                                of Wheels!</p>
                        </div>
                        <div class="d-flex justify-content-between align-items-center">
                            <p class="blog-date">January 3rd, 2025 by Peter Amiri</p>
                            <button class="bg--iris fs-18px text-white rounded-2 px-3 py-1">Learn more</button>
                        </div>
                    </div>
                    <div class="p-4 bg-white rounded-5 shadow-sm swiper-slide">
                        <div>
                            <p class="fs-18px fw-bold">Celebrating 20 Years of Wheels: A Look Back and a Step Forward
                                as Wheels.dev</p>
                            <p class="blog-description">As we ring in the new year, we’re thrilled to celebrate a
                                monumental milestone: 20 years
                                of Wheels!</p>
                        </div>
                        <div class="d-flex justify-content-between align-items-center">
                            <p class="blog-date">January 3rd, 2025 by Peter Amiri</p>
                            <button class="bg--iris fs-18px text-white rounded-2 px-3 py-1">Learn more</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- our guide  -->
        <div class="gudie-main py-5">
            <h1 class="text-center text-white fs-60px fw-bold">Our Guide</h1>
            <div class="container mt-5">
                <div class="row">
                    <div class="col-4 border-end">
                        <!-- Vertical Tabs Navigation -->
                        <div class="nav flex-column nav-pills-primary" id="v-pills-tab" role="tablist"
                            aria-orientation="vertical">
                            <button class="nav-link text-white fw-bold rounded-2 active" id="v-pills-intro-tab"
                                data-bs-toggle="pill" data-bs-target="#v-pills-introduction" type="button" role="tab"
                                aria-controls="v-pills-introduction" aria-selected="true">Home</button>
                            <button class="nav-link mt-3 text-white fw-bold rounded-2" id="v-pills-command-tab"
                                data-bs-toggle="pill" data-bs-target="#v-pills-command" type="button" role="tab"
                                aria-controls="v-pills-command" aria-selected="false">Command Line tools</button>
                            <button class="nav-link mt-3 text-white fw-bold rounded-2"
                                id="v-pills-working-with-wheels-tab" data-bs-toggle="pill"
                                data-bs-target="#v-working-with-wheels" type="button" role="tab"
                                aria-controls="v-working-with-wheels" aria-selected="false">Working with Wheels</button>
                            <button class="nav-link mt-3 text-white fw-bold rounded-2"
                                id="v-pills-handling-request-controllers-tab" data-bs-toggle="pill"
                                data-bs-target="#v-request-controller" type="button" role="tab"
                                aria-controls="v-request-controller" aria-selected="false">Handling Requests with
                                Controllers</button>
                            <button class="nav-link mt-3 text-white fw-bold rounded-2" id="v-pills-multiple-format-tab"
                                data-bs-toggle="pill" data-bs-target="#v-multiple-format" type="button" role="tab"
                                aria-controls="v-multiple-format" aria-selected="false">Responding with Multiple
                                Formats</button>
                            <button class="nav-link mt-3 text-white fw-bold rounded-2" id="v-pills-displaying-tab"
                                data-bs-toggle="pill" data-bs-target="#v-displaying" type="button" role="tab"
                                aria-controls="v-displaying" aria-selected="false">Displaying Views to Users</button>
                            <button class="nav-link mt-3 text-white fw-bold rounded-2" id="v-pills-interaction-tab"
                                data-bs-toggle="pill" data-bs-target="#v-interaction" type="button" role="tab"
                                aria-controls="v-interaction" aria-selected="false">Database Interaction Through
                                Models</button>
                            <button class="nav-link mt-3 text-white fw-bold rounded-2" id="v-pills-plugins-tab"
                                data-bs-toggle="pill" data-bs-target="#v-plugins" type="button" role="tab"
                                aria-controls="v-plugins" aria-selected="false">Plugins</button>
                            <button class="nav-link mt-3 text-white fw-bold rounded-2" id="v-pills-external-tab"
                                data-bs-toggle="pill" data-bs-target="#v-external" type="button" role="tab"
                                aria-controls="v-external" aria-selected="false">External Links</button>
                        </div>
                    </div>
                    <div class="col-8">
                        <!-- Vertical Tabs Content -->
                        <div class="tab-content" id="v-pills-tabContent">
                            <div class="tab-pane fade show active" id="v-pills-introduction" role="tabpanel"
                                aria-labelledby="v-pills-intro-tab">
                                <h3 class="fs-24px text--primary fw-semibold">Getting Started</h3>
                                <p class="text-white fs-24px">Install Wheels and get a local development server running
                                </p>
                                <p class="fs-18px text-white">
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
                                    <button class="bg--primary fs-16px fw-semibold px-3 py-1 rounded text-white">Learn
                                        more</button>
                                </div>
                            </div>
                            <div class="tab-pane fade" id="v-pills-command" role="tabpanel"
                                aria-labelledby="v-pills-command-tab">
                                <h3 class="fs-24px text--primary fw-semibold">Command Line tools</h3>
                                <p class="text-white fs-24px">Command Line tools
                                </p>
                                <p class="fs-18px text-white">
                                    Lorem ipsum dolor sit amet consectetur adipisicing elit. Tempore repellendus
                                    veritatis quod ipsam voluptates sapiente! Quidem, nihil? Nam id natus dolore!
                                    Accusamus vel ea error quisquam dolorum deserunt veniam assumenda.
                                </p>
                                <div class="d-flex justify-content-end">
                                    <button class="bg--primary fs-16px fw-semibold px-3 py-1 rounded text-white">Learn
                                        more</button>
                                </div>
                            </div>
                            <div class="tab-pane fade" id="v-working-with-wheels" role="tabpanel"
                                aria-labelledby="v-pills-working-with-wheels-tab">
                                <h3 class="fs-24px text--primary fw-semibold">Working with Wheels</h3>
                                <p class="text-white fs-24px">Working with Wheels
                                </p>
                                <p class="fs-18px text-white">
                                    Lorem ipsum dolor sit amet consectetur adipisicing elit. Tempore repellendus
                                    veritatis quod ipsam voluptates sapiente! Quidem, nihil? Nam id natus dolore!
                                    Accusamus vel ea error quisquam dolorum deserunt veniam assumenda.
                                </p>
                                <div class="d-flex justify-content-end">
                                    <button class="bg--primary fs-16px fw-semibold px-3 py-1 rounded text-white">Learn
                                        more</button>
                                </div>
                            </div>
                            <div class="tab-pane fade" id="v-request-controller" role="tabpanel"
                                aria-labelledby="v-pills-handling-request-controllers-tab">
                                <h3 class="fs-24px text--primary fw-semibold">Handling Requests with Controllers</h3>
                                <p class="text-white fs-24px">Handling Requests with Controllers
                                </p>
                                <p class="fs-18px text-white">
                                    Lorem ipsum dolor sit amet consectetur adipisicing elit. Tempore repellendus
                                    veritatis quod ipsam voluptates sapiente! Quidem, nihil? Nam id natus dolore!
                                    Accusamus vel ea error quisquam dolorum deserunt veniam assumenda.
                                </p>
                                <div class="d-flex justify-content-end">
                                    <button class="bg--primary fs-16px fw-semibold px-3 py-1 rounded text-white">Learn
                                        more</button>
                                </div>
                            </div>
                            <div class="tab-pane fade" id="v-multiple-format" role="tabpanel"
                                aria-labelledby="v-pills-multiple-format-tab">
                                <h3 class="fs-24px text--primary fw-semibold">Responding with Multiple Formats</h3>
                                <p class="text-white fs-24px">Responding with Multiple Formats
                                </p>
                                <p class="fs-18px text-white">
                                    Lorem ipsum dolor sit amet consectetur adipisicing elit. Tempore repellendus
                                    veritatis quod ipsam voluptates sapiente! Quidem, nihil? Nam id natus dolore!
                                    Accusamus vel ea error quisquam dolorum deserunt veniam assumenda.
                                </p>
                                <div class="d-flex justify-content-end">
                                    <button class="bg--primary fs-16px fw-semibold px-3 py-1 rounded text-white">Learn
                                        more</button>
                                </div>
                            </div>
                            <div class="tab-pane fade" id="v-displaying" role="tabpanel"
                                aria-labelledby="v-pills-displaying-tab">
                                <h3 class="fs-24px text--primary fw-semibold">Displaying Views to Users</h3>
                                <p class="text-white fs-24px">Displaying Views to Users
                                </p>
                                <p class="fs-18px text-white">
                                    Lorem ipsum dolor sit amet consectetur adipisicing elit. Tempore repellendus
                                    veritatis quod ipsam voluptates sapiente! Quidem, nihil? Nam id natus dolore!
                                    Accusamus vel ea error quisquam dolorum deserunt veniam assumenda.
                                </p>
                                <div class="d-flex justify-content-end">
                                    <button class="bg--primary fs-16px fw-semibold px-3 py-1 rounded text-white">Learn
                                        more</button>
                                </div>
                            </div>
                            <div class="tab-pane fade" id="v-interaction" role="tabpanel"
                                aria-labelledby="v-pills-interaction-tab">
                                <h3 class="fs-24px text--primary fw-semibold">Database Interaction Through Models</h3>
                                <p class="text-white fs-24px">Database Interaction Through Models
                                </p>
                                <p class="fs-18px text-white">
                                    Lorem ipsum dolor sit amet consectetur adipisicing elit. Tempore repellendus
                                    veritatis quod ipsam voluptates sapiente! Quidem, nihil? Nam id natus dolore!
                                    Accusamus vel ea error quisquam dolorum deserunt veniam assumenda.
                                </p>
                                <div class="d-flex justify-content-end">
                                    <button class="bg--primary fs-16px fw-semibold px-3 py-1 rounded text-white">Learn
                                        more</button>
                                </div>
                            </div>
                            <div class="tab-pane fade" id="v-plugins" role="tabpanel"
                                aria-labelledby="v-pills-plugins-tab">
                                <h3 class="fs-24px text--primary fw-semibold">Plugins</h3>
                                <p class="text-white fs-24px">Plugins
                                </p>
                                <p class="fs-18px text-white">
                                    Lorem ipsum dolor sit amet consectetur adipisicing elit. Tempore repellendus
                                    veritatis quod ipsam voluptates sapiente! Quidem, nihil? Nam id natus dolore!
                                    Accusamus vel ea error quisquam dolorum deserunt veniam assumenda.
                                </p>
                                <div class="d-flex justify-content-end">
                                    <button class="bg--primary fs-16px fw-semibold px-3 py-1 rounded text-white">Learn
                                        more</button>
                                </div>
                            </div>
                            <div class="tab-pane fade" id="v-external" role="tabpanel"
                                aria-labelledby="v-pills-external-tab">
                                <h3 class="fs-24px text--primary fw-semibold">External Links</h3>
                                <p class="text-white fs-24px">External Links
                                </p>
                                <p class="fs-18px text-white">
                                    Lorem ipsum dolor sit amet consectetur adipisicing elit. Tempore repellendus
                                    veritatis quod ipsam voluptates sapiente! Quidem, nihil? Nam id natus dolore!
                                    Accusamus vel ea error quisquam dolorum deserunt veniam assumenda.
                                </p>
                                <div class="d-flex justify-content-end">
                                    <button class="bg--primary fs-16px fw-semibold px-3 py-1 rounded text-white">Learn
                                        more</button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- welcome community -->
        <div class="container py-5 mt-5">
            <div class="row align-items-center gy-5">
                <div class="col-lg-6 text-center col-12">
                    <p class="fs-60px line-height-70 fw-bold">Welcome to our community</p>
                    <button class="bg--primary fs-16px px-3 py-2 rounded text-white">Explore community</button>
                </div>
                <div class="col-lg-6 text-center col-12">
                    <img src="images/community.png" class="img-fluid" alt="Community" width="428" height="428">
                </div>
            </div>
        </div>

        <!-- Top contribute -->
        <div class="container py-5 mt-5">
            <div class="text-center">
                <p class="fs-60px line-height-70 fw-bold">Top Contribute</p>
                <p class="fs-22px">7 individuals are supporting WHEELS.FW <br> Contribute on Open Collective</p>
            </div>
            <div class="d-flex justify-content-center mt-5 gap-3">
                <img src="images/person1.png" alt="" height="271" width="146">
                <img src="images/person2.png" class="mt-5" alt="" height="271" width="146">
                <img src="images/person3.png" alt="" height="271" width="146">
                <img src="images/person4.png" class="mt-5" alt="" height="271" width="146">
                <img src="images/person5.png" alt="" height="271" width="146">
                <img src="images/person6.png" class="mt-5" alt="" height="271" width="146">
                <img src="images/person7.png" alt="" height="271" width="146">
            </div>
        </div>
    </main>

    <footer class="bg-white pt-5 pb-3 border-top">
        <div class="container">
            <div class="row gx-5">
                <div class="col-md-4">
                    <img src="images/wheels-logo.png" width="284" alt="">
                    <div class="mt-3">
                        <p class="fs-18px fw-semibold p-0 m-0">Let's Keep in touch</p>
                        <p class="fs-12px fw-semibold">Enter your email to stay up to date with the latest updates from
                            Wheels.dev</p>
                    </div>
                    <div>
                        <input type="email" class="form-control mb-2" placeholder="your@email.com">
                        <button class="text-white py-2 fs-12px rounded-2 bg--primary w-100">Subscribe to
                            newsletter</button>
                    </div>
                </div>
                <div class="col-md-2">
                    <h6 class="fw-bold fs-14px">Guides</h6>
                    <ul class="list-unstyled">
                        <li class="mt-3"><a href="#" class="text-dark fs-16px text-decoration-none">Introduction</a>
                        </li>
                        <li class="mt-3"><a href="#" class="text-dark fs-16px text-decoration-none">Command Line
                                Tools</a></li>
                        <li class="mt-3"><a href="#" class="text-dark fs-16px text-decoration-none">Working with
                                Wheels</a></li>
                        <li class="mt-3"><a href="#" class="text-dark fs-16px text-decoration-none">Handling
                                Requests</a></li>
                        <li class="mt-3"><a href="#" class="text-dark fs-16px text-decoration-none">Multiple Formats</a>
                        </li>
                        <li class="mt-3"><a href="#" class="text-dark fs-16px text-decoration-none">Displaying Views</a>
                        </li>
                        <li class="mt-3"><a href="#" class="text-dark fs-16px text-decoration-none">Database
                                Interaction</a></li>
                    </ul>
                </div>
                <div class="col-md-2">
                    <h6 class="fw-bold fs-14px">Meta</h6>
                    <ul class="list-unstyled">
                        <li class="mt-3"><a href="#" class="text-dark fs-16px text-decoration-none">Log in</a></li>
                        <li class="mt-3"><a href="#" class="text-dark fs-16px text-decoration-none">Entries feed</a>
                        </li>
                        <li class="mt-3"><a href="#" class="text-dark fs-16px text-decoration-none">Comments feed</a>
                        </li>
                        <li class="mt-3"><a href="#" class="text-dark fs-16px text-decoration-none">WordPress.org</a>
                        </li>
                    </ul>
                </div>
                <div class="col-md-2">
                    <h6 class="fw-bold fs-14px">Plugins</h6>
                    <ul class="list-unstyled">
                        <li class="mt-3"><a href="#" class="text-dark fs-16px text-decoration-none">Installing and Using
                                PI</a></li>
                        <li class="mt-3"><a href="#" class="text-dark fs-16px text-decoration-none">Developing
                                Plugins</a></li>
                        <li class="mt-3"><a href="#" class="text-dark fs-16px text-decoration-none">Publishing
                                Plugins</a></li>
                    </ul>
                </div>
                <div class="col-md-2">
                    <h6 class="fw-bold fs-14px">External Links</h6>
                    <ul class="list-unstyled">
                        <li class="mt-3"><a href="#" class="text-dark fs-16px text-decoration-none">Source Code</a></li>
                        <li class="mt-3"><a href="#" class="text-dark fs-16px text-decoration-none">Issue Tracker</a>
                        </li>
                        <li class="mt-3"><a href="#" class="text-dark fs-16px text-decoration-none">Sponsor Us</a></li>
                        <li class="mt-3"><a href="#" class="text-dark fs-16px text-decoration-none">Community</a></li>
                    </ul>
                </div>
            </div>
            <hr>
            <div class="text-muted d-flex justify-content-between align-items-center">
                <div>
                    <p class="p-0 m-0 fs-12px">&copy; 2025 Wheels. All rights reserved.</p>
                    <p class="fs-12px">Wheels is licensed under the Apache License, Version 2.0.</p>
                    <p class="fs-12px">ColdFusion hosting provided by Vivio Technologies.</p>
                </div>
                <div class="d-flex justify-content-center gap-3">
                    <a href="#" class="text-dark">
                        <svg width="25" height="24" viewBox="0 0 25 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                            <path
                                d="M12.2852 0.248535C10.6719 0.248535 9.07436 0.56256 7.58385 1.17268C6.09334 1.7828 4.73904 2.67707 3.59825 3.80442C1.29433 6.08121 0 9.16921 0 12.3891C0 17.7552 3.52585 22.3079 8.40307 23.9226C9.01733 24.0197 9.21389 23.6434 9.21389 23.3156V21.2638C5.8109 21.9923 5.08607 19.637 5.08607 19.637C4.52095 18.2287 3.72241 17.8523 3.72241 17.8523C2.60446 17.0996 3.80841 17.1239 3.80841 17.1239C5.03693 17.2089 5.68804 18.3744 5.68804 18.3744C6.75686 20.2197 8.56278 19.6734 9.26303 19.382C9.3736 18.5929 9.69302 18.0587 10.037 17.7552C7.30969 17.4517 4.44724 16.4076 4.44724 11.7821C4.44724 10.4345 4.91408 9.35395 5.71261 8.49197C5.58976 8.18845 5.15978 6.92584 5.83547 5.28686C5.83547 5.28686 6.86742 4.95907 9.21389 6.5252C10.1844 6.25811 11.241 6.12456 12.2852 6.12456C13.3294 6.12456 14.386 6.25811 15.3565 6.5252C17.703 4.95907 18.7349 5.28686 18.7349 5.28686C19.4106 6.92584 18.9806 8.18845 18.8578 8.49197C19.6563 9.35395 20.1231 10.4345 20.1231 11.7821C20.1231 16.4197 17.2484 17.4396 14.5088 17.7431C14.9511 18.1194 15.3565 18.86 15.3565 19.9891V23.3156C15.3565 23.6434 15.5531 24.0319 16.1796 23.9226C21.0568 22.2958 24.5704 17.7552 24.5704 12.3891C24.5704 10.7948 24.2526 9.21605 23.6352 7.7431C23.0178 6.27014 22.1129 4.93177 20.9721 3.80442C19.8313 2.67707 18.477 1.7828 16.9865 1.17268C15.496 0.56256 13.8985 0.248535 12.2852 0.248535Z"
                                fill="#0C1620" />
                        </svg>
                    </a>
                    <a href="#" class="text-dark">
                        <svg width="22" height="22" viewBox="0 0 22 22" fill="none" xmlns="http://www.w3.org/2000/svg">
                            <path
                                d="M10.5201 0.248536C8.69846 0.247922 6.90798 0.721253 5.32461 1.62202C3.74124 2.52279 2.41945 3.81999 1.48913 5.38619C0.558809 6.95238 0.0519596 8.73366 0.0183855 10.555C-0.0151887 12.3764 0.425667 14.1751 1.29764 15.7745L0.0551367 20.132C0.011417 20.285 0.0102522 20.4471 0.051768 20.6007C0.0932837 20.7543 0.175908 20.8937 0.290748 21.0039C0.405588 21.114 0.548296 21.1908 0.703512 21.2259C0.858728 21.261 1.02058 21.2531 1.17164 21.203L5.26313 19.8398C6.65763 20.6456 8.21882 21.1199 9.82592 21.2258C11.433 21.3317 13.043 21.0666 14.5312 20.4508C16.0194 19.835 17.346 18.8851 18.4084 17.6745C19.4708 16.464 20.2404 15.0253 20.6578 13.4698C21.0753 11.9142 21.1292 10.2835 20.8156 8.70372C20.5019 7.12397 19.8291 5.63754 18.849 4.35943C17.869 3.08132 16.6081 2.04579 15.1638 1.33295C13.7196 0.620115 12.1307 0.249074 10.5201 0.248536ZM7.02013 8.99854C7.02013 8.76647 7.11232 8.54391 7.27641 8.37982C7.4405 8.21572 7.66306 8.12354 7.89513 8.12354H13.1451C13.3772 8.12354 13.5997 8.21572 13.7638 8.37982C13.9279 8.54391 14.0201 8.76647 14.0201 8.99854C14.0201 9.2306 13.9279 9.45316 13.7638 9.61725C13.5997 9.78135 13.3772 9.87354 13.1451 9.87354H7.89513C7.66306 9.87354 7.4405 9.78135 7.27641 9.61725C7.11232 9.45316 7.02013 9.2306 7.02013 8.99854ZM7.89513 11.6235H11.3951C11.6272 11.6235 11.8497 11.7157 12.0138 11.8798C12.1779 12.0439 12.2701 12.2665 12.2701 12.4985C12.2701 12.7306 12.1779 12.9532 12.0138 13.1173C11.8497 13.2814 11.6272 13.3735 11.3951 13.3735H7.89513C7.66306 13.3735 7.4405 13.2814 7.27641 13.1173C7.11232 12.9532 7.02013 12.7306 7.02013 12.4985C7.02013 12.2665 7.11232 12.0439 7.27641 11.8798C7.4405 11.7157 7.66306 11.6235 7.89513 11.6235Z"
                                fill="#0C1620" />
                        </svg>

                    </a>
                    <a href="#" class="text-dark">
                        <svg width="25" height="24" viewBox="0 0 25 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                            <mask id="mask0_129_385" style="mask-type:luminance" maskUnits="userSpaceOnUse" x="0" y="0"
                                width="25" height="24">
                                <path d="M0.845703 0.248535H24.5386V23.9414H0.845703V0.248535Z" fill="white" />
                            </mask>
                            <g mask="url(#mask0_129_385)">
                                <path
                                    d="M19.5038 1.35693H23.1373L15.2002 10.4516L24.5386 22.8295H17.2276L11.4973 15.3239L4.94795 22.8295H1.3111L9.79992 13.0985L0.845703 1.35863H8.3428L13.5146 8.21772L19.5038 1.35693ZM18.2261 20.6497H20.24L7.24278 3.42329H5.08334L18.2261 20.6497Z"
                                    fill="#0C1620" />
                            </g>
                        </svg>
                    </a>
                    <a href="#" class="text-dark">
                        <svg width="13" height="24" viewBox="0 0 13 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                            <path
                                d="M8.71454 13.8719H11.6396L12.8096 9.13336H8.71454V6.76407C8.71454 5.54389 8.71454 4.39479 11.0546 4.39479H12.8096V0.414385C12.4282 0.363446 10.9879 0.248535 9.46686 0.248535C6.29026 0.248535 4.03447 2.21149 4.03447 5.81636V9.13336H0.524414V13.8719H4.03447V23.9414H8.71454V13.8719Z"
                                fill="#0C1620" />
                        </svg>
                    </a>
                </div>
            </div>
        </div>
    </footer>

    <!-- Bootstrap JS -->
    <script src="javascripts/bootstrap.js"></script>
    <script src="javascripts/swiper.js"></script>
    <script src="javascripts/custom.js"></script>
</body>

</html>