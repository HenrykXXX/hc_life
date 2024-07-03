window.addEventListener('message', function(event) {
    const type = event.data.type;

    if (type === "show") {
        updateGarage(event.data);
        document.getElementById('container').style.display = 'flex';
    }
});

document.getElementById('get-vehicle-button').addEventListener('click', function() {
    const selectedItem = document.querySelector('#garage-vehicle-list li.selected');
    if (selectedItem) {
        const model = selectedItem.getAttribute('data-model');
        const key = selectedItem.getAttribute('data-id');
        if (!isNaN(model)) {
            fetch(`https://${GetParentResourceName()}/getVehicle`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify({ model: model, key : key })
            }).then(response => {
                // Handle the response from the server if needed
                console.log(response);
            }).catch(error => {
                console.error('Error buying item:', error);
            });
        } else {
            console.log('Invalid buy amount');
        }
    } else {
        console.log('No item selected');
    }
});


function updateGarage(data) {
    const garageVehicleList = document.getElementById('garage-vehicle-list');
    garageVehicleList.innerHTML = ''; // Clear existing player items

    data.vehicles.forEach(veh => {
        const li = document.createElement('li');
        const itemImage = document.createElement('img');
        //itemImage.src = `images/${item[0]}.png`; // Assuming item images are stored in an "images" folder
        itemImage.classList.add('item-image');
        li.appendChild(itemImage);
        li.innerHTML += `Veh id: ${veh.key} - model: ${veh.name} - spawned ${veh.spawned}`;
        li.setAttribute('data-model', veh.model);
        li.setAttribute('data-id', veh.key);
        garageVehicleList.appendChild(li);
    });

}



document.getElementById('garage-vehicle-list').addEventListener('click', function(event) {
    if (event.target && event.target.tagName === 'LI') {
        const selectedItem = document.querySelector('#garage-vehicle-list li.selected');
        if (selectedItem) {
            selectedItem.classList.remove('selected');
        }
        event.target.classList.add('selected');
    }
});


document.addEventListener('keydown', function(event) {
    if (event.key === 'Escape' || event.keyCode === 27) {
        document.getElementById('container').style.display = 'none';
        // Notify the game to handle the close event
        fetch(`https://${GetParentResourceName()}/hideGarage`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            }
        });
    }
});