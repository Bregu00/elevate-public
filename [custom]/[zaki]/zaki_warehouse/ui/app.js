// Main application logic
document.addEventListener("DOMContentLoaded", () => {
  // Initialize the UI but don't show it
  initUI()

  // Listen for NUI messages from the FiveM client
  window.addEventListener("message", (event) => {
    const data = event.data

    if (data.type === "open") {
      openUI()
      if (data.warehouseData) {
        updateUI(data.warehouseData)
      }
    } else if (data.type === "close") {
      closeUI()
    } else if (data.type === "update") {
      updateUI(data.warehouseData)
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

// Initialize the UI with tab switching
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

  // Update crate count
  if (data.crateCount) {
    document.querySelector(".crate-count").textContent = data.crateCount
  }

  // Update available crates
  if (data.availableCrates) {
    const availableGrid = document.querySelector("#available-content .crates-grid")
    availableGrid.innerHTML = ""

    if (data.availableCrates.length === 0) {
      availableGrid.innerHTML = '<div class="no-crates">Ingen tilgængelige kasser</div>'
    } else {
      data.availableCrates.forEach((crate, index) => {
        const card = createCrateCard(crate, "available")
        card.style.animationDelay = `${index * 0.05}s`
        card.classList.add("slide-up")
        availableGrid.appendChild(card)
      })
    }
  }

  // Update warehouse crates
  if (data.warehouseCrates) {
    const warehouseGrid = document.querySelector("#warehouse-content .crates-grid")
    warehouseGrid.innerHTML = ""

    if (data.warehouseCrates.length === 0) {
      warehouseGrid.innerHTML = '<div class="no-crates">Ingen kasser i dit varehus</div>'
    } else {
      data.warehouseCrates.forEach((crate, index) => {
        const card = createCrateCard(crate, "warehouse")
        card.style.animationDelay = `${index * 0.05}s`
        card.classList.add("slide-up")
        warehouseGrid.appendChild(card)
      })
    }
  }

  // Update truck options
  if (data.hasTruck !== undefined) {
    const truckOptions = document.querySelector("#truck-content .truck-options")
    truckOptions.innerHTML = ""

    if (data.hasTruck) {
      // Show truck management options
      const spawnOption = document.createElement("div")
      spawnOption.className = "truck-option"
      spawnOption.innerHTML = `
        <div class="truck-option-title">
          <i class="fas fa-truck"></i> Spawn Lastbil
        </div>
        <div class="truck-option-description">
          Spawn din lastbil ved varehuset
        </div>
        <button class="truck-button" id="spawn-truck">
          <i class="fas fa-truck"></i> Spawn Lastbil
        </button>
      `
      truckOptions.appendChild(spawnOption)

      const returnOption = document.createElement("div")
      returnOption.className = "truck-option"
      returnOption.innerHTML = `
        <div class="truck-option-title">
          <i class="fas fa-undo"></i> Aflever Lastbil
        </div>
        <div class="truck-option-description">
          Aflever din lastbil ved varehuset
        </div>
        <button class="truck-button" id="return-truck">
          <i class="fas fa-undo"></i> Aflever Lastbil
        </button>
      `
      truckOptions.appendChild(returnOption)

      // Add event listeners
      document.getElementById("spawn-truck").addEventListener("click", () => {
        sendData("spawnTruck", {})
      })

      document.getElementById("return-truck").addEventListener("click", () => {
        sendData("returnTruck", {})
      })
    } else {
      // Show buy truck option
      const buyOption = document.createElement("div")
      buyOption.className = "truck-option"
      buyOption.innerHTML = `
        <div class="truck-option-title">
          <i class="fas fa-shopping-cart"></i> Køb Lastbil
        </div>
        <div class="truck-option-description">
          Køb en lastbil for at transportere kasser: ${data.truckPrice ? data.truckPrice : "50,000"} DKK
        </div>
        <button class="truck-button" id="buy-truck">
          <i class="fas fa-shopping-cart"></i> Køb Lastbil
        </button>
      `
      truckOptions.appendChild(buyOption)

      // Add event listener
      document.getElementById("buy-truck").addEventListener("click", () => {
        sendData("buyTruck", {})
      })
    }
  }
}

// Modify the createCrateCard function to use the crateId directly for image path
function createCrateCard(crate, type) {
  const card = document.createElement("div")
  card.className = "crate-card"

  // Use the crateId directly for the image path
  // If the image fails to load, it will fall back to the default crate.png
  const crateImage = `images/${crate.id}.jpg`
  const fallbackImage = "images/crate.png"

  // Create card HTML based on crate type
  if (type === "available") {
    let buyButtonClass = "buy-button"
    let buyButtonDisabled = ""
    let buyButtonText = '<i class="fas fa-shopping-cart"></i> Køb kasse'

    if (!crate.canBuy) {
      buyButtonClass += " disabled"
      buyButtonDisabled = "disabled"

      // If player doesn't have enough EXP
      if (crate.playerExp < crate.requiredExp) {
        buyButtonText = '<i class="fas fa-lock"></i> Kræver mere EXP'
      } else {
        buyButtonText = '<i class="fas fa-exclamation-circle"></i> Låst!'
      }
    }

    card.innerHTML = `
      <div class="crate-image-container">
        <img src="${crateImage}" class="crate-image" alt="${crate.name}" onerror="this.onerror=null; this.src='${fallbackImage}';">
      </div>
      <div class="crate-info">
        <h3 class="crate-name">${crate.name}</h3>
        <div class="crate-stats">
          <div class="stat">
            <span class="stat-label">Pris</span>
            <span class="stat-value">${crate.buyPrice}</span>
          </div>
          <div class="stat">
            <span class="stat-label">Gevinst</span>
            <span class="stat-value">${crate.sellPrice}</span>
          </div>
          <div class="stat">
            <span class="stat-label">Påkrævet EXP</span>
            <span class="stat-value">${crate.requiredExp}</span>
          </div>
          <div class="stat">
            <span class="stat-label">Belønnings EXP</span>
            <span class="stat-value">${crate.expReward}</span>
          </div>
        </div>
        <button class="${buyButtonClass}" data-id="${crate.id}" ${buyButtonDisabled}>
          ${buyButtonText}
        </button>
      </div>
    `

    // Add event listener to buy button
    const buyButton = card.querySelector(".buy-button")
    if (buyButton && !buyButton.classList.contains("disabled")) {
      buyButton.addEventListener("click", function () {
        const crateId = this.getAttribute("data-id")
        buyCrate(crateId, crate.name, crate.buyPrice)
      })
    }
  } else if (type === "warehouse") {
    let sellButtonClass = "sell-button"
    let sellButtonDisabled = ""
    let sellButtonText = '<i class="fas fa-dollar-sign"></i> Sælg kasse'
    let countdownText = ""

    if (!crate.canSell) {
      sellButtonClass += " disabled"
      sellButtonDisabled = "disabled"
      sellButtonText = '<i class="fas fa-clock"></i> Venter...'
      countdownText = `<div class="countdown">Tid tilbage: ${crate.timeLeft}</div>`
    }

    card.innerHTML = `
      <div class="crate-image-container">
        <img src="${crateImage}" class="crate-image" alt="${crate.name}" onerror="this.onerror=null; this.src='${fallbackImage}';">
      </div>
      <div class="crate-info">
        <h3 class="crate-name">${crate.name}</h3>
        <div class="crate-stats">
          <div class="stat">
            <span class="stat-label">Gevinst</span>
            <span class="stat-value">${crate.sellPrice}</span>
          </div>
          <div class="stat">
            <span class="stat-label">EXP Belønning</span>
            <span class="stat-value">${crate.expReward}</span>
          </div>
        </div>
        <button class="${sellButtonClass}" data-id="${crate.id}" ${sellButtonDisabled}>
          ${sellButtonText}
        </button>
        ${countdownText}
      </div>
    `

    // Add event listener to sell button
    const sellButton = card.querySelector(".sell-button")
    if (sellButton && !sellButton.classList.contains("disabled")) {
      sellButton.addEventListener("click", function () {
        const crateId = this.getAttribute("data-id")
        sellCrate(crateId)
      })
    }
  }

  return card
}

// Modify the buyCrate function to handle price formatting
function buyCrate(crateId, crateName, buyPrice) {
  // Extract just the number from the formatted price
  const rawPrice = typeof buyPrice === "string" ? buyPrice.replace(/[^0-9]/g, "") : buyPrice

  sendData("buyCrate", {
    crateId: crateId,
    crateName: crateName,
    buyPrice: Number.parseInt(rawPrice), // Send as a number
  })
}

// Sell a crate
function sellCrate(crateId) {
  sendData("sellCrate", { crateId: crateId })
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

// Declare GetParentResourceName if it's not available globally
if (typeof GetParentResourceName === "undefined") {
  function GetParentResourceName() {
    return "warehouse" // Replace 'warehouse' with your resource name if needed.  This is a fallback.
  }
}

