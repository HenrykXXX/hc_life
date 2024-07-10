// script.js
window.addEventListener('message', function(event) {
    if (event.data.type === "OPEN_MENU") {
        const cars = event.data.cars;
        const ul = document.getElementById('carList');
        ul.innerHTML = '';
        cars.forEach(car => {
            const li = document.createElement('li');
            li.textContent = `${car.name} - $${car.price}`;
            li.onclick = () => selectCar(car);
            ul.appendChild(li);
        });
        document.body.style.display = 'block' ;
    }
});

let selectedCar = null;

function selectCar(car) {
    selectedCar = car;
    fetch(`...`)
        .then(response => response.json())
        .then(data => {
            document.getElementById('carName').textContent = data.name;
            document.getElementById('carImage').src = data.image;
            document.getElementById('carSpeed').textContent = `Speed: ${data.speed}`;
            document.getElementById('carSeats').textContent = `Seats: ${data.seats}`;
            document.getElementById('carTrunk').textContent = `Trunk space: ${data.trunk}`;
            document.getElementById('carPrice').textContent = `Price: $${data.price}`;
        })
        .catch(error => console.error('Error fetching car details:', error));
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

document.addEventListener('keyup', function(event) {
    if (event.key === 'Escape' || event.keyCode === 27) {
        document.body.style.display = 'none';
        fetch(`https://${GetParentResourceName()}/hideCarDealer`, {
            method: 'POST'
        }).then(resp => resp.json()).then(resp => console.log(resp));
    }
});

