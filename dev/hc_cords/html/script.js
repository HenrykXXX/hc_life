window.addEventListener('message', function(event) {
    if (event.data.type === "show") {
        document.body.style.display = 'flex';
    } else if (event.data.action === 'setCoords') {
        // Convert string to an array, assuming coordinates are separated by a comma and a space
        const coordsArray = event.data.coords.split(', ').map(Number);
        
        // Round coordinates to full values
        const roundedCoords = coordsArray.map(coord => Math.round(coord));
        
        // Set rounded coordinates to the coordinate box
        const coordBox = document.getElementById('coordBox');
        coordBox.value = roundedCoords.join(', ');
    }
});;

document.addEventListener('keydown', function(event) {
    if (event.key === 'Backspace' || event.keyCode === 8) {
        document.body.style.display = 'none';
        fetch(`https://${GetParentResourceName()}/HideCords`, {
            method: 'POST'
        }).then(resp => resp.json()).then(resp => console.log(resp));
    }
});

