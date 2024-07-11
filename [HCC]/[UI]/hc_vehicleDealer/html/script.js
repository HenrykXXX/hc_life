document.addEventListener('DOMContentLoaded', function() {
    const colorItems = document.querySelectorAll('.color-list .color');
    colorItems.forEach(item => {
        item.addEventListener('click', function() {
            const color = this.getAttribute('data-color');
            if (selectedVeh) {
                selectedVeh.color = color;
                //selectVeh(selectedVeh); // Update display with selected color
            }
        });
    });
});

// script.js
window.addEventListener('message', function(event) {
    if (event.data.type === "show") {
        updateVehicles(event.data.vehs);
        
        document.body.style.display = 'block' ;
    }
});

function updateVehicles(vehs) {
    const ul = document.getElementById('carList');
    ul.innerHTML = '';
    const firstVeh = vehs[0];
    vehs.forEach(veh => {
        //<li class="list car-listed">Adder</li>
        const li = document.createElement('li');
        li.textContent = `${veh.name} - $${veh.price}`;
        li.className = 'list car-listed';
        li.onclick = () => selectVeh(veh);
        ul.appendChild(li);
    });
    selectVeh(firstVeh);
    selectVeh.color = '0';
}

let selectedVeh = null;

function selectVeh(veh) {
    console.log("select");
    selectedVeh = veh;

    document.getElementById('carName').textContent = veh.name;
    //document.getElementById('carImage').src = data.image;
    document.getElementById('carSpeed').textContent = `Speed: ${veh.maxSpeed} km/h`;
    document.getElementById('carSeats').textContent = `Seats: ${veh.seats}`;
    document.getElementById('carTrunk').textContent = `Trunk space: ${veh.trunkSpace}kg`;
    document.getElementById('car-price').textContent = `Price: $${veh.price}`;
}

function buyVeh() {
    if (selectedVeh) {
        fetch(`https://${GetParentResourceName()}/buyVeh`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({ veh: selectedVeh })
        }).then(res => res.json()).then(data => {
            console.log(data);
        });
        hideVehDealer();
    }
}

function hideVehDealer() {
    document.body.style.display = 'none';
        fetch(`https://${GetParentResourceName()}/hide`, {
            method: 'POST'
        }).then(resp => resp.json()).then(resp => console.log(resp));
}


document.addEventListener('keyup', function(event) {
    if (event.key === 'Escape' || event.keyCode === 27) {
        hideVehDealer();
    }
});

