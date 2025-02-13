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

const handleBlogFilter = (type, button) => {
    const blogsContainer = document.getElementById('blogsContainer');
    const filtersContainer = document.getElementById('filtersContainer');
    const archives = document.getElementById('Archives');
    const categories = document.getElementById('Categories');

    blogsContainer.classList.remove('col-lg-12', 'col-lg-10');
    blogsContainer.classList.add(type === 'All' ? 'col-lg-12' : 'col-lg-10');
    filtersContainer.classList.remove('d-none');

    const buttons = document.querySelectorAll('.filter-blog-button');
    buttons.forEach(btn => {
        btn.classList.add('bg-transparent');
        btn.classList.remove('bg--iris', 'text-white');
        const svg = btn.querySelector('svg');
        if (svg) {
            svg.classList.add('d-none');
        }
    });
    const svg = button.querySelector('svg');
    if (svg) {
        svg.classList.remove('d-none');
    }
    button.classList.remove('bg-transparent');
    button.classList.add('bg--iris', 'text-white');

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
