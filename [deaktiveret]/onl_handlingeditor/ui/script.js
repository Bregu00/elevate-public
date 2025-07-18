console.log('Debug: Script loaded');

const handlingTemplate = `<fMass value="fMass_value"/>
<fInitialDragCoeff value="fInitialDragCoeff_value"/>
<fDownForceModifier value="fDownForceModifier_value"/>
<fPercentSubmerged value="fPercentSubmerged_value"/>
<vecCentreOfMassOffset x="vecCentreOfMassOffset_x_value" y="vecCentreOfMassOffset_y_value" z="vecCentreOfMassOffset_z_value"/>
<vecInertiaMultiplier x="vecInertiaMultiplier_x_value" y="vecInertiaMultiplier_y_value" z="vecInertiaMultiplier_z_value"/>
<fDriveBiasFront value="fDriveBiasFront_value"/>
<nInitialDriveGears value="nInitialDriveGears_value"/>
<fInitialDriveForce value="fInitialDriveForce_value"/>
<fDriveInertia value="fDriveInertia_value"/>
<fClutchChangeRateScaleUpShift value="fClutchChangeRateScaleUpShift_value"/>
<fClutchChangeRateScaleDownShift value="fClutchChangeRateScaleDownShift_value"/>
<fInitialDriveMaxFlatVel value="fInitialDriveMaxFlatVel_value"/>
<fBrakeForce value="fBrakeForce_value"/>
<fBrakeBiasFront value="fBrakeBiasFront_value"/>
<fHandBrakeForce value="fHandBrakeForce_value"/>
<fSteeringLock value="fSteeringLock_value"/>
<fTractionCurveMax value="fTractionCurveMax_value"/>
<fTractionCurveMin value="fTractionCurveMin_value"/>
<fTractionCurveLateral value="fTractionCurveLateral_value"/>
<fTractionSpringDeltaMax value="fTractionSpringDeltaMax_value"/>
<fLowSpeedTractionLossMult value="fLowSpeedTractionLossMult_value"/>
<fCamberStiffnesss value="fCamberStiffnesss_value"/>
<fTractionBiasFront value="fTractionBiasFront_value"/>
<fTractionLossMult value="fTractionLossMult_value"/>
<fSuspensionForce value="fSuspensionForce_value"/>
<fSuspensionCompDamp value="fSuspensionCompDamp_value"/>
<fSuspensionReboundDamp value="fSuspensionReboundDamp_value"/>
<fSuspensionUpperLimit value="fSuspensionUpperLimit_value"/>
<fSuspensionLowerLimit value="fSuspensionLowerLimit_value"/>
<fSuspensionRaise value="fSuspensionRaise_value"/>
<fSuspensionBiasFront value="fSuspensionBiasFront_value"/>
<fAntiRollBarForce value="fAntiRollBarForce_value"/>
<fAntiRollBarBiasFront value="fAntiRollBarBiasFront_value"/>
<fRollCentreHeightFront value="fRollCentreHeightFront_value"/>
<fRollCentreHeightRear value="fRollCentreHeightRear_value"/>
<fCollisionDamageMult value="fCollisionDamageMult_value"/>
<fWeaponDamageMult value="fWeaponDamageMult_value"/>
<fDeformationDamageMult value="fDeformationDamageMult_value"/>
<fEngineDamageMult value="fEngineDamageMult_value"/>
<fPetrolTankVolume value="fPetrolTankVolume_value"/>
<fOilVolume value="fOilVolume_value"/>
<fSeatOffsetDistX value="fSeatOffsetDistX_value"/>
<fSeatOffsetDistY value="fSeatOffsetDistY_value"/>
<fSeatOffsetDistZ value="fSeatOffsetDistZ_value"/>
<nMonetaryValue value="nMonetaryValue_value"/>`;
const resName = typeof GetParentResourceName == "function" ? GetParentResourceName() : "onl_handlingeditor";
const elements = {};

