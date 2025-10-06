// GHAA HUB 2025 - Advanced Animations JavaScript
// High-performance animations and effects

class AnimationController {
    constructor() {
        this.animations = new Map();
        this.observers = new Map();
        this.init();
    }

    init() {
        this.setupIntersectionObserver();
        this.setupScrollAnimations();
        this.setupHoverEffects();
        this.setupLoadingAnimations();
        this.setupParticleSystem();
        this.setupCodeAnimations();
    }

    // Intersection Observer for scroll animations
    setupIntersectionObserver() {
        const observerOptions = {
            threshold: 0.1,
            rootMargin: '0px 0px -50px 0px'
        };

        this.scrollObserver = new IntersectionObserver((entries) => {
            entries.forEach(entry => {
                if (entry.isIntersecting) {
                    this.triggerAnimation(entry.target);
                }
            });
        }, observerOptions);

        // Observe all animated elements
        document.querySelectorAll('[data-animation]').forEach(el => {
            this.scrollObserver.observe(el);
        });
    }

    // Scroll-based animations
    setupScrollAnimations() {
        let ticking = false;

        const updateScrollAnimations = () => {
            const scrollY = window.pageYOffset;
            
            // Parallax effects
            this.updateParallaxElements(scrollY);
            
            // Progress bars
            this.updateProgressBars(scrollY);
            
            // Staggered animations
            this.updateStaggeredAnimations(scrollY);
            
            ticking = false;
        };

        const requestTick = () => {
            if (!ticking) {
                requestAnimationFrame(updateScrollAnimations);
                ticking = true;
            }
        };

        window.addEventListener('scroll', requestTick);
    }

    // Hover effects
    setupHoverEffects() {
        // 3D card effects
        document.querySelectorAll('.card-3d').forEach(card => {
            card.addEventListener('mousemove', (e) => {
                this.handle3DCardHover(e, card);
            });
            
            card.addEventListener('mouseleave', () => {
                this.reset3DCard(card);
            });
        });

        // Magnetic buttons
        document.querySelectorAll('.magnetic').forEach(button => {
            button.addEventListener('mousemove', (e) => {
                this.handleMagneticEffect(e, button);
            });
            
            button.addEventListener('mouseleave', () => {
                this.resetMagneticEffect(button);
            });
        });

        // Ripple effects
        document.querySelectorAll('.ripple').forEach(element => {
            element.addEventListener('click', (e) => {
                this.createRippleEffect(e, element);
            });
        });
    }

    // Loading animations
    setupLoadingAnimations() {
        // Typing animation
        this.initTypingAnimation();
        
        // Counter animations
        this.initCounterAnimations();
        
        // Progress animations
        this.initProgressAnimations();
    }

    // Particle system
    setupParticleSystem() {
        this.particles = [];
        this.particleContainer = document.getElementById('particles');
        
        if (this.particleContainer) {
            this.createParticles();
            this.animateParticles();
        }
    }

    // Code window animations
    setupCodeAnimations() {
        const codeWindow = document.querySelector('.code-window');
        if (codeWindow) {
            this.animateCodeWindow(codeWindow);
        }
    }

    // Animation trigger methods
    triggerAnimation(element) {
        const animationType = element.getAttribute('data-animation');
        const delay = element.getAttribute('data-delay') || 0;
        
        setTimeout(() => {
            element.classList.add('animate');
            
            // Add specific animation classes
            switch (animationType) {
                case 'fadeIn':
                    element.classList.add('fade-in-visible');
                    break;
                case 'slideInLeft':
                    element.classList.add('slide-in-left-visible');
                    break;
                case 'slideInRight':
                    element.classList.add('slide-in-right-visible');
                    break;
                case 'slideInUp':
                    element.classList.add('slide-in-up-visible');
                    break;
                case 'zoomIn':
                    element.classList.add('zoom-in-visible');
                    break;
                case 'stagger':
                    this.triggerStaggerAnimation(element);
                    break;
            }
        }, delay);
    }

    // Parallax effects
    updateParallaxElements(scrollY) {
        const parallaxElements = document.querySelectorAll('[data-parallax]');
        
        parallaxElements.forEach(element => {
            const speed = element.getAttribute('data-parallax') || 0.5;
            const yPos = -(scrollY * speed);
            element.style.transform = `translateY(${yPos}px)`;
        });
    }

    // Progress bars
    updateProgressBars(scrollY) {
        const progressBars = document.querySelectorAll('.progress-bar');
        
        progressBars.forEach(bar => {
            const rect = bar.getBoundingClientRect();
            const isVisible = rect.top < window.innerHeight && rect.bottom > 0;
            
            if (isVisible && !bar.classList.contains('animated')) {
                this.animateProgressBar(bar);
                bar.classList.add('animated');
            }
        });
    }

