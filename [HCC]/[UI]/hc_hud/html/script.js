document.addEventListener('DOMContentLoaded', () => {
    const healthBar = document.querySelector('.health .bar');
    const armorBar = document.querySelector('.armor .bar');
    const foodBar = document.querySelector('.food .bar');
    const waterBar = document.querySelector('.water .bar');
    const energyBar = document.querySelector('.energy .bar');

    window.addEventListener('message', (event) => {
        const data = event.data;

        if (data.type === 'updateHUD') {
            updateStatBar(healthBar, data.health);
            updateStatBar(armorBar, data.armor);
            updateStatBar(foodBar, data.food);
            updateStatBar(waterBar, data.water);
            updateStatBar(energyBar, data.energy);
        }
    });

    function updateStatBar(element, value) {
        value = Math.max(0, Math.min(100, value)); // Ensure value is between 0 and 100
        element.style.width = `${value}%`;
    }
});