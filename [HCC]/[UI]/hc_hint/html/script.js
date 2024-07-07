window.addEventListener('message', function(event) {
    const type = event.data.type;

    if (type === "show") {
        showHint(event.data.msg);      
    }
});

document.addEventListener('DOMContentLoaded', () => {
    const hintContainer = document.getElementById('hintContainer');
});

function showHint(text) {
    const newHint = document.createElement('li');
    newHint.textContent = text;
    newHint.classList.add('hint');

    hintContainer.appendChild(newHint);

    setTimeout(() => {
        newHint.classList.remove('hint_show');
        
        setTimeout(() => {
            hintContainer.removeChild(newHint);
        }, 500);
    }, 5000);

    currentHint = newHint;
}