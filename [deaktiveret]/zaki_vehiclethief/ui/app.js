// Main application logic
document.addEventListener("DOMContentLoaded", () => {
  // Initialize the UI but don't show it
  initUI()

  // Listen for NUI messages from the FiveM client
  window.addEventListener("message", (event) => {
    const data = event.data

    if (data.type === "open") {
      openUI()
      if (data.level) {
        updateUI(data)
      }
    } else if (data.type === "close") {
      closeUI()
    } else if (data.type === "update") {
      updateUI(data)
    }
  })

  // Close on ESC key
  document.addEventListener("keyup", (event) => {
    if (event.key === "Escape") {
      closeUI()
    }
  })
})

// Open UI with animation
function openUI() {
  const app = document.getElementById("app")
  const container = document.querySelector(".container")

  app.style.display = "flex"

  // Trigger reflow
  void container.offsetWidth

  // Add visible class for animation
  setTimeout(() => {
    container.classList.add("visible")
  }, 50)
}

// Close UI with animation
function closeUI() {
  const app = document.getElementById("app")
  const container = document.querySelector(".container")

  container.classList.remove("visible")

  // Wait for animation to complete
  setTimeout(() => {
    app.style.display = "none"
    sendData("close", {})
  }, 300)
}

// Initialize the UI with sample data (will be replaced with real data)
function initUI() {
  // Set up tab switching
  const tabs = document.querySelectorAll(".tab")
  tabs.forEach((tab) => {
    tab.addEventListener("click", function () {
      const tabName = this.getAttribute("data-tab")

      // Remove active class from all tabs and content
      document.querySelectorAll(".tab").forEach((t) => t.classList.remove("active"))
      document.querySelectorAll(".tab-content").forEach((c) => {
        c.classList.remove("active")
      })

      // Add active class to clicked tab and corresponding content
      this.classList.add("active")

      // Add active class with a slight delay for animation
      setTimeout(() => {
        document.getElementById(`${tabName}-content`).classList.add("active")
      }, 50)
    })
  })

  // Add refresh button event listener
  document.getElementById("refresh-button").addEventListener("click", function () {
    this.classList.add("spinning")
    sendData("refreshData", {})

    // Remove spinning class after animation completes
    setTimeout(() => {
      this.classList.remove("spinning")
    }, 1000)
  })
}

// Update UI with data
function updateUI(data) {
  // Update level info
  if (data.level) {
    document.querySelector(".level-label").textContent = `${data.level.label} - `
    document.querySelector(".level-progress").textContent = `${data.level.current}/${data.level.max}`
    document.querySelector(".progress").style.width = `${data.level.percentage}%`
  }

  // Update refresh time
  if (data.refreshTime) {
    document.querySelector(".refresh-time").textContent = data.refreshTime
  }

  // Update vehicle count
  if (data.vehicleCount) {
    document.querySelector(".vehicle-count").textContent = data.vehicleCount
  }

  // Update public vehicles
  if (data.publicVehicles) {
    const publicGrid = document.querySelector("#public-content .vehicles-grid")
    publicGrid.innerHTML = ""

    if (data.publicVehicles.length === 0) {
      publicGrid.innerHTML = '<div class="no-vehicles">Ingen tilgængelige køretøjer</div>'
    } else {
      data.publicVehicles.forEach((vehicle, index) => {
        const card = createVehicleCard(vehicle, "public")
        card.style.animationDelay = `${index * 0.05}s`
        card.classList.add("slide-up")
        publicGrid.appendChild(card)
      })
    }
  }

  // Update personal vehicles
  if (data.personalVehicles) {
    const personalGrid = document.querySelector("#personal-content .vehicles-grid")
    personalGrid.innerHTML = ""

    if (data.personalVehicles.length === 0) {
      personalGrid.innerHTML = '<div class="no-vehicles">Ingen personlige køretøjer</div>'
    } else {
      data.personalVehicles.forEach((vehicle, index) => {
        const card = createVehicleCard(vehicle, "personal")
        card.style.animationDelay = `${index * 0.05}s`
        card.classList.add("slide-up")
        personalGrid.appendChild(card)
      })
    }
  }

  // Update user vehicles
  if (data.userVehicles) {
    const vehiclesGrid = document.querySelector("#vehicles-content .vehicles-grid")
    vehiclesGrid.innerHTML = ""

    if (data.userVehicles.length === 0) {
      vehiclesGrid.innerHTML = '<div class="no-vehicles">Ingen køretøjer i dit varehus</div>'
    } else {
      data.userVehicles.forEach((vehicle, index) => {
        const card = createVehicleCard(vehicle, "user")
        card.style.animationDelay = `${index * 0.05}s`
        card.classList.add("slide-up")
        vehiclesGrid.appendChild(card)
      })
    }
  }
}

