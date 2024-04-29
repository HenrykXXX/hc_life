// script.js
window.addEventListener('message', function(event) {
    if (event.data.type === "OPEN_MENU") {
        const cars = event.data.cars;
        const ul = document.getElementById('carList');
        ul.innerHTML = '';
        cars.forEach(car => {
            const li = document.createElement('li');
            li.textContent = `${car.carModel} - $${car.price}`;
            li.onclick = () => selectCar(car);
            ul.appendChild(li);
        });
        document.body.style.display = 'block' ;
    }
});

let selectedCar = null;

function selectCar(car) {
    selectedCar = car;
}

function buyCar() {
    if (selectedCar) {
        fetch(`https://${GetParentResourceName()}/buyCar`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({ car: selectedCar })
        }).then(res => res.json()).then(data => {
            console.log(data);
        });
    }
}

document.addEventListener('keydown', function(event) {
    if (event.key === 'Backspace' || event.keyCode === 8) {
        document.body.style.display = 'none';
        fetch(`https://${GetParentResourceName()}/hideCarDealer`, {
            method: 'POST'
        }).then(resp => resp.json()).then(resp => console.log(resp));
    }
});