const handlingData = {
    categories: {
        engine: {
            title: "Engine & Mass",
            items: {
                fMass: {
                    name: "Mass",
                    description: "Vehicle mass in kilograms. Affects acceleration, braking, and collision physics.",
                    type: "float",
                    change: 100.0
                },
                fInitialDragCoeff: {
                    name: "Drag Coefficient",
                    description: "Air resistance. Higher values make the vehicle slow down faster at high speeds.",
                    type: "float",
                    change: 1.0
                },
                fPercentSubmerged: {
                    name: "Percent Submerged",
                    description: "How much of the vehicle needs to be submerged before it floats.",
                    type: "float",
                    change: 5.0
                },
                vecCentreOfMassOffset: {
                    name: "Centre of Mass Offset",
                    description: "Offset of the center of mass from the middle of the vehicle.",
                    type: "vector",
                    change: 0.1
                }
            }
        },
        transmission: {
            title: "Transmission",
            items: {
                fDriveBiasFront: {
                    name: "Drive Bias Front",
                    description: "Power distribution (0.0 = RWD, 1.0 = FWD, 0.5 = AWD).",
                    type: "float",
                    change: 0.05
                },
                nInitialDriveGears: {
                    name: "Drive Gears",
                    description: "Number of forward gears.",
                    type: "int",
                    change: 1
                },
                fInitialDriveForce: {
                    name: "Drive Force",
                    description: "Base engine power multiplier.",
                    type: "float",
                    change: 0.1
                },
                fDriveInertia: {
                    name: "Drive Inertia",
                    description: "Engine rev speed.",
                    type: "float",
                    change: 1.0
                },
                fInitialDriveMaxFlatVel: {
                    name: "Max Flat Velocity",
                    description: "Maximum speed in high gear.",
                    type: "float",
                    change: 5.0
                }
            }
        },
        braking: {
            title: "Braking",
            items: {
                fBrakeForce: {
                    name: "Brake Force",
                    description: "Base braking power.",
                    type: "float",
                    change: 0.2
                },
                fBrakeBiasFront: {
                    name: "Brake Bias Front",
                    description: "Brake distribution (0.0 = rear, 1.0 = front).",
                    type: "float",
                    change: 0.1
                },
                fHandBrakeForce: {
                    name: "Handbrake Force",
                    description: "Handbrake power.",
                    type: "float",
                    change: 0.2
                }
            }
        },
        traction: {
            title: "Traction & Handling",
            items: {
                fTractionCurveMax: {
                    name: "Traction Curve Max",
                    description: "Maximum grip multiplier.",
                    type: "float",
                    change: 0.1
                },
                fTractionCurveMin: {
                    name: "Traction Curve Min",
                    description: "Minimum grip multiplier.",
                    type: "float",
                    change: 0.1
                },
                fTractionCurveLateral: {
                    name: "Traction Curve Lateral",
                    description: "Cornering grip multiplier.",
                    type: "float",
                    change: 1.0
                },
                fTractionSpringDeltaMax: {
                    name: "Traction Spring Delta Max",
                    description: "Maximum suspension compression for grip.",
                    type: "float",
                    change: 0.1
                }
            }
        },
        suspension: {
            title: "Suspension",
            items: {
                fSuspensionForce: {
                    name: "Force",
                    description: "Suspension stiffness multiplier.",
                    type: "float",
                    change: 1.0
                },
                fSuspensionCompDamp: {
                    name: "Compression Damping",
                    description: "Damping during compression.",
                    type: "float",
                    change: 1.0
                },
                fSuspensionReboundDamp: {
                    name: "Rebound Damping",
                    description: "Damping during rebound.",
                    type: "float",
                    change: 1.0
                },
                fSuspensionUpperLimit: {
                    name: "Upper Limit",
                    description: "Maximum suspension height.",
                    type: "float",
                    change: 1.0
                },
                fSuspensionLowerLimit: {
                    name: "Lower Limit",
                    description: "Minimum suspension height.",
                    type: "float",
                    change: 1.0
                },
                fSuspensionRaise: {
                    name: "Raise Height",
                    description: "Suspension ride height.",
                    type: "float",
                    change: 1.0
                }
            }
        },
        damage: {
            title: "Damage & Misc",
            items: {
                fCollisionDamageMult: {
                    name: "Collision Damage",
                    description: "Damage from collisions.",
                    type: "float",
                    change: 1.0
                },
                fWeaponDamageMult: {
                    name: "Weapon Damage",
                    description: "Damage from weapons.",
                    type: "float",
                    change: 1.0
                },
                fDeformationDamageMult: {
                    name: "Deformation Damage",
                    description: "Visual damage from collisions.",
                    type: "float",
                    change: 1.0
                },
                fEngineDamageMult: {
                    name: "Engine Damage",
                    description: "Engine damage multiplier.",
                    type: "float",
                    change: 1.0
                }
            }
        }
    }
};

