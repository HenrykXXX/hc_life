window.addEventListener('message', function(event) {
    const type = event.data.type;

    if (type === "show") {
        showHint(event.data.msg);      
    }
});


const hint = document.querySelector('.hint');

function showHint(msg) {
    document.getElementById('hint_text').textContent = msg;
    hint.classList.add('hint_show');
    setTimeout(hideHint, 5000);
}

function hideHint() {
    hint.classList.remove('hint_show');
}

document.addEventListener('click', () => {
    showHint();
    setTimeout(hideHint, 5000);
});