// Create a vehicle card element
function createVehicleCard(vehicle, type) {
  const card = document.createElement("div")
  card.className = "vehicle-card"

  // Handle image loading errors
  const imageUrl = vehicle.image
  const fallbackImage = "ui/images/default.jpg"

  // Create card HTML based on vehicle type
  if (type === "public" || type === "personal") {
    let buyButtonClass = "buy-button"
    let buyButtonDisabled = ""
    let buyButtonText = '<i class="fas fa-shopping-cart"></i> Køb bil'

    if (!vehicle.canBuy) {
      buyButtonClass += " disabled"
      buyButtonDisabled = "disabled"

      // If player doesn't have enough EXP
      if (vehicle.playerExp < vehicle.requiredExp) {
        buyButtonText = '<i class="fas fa-lock"></i> Kræver mere EXP'
      } else {
        buyButtonText = '<i class="fas fa-exclamation-circle"></i> Har mission'
      }
    }

    card.innerHTML = `
            <div class="vehicle-image-container">
                <img src="${imageUrl}" alt="${vehicle.name}" class="vehicle-image" onerror="this.src='${fallbackImage}'">
            </div>
            <div class="vehicle-info">
                <h3 class="vehicle-name">${vehicle.name}</h3>
                <div class="vehicle-stats">
                    <div class="stat">
                        <span class="stat-label">Depositum</span>
                        <span class="stat-value">${vehicle.deposit}</span>
                    </div>
                    <div class="stat">
                        <span class="stat-label">Endelige Salgspris</span>
                        <span class="stat-value">${vehicle.sellPrice || 'Ikke tilgængelig'}</span>
                    </div>
                    <div class="stat">
                        <span class="stat-label">Påkrævet EXP</span>
                        <span class="stat-value">${vehicle.driverExp}</span>
                    </div>
                    <div class="stat">
                        <span class="stat-label">Belønnings EXP</span>
                        <span class="stat-value">${vehicle.expreward}</span>
                    </div>
                </div>
                <button class="${buyButtonClass}" data-id="${vehicle.id}" ${buyButtonDisabled}>
                    ${buyButtonText}
                </button>
                ${vehicle.countdown ? `<div class="countdown">Deltående: ${vehicle.countdown}</div>` : ""}
            </div>
        `

    // Add event listener to buy button
    const buyButton = card.querySelector(".buy-button")
    if (buyButton && !buyButton.classList.contains("disabled")) {
      buyButton.addEventListener("click", function () {
        const vehicleId = this.getAttribute("data-id")
        buyVehicle(vehicleId)
      })
    }
  } else if (type === "user") {
    let sellButtonClass = "buy-button"
    let sellButtonDisabled = ""
    let sellButtonText = '<i class="fas fa-dollar-sign"></i> Sælg bil'

    if (!vehicle.canSell) {
      sellButtonClass += " disabled"
      sellButtonDisabled = "disabled"
      sellButtonText = '<i class="fas fa-clock"></i> Venter...'
    }

    card.innerHTML = `
            <div class="vehicle-image-container">
                <img src="${imageUrl}" alt="${vehicle.name}" class="vehicle-image" onerror="this.src='${fallbackImage}'">
            </div>
            <div class="vehicle-info">
                <h3 class="vehicle-name">${vehicle.name}</h3>
                <div class="vehicle-stats">
                    <div class="stat">
                        <span class="stat-label">Gevinst</span>
                        <span class="stat-value">${vehicle.sellPrice || 'Ikke tilgængelig'}</span>
                    </div>
                    <div class="stat">
                        <span class="stat-label">Status</span>
                        <span class="stat-value">${vehicle.status}</span>
                    </div>
                </div>
                <button class="${sellButtonClass}" data-id="${vehicle.id}" ${sellButtonDisabled}>
                    ${sellButtonText}
                </button>
                ${vehicle.timeLeft ? `<div class="countdown">Tid tilbage: ${vehicle.timeLeft}</div>` : ""}
            </div>
        `

    // Add event listener to sell button
    const sellButton = card.querySelector(".buy-button")
    if (sellButton && !sellButton.classList.contains("disabled")) {
      sellButton.addEventListener("click", function () {
        const vehicleId = this.getAttribute("data-id")
        sellVehicle(vehicleId)
      })
    }
  }

  return card
}

// Buy a vehicle
function buyVehicle(vehicleId) {
  sendData("buyVehicle", { vehicleId: vehicleId })
}

// Sell a vehicle
function sellVehicle(vehicleId) {
  sendData("sellVehicle", { vehicleId: vehicleId })
}

// Send data to the FiveM client
function sendData(action, data) {
  const resourceName = GetParentResourceName()
  fetch(`https://${resourceName}/${action}`, {
    method: "POST",
    headers: {
      "Content-Type": "application/json; charset=UTF-8",
    },
    body: JSON.stringify(data),
  }).catch((error) => console.error("Error:", error))
}

