window.addEventListener('message', function(event) {
    if (event.data.type === "show") {
        updateInventory(event.data);
        document.getElementById('inventory-container').style.display = 'block';
    }
});

function updateInventory(data) {
    document.getElementById('money').textContent = "Money: $" + data.money;
    document.getElementById('bank-money').textContent = "Bank Money: $" + data.bankMoney;

    const itemList = document.getElementById('item-list');
    itemList.innerHTML = ''; // Clear existing items

    data.inventory.forEach(item => {
        const li = document.createElement('li');
        li.textContent = `${item[0]} - Quantity: ${item[1]}`;
        itemList.appendChild(li);
    });
}

// Listen for NUI messages from Lua
window.addEventListener('message', function(event) {
    if (event.data.action === "display") {
        if (event.data.show) {
            document.getElementById('inventory-container').classList.remove('hidden');
        } else {
            document.getElementById('inventory-container').classList.add('hidden');
        }
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