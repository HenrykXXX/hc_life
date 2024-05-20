window.addEventListener('message', function(event) {
    const type = event.data.type;

    if (type === "show") {
        updateInventory(event.data);
        document.getElementById('container').style.display = 'flex';
        if (event.data.shopItems) {
            console.log("shop items recieved");
            updateMarket(event.data);
        }
    }
});

document.getElementById('sell-item-button').addEventListener('click', function() {
    const selectedItem = document.querySelector('#player-item-list li.selected');
    if (selectedItem) {
        const itemName = selectedItem.textContent.split(' - ')[0];
        const amount = parseInt(document.getElementById('sell-amount').value);
        if (!isNaN(amount) && amount > 0) {
            fetch(`https://${GetParentResourceName()}/sellItem`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify({ item: itemName, quantity: amount })
            }).then(response => {
                // Handle the response from the server if needed
                console.log(response);
            }).catch(error => {
                console.error('Error selling item:', error);
            });
        } else {
            console.log('Invalid sell amount');
        }
    } else {
        console.log('No item selected');
    }
});

function updateInventory(data) {
    document.getElementById('money').textContent = "Money: $" + data.money;
    document.getElementById('bank-money').textContent = "Bank Money: $" + data.bankMoney;

    const playerItemList = document.getElementById('player-item-list');
    playerItemList.innerHTML = ''; // Clear existing player items

    data.inventory.forEach(item => {
        const li = document.createElement('li');
        const itemImage = document.createElement('img');
        //itemImage.src = `images/${item[0]}.png`; // Assuming item images are stored in an "images" folder
        itemImage.classList.add('item-image');
        li.appendChild(itemImage);
        li.innerHTML += `${item[0]} - Quantity: ${item[1]}`;
        playerItemList.appendChild(li);
    });

    // Update max weight and current weight labels
    document.getElementById('player-title').textContent = "Inventory";
}

function updateMarket(data) {
    const marketItemList = document.getElementById('other-item-list');
    marketItemList.innerHTML = ''; // Clear existing player items

    data.shopItems.forEach(item => {
        const li = document.createElement('li');
        const itemImage = document.createElement('img');
        //itemImage.src = `images/${item[0]}.png`; // Assuming item images are stored in an "images" folder
        itemImage.classList.add('item-image');
        li.appendChild(itemImage);
        li.innerHTML += `${item.name} - $${item.price}`;
        marketItemList.appendChild(li);
    });
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

document.addEventListener('keydown', function(event) {
    if (event.key === 'Backspace' || event.keyCode === 8) {
        document.getElementById('container').style.display = 'none';
        // Notify the game to handle the close event
        fetch(`https://${GetParentResourceName()}/hideMarket`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            }
        });
    }
});