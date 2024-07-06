const normalHandlingData = [
    'fEnginePower',
    'fMass',
    'fInitialDragCoeff',
    'fDownforceModifier',
    'fPercentSubmerged',
    'fDriveBiasFront',
    'nInitialDriveGears',
    'fInitialDriveForce',
    'fDriveInertia',
    'fClutchChangeRateScaleUpShift',
    'fClutchChangeRateScaleDownShift',
    'fInitialDriveMaxFlatVel',
    'fBrakeForce',
    'fBrakeBiasFront',
    'fHandBrakeForce',
    'fSteeringLock',
    'fTractionCurveMax',
    'fTractionCurveMin',
    'fTractionCurveLateral',
    'fTractionSpringDeltaMax',
    'fLowSpeedTractionLossMult',
    'fCamberStiffnesss',
    'fTractionBiasFront',
    'fTractionLossMult',
    'fSuspensionForce',
    'fSuspensionCompDamp',
    'fSuspensionReboundDamp',
    'fSuspensionUpperLimit',
    'fSuspensionLowerLimit',
    'fSuspensionRaise',
    'fSuspensionBiasFront',
    'fAntiRollBarForce',
    'fAntiRollBarBiasFront',
    'fRollCentreHeightFront',
    'fRollCentreHeightRear',
    'fCollisionDamageMult',
    'fWeaponDamageMult',
    'fDeformationDamageMult',
    'fEngineDamageMult',
    'fPetrolTankVolume',
    'fOilVolume',
    'fSeatOffsetDistX',
    'fSeatOffsetDistY',
    'fSeatOffsetDistZ',
    'nMonetaryValue'
];

const vectorHandlingData = [
    'vecCentreOfMassOffset',
    'vecInertiaMultiplier'
];

function createHandlingEditor() {
    const container = document.querySelector('.container');
    const grid = document.createElement('div');
    grid.className = 'grid';

    normalHandlingData.forEach(item => {
        const gridItem = document.createElement('div');
        gridItem.className = 'grid-item';

        const label = document.createElement('label');
        label.textContent = item;
        gridItem.appendChild(label);

        const input = document.createElement('input');
        input.type = 'number';
        input.step = '0.01';
        input.value = '1.0';
        gridItem.appendChild(input);

        const button = document.createElement('button');
        button.textContent = 'Set';
        button.addEventListener('click', () => {
            fetch(`https://${GetParentResourceName()}/setHandlingData`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify({
                    handlingType: item,
                    value: parseFloat(input.value)
                })
            });
        });
        gridItem.appendChild(button);

        grid.appendChild(gridItem);
    });

    vectorHandlingData.forEach(item => {
        const gridItem = document.createElement('div');
        gridItem.className = 'grid-item';

        const label = document.createElement('label');
        label.textContent = item;
        gridItem.appendChild(label);

        const inputX = document.createElement('input');
        inputX.type = 'number';
        inputX.step = '0.01';
        inputX.placeholder = 'X';
        gridItem.appendChild(inputX);

        const inputY = document.createElement('input');
        inputY.type = 'number';
        inputY.step = '0.01';
        inputY.placeholder = 'Y';
        gridItem.appendChild(inputY);

        const inputZ = document.createElement('input');
        inputZ.type = 'number';
        inputZ.step = '0.01';
        inputZ.placeholder = 'Z';
        gridItem.appendChild(inputZ);

        const button = document.createElement('button');
        button.textContent = 'Set';
        button.addEventListener('click', () => {
            fetch(`https://${GetParentResourceName()}/setHandlingData`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify({
                    handlingType: item,
                    value: {
                        x: parseFloat(inputX.value),
                        y: parseFloat(inputY.value),
                        z: parseFloat(inputZ.value)
                    }
                })
            });
        });
        gridItem.appendChild(button);

        grid.appendChild(gridItem);
    });

    container.appendChild(grid);
}

window.addEventListener('message', event => {
    if (event.data.type === 'show') {
        document.querySelector('.container').style.display = 'block';
    }
});

document.addEventListener('keyup', function(event) {
    if (event.key === 'Escape' || event.keyCode === 27) {
        document.querySelector('.container').style.display = 'none';
        fetch(`https://${GetParentResourceName()}/hideTunerShop`, {
            method: 'POST'
        }).then(resp => resp.json()).then(resp => console.log(resp));
    }
});

// Create the handling editor content when the page loads
document.addEventListener('DOMContentLoaded', createHandlingEditor);