    // Staggered animations
    updateStaggeredAnimations(scrollY) {
        const staggerContainers = document.querySelectorAll('.stagger-container');
        
        staggerContainers.forEach(container => {
            const rect = container.getBoundingClientRect();
            const isVisible = rect.top < window.innerHeight && rect.bottom > 0;
            
            if (isVisible && !container.classList.contains('animated')) {
                this.triggerStaggerAnimation(container);
                container.classList.add('animated');
            }
        });
    }

    // 3D card hover effect
    handle3DCardHover(e, card) {
        const rect = card.getBoundingClientRect();
        const x = e.clientX - rect.left;
        const y = e.clientY - rect.top;
        
        const centerX = rect.width / 2;
        const centerY = rect.height / 2;
        
        const rotateX = (y - centerY) / 10;
        const rotateY = (centerX - x) / 10;
        
        card.style.transform = `perspective(1000px) rotateX(${rotateX}deg) rotateY(${rotateY}deg) translateZ(10px)`;
    }

    reset3DCard(card) {
        card.style.transform = 'perspective(1000px) rotateX(0) rotateY(0) translateZ(0)';
    }

    // Magnetic effect
    handleMagneticEffect(e, button) {
        const rect = button.getBoundingClientRect();
        const x = e.clientX - rect.left - rect.width / 2;
        const y = e.clientY - rect.top - rect.height / 2;
        
        const distance = Math.sqrt(x * x + y * y);
        const maxDistance = 50;
        
        if (distance < maxDistance) {
            const strength = (maxDistance - distance) / maxDistance;
            const moveX = x * strength * 0.3;
            const moveY = y * strength * 0.3;
            
            button.style.transform = `translate(${moveX}px, ${moveY}px)`;
        }
    }

    resetMagneticEffect(button) {
        button.style.transform = 'translate(0, 0)';
    }

    // Ripple effect
    createRippleEffect(e, element) {
        const ripple = document.createElement('span');
        const rect = element.getBoundingClientRect();
        const size = Math.max(rect.width, rect.height);
        const x = e.clientX - rect.left - size / 2;
        const y = e.clientY - rect.top - size / 2;
        
        ripple.style.cssText = `
            position: absolute;
            width: ${size}px;
            height: ${size}px;
            left: ${x}px;
            top: ${y}px;
            background: rgba(0, 212, 255, 0.3);
            border-radius: 50%;
            transform: scale(0);
            animation: ripple 0.6s ease-out;
            pointer-events: none;
        `;
        
        element.style.position = 'relative';
        element.style.overflow = 'hidden';
        element.appendChild(ripple);
        
        setTimeout(() => {
            ripple.remove();
        }, 600);
    }

    // Typing animation
    initTypingAnimation() {
        const typingElements = document.querySelectorAll('.typing-text');
        
        typingElements.forEach(element => {
            const text = element.textContent;
            element.textContent = '';
            element.style.borderRight = '2px solid #00d4ff';
            
            let i = 0;
            const typeWriter = () => {
                if (i < text.length) {
                    element.textContent += text.charAt(i);
                    i++;
                    setTimeout(typeWriter, 100);
                } else {
                    element.style.borderRight = 'none';
                }
            };
            
            // Start when visible
            const observer = new IntersectionObserver((entries) => {
                entries.forEach(entry => {
                    if (entry.isIntersecting) {
                        typeWriter();
                        observer.unobserve(entry.target);
                    }
                });
            });
            
            observer.observe(element);
        });
    }

    // Counter animations
    initCounterAnimations() {
        const counters = document.querySelectorAll('.counter');
        
        counters.forEach(counter => {
            const observer = new IntersectionObserver((entries) => {
                entries.forEach(entry => {
                    if (entry.isIntersecting) {
                        this.animateCounter(counter);
                        observer.unobserve(entry.target);
                    }
                });
            });
            
            observer.observe(counter);
        });
    }

    animateCounter(element) {
        const target = parseInt(element.getAttribute('data-target'));
        const duration = parseInt(element.getAttribute('data-duration')) || 2000;
        const increment = target / (duration / 16);
        let current = 0;
        
        const updateCounter = () => {
            if (current < target) {
                current += increment;
                element.textContent = Math.floor(current);
                requestAnimationFrame(updateCounter);
            } else {
                element.textContent = target;
            }
        };
        
        updateCounter();
    }

    // Progress animations
    initProgressAnimations() {
        const progressBars = document.querySelectorAll('.progress-bar');
        
        progressBars.forEach(bar => {
            const observer = new IntersectionObserver((entries) => {
                entries.forEach(entry => {
                    if (entry.isIntersecting) {
                        this.animateProgressBar(bar);
                        observer.unobserve(entry.target);
                    }
                });
            });
            
            observer.observe(bar);
        });
    }

    animateProgressBar(bar) {
        const target = parseInt(bar.getAttribute('data-progress'));
        const duration = 2000;
        const increment = target / (duration / 16);
        let current = 0;
        
        const updateProgress = () => {
            if (current < target) {
                current += increment;
                bar.style.width = `${current}%`;
                requestAnimationFrame(updateProgress);
            } else {
                bar.style.width = `${target}%`;
            }
        };
        
        updateProgress();
    }

