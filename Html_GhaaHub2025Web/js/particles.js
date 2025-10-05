// GHAA HUB 2025 - Advanced Particle System
// High-performance particle effects for the future of Roblox scripting

class ParticleSystem {
    constructor(container, options = {}) {
        this.container = container;
        this.particles = [];
        this.animationId = null;
        this.isRunning = false;
        
        // Default options
        this.options = {
            particleCount: 50,
            particleSize: { min: 1, max: 4 },
            particleSpeed: { min: 0.5, max: 2 },
            particleLife: { min: 10, max: 20 },
            particleColor: 'rgba(0, 212, 255, 0.6)',
            particleShape: 'circle', // circle, square, triangle
            gravity: 0.1,
            wind: 0,
            mouseInteraction: true,
            collisionDetection: false,
            ...options
        };
        
        this.mouse = { x: 0, y: 0 };
        this.canvas = null;
        this.ctx = null;
        
        this.init();
    }
    
    init() {
        this.createCanvas();
        this.createParticles();
        this.bindEvents();
        this.start();
    }
    
    createCanvas() {
        this.canvas = document.createElement('canvas');
        this.canvas.style.cssText = `
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            pointer-events: none;
            z-index: 1;
        `;
        
        this.container.appendChild(this.canvas);
        this.ctx = this.canvas.getContext('2d');
        
        this.resize();
    }
    
    resize() {
        const rect = this.container.getBoundingClientRect();
        this.canvas.width = rect.width;
        this.canvas.height = rect.height;
    }
    
    createParticles() {
        for (let i = 0; i < this.options.particleCount; i++) {
            this.addParticle();
        }
    }
    
    addParticle() {
        const particle = {
            x: Math.random() * this.canvas.width,
            y: Math.random() * this.canvas.height,
            vx: (Math.random() - 0.5) * this.options.particleSpeed.max,
            vy: (Math.random() - 0.5) * this.options.particleSpeed.max,
            size: Math.random() * (this.options.particleSize.max - this.options.particleSize.min) + this.options.particleSize.min,
            life: Math.random() * (this.options.particleLife.max - this.options.particleLife.min) + this.options.particleLife.min,
            maxLife: Math.random() * (this.options.particleLife.max - this.options.particleLife.min) + this.options.particleLife.min,
            color: this.options.particleColor,
            shape: this.options.particleShape,
            rotation: Math.random() * Math.PI * 2,
            rotationSpeed: (Math.random() - 0.5) * 0.1
        };
        
        this.particles.push(particle);
    }
    
    bindEvents() {
        // Mouse interaction
        if (this.options.mouseInteraction) {
            this.container.addEventListener('mousemove', (e) => {
                const rect = this.container.getBoundingClientRect();
                this.mouse.x = e.clientX - rect.left;
                this.mouse.y = e.clientY - rect.top;
            });
        }
        
        // Resize
        window.addEventListener('resize', () => {
            this.resize();
        });
        
        // Visibility change
        document.addEventListener('visibilitychange', () => {
            if (document.hidden) {
                this.stop();
            } else {
                this.start();
            }
        });
    }
    
    start() {
        if (!this.isRunning) {
            this.isRunning = true;
            this.animate();
        }
    }
    
    stop() {
        this.isRunning = false;
        if (this.animationId) {
            cancelAnimationFrame(this.animationId);
        }
    }
    
    animate() {
        if (!this.isRunning) return;
        
        this.update();
        this.render();
        
        this.animationId = requestAnimationFrame(() => this.animate());
    }
    
