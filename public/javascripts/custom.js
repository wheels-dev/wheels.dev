var swiper = new Swiper(".blogSwiper", {
    spaceBetween: 30,
    freeMode: true,
    initialSlide: 2,
    autoHeight: true,
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