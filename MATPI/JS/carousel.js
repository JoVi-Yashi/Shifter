export function initCarousel() {
    const carousel = document.getElementById("carousel");
    const totalSlides = carousel.children.length;
    const indicators = document.getElementById("indicators");
    let index = 0;

    function updateCarousel() {
        carousel.style.transform = `translateX(-${index * 100}vw)`;
        updateIndicators();
    }

    function updateIndicators() {
        indicators.innerHTML = "";
        for (let i = 0; i < totalSlides; i++) {
            const dot = document.createElement("span");
            if (i === index) dot.classList.add("active");
            dot.onclick = () => {
                index = i;
                updateCarousel();
            };
            indicators.appendChild(dot);
        }
    }

    function nextSlide() {
        index = (index + 1) % totalSlides;
        updateCarousel();
    }

    function prevSlide() {
        index = (index - 1 + totalSlides) % totalSlides;
        updateCarousel();
    }

    setInterval(nextSlide, 5000); // Cambia cada 5 segundos
    updateCarousel();
}

// Inicializa el carrusel al cargar la página
document.addEventListener("DOMContentLoaded", () => {
    initCarousel();
});