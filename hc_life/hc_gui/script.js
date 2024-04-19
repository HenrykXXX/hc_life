function selectWeapon() {
    let selectedWeapon = document.getElementById('weapon-select').value;
    fetch(`https://${GetParentResourceName()}/selectWeapon`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json; charset=UTF-8',
        },
        body: JSON.stringify({
            weapon: selectedWeapon
        })
    }).then(resp => resp.json()).then(data => {
        if (data.success) {
            console.log('Weapon added successfully');
        }
    });
}

window.addEventListener('message', function(event) {
    if (event.data.type === "toggleVisibility") {
        document.body.style.display = event.data.show ? 'flex' : 'none';
    }
});

document.addEventListener('keydown', function(event) {
    if (event.key === 'e' || event.keyCode === 69) {  // 'E' key
        document.body.style.display = 'none';
        fetch(`https://${GetParentResourceName()}/HideWeaponSelector`, {
            method: 'POST'
        }).then(resp => resp.json()).then(resp => console.log(resp));
    }
});