let selectedVehicle = null;

window.addEventListener('message', function(event) {
    if (event.data.type === "show") {
        updateGarage(event.data.vehicles);
        document.body.style.display = 'block';
    }
});

function updateGarage(vehicles) {
    const ul = document.getElementById('garage-vehicle-list');
    ul.innerHTML = '';
    vehicles.forEach(veh => {
        const li = document.createElement('li');
        li.textContent = `${veh.name} - ID: ${veh.key}`;
        li.className = 'list vehicle-listed';
        li.onclick = () => selectVehicle(veh);
        ul.appendChild(li);
    });
    if (vehicles.length > 0) {
        selectVehicle(vehicles[0]);
    }
}

function selectVehicle(veh) {
    selectedVehicle = veh;
    document.getElementById('vehicleName').textContent = veh.name;
    document.getElementById('vehicleSpeed').textContent = `Speed: ${veh.maxSpeed || '--'} km/h`;
    document.getElementById('vehicleSeats').textContent = `Seats: ${veh.seats || '--'}`;
    document.getElementById('vehicleTrunk').textContent = `Trunk space: ${veh.trunkSpace || '--'}kg`;
    document.getElementById('vehicleState').textContent = `State: ${veh.spawned ? 'Spawned' : 'In Garage'}`;
    document.getElementById('vehicle-price').textContent = `Model: ${veh.model}`;
}

function getVehicle() {
    if (selectedVehicle) {
        fetch(`https://${GetParentResourceName()}/getVehicle`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({ model: selectedVehicle.model, key: selectedVehicle.key })
        }).then(response => {
            console.log(response);
            hideGarage();
        }).catch(error => {
            console.error('Error getting vehicle:', error);
        });
    }
}

function hideGarage() {
    document.body.style.display = 'none';
    fetch(`https://${GetParentResourceName()}/hideGarage`, {
        method: 'POST'
    }).then(resp => resp.json()).then(resp => console.log(resp));
}

document.addEventListener('keyup', function(event) {
    if (event.key === 'Escape' || event.keyCode === 27) {
        hideGarage();
    }
});