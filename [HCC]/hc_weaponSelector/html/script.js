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
    if (event.data.type === "show") {
        document.body.style.display = 'flex' ;
    }
});

document.addEventListener('keyup', function(event) {
    if (event.key === 'Escape' || event.keyCode === 27) {
        document.body.style.display = 'none';
        fetch(`https://${GetParentResourceName()}/HideWeaponSelector`, {
            method: 'POST'
        }).then(resp => resp.json()).then(resp => console.log(resp));
    }
});