function generateUI() {
    try {
        console.log('Debug: Generating UI');
        const categoriesContainer = document.querySelector('.categories');
        if (!categoriesContainer) {
            console.error('Debug: Categories container not found');
            return;
        }

        categoriesContainer.innerHTML = '';

        for (const [categoryId, category] of Object.entries(handlingData.categories)) {
            const categoryElement = document.createElement('div');
            categoryElement.className = 'category';
            categoryElement.innerHTML = `
                <div class="category-header">
                    ${category.title}
                </div>
                <div class="category-content">
                    ${Object.entries(category.items).map(([itemId, item]) => `
                        <div class="handling-item">
                            <div class="handling-label">
                                <div class="handling-name">${item.name}</div>
                                <div class="handling-description">${item.description}</div>
                            </div>
                            <div class="handling-controls">
                                <input id="${itemId}" 
                                    type="number" 
                                    class="input" 
                                    value="0.0" 
                                    step="any"
                                    title="Enter value or use +/- buttons"
                                    placeholder="Enter value">
                                <button class="button" onclick="Add('${itemId}')" title="Increase value">+</button>
                                <button class="button" onclick="Substract('${itemId}')" title="Decrease value">-</button>
                            </div>
                        </div>
                    `).join('')}
                </div>
            `;
            categoriesContainer.appendChild(categoryElement);
        }

        // Initialize elements and add input handlers
        document.querySelectorAll('.input').forEach(input => {
            if (input && input.id) {
                elements[input.id] = input;
                
                // Handle manual input
                input.addEventListener("input", function() {
                    const value = this.value.trim();
                    if (value === "" || isNaN(value)) return;
                    
                    const numValue = Number(value);
                    Post("update", {
                        target: input.id,
                        value: numValue
                    });
                });

                // Handle focus events
                input.addEventListener("focus", function() {
                    this.select(); // Select all text when focused
                });

                // Handle enter key
                input.addEventListener("keydown", function(e) {
                    if (e.key === "Enter") {
                        this.blur(); // Remove focus when Enter is pressed
                    }
                });

                // Update value on blur (when input loses focus)
                input.addEventListener("blur", function() {
                    const value = this.value.trim();
                    if (value === "" || isNaN(value)) {
                        this.value = "0.0"; // Reset to default if invalid
                        return;
                    }
                    
                    const numValue = Number(value);
                    Post("update", {
                        target: input.id,
                        value: numValue
                    });
                });
            }
        });
    } catch (error) {
        console.error('Debug: Error generating UI:', error);
    }
}

window.onload = function() {
    try {
        generateUI();
        
        // Store references to all input elements
        const inputs = document.querySelectorAll('.input');
        if (inputs.length === 0) {
            console.error('No input elements found');
            return;
        }

        inputs.forEach(input => {
            if (!input || !input.id) return;
            
            elements[input.id] = input;
            input.addEventListener("input", function() {
                const value = Number(input.value);
                if (value) {
                    Post("update", {
                        target: input.id,
                        value: value
                    });
                }
            });
        });
    } catch (error) {
        console.error('Error initializing handling editor:', error);
    }
};

async function Post(name, data){
    try{
        const resp = await fetch(`https://${resName}/${name}`, {
            method: "POST",
            mode: "same-origin",
            headers: {
                "Accept": "application/json",
                "Content-Type": "application/json; charset=UTF-8"
            },
            body: data ? JSON.stringify(data) : "{}"
        });
        if(!resp.ok){
            return;
        }
        return await resp.json();
    }catch(err){}
}

