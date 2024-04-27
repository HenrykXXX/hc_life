let selectedItem = null;

window.addEventListener('message', function(event) {
    if (event.data.type === "show") {
        document.body.style.display = 'block' ;
        displayItems(event.data.inventory);
    }
});

function displayItems(items) {
    const itemList = document.getElementById('itemList');
    itemList.innerHTML = '';
    items.forEach(item => {
        let li = document.createElement('li');
        li.textContent = `${item[0]} (Qty: ${item[1]})`;
        li.onclick = () => {
            // Remove existing selection
            const currentlySelected = document.querySelector('.selected');
            if (currentlySelected) {
                currentlySelected.classList.remove('selected');
            }
            // Mark this item as selected
            li.classList.add('selected');
            selectedItem = item;
        };
        itemList.appendChild(li);
    });
}

function sellSelectedItem() {
    if (selectedItem) {
        fetch(`https://${GetParentResourceName()}/sellItem`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({
                item: selectedItem[0],
                quantity: selectedItem[1]
            })
        }).then(resp => resp.json()).then(data => console.log(data));
    }
}

document.addEventListener('keydown', function(event) {
    if (event.key === 'Backspace' || event.keyCode === 8) {
        document.body.style.display = 'none';
        fetch(`https://${GetParentResourceName()}/hideMarket`, {
            method: 'POST'
        }).then(resp => resp.json()).then(resp => console.log(resp));
    }
});