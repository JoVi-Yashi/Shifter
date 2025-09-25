// SIDEBAR FUNCTIONALITY - VERSIÓN COMPLETA Y CORREGIDA
document.addEventListener('DOMContentLoaded', function() {
    // Elementos de la sidebar
    const sidebar = document.getElementById('sidebar');
    const sidebarOverlay = document.getElementById('sidebarOverlay');
    const sidebarToggle = document.getElementById('sidebarToggle');
    
    // Verificar que los elementos existen
    if (!sidebar || !sidebarOverlay || !sidebarToggle) {
        console.error('Error: No se encontraron los elementos de la sidebar');
        return;
    }

    // Función para abrir/cerrar sidebar
    function toggleSidebar() {
        sidebar.classList.toggle('active');
        sidebarOverlay.classList.toggle('active');
        
        // Bloquear scroll del body cuando la sidebar está abierta
        if (sidebar.classList.contains('active')) {
            document.body.style.overflow = 'hidden';
        } else {
            document.body.style.overflow = '';
        }
    }

    // Evento para el botón toggle
    sidebarToggle.addEventListener('click', function(e) {
        e.preventDefault();
        toggleSidebar();
    });

    // Evento para el overlay
    sidebarOverlay.addEventListener('click', toggleSidebar);

    // Cerrar sidebar al hacer clic en un ítem del menú (solo en móviles)
    document.querySelectorAll('.menu-item').forEach(item => {
        item.addEventListener('click', function() {
            if (window.innerWidth <= 768) {
                setTimeout(toggleSidebar, 300);
            }
        });
    });

    // Cerrar con tecla Escape
    document.addEventListener('keydown', function(e) {
        if (e.key === 'Escape' && sidebar.classList.contains('active')) {
            toggleSidebar();
        }
    });

    // FUNCIÓN PARA ACTUALIZAR LA HORA
    function updateTime() {
        const now = new Date();
        const timeString = now.toLocaleTimeString('es-ES', {
            hour: '2-digit',
            minute: '2-digit',
            second: '2-digit'
        });
        const timeDisplay = document.getElementById('timeDisplay');
        if (timeDisplay) timeDisplay.textContent = timeString;
    }

    // Actualizar hora cada segundo
    setInterval(updateTime, 1000);
    updateTime(); // Ejecutar inmediatamente

    // ACTUALIZAR ESTADÍSTICAS
    function updateStats() {
        const ventas = Math.floor(150 + Math.random() * 20);
        const ingresos = Math.floor(230000 + Math.random() * 20000);
        const clientes = Math.floor(85 + Math.random() * 10);
        const rating = (4.6 + Math.random() * 0.4).toFixed(1);

        // Actualizar valores con animación
        animateValue('totalVentas', parseInt(document.getElementById('totalVentas').textContent) || 0, ventas, 1000);
        animateValue('clientes', parseInt(document.getElementById('clientes').textContent) || 0, clientes, 1000);
        animateValue('rating', parseFloat(document.getElementById('rating').textContent) || 0, rating, 1000);
        
        // Formatear ingresos como moneda
        const ingresosElement = document.getElementById('ingresos');
        if (ingresosElement) {
            const current = parseInt(ingresosElement.textContent.replace(/\D/g,'')) || 230000;
            animateCurrencyValue(current, ingresos, 1000, ingresosElement);
        }
    }

    // Función para animar cambios de valor
    function animateValue(id, start, end, duration) {
        const obj = document.getElementById(id);
        if (!obj) return;
        
        let startTimestamp = null;
        const step = (timestamp) => {
            if (!startTimestamp) startTimestamp = timestamp;
            const progress = Math.min((timestamp - startTimestamp) / duration, 1);
            obj.innerHTML = Math.floor(progress * (end - start) + start);
            if (progress < 1) {
                window.requestAnimationFrame(step);
            }
        };
        window.requestAnimationFrame(step);
    }

    // Función para animar valores monetarios
    function animateCurrencyValue(start, end, duration, element) {
        let startTimestamp = null;
        const step = (timestamp) => {
            if (!startTimestamp) startTimestamp = timestamp;
            const progress = Math.min((timestamp - startTimestamp) / duration, 1);
            const value = Math.floor(progress * (end - start) + start);
            element.textContent = '$' + value.toLocaleString();
            if (progress < 1) {
                window.requestAnimationFrame(step);
            }
        };
        window.requestAnimationFrame(step);
    }

    // Actualizar estadísticas cada 10 segundos
    setInterval(updateStats, 10000);
    updateStats(); // Ejecutar inmediatamente

    // ANIMACIÓN DE TARJETAS AL CARGAR
    function animateCards() {
        const cards = document.querySelectorAll('.stat-card, .content-card, .progress-card, .producto');
        cards.forEach((card, index) => {
            card.style.opacity = '0';
            card.style.transform = 'translateY(20px)';
            setTimeout(() => {
                card.style.transition = 'all 0.6s ease';
                card.style.opacity = '1';
                card.style.transform = 'translateY(0)';
            }, index * 100);
        });
    }

    // Ejecutar animación al cargar
    animateCards();

    // ACTUALIZAR AÑO EN EL FOOTER
    const yearElement = document.getElementById('currentYear');
    if (yearElement) {
        yearElement.textContent = new Date().getFullYear();
    }

    // SIMULAR ACTIVIDAD RECIENTE
    function simulateRecentActivity() {
        const activities = [
            { icon: '🍔', title: 'Nueva orden: Matpi XL', time: 'Hace 1 minuto' },
            { icon: '⭐', title: 'Reseña 4 estrellas', time: 'Hace 3 minutos' },
            { icon: '🚚', title: 'Pedido en camino', time: 'Hace 5 minutos' },
            { icon: '👤', title: 'Cliente frecuente', time: 'Hace 10 minutos' },
            { icon: '💰', title: 'Pago procesado: $18,500', time: 'Hace 12 minutos' },
            { icon: '🔔', title: 'Promoción activada', time: 'Hace 15 minutos' }
        ];
        
        const activityContainer = document.querySelector('.content-card');
        if (!activityContainer) return;
        
        setInterval(() => {
            const randomActivity = activities[Math.floor(Math.random() * activities.length)];
            
            const newActivity = document.createElement('div');
            newActivity.className = 'activity-item';
            newActivity.innerHTML = `
                <div class="activity-icon">${randomActivity.icon}</div>
                <div class="activity-content">
                    <h4>${randomActivity.title}</h4>
                    <p>${randomActivity.time}</p>
                </div>
            `;
            
            activityContainer.insertBefore(newActivity, activityContainer.firstChild.nextSibling);
            
            if (activityContainer.children.length > 7) {
                activityContainer.removeChild(activityContainer.lastChild);
            }
            
            newActivity.style.opacity = '0';
            newActivity.style.transform = 'translateX(-20px)';
            setTimeout(() => {
                newActivity.style.transition = 'all 0.4s ease';
                newActivity.style.opacity = '1';
                newActivity.style.transform = 'translateX(0)';
            }, 10);
            
        }, 15000);
    }

    simulateRecentActivity();
});