function Add(name){
    const element = elements[name];
    if(element){
        const val = Number(element.value);
        if(typeof val == "number"){
            Post("change", {
                type: "add",
                target: name
            }).then(function(result){
                if(result!=false){
                    element.value = result;
                }
            });
        }
    }
}

function Substract(name){
    const element = elements[name];
    if(element){
        const val = Number(element.value);
        if(typeof val == "number"){
            Post("change", {
                type: "substract",
                target: name
            }).then(function(result){
                if(result!=false){
                    element.value = result;
                }
            });
        }
    }
}

function Export(){
    let result = handlingTemplate;
    for (const k in elements){
        result = result.replaceAll(`${k}_value`, elements[k].value);
    }
    const element = document.createElement("textarea");
    element.value = result;
    document.body.appendChild(element);
    element.select();
    document.execCommand("copy");
    document.body.removeChild(element);
}

window.addEventListener("message", function(event) {
    try {
        console.log('Debug: Received message:', event.data);
    let e = event.data;
        if (e.action == "show") {
            console.log('Debug: Show action received');
            generateUI();
            for (const [key, value] of Object.entries(e.handling || {})) {
                if (elements[key]) {
                    elements[key].value = value;
                    console.log(`Debug: Set ${key} to ${value}`);
                }
            }
            const container = document.getElementById('container');
            if (container) {
                container.classList.add('show');
                console.log('Debug: Container displayed');
            }
        } else if (e.action == "hide") {
            console.log('Debug: Hide action received');
            const container = document.getElementById('container');
            if (container) {
                container.classList.remove('show');
            }
        }
    } catch (error) {
        console.error('Debug: Error handling message:', error);
    }
});

window.addEventListener("keydown", function(e) {
    if (e.key == "Escape") {
        const container = document.getElementById('container');
        if (container) {
            container.classList.remove('show');
        }
        Post("close");
    }
});

// Replace the existing Import function with these new functions
function Import() {
    const dialog = document.getElementById('import-dialog');
    const textarea = document.getElementById('import-data');
    textarea.value = ''; // Clear previous content
    dialog.classList.add('show');
}

function CloseImportDialog() {
    const dialog = document.getElementById('import-dialog');
    dialog.classList.remove('show');
}

function ApplyImport() {
    const textarea = document.getElementById('import-data');
    const text = textarea.value.trim();
    
    if (!text) {
        return;
    }
    
    try {
        // Wrap the handling data in a root element for proper parsing
        const wrappedText = `<handling>${text}</handling>`;
        const parser = new DOMParser();
        const xmlDoc = parser.parseFromString(wrappedText, "text/xml");
        
        // Extract values from the XML
        const newValues = {};
        
        // Handle regular float/int values
        for (const key in elements) {
            const elem = xmlDoc.querySelector(key);
            if (elem && elem.getAttribute('value')) {
                const value = Number(elem.getAttribute('value'));
                if (!isNaN(value)) {
                    newValues[key] = value;
                    console.log(`Importing ${key}: ${value}`);
                }
            }
        }
        
        // Handle vector values (special case)
        ['vecCentreOfMassOffset', 'vecInertiaMultiplier'].forEach(vectorName => {
            const elem = xmlDoc.querySelector(vectorName);
            if (elem) {
                const x = elem.getAttribute('x');
                const y = elem.getAttribute('y');
                const z = elem.getAttribute('z');
                if (x) newValues[vectorName + '_x'] = Number(x);
                if (y) newValues[vectorName + '_y'] = Number(y);
                if (z) newValues[vectorName + '_z'] = Number(z);
                console.log(`Importing ${vectorName}: x=${x}, y=${y}, z=${z}`);
            }
        });
        
        // Update all the values
        let updatedCount = 0;
        Object.entries(newValues).forEach(([key, value]) => {
            if (elements[key] && !isNaN(value)) {
                elements[key].value = value;
                Post("update", {
                    target: key,
                    value: value
                });
                updatedCount++;
            }
        });
        
        console.log(`Successfully imported ${updatedCount} values`);
        CloseImportDialog(); // Close dialog after successful import
        
    } catch (error) {
        console.error('Error importing handling data:', error);
    }
}