    update() {
        this.particles.forEach((particle, index) => {
            // Update position
            particle.x += particle.vx;
            particle.y += particle.vy;
            
            // Apply gravity
            particle.vy += this.options.gravity;
            
            // Apply wind
            particle.vx += this.options.wind;
            
            // Update rotation
            particle.rotation += particle.rotationSpeed;
            
            // Update life
            particle.life -= 0.016; // Assuming 60fps
            
            // Mouse interaction
            if (this.options.mouseInteraction) {
                const dx = this.mouse.x - particle.x;
                const dy = this.mouse.y - particle.y;
                const distance = Math.sqrt(dx * dx + dy * dy);
                
                if (distance < 100) {
                    const force = (100 - distance) / 100;
                    particle.vx += (dx / distance) * force * 0.1;
                    particle.vy += (dy / distance) * force * 0.1;
                }
            }
            
            // Collision detection
            if (this.options.collisionDetection) {
                this.checkCollisions(particle);
            }
            
            // Boundary checking
            if (particle.x < 0 || particle.x > this.canvas.width) {
                particle.vx *= -0.8;
                particle.x = Math.max(0, Math.min(this.canvas.width, particle.x));
            }
            
            if (particle.y < 0 || particle.y > this.canvas.height) {
                particle.vy *= -0.8;
                particle.y = Math.max(0, Math.min(this.canvas.height, particle.y));
            }
            
            // Remove dead particles
            if (particle.life <= 0) {
                this.particles.splice(index, 1);
                this.addParticle(); // Add new particle to maintain count
            }
        });
    }
    
    checkCollisions(particle) {
        this.particles.forEach(otherParticle => {
            if (particle === otherParticle) return;
            
            const dx = particle.x - otherParticle.x;
            const dy = particle.y - otherParticle.y;
            const distance = Math.sqrt(dx * dx + dy * dy);
            const minDistance = particle.size + otherParticle.size;
            
            if (distance < minDistance) {
                // Collision response
                const angle = Math.atan2(dy, dx);
                const targetX = particle.x + Math.cos(angle) * minDistance;
                const targetY = particle.y + Math.sin(angle) * minDistance;
                
                const ax = (targetX - otherParticle.x) * 0.1;
                const ay = (targetY - otherParticle.y) * 0.1;
                
                particle.vx -= ax;
                particle.vy -= ay;
                otherParticle.vx += ax;
                otherParticle.vy += ay;
            }
        });
    }
    
    render() {
        // Clear canvas
        this.ctx.clearRect(0, 0, this.canvas.width, this.canvas.height);
        
        this.particles.forEach(particle => {
            this.ctx.save();
            
            // Set alpha based on life
            const alpha = particle.life / particle.maxLife;
            this.ctx.globalAlpha = alpha;
            
            // Set color
            this.ctx.fillStyle = particle.color;
            this.ctx.strokeStyle = particle.color;
            
            // Move to particle position
            this.ctx.translate(particle.x, particle.y);
            this.ctx.rotate(particle.rotation);
            
            // Draw particle based on shape
            switch (particle.shape) {
                case 'circle':
                    this.ctx.beginPath();
                    this.ctx.arc(0, 0, particle.size, 0, Math.PI * 2);
                    this.ctx.fill();
                    break;
                    
                case 'square':
                    this.ctx.fillRect(-particle.size, -particle.size, particle.size * 2, particle.size * 2);
                    break;
                    
                case 'triangle':
                    this.ctx.beginPath();
                    this.ctx.moveTo(0, -particle.size);
                    this.ctx.lineTo(-particle.size, particle.size);
                    this.ctx.lineTo(particle.size, particle.size);
                    this.ctx.closePath();
                    this.ctx.fill();
                    break;
                    
                case 'star':
                    this.drawStar(0, 0, particle.size, 5, 0.5);
                    break;
            }
            
            this.ctx.restore();
        });
    }
    
    drawStar(x, y, radius, points, innerRadius) {
        const angle = Math.PI / points;
        
        this.ctx.beginPath();
        for (let i = 0; i < 2 * points; i++) {
            const r = i % 2 === 0 ? radius : innerRadius;
            const a = i * angle;
            const px = x + Math.cos(a) * r;
            const py = y + Math.sin(a) * r;
            
            if (i === 0) {
                this.ctx.moveTo(px, py);
            } else {
                this.ctx.lineTo(px, py);
            }
        }
        this.ctx.closePath();
        this.ctx.fill();
    }
    
