function initSwiper() {
    let swiperInstance = null;
    if (window.innerWidth >= 768 && !swiperInstance) {
        swiperInstance = new Swiper(".blogSwiper", {
            spaceBetween: 30,
            freeMode: true,
            initialSlide: 1,
            slidesOffsetBefore: 250,
            breakpoints: {
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
    } else if (window.innerWidth < 768 && swiperInstance) {
        swiperInstance.destroy(true, true);
        swiperInstance = null;
    }
}

// Initialize on load
window.addEventListener("load", initSwiper);
// Re-initialize on resize
window.addEventListener("resize", initSwiper);


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
    slidesPerView: "auto",
    centeredSlides: true,
    pagination: {
        el: ".swiper-pagination",
        clickable: true,
    },
});


if (typeof handleApiSection === 'undefined') {
    const handleApiSection = (type, button) => {

        const sectionContainer = document.getElementById('sectionContainer');
        const functionsContainer = document.getElementById('functionsContainer');

        const buttons = document.querySelectorAll('.filter-button');
        buttons.forEach(btn => {
            btn.classList.remove('active');
        });
        button.classList.add('active');

        if (type === "All") {
            sectionContainer.classList.add("d-none");
            functionsContainer.classList.remove("d-none");
        } else {
            sectionContainer.classList.remove("d-none");
            functionsContainer.classList.add("d-none");
        }
    }
}

if (typeof handleApiFilters === 'undefined') {
    const handleApiFilters = (button) => {
        const buttonContainer = document.querySelectorAll('.api-filter-buttons button');
        buttonContainer.forEach(btn => {
            btn.classList.remove('active');
        });
        button.classList.add('active');
    }
}