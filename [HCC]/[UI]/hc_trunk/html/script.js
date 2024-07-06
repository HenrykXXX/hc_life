window.addEventListener('message', function(event) {
    const type = event.data.type;

    if (type === "show") {
        updateInventory(event.data);
        document.getElementById('container').style.display = 'flex';
        if (event.data.trunk) {
            updateTrunk(event.data);
        }
    }
});

function updateInventory(data) {
    const playerItemList = document.getElementById('player-item-list');
    playerItemList.innerHTML = ''; // Clear existing player items

    data.inventory.items.forEach(item => {
        const li = document.createElement('li');
        const itemImage = document.createElement('img');
        //itemImage.src = `images/${item[0]}.png`; // Assuming item images are stored in an "images" folder
        itemImage.classList.add('item-image');
        li.appendChild(itemImage);
        li.innerHTML += `${item.name} - Quantity: ${item.quantity}`;
        li.setAttribute("data-item", item.item);
        playerItemList.appendChild(li);
    });

    // Update max weight and current weight labels
    document.getElementById('player-title').textContent = "Inventory";
    document.getElementById('player-weight').textContent = `${data.inventory.currentWeight}/${data.inventory.maxWeight}kg`;
}

function updateTrunk(data) {
    const trunkItemList = document.getElementById('trunk-item-list');
    trunkItemList.innerHTML = ''; // Clear existing player items

    data.trunk.items.forEach(item => {
        const li = document.createElement('li');
        const itemImage = document.createElement('img');
        //itemImage.src = `images/${item[0]}.png`; // Assuming item images are stored in an "images" folder
        itemImage.classList.add('item-image');
        li.appendChild(itemImage);
        li.innerHTML += `${item.name} - Quantity: ${item.quantity}`;
        li.setAttribute("data-item", item.item);
        trunkItemList.appendChild(li);
    });

    document.getElementById('trunk-weight').textContent = `${data.trunk.currentWeight}/${data.trunk.maxWeight}kg`;
}


// Add click event listener for item selection
document.getElementById('player-item-list').addEventListener('click', function(event) {
    if (event.target && event.target.tagName === 'LI') {
        const selectedItem = document.querySelector('#player-item-list li.selected');
        if (selectedItem) {
            selectedItem.classList.remove('selected');
        }
        event.target.classList.add('selected');
    }
});

document.getElementById('trunk-item-list').addEventListener('click', function(event) {
    if (event.target && event.target.tagName === 'LI') {
        const selectedItem = document.querySelector('#other-item-list li.selected');
        if (selectedItem) {
            selectedItem.classList.remove('selected');
        }
        event.target.classList.add('selected');
    }
});


document.addEventListener('keyup', function(event) {
    if (event.key === 'Escape' || event.keyCode === 27) {
        document.getElementById('container').style.display = 'none';
        // Notify the game to handle the close event
        fetch(`https://${GetParentResourceName()}/hideTrunk`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            }
        });
    }
});

document.getElementById('trunk-item-button').addEventListener('click', function() {
    const selectedItem = document.querySelector('#trunk-item-list li.selected');
    if (selectedItem) {
        const itemName = selectedItem.getAttribute("data-item");
        const amount = parseInt(document.getElementById('trunk-amount').value);
        fetch(`https://${GetParentResourceName()}/getTrunkItem`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({ item: itemName, amount: amount })
        });
    }
});

document.getElementById('player-item-button').addEventListener('click', function() {
    const selectedItem = document.querySelector('#player-item-list li.selected');
    if (selectedItem) {
        const itemName = selectedItem.getAttribute("data-item");
        const amount = parseInt(document.getElementById('player-amount').value);
        fetch(`https://${GetParentResourceName()}/storePlayerItem`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({ item: itemName, amount: amount })
        });
    }
});