    // Public methods
    addParticleAt(x, y) {
        const particle = {
            x: x,
            y: y,
            vx: (Math.random() - 0.5) * this.options.particleSpeed.max,
            vy: (Math.random() - 0.5) * this.options.particleSpeed.max,
            size: Math.random() * (this.options.particleSize.max - this.options.particleSize.min) + this.options.particleSize.min,
            life: Math.random() * (this.options.particleLife.max - this.options.particleLife.min) + this.options.particleLife.min,
            maxLife: Math.random() * (this.options.particleLife.max - this.options.particleLife.min) + this.options.particleLife.min,
            color: this.options.particleColor,
            shape: this.options.particleShape,
            rotation: Math.random() * Math.PI * 2,
            rotationSpeed: (Math.random() - 0.5) * 0.1
        };
        
        this.particles.push(particle);
    }
    
    setParticleCount(count) {
        this.options.particleCount = count;
        
        // Remove excess particles
        while (this.particles.length > count) {
            this.particles.pop();
        }
        
        // Add new particles if needed
        while (this.particles.length < count) {
            this.addParticle();
        }
    }
    
    setGravity(gravity) {
        this.options.gravity = gravity;
    }
    
    setWind(wind) {
        this.options.wind = wind;
    }
    
    setParticleColor(color) {
        this.options.particleColor = color;
    }
    
    setParticleShape(shape) {
        this.options.particleShape = shape;
    }
    
    // Cleanup
    destroy() {
        this.stop();
        if (this.canvas && this.canvas.parentNode) {
            this.canvas.parentNode.removeChild(this.canvas);
        }
    }
}

// Specialized particle systems
class FloatingParticles extends ParticleSystem {
    constructor(container) {
        super(container, {
            particleCount: 30,
            particleSize: { min: 1, max: 3 },
            particleSpeed: { min: 0.2, max: 0.8 },
            particleLife: { min: 15, max: 25 },
            particleColor: 'rgba(0, 212, 255, 0.4)',
            particleShape: 'circle',
            gravity: -0.02,
            wind: 0.01,
            mouseInteraction: true
        });
    }
}

class CodeParticles extends ParticleSystem {
    constructor(container) {
        super(container, {
            particleCount: 20,
            particleSize: { min: 2, max: 5 },
            particleSpeed: { min: 0.5, max: 1.5 },
            particleLife: { min: 8, max: 15 },
            particleColor: 'rgba(0, 255, 0, 0.6)',
            particleShape: 'square',
            gravity: 0.05,
            wind: 0,
            mouseInteraction: false
        });
    }
}

class GlowParticles extends ParticleSystem {
    constructor(container) {
        super(container, {
            particleCount: 15,
            particleSize: { min: 3, max: 8 },
            particleSpeed: { min: 0.1, max: 0.5 },
            particleLife: { min: 20, max: 30 },
            particleColor: 'rgba(255, 107, 107, 0.3)',
            particleShape: 'star',
            gravity: 0,
            wind: 0.02,
            mouseInteraction: true
        });
    }
}

// Initialize particle systems when DOM is loaded
document.addEventListener('DOMContentLoaded', function() {
    // Hero particles
    const heroParticles = document.getElementById('particles');
    if (heroParticles) {
        new FloatingParticles(heroParticles);
    }
    
    // Code window particles
    const codeWindow = document.querySelector('.code-window');
    if (codeWindow) {
        new CodeParticles(codeWindow);
    }
    
    // Background glow particles
    const heroBackground = document.querySelector('.hero-background');
    if (heroBackground) {
        new GlowParticles(heroBackground);
    }
});

// Export for external use
window.ParticleSystem = ParticleSystem;
window.FloatingParticles = FloatingParticles;
window.CodeParticles = CodeParticles;
window.GlowParticles = GlowParticles;