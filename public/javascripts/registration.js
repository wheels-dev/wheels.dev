// Registration form functionality with real-time email validation
document.addEventListener('DOMContentLoaded', function() {
    const registrationForm = document.getElementById('registrationForm');
    if (!registrationForm) return;

    // Email validation variables
    let emailCheckTimeout;
    let isEmailChecking = false;

    // Form elements
    const firstName = document.getElementById('firstName');
    const lastName = document.getElementById('lastName');
    const email = document.getElementById('email');
    const passwordHash = document.getElementById('passwordHash');
    const confirmPassword = document.getElementById('confirmPassword');
    const termsCheck = document.getElementById('termsCheck');

    // Validation functions
    function validateInput(field, isValid, message) {
        const icon = document.getElementById('icon-' + field.id);
        
        if (isValid) {
            field.classList.remove('input-invalid', 'is-invalid');
            field.classList.add('input-valid', 'is-valid');
            if (field.type !== 'checkbox' && icon) {
                icon.innerHTML = '<i class="bi bi-check-circle-fill text-success"></i>';
            }
            hideError(field);
        } else {
            field.classList.remove('input-valid', 'is-valid');
            field.classList.add('input-invalid', 'is-invalid');
            if (field.type !== 'checkbox' && icon) {
                icon.innerHTML = '<i class="bi bi-x-circle-fill text-danger"></i>';
            }
            showError(field, message);
        }
    }

    function showError(field, message) {
        const errorElement = field.closest('.mb-3')?.querySelector('.invalid-feedback') || 
                           field.parentElement.querySelector('.invalid-feedback');
        if (errorElement) {
            errorElement.textContent = message;
            errorElement.style.display = 'block';
        }
        field.classList.add('is-invalid');
    }

    function hideError(field) {
        const errorElement = field.closest('.mb-3')?.querySelector('.invalid-feedback') || 
                           field.parentElement.querySelector('.invalid-feedback');
        if (errorElement) {
            errorElement.style.display = 'none';
        }
        field.classList.remove('is-invalid');
    }

    function showSuccess(field, message) {
        const successElement = field.closest('.mb-3')?.querySelector('.valid-feedback');
        if (successElement) {
            successElement.textContent = message;
            successElement.classList.remove('d-none');
        }
        field.classList.add('is-valid');
    }

    function hideSuccess(field) {
        const successElement = field.closest('.mb-3')?.querySelector('.valid-feedback');
        if (successElement) {
            successElement.classList.add('d-none');
        }
        field.classList.remove('is-valid');
    }

    function showEmailSpinner() {
        const spinner = document.querySelector('.email-check-spinner');
        if (spinner) {
            spinner.classList.remove('d-none');
        }
    }

    function hideEmailSpinner() {
        const spinner = document.querySelector('.email-check-spinner');
        if (spinner) {
            spinner.classList.add('d-none');
        }
    }

    function checkEmailAvailability(emailValue) {
        if (isEmailChecking) return;
        
        isEmailChecking = true;
        showEmailSpinner();
        
        fetch(`/api/v1/auth/check-email?email=${encodeURIComponent(emailValue)}`)
            .then(response => response.json())
            .then(data => {
                const iconEmail = document.getElementById('icon-email');
                
                if (data.available) {
                    email.classList.remove('is-invalid');
                    email.classList.add('is-valid');
                    if (iconEmail) {
                        iconEmail.innerHTML = '<i class="bi bi-check-circle-fill text-success"></i>';
                    }
                    showSuccess(email, data.message);
                    hideError(email);
                } else {
                    email.classList.remove('is-valid');
                    email.classList.add('is-invalid');
                    if (iconEmail) {
                        iconEmail.innerHTML = '<i class="bi bi-x-circle-fill text-danger"></i>';
                    }
                    showError(email, data.message);
                    hideSuccess(email);
                }
            })
            .catch(error => {
                console.error('Error checking email:', error);
                showError(email, 'Error checking email availability. Please try again.');
            })
            .finally(() => {
                hideEmailSpinner();
                isEmailChecking = false;
            });
    }

    // Input event listeners
    if (firstName) {
        firstName.addEventListener('input', function() {
            const isValid = this.value.length >= 3 && this.value.length <= 20;
            validateInput(this, isValid, 'First name must be 3–20 letters only (A–Z or a–z).');
        });
    }

    if (lastName) {
        lastName.addEventListener('input', function() {
            const isValid = this.value.length >= 3 && this.value.length <= 20;
            validateInput(this, isValid, 'Last name must be 3–20 letters only (A–Z or a–z).');
        });
    }

    if (email) {
        email.addEventListener('input', function() {
            const emailValue = this.value.trim();
            const isValidEmail = /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(emailValue);
            
            // Clear previous timeout
            if (emailCheckTimeout) {
                clearTimeout(emailCheckTimeout);
            }
            
            // Hide previous validation states
            hideError(this);
            hideSuccess(this);
            const iconEmail = document.getElementById('icon-email');
            if (iconEmail) {
                iconEmail.innerHTML = '';
            }
            
            if (emailValue.length === 0) {
                validateInput(this, false, 'Please enter a valid email address format (e.g., name@example.com).');
            } else if (!isValidEmail) {
                validateInput(this, false, 'Please enter a valid email address format (e.g., name@example.com).');
            } else {
                // Set timeout to check email availability after user stops typing
                emailCheckTimeout = setTimeout(() => {
                    checkEmailAvailability(emailValue);
                }, 500);
            }
        });
    }

    if (passwordHash) {
        passwordHash.addEventListener('input', function() {
            const isValid = this.value.length >= 8;
            validateInput(this, isValid, 'Your password should be at least 8 characters.');
        });
    }

    if (confirmPassword) {
        confirmPassword.addEventListener('input', function() {
            const isValid = this.value.length >= 8 && this.value === passwordHash.value;
            validateInput(this, isValid, 'Passwords must match.');
        });
    }

    if (termsCheck) {
        termsCheck.addEventListener('change', function() {
            validateInput(this, this.checked, 'You must agree to the terms and privacy policy to continue.');
        });
    }

    // Form submission
    registrationForm.addEventListener('submit', function(e) {
        let hasErrors = false;
        
        // Clear previous validation states
        this.querySelectorAll('.is-invalid').forEach(field => {
            field.classList.remove('is-invalid');
        });
        this.querySelectorAll('.invalid-feedback').forEach(feedback => {
            feedback.textContent = '';
            feedback.style.display = 'none';
        });
        
        // Validate all fields
        const validations = {
            firstName: {
                validator: value => value.length >= 3 && value.length <= 20,
                message: 'First name must be 3–20 letters only (A–Z or a–z).'
            },
            lastName: {
                validator: value => value.length >= 3 && value.length <= 20,
                message: 'Last name must be 3–20 letters only (A–Z or a–z).'
            },
            email: {
                validator: value => /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(value),
                message: 'Please enter a valid email address format (e.g., name@example.com).'
            },
            passwordHash: {
                validator: value => value.length >= 8,
                message: 'Your password should be at least 8 characters.'
            },
            confirmPassword: {
                validator: value => value.length >= 8 && value === passwordHash.value,
                message: 'Passwords must match.'
            },
            termsCheck: {
                validator: value => value,
                message: 'You must agree to the terms and privacy policy to continue.'
            }
        };
        
        for (const [fieldName, validation] of Object.entries(validations)) {
            const field = this[fieldName];
            if (field) {
                const value = field.type === 'checkbox' ? field.checked : field.value;
                if (!validation.validator(value)) {
                    showError(field, validation.message);
                    hasErrors = true;
                }
            }
        }
        
        // Check if email is available
        if (email && email.classList.contains('is-invalid')) {
            hasErrors = true;
        }
        
        if (hasErrors) {
            e.preventDefault();
        } else {
            const submitButton = this.querySelector('button[type="submit"]');
            const spinner = submitButton.querySelector('.spinner-border');
            const buttonText = submitButton.querySelector('.button-text');
            
            submitButton.disabled = true;
            spinner.classList.remove('d-none');
            buttonText.textContent = 'Registering...';
        }
    });
}); 