function selectSpawn(index) {
    fetch(`https://${GetParentResourceName()}/selectSpawn`, {
        method: "POST",
        headers: {
            'Content-Type': 'application/json; charset=UTF-8',
        },
        body: JSON.stringify({ spawnIndex: index })
    }).then(resp => resp.json()).then(data => {
        if (data === 'ok') {
            console.log('Spawn selected successfully');
        }
    });
}

window.addEventListener('message', event => {
    const item = event.data;
    if (item.type === 'show') {
        document.getElementById('spawn-menu').style.display = 'block';
    } else if (item.type === 'hide') {
        document.getElementById('spawn-menu').style.display = 'none';
    }
});