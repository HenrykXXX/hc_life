window.addEventListener('message', function(event) {
    if (event.data.type === "show") {
        updateBankData(event.data);
        document.getElementById('bank-container').style.display = 'block';
    }
});

function updateBankData(data) {
    document.getElementById('money').textContent = "Money: $" + data.money;
    document.getElementById('bank-money').textContent = "Bank Money: $" + data.bankMoney;
}

document.addEventListener('keydown', function(event) {
    if (event.key === 'Backspace' || event.keyCode === 8) {
        document.getElementById('bank-container').style.display = 'none';
        // Notify the game to handle the close event
        fetch(`https://${GetParentResourceName()}/hideBank`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            }
        });
    }
});

// Add the following lines at the end of the file
document.getElementById('withdraw-btn').addEventListener('click', function() {
    const amount = document.getElementById('amount').value;
    fetch(`https://${GetParentResourceName()}/withdrawMoney`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({ amount: amount })
    });
});

document.getElementById('deposit-btn').addEventListener('click', function() {
    const amount = document.getElementById('amount').value;
    fetch(`https://${GetParentResourceName()}/depositMoney`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({ amount: amount })
    });
});