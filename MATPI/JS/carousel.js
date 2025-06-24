document.addEventListener('DOMContentLoaded', function () {
    const carousel = document.getElementById("carousel");
    const totalSlides = carousel.children.length;
    const indicators = document.getElementById("indicators");
    let index = 0;
    let autoplayInterval;

    // Función para actualizar el carrusel
    function updateCarousel() {
        carousel.style.transform = `translateX(-${index * 100}%)`;
        updateIndicators();
    }

    // Función para actualizar indicadores
    function updateIndicators() {
        indicators.innerHTML = "";
        for (let i = 0; i < totalSlides; i++) {
            const dot = document.createElement("span");
            dot.className = "indicator-dot";
            if (i === index) dot.classList.add("active");

            // Asignar evento click correctamente
            dot.addEventListener('click', function () {
                index = i;
                updateCarousel();
                resetAutoplay();
            });

            indicators.appendChild(dot);
        }
    }

    // Funciones de navegación
    function nextSlide() {
        index = (index + 1) % totalSlides;
        updateCarousel();
        resetAutoplay();
    }

    function prevSlide() {
        index = (index - 1 + totalSlides) % totalSlides;
        updateCarousel();
        resetAutoplay();
    }

    // Control autoplay
    function startAutoplay() {
        autoplayInterval = setInterval(nextSlide, 5000);
    }

    function resetAutoplay() {
        clearInterval(autoplayInterval);
        startAutoplay();
    }

    // Event listeners para botones
    document.querySelector('.carousel-button-prev[onclick="prevSlide()"]').addEventListener('click', prevSlide);
    document.querySelector('.carousel-button-next[onclick="nextSlide()"]').addEventListener('click', nextSlide);

    // Inicialización
    updateCarousel();
    startAutoplay();

    // Pausar al interactuar
    carousel.parentElement.addEventListener('mouseenter', function () {
        clearInterval(autoplayInterval);
    });

    carousel.parentElement.addEventListener('mouseleave', function () {
        startAutoplay();
    });
});