var swiper = new Swiper(".blogSwiper", {
    spaceBetween: 30,
    freeMode: true,
    initialSlide: 2,
    // autoHeight: true,
    slidesOffsetBefore: 250,
    breakpoints: {
        640: {
            slidesPerView: 1,
            spaceBetween: 10,
        },
        768: {
            slidesPerView: 2,
            spaceBetween: 20,
        },
        1024: {
            slidesPerView: 3,
            spaceBetween: 30,
        },
    },
});

var contributorsSwiperThumb = new Swiper(".contributorsSwiperThumb", {
    spaceBetween: 0,
    slidesPerView: 8,
    freeMode: true,
    watchSlidesProgress: true,
        navigation: {
        nextEl: ".swiper-button-next",
        prevEl: ".swiper-button-prev",
    },
});

var contributorsSwiper = new Swiper(".contributorsSwiper", {
    spaceBetween: 30,
    thumbs: {
        swiper: contributorsSwiperThumb,
    },
});

var contributorsSwiper = new Swiper(".testimonialsSwiper", {
    spaceBetween: 30,
    
    pagination: {
        el: ".swiper-pagination",
        clickable: true,
    },
});

const handleBlogFilter = (type, button) => {
    const blogsContainer = document.getElementById('blogsContainer');
    const filtersContainer = document.getElementById('filtersContainer');
    const archives = document.getElementById('Archives');
    const categories = document.getElementById('Categories');

    blogsContainer.classList.remove('col-lg-12', 'col-lg-10');
    blogsContainer.classList.add(type === 'All' ? 'col-lg-12' : 'col-lg-10');
    filtersContainer.classList.remove('d-none');

    const buttons = document.querySelectorAll('.filter-button');
    buttons.forEach(btn => {
        btn.classList.remove('active');
    });
    button.classList.add('active');

    Array.from(filtersContainer.children).forEach(child => child.classList.add('d-none'));

    if (type === 'All') {
        filtersContainer.classList.add('d-none');
    } else if (type === 'Archives') {
        archives.classList.remove('d-none');
        categories.classList.add('d-none');
    } else {
        archives.classList.add('d-none');
        document.getElementById(type).classList.remove('d-none');
    }
}

const handleApiSection = (type, button) => {

    const sectionContainer = document.getElementById('sectionContainer');
    const functionsContainer = document.getElementById('functionsContainer');

    const buttons = document.querySelectorAll('.filter-button');
    buttons.forEach(btn => {
        btn.classList.remove('active');
    });
    button.classList.add('active');

    if(type === "All"){
        sectionContainer.classList.add("d-none");
        functionsContainer.classList.remove("d-none");
    }else{
        sectionContainer.classList.remove("d-none");
        functionsContainer.classList.add("d-none");
    }
}

const handleApiFilters = (button) => {
    const buttonContainer = document.querySelectorAll('.api-filter-buttons button');
    buttonContainer.forEach(btn => {
       btn.classList.remove('active');
    });
    button.classList.add('active');
}