document.addEventListener('DOMContentLoaded', () => {
    const themeToggle = document.getElementById('theme-toggle');
    const iconMoon = document.querySelector('.icon-moon');
    const iconSun = document.querySelector('.icon-sun');

    function updateIcons(isDark) {
        if (isDark) {
            iconMoon.style.display = 'none';
            iconSun.style.display = 'block';
        } else {
            iconMoon.style.display = 'block';
            iconSun.style.display = 'none';
        }
    }

    // Initialize icons based on the class set by our head script
    const isInitiallyDark = document.documentElement.classList.contains('dark');
    updateIcons(isInitiallyDark);

    themeToggle.addEventListener('click', (e) => {
        const isDark = document.documentElement.classList.contains('dark');
        const willBeDark = !isDark;

        function applyTheme() {
            document.documentElement.classList.toggle('dark');
            updateIcons(willBeDark);
            localStorage.setItem('theme', willBeDark ? 'dark' : 'light');
        }

        // Fallback for browsers that don't support View Transitions API
        if (!document.startViewTransition) {
            applyTheme();
            return;
        }

        // Get click origin (center of the button)
        const rect = themeToggle.getBoundingClientRect();
        const x = rect.left + rect.width / 2;
        const y = rect.top + rect.height / 2;

        // Calculate max distance to corners for exact circle size
        const endRadius = Math.hypot(
            Math.max(x, innerWidth - x),
            Math.max(y, innerHeight - y)
        );

        // Execute the toggle inside the transition API
        const transition = document.startViewTransition(() => {
            applyTheme();
        });

        // Animate after state updates
        transition.ready.then(() => {
            document.documentElement.animate(
                {
                    clipPath: [
                        `circle(0px at ${x}px ${y}px)`,
                        `circle(${endRadius}px at ${x}px ${y}px)`
                    ]
                },
                {
                    duration: 800,
                    easing: 'cubic-bezier(0.645, 0.045, 0.355, 1)',
                    pseudoElement: '::view-transition-new(root)'
                }
            );
        });
    });

    // Copy button handler
    const copyBtn = document.getElementById('copy-btn');
    const copyText = document.getElementById('copy-text')
        ? document.getElementById('copy-text').textContent
        : 'flutter pub add flutter_theme_circle_animation';

    if (copyBtn) {
        copyBtn.addEventListener('click', () => {
            navigator.clipboard.writeText(copyText).then(() => {
                const originalSvg = copyBtn.innerHTML;
                copyBtn.innerHTML = `
                    <svg viewBox="0 0 24 24" width="20" height="20">
                        <polyline points="20 6 9 17 4 12"></polyline>
                    </svg>
                `;
                setTimeout(() => {
                    copyBtn.innerHTML = originalSvg;
                }, 2000);
            });
        });
    }
});
