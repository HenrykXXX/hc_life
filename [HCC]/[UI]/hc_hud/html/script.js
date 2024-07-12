document.addEventListener('DOMContentLoaded', () => {
    const healthBar = document.querySelector('.stats.health');
    const armorBar = document.querySelector('.stats.armor');
    const foodBar = document.querySelector('.stats.food');
    const waterBar = document.querySelector('.stats.water');
    const energyBar = document.querySelector('.stats.energy');

    window.addEventListener('message', (event) => {
        const data = event.data;

        if (data.type === 'updateHUD') {
            updateStatBar(healthBar, data.health, '❤️');
            updateStatBar(armorBar, data.armor, '🛡️');
            updateStatBar(foodBar, data.food, '🍗');
            updateStatBar(waterBar, data.water, '🥛');
            updateStatBar(energyBar, data.energy, '⚡');
        }
    });

    function updateStatBar(element, value, emoji) {
        value = Math.floor(value);
        element.style.width = `${value}px`;
        element.innerHTML = `${emoji}<p>${value}%</p>`;
    }
});
