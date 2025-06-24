document.addEventListener('DOMContentLoaded', function () {
    const formulario = document.getElementById('inicio_sesion');

    formulario.addEventListener('submit', function (event) {
        event.preventDefault();
        limpiarErrores();

        const usuario = sanitizarInput(document.getElementById('numero_documento').value.trim());
        const clave = sanitizarInput(document.getElementById('clave').value.trim());

        let valido = true;

        // Validar usuario
        if (!/^[0-9]{8,10}$/.test(usuario)) {
            mostrarError('numero_documento', 'Debe contener entre 8 y 10 dígitos numéricos');
            valido = false;
        }

        // Validar contraseña
        if (clave.length < 6) {
            mostrarError('clave', 'La contraseña debe tener al menos 6 caracteres');
            valido = false;
        }

        if (valido) {
            // Simulación de envío exitoso
            mostrarCarga();

            // En producción, usaría esto:
            // enviarDatosAlServidor(usuario, clave);

            // Simulamos una respuesta del servidor después de 1.5 segundos
            setTimeout(() => {
                ocultarCarga();
                window.location.href = 'Dashboard.html';
            }, 1500);
        }
    });

    // Funciones auxiliares
    function mostrarError(elementoId, mensaje) {
        const errorElement = document.getElementById(elementoId + '-error');
        if (errorElement) {
            errorElement.textContent = mensaje;
            errorElement.style.display = 'block';
        }

        const inputElement = document.getElementById(elementoId);
        if (inputElement) {
            inputElement.classList.add('input-error');
        }
    }

    function limpiarErrores() {
        document.querySelectorAll('.error-message').forEach(el => {
            el.textContent = '';
            el.style.display = 'none';
        });

        document.querySelectorAll('.input-error').forEach(el => {
            el.classList.remove('input-error');
        });
    }

    function sanitizarInput(input) {
        return input.replace(/</g, "&lt;").replace(/>/g, "&gt;");
    }

    function mostrarCarga() {
        const boton = formulario.querySelector('button[type="submit"]');
        boton.disabled = true;
        boton.innerHTML = '<span class="spinner"></span> Validando...';
    }

    function ocultarCarga() {
        const boton = formulario.querySelector('button[type="submit"]');
        boton.disabled = false;
        boton.textContent = 'Ingresar';
    }
});