// Toggle dropdown on click
document.querySelector('.profile-btn').addEventListener('click', function() {
    document.querySelector('.dropdown-content').classList.toggle('show');
});

// Close dropdown when clicking outside
window.onclick = function(event) {
    if (!event.target.matches('.profile-btn')) {
        var dropdowns = document.querySelectorAll('.dropdown-content');
        dropdowns.forEach(function(dropdown) {
            if (dropdown.classList.contains('show')) {
                dropdown.classList.remove('show');
            }
        });
    }
};

// Highlight current nav link
document.addEventListener('DOMContentLoaded', function() {
    const navLinks = document.querySelectorAll('.nav-link');
    const currentPage = window.location.pathname.split('/').pop();
    
    navLinks.forEach(link => {
        const linkPage = link.getAttribute('href');
        if (linkPage === currentPage || 
           (linkPage === 'formConfiguracion.html' && currentPage === '')) {
            link.classList.add('active');
        } else {
            link.classList.remove('active');
        }
    });
});