    // Particle system
    createParticles() {
        const particleCount = 50;
        
        for (let i = 0; i < particleCount; i++) {
            this.createParticle();
        }
    }

    createParticle() {
        const particle = document.createElement('div');
        particle.className = 'particle';
        
        const size = Math.random() * 4 + 1;
        const x = Math.random() * 100;
        const y = Math.random() * 100;
        const duration = Math.random() * 20 + 10;
        const delay = Math.random() * 5;
        
        particle.style.cssText = `
            position: absolute;
            width: ${size}px;
            height: ${size}px;
            background: rgba(0, 212, 255, 0.6);
            border-radius: 50%;
            left: ${x}%;
            top: ${y}%;
            animation: particleFloat${Math.floor(Math.random() * 3) + 1} ${duration}s ease-in-out infinite;
            animation-delay: ${delay}s;
        `;
        
        this.particleContainer.appendChild(particle);
        this.particles.push(particle);
    }

    animateParticles() {
        this.particles.forEach(particle => {
            // Add mouse interaction
            particle.addEventListener('mouseenter', () => {
                particle.style.animationPlayState = 'paused';
                particle.style.transform = 'scale(1.5)';
            });
            
            particle.addEventListener('mouseleave', () => {
                particle.style.animationPlayState = 'running';
                particle.style.transform = 'scale(1)';
            });
        });
    }

    // Code window animation
    animateCodeWindow(codeWindow) {
        const codeLines = codeWindow.querySelectorAll('.code-line');
        let currentLine = 0;
        
        const animateNextLine = () => {
            if (currentLine < codeLines.length) {
                codeLines[currentLine].style.opacity = '1';
                codeLines[currentLine].style.transform = 'translateX(0)';
                currentLine++;
                setTimeout(animateNextLine, 500);
            }
        };
        
        // Initialize lines
        codeLines.forEach(line => {
            line.style.opacity = '0';
            line.style.transform = 'translateX(-20px)';
            line.style.transition = 'all 0.5s ease';
        });
        
        // Start animation
        setTimeout(animateNextLine, 1000);
    }

    // Stagger animation
    triggerStaggerAnimation(container) {
        const children = container.querySelectorAll('.stagger-item');
        
        children.forEach((child, index) => {
            setTimeout(() => {
                child.classList.add('animate');
            }, index * 100);
        });
    }

    // Utility methods
    addAnimation(element, animationClass, duration = 1000) {
        element.classList.add(animationClass);
        setTimeout(() => {
            element.classList.remove(animationClass);
        }, duration);
    }

    // Cleanup
    destroy() {
        this.scrollObserver?.disconnect();
        this.particles?.forEach(particle => particle.remove());
    }
}

// Initialize animation controller
const animationController = new AnimationController();

// Add CSS for animations
const animationStyles = document.createElement('style');
animationStyles.textContent = `
    .fade-in {
        opacity: 0;
        transform: translateY(30px);
        transition: all 0.6s ease;
    }
    
    .fade-in-visible {
        opacity: 1;
        transform: translateY(0);
    }
    
    .slide-in-left {
        opacity: 0;
        transform: translateX(-50px);
        transition: all 0.6s ease;
    }
    
    .slide-in-left-visible {
        opacity: 1;
        transform: translateX(0);
    }
    
    .slide-in-right {
        opacity: 0;
        transform: translateX(50px);
        transition: all 0.6s ease;
    }
    
    .slide-in-right-visible {
        opacity: 1;
        transform: translateX(0);
    }
    
    .slide-in-up {
        opacity: 0;
        transform: translateY(50px);
        transition: all 0.6s ease;
    }
    
    .slide-in-up-visible {
        opacity: 1;
        transform: translateY(0);
    }
    
    .zoom-in {
        opacity: 0;
        transform: scale(0.8);
        transition: all 0.6s ease;
    }
    
    .zoom-in-visible {
        opacity: 1;
        transform: scale(1);
    }
    
    .stagger-item {
        opacity: 0;
        transform: translateY(20px);
        transition: all 0.5s ease;
    }
    
    .stagger-item.animate {
        opacity: 1;
        transform: translateY(0);
    }
    
    .progress-bar {
        width: 0%;
        transition: width 2s ease;
    }
    
    .counter {
        font-weight: bold;
    }
    
    .particle {
        pointer-events: none;
    }
    
    @keyframes ripple {
        0% {
            transform: scale(0);
            opacity: 1;
        }
        100% {
            transform: scale(1);
            opacity: 0;
        }
    }
    
    .card-3d {
        transition: transform 0.1s ease;
    }
    
    .magnetic {
        transition: transform 0.1s ease;
    }
    
    .ripple {
        position: relative;
        overflow: hidden;
    }
`;

document.head.appendChild(animationStyles);

// Export for external use
window.AnimationController = AnimationController;