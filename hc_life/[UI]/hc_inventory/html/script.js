window.addEventListener('message', function(event) {
    if (event.data.type === "show") {
        updateInventory(event.data);
        document.getElementById('inventory-container').style.display = 'flex';
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
    document.getElementById('player-weight').textContent = `${data.currentWeight}/${data.maxWeight}kg`;
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
        document.getElementById('inventory-container').style.display = 'none';
        // Notify the game to handle the close event
        fetch(`https://${GetParentResourceName()}/hideInventory`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            }
        });
    }
});