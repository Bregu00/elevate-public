<template>
  <div :class="['blueprints-container', { hidden: !display }]">
    <div class="blueprints-header">
      <div class="header-title">
        <i class="fas fa-tools"></i>
        <h1>DATABASE</h1>
      </div>
      <div class="header-actions">
        <!-- Close button styled like a luk button -->
        <div class="window-button close" @click="closeApp">
          <i class="fas fa-times"></i>
          <span>Luk</span>
        </div>
      </div>
    </div>
    
    <div class="blueprints-content">
      <div class="apps-grid">
        <div 
          v-for="app in filteredApps" 
          :key="app.name" 
          class="app-item"
          @click="openApp(app)"
        >
          <div class="app-icon">
            <img v-if="app.img" :src="app.img" alt="" />
            <i v-else-if="app.icon" class="material-icons">{{ app.icon }}</i>
          </div>
          <div class="app-label">{{ app.label }}</div>
        </div>
      </div>
    </div>
    
    <!-- App Window -->
    <div v-if="selectedAppName !== ''" class="app-window">
      <div class="window-header">
        <h2>{{ selectedTitle }}</h2>
        <div class="window-actions">
          <div class="window-button back" @click="closeSelectedApp">
            <i class="fas fa-arrow-left"></i>
            <span>Tilbage</span>
          </div>
          <div class="window-button close" @click="closeApp">
            <i class="fas fa-times"></i>
            <span>Luk</span>
          </div>
        </div>
      </div>
      <div class="window-content">
        <!-- Politi Database -->
        <div v-if="selectedAppName === 'policedatabase'" class="database-content">
          <div class="database-search">
            <input 
              type="text" 
              placeholder="Søg efter Navn, telefonnummer eller fødselsdato..." 
              v-model="policeSearchQuery" 
              @input="debouncedSearchPoliceDatabase"
            >
            <button @click="searchPoliceDatabase">Søg</button>
          </div>
          
          <div class="database-table">
            <table>
              <thead>
                <tr>
                  <th>Navn</th>
                  <th>Fødselsdato</th>
                  <th>Telefonnummer</th>
                  <th>Handling</th>
                </tr>
              </thead>
              <tbody>
                <tr v-for="(person, index) in policeRecords" :key="index">
                  <td>{{ person.label }}</td>
                  <td>{{ person.dateofbirth }}</td> 
                  <td>{{ person.phone_number }}</td> 
                  <td>
                    <button class="action-button">Vis detaljer</button>
                  </td>
                </tr>
              </tbody>
            </table>
          </div>
        </div>
        
        <!-- Fængselssystem -->
        <div v-if="selectedAppName === 'kriminal'" class="database-content">
          <div class="database-header">
            <h3>Aktive Indsatte</h3>
            <div class="header-actions">
              <button class="primary-button" @click="addInmate">Ny Indsættelse</button>
            </div>
          </div>
          
          <div class="database-table">
            <table>
              <thead>
                <tr>
                  <th>ID</th>
                  <th>Navn</th>
                  <th>Løsladelses Tidspunkt</th>
                  <th>Status</th>
                  <th>Handling</th>
                </tr>
              </thead>
              <tbody>
                <tr v-for="(inmate, index) in inmates" :key="index">
                  <td>{{ inmate.id }}</td>
                  <td>{{ inmate.name }}</td>
                  <td>{{ inmate.endDate }}</td>
                  <td>
                    <span :class="inmate.online ? 'status-online' : 'status-offline'">
                      {{ inmate.online ? 'Online' : 'Offline' }}
                    </span>
                  </td>
                  <td>
                    <button class="action-button" @click="manageInmate(inmate.id)">Administrer</button>
                  </td>
                </tr>
              </tbody>
            </table>
          </div>
        </div>
        
        <!-- Leasing Database -->
        <div v-if="selectedAppName === 'leasingdatabase'" class="database-content">
          <div class="database-header">
            <h3>Aktive Leasingkontrakter</h3>
          </div>
          
          <div class="database-table">
            <table>
              <thead>
                <tr>
                  <th>ID</th>
                  <th>Låner</th>
                  <th>Nummerplade</th>
                  <th>Model</th>
                  <th>Pris</th>
                  <th>Start Dato</th>
                  <th>Slut Dato</th>
                  <th>Handlinger</th>
                </tr>
              </thead>
              <tbody>
                <tr v-for="(vehicle, index) in leasingVehicles" :key="index">
                  <td>{{ vehicle.id }}</td>
                  <td>{{ vehicle.identifierLabel }}</td>
                  <td>{{ vehicle.plate }}</td>
                  <td>{{ vehicle.model }}</td>
                  <td>{{ vehicle.price }} DKK</td>
                  <td>{{ vehicle.startLabel }}</td>
                  <td>{{ vehicle.endLabel }}</td>
                  <td>
                    <div class="action-buttons">
                      <button 
                        class="action-button small" 
                        @click="extendLeasing(vehicle.id)" 
                        :disabled="playerJobGrade < jobGradeRequirements.extendLeasing"
                        :title="playerJobGrade < jobGradeRequirements.extendLeasing ? `Du har ikke tilstrækkelig jobgrad til at forlænge leasingkontrakter (kræver grad ${jobGradeRequirements.extendLeasing})` : ''"
                      >Forlæng</button>
                      <button 
                        class="action-button small danger" 
                        @click="withdrawLeasing(vehicle.id)" 
                        :disabled="playerJobGrade < jobGradeRequirements.withdrawLeasing"
                        :title="playerJobGrade < jobGradeRequirements.withdrawLeasing ? `Du har ikke tilstrækkelig jobgrad til at trække leasingkontrakter tilbage (kræver grad ${jobGradeRequirements.withdrawLeasing})` : ''"
                      >Træk Tilbage</button>
                    </div>
                  </td>
                </tr>
              </tbody>
            </table>
          </div>
        </div>

        <div v-if="selectedAppName === 'ownedvehicles'" class="database-content">
          <div class="database-header">
            <h3>Mine Køretøjer</h3>
            <div class="header-actions">
              <input 
                type="text" 
                placeholder="Søg efter køretøj..." 
                v-model="ownedVehiclesSearchQuery" 
                @input="filterOwnedVehicles"
                class="search-bar"
              />
            </div>
          </div>
          
          <div v-if="isLoadingOwnedVehicles" class="loading-container">
            <div class="loading-spinner"></div>
            <p>Indlæser køretøjer...</p>
          </div>
          
          <div v-else-if="ownedVehicles.length === 0" class="empty-state">
            <i class="fas fa-car-side fa-3x"></i>
            <p>Du har ingen køretøjer</p>
          </div>
          
          <div v-else class="database-table">
            <table>
              <thead>
                <tr>
                  <th>Navn</th>
                  <th>Nummerplade</th>
                  <th>Klasse</th>
                  <th>Handling</th>
                </tr>
              </thead>
              <tbody>
                <tr v-for="(vehicle, index) in filteredOwnedVehicles" :key="index">
                  <td>{{ vehicle.name }}</td>
                  <td>{{ vehicle.plate }}</td>
                  <td>{{ vehicle.class || 'Unknown' }}</td>
                  <td>
                    <button class="action-button small" @click="addToLeasing(vehicle)">
                      Tilføj til Leasing
                    </button>
                  </td>
                </tr>
              </tbody>
            </table>
          </div>
        </div>

        <!-- Leasing System -->
        <div v-if="selectedAppName === 'leasingsystem'" class="database-content">
          <div class="database-header">
            <h3>Leasing System</h3>
            <div class="header-actions">
              <input 
                type="text" 
                placeholder="Søg efter køretøj..." 
                v-model="leasingSearchQuery" 
                @input="filterLeasingSystemEntries"
                class="search-bar"
              />
            </div>
          </div>
          <div class="database-table">
            <table>
              <thead>
                <tr>
                  <th>Navn</th>
                  <th>Klasse</th>
                  <th>Nummerplade</th>
                  <th>Pris</th>
                  <th>Status</th>
                  <th>Leasing</th>
                  <th>Handling</th>
                </tr>
              </thead>
              <tbody>
                <tr v-for="(entry, index) in filteredLeasingSystemEntries" :key="index">
                  <td>{{ entry.name }}</td>
                  <td>{{ entry.class }}</td>
                  <td>{{ entry.plate }}</td>
                  <td>{{ entry.rate }} DKK/dag</td>
                  <td>
                    <span :class="entry.status === 'Ledig' ? 'status-available' : 'status-leased'">
                      {{ entry.status }}
                    </span>
                  </td>
                  <td>
                    <button 
                      class="action-button small" 
                      @click="openLeaseModal(entry)" 
                      :disabled="entry.status === 'Ikke Ledig'" 
                      :title="entry.status === 'Ikke Ledig' ? 'Køretøjet er allerede leaset' : ''"
                    >
                      Lease Køretøj
                    </button>
                  </td>
                  <td>
                    <button 
                      class="action-button small" 
                      @click="openManagementModal(entry)"
                      :disabled="playerJobGrade < jobGradeRequirements.settingsLeasing"
                      :title="playerJobGrade < jobGradeRequirements.settingsLeasing ? `Du har ikke tilstrækkelig jobgrad til at trække leasingkontrakter tilbage (kræver grad ${jobGradeRequirements.withdrawLeasing})` : ''"
                      >Handlinger</button>
                  </td>
                </tr>
              </tbody>
            </table>
          </div>
        </div>

        <!-- Vehicle Catalog -->
        <div v-if="selectedAppName === 'vehiclecatalog'" class="database-content">
          <div class="database-header">
            <h3>Køretøjs Katalog</h3>
            <div class="header-actions">
              <input 
                type="text" 
                placeholder="Søg efter køretøj..." 
                v-model="catalogSearchQuery" 
                @input="filterCatalogVehicles"
                class="search-bar"
              />
            </div>
          </div>
          
          <div v-if="filteredLeasingSystemEntries.length === 0" class="empty-state">
            <i class="fas fa-car-side fa-3x"></i>
            <p>Ingen ledige køretøjer fundet</p>
          </div>
          
          <div v-else class="vehicle-catalog-grid">
            <div 
              v-for="vehicle in availableCatalogVehicles" 
              :key="vehicle.id" 
              class="vehicle-catalog-card"
            >
              <div class="vehicle-catalog-image">
                <img 
                  :src="vehicle.imageUrl || '/placeholder.svg?height=200&width=300'" 
                  :alt="vehicle.name"
                  @error="handleImageError"
                />
              </div>
              <div class="vehicle-catalog-info">
                <h4>{{ vehicle.name }}</h4>
                <div class="vehicle-catalog-details">
                    <p><b>Klasse: </b> <span style="margin-left: 5px;">{{ vehicle.class }}</span></p>
                    <p><b>Dagspris: </b> <span style="margin-left: 5px;">{{ vehicle.rate.toLocaleString('da-DK', { minimumFractionDigits: 2, maximumFractionDigits: 2 }) }} DKK/dag </span></p>
                    <p><b>Førstegangs Ydelse: </b> <span style="margin-left: 5px;"> {{ (vehicle.rate * 5).toLocaleString('da-DK', { minimumFractionDigits: 2, maximumFractionDigits: 2 }) }} DKK</span></p>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Lease Vehicle Modal -->
    <div v-if="showLeaseModal" class="modal-overlay">
      <div class="modal-container">
        <div class="modal-header">
          <h3>Lease Køretøj: {{ selectedVehicle.name }}</h3>
          <button class="close-button" @click="closeLeaseModal">×</button>
        </div>
        <div class="modal-body">
          <div class="form-group">
            <label>Køretøj</label>
            <div class="vehicle-info">
              <p><strong>Model:</strong> {{ selectedVehicle.name }}</p>
              <p><strong>Klasse:</strong> {{ selectedVehicle.class }}</p>
              <p><strong>Basispris:</strong> {{ selectedVehicle.price }} DKK/dag</p>
            </div>
          </div>

          <div class="form-group">
            <label for="leaseLength">Leasing Periode</label>
            <div class="lease-length-container">
              <div class="lease-option" 
                   v-for="option in leaseLengthOptions" 
                   :key="option.value"
                   :class="{ 'selected': leaseLength === option.value }"
                   @click="leaseLength = option.value">
                {{ option.label }}
              </div>
            </div>
          </div>

          <div class="form-group">
            <label for="discount">Rabat (%)</label>
            <input 
              type="number" 
              id="discount" 
              v-model.number="discount" 
              min="0" 
              max="100" 
              class="form-input"
            />
          </div>
          
          <div class="form-group">
            <label for="player">Vælg Spiller</label>
            <select id="player" v-model="selectedPlayer" class="form-input">
              <option value="">Vælg en spiller...</option>
              <option v-for="player in onlinePlayers" :key="player.id" :value="player.id">
                {{ player.name }}
              </option>
            </select>
          </div>

          <div class="form-group">
            <label class="checkbox-container">
              Tilføj fuld tune til køretøjet
              <input type="checkbox" v-model="addFullTune">
              <span class="checkmark"></span>
            </label>
          </div>

          <div class="price-calculation">
            <div class="price-row">
              <span>Basispris:</span>
                <span>{{ selectedVehicle.rate.toLocaleString('da-DK', { minimumFractionDigits: 2, maximumFractionDigits: 2 }) }} DKK/dag</span>
            </div>
            <div class="price-row">
              <span>Periode:</span>
              <span>{{ getLeaseLengthLabel() }}</span>
            </div>
            <div class="price-row" v-if="discount > 0">
              <span>Rabat:</span>
              <span>{{ discount }}%</span>
            </div>
            <div class="price-row total">
              <span>Total pris:</span>
                <span>{{ calculateTotalPrice().toLocaleString('da-DK', { minimumFractionDigits: 2, maximumFractionDigits: 2 }) }} DKK</span>
            </div>
          </div>
        </div>
        <div class="modal-footer">
          <div class="modal-footer-left">
            <button class="back-button" @click="closeLeaseModal">Tilbage</button>
          </div>
          <div class="modal-footer-right">
            <button class="lease-button" @click="confirmLease" :disabled="!selectedPlayer">Lease</button>
          </div>
        </div>
      </div>
    </div>

  <!-- Extend Lease Modal -->
  <div v-if="showExtendModal" class="modal-overlay">
    <div class="modal-container">
      <div class="modal-header">
        <h3>Forlæng Leasing: {{ selectedVehicle.name || selectedVehicle.model }}</h3>
        <button class="close-button" @click="closeExtendModal">×</button>
      </div>
      <div class="modal-body">
        <div class="form-group">
          <label>Køretøj</label>
          <div class="vehicle-info">
            <p><strong>Model:</strong> {{ selectedVehicle.name || selectedVehicle.model }}</p>
            <p><strong>Nummerplade:</strong> {{ selectedVehicle.plate }}</p>
            <p><strong>Låner:</strong> {{ selectedVehicle.borrower }}</p>
            <p><strong>Nuværende slutdato:</strong> {{ selectedVehicle.endLabel }}</p>
          </div>
        </div>

        <div class="form-group">
          <label for="extendDays">Antal dage at forlænge med</label>
          <div class="lease-length-container">
            <div class="lease-option" 
                 v-for="option in extendDaysOptions" 
                 :key="option.value"
                 :class="{ 'selected': extendDays === option.value }"
                 @click="extendDays = option.value">
              {{ option.label }}
            </div>
          </div>
        </div>

        <div class="price-calculation">
          <div class="price-row">
            <span>Ny slutdato:</span>
            <span>{{ calculateNewEndDate(selectedVehicle.endDate, extendDays) }}</span>
          </div>
        </div>
      </div>
      <div class="modal-footer">
        <div class="modal-footer-left">
          <button class="back-button" @click="closeExtendModal">Tilbage</button>
        </div>
        <div class="modal-footer-right">
          <button 
            class="lease-button" 
            @click="confirmExtend" 
            :disabled="playerJobGrade < jobGradeRequirements.extendLeasing"
            :title="playerJobGrade < jobGradeRequirements.extendLeasing ? `Du har ikke tilstrækkelig jobgrad til at forlænge leasingkontrakter (kræver grad ${jobGradeRequirements.extendLeasing})` : ''"
          >Forlæng</button>
        </div>
      </div>
    </div>
  </div>

  <!-- Withdraw Lease Confirmation Modal -->
  <div v-if="showWithdrawModal" class="modal-overlay">
    <div class="modal-container">
      <div class="modal-header">
        <h3>Træk Leasing Tilbage</h3>
        <button class="close-button" @click="closeWithdrawModal">×</button>
      </div>
      <div class="modal-body">
        <div class="form-group">
          <label>Køretøj</label>
          <div class="vehicle-info">
            <p><strong>Model:</strong> {{ selectedVehicle.name || selectedVehicle.model }}</p>
            <p><strong>Nummerplade:</strong> {{ selectedVehicle.plate }}</p>
            <p><strong>Låner:</strong> {{ selectedVehicle.borrower }}</p>
          </div>
        </div>

        <div class="confirmation-message">
          <p>Er du sikker på, at du vil trække denne leasingkontrakt tilbage?</p>
          <p>Dette vil fjerne køretøjet fra databasen og kan ikke fortrydes.</p>
        </div>
      </div>
      <div class="modal-footer">
        <div class="modal-footer-left">
          <button class="back-button" @click="closeWithdrawModal">Annuller</button>
        </div>
        <div class="modal-footer-right">
          <button class="action-button danger" @click="confirmWithdraw" 
          :disabled="playerJobGrade < jobGradeRequirements.withdrawLeasing"
          :title="playerJobGrade < jobGradeRequirements.withdrawLeasing ? `Du har ikke tilstrækkelig jobgrad til at trække leasingkontrakter tilbage (kræver grad ${jobGradeRequirements.withdrawLeasing})` : ''"
          >Træk Tilbage</button>
        </div>
      </div>
    </div>
  </div>

  <!-- Add this new modal for adding to leasing -->
  <div v-if="showAddToLeasingModal" class="modal-overlay">
    <div class="modal-container">
      <div class="modal-header">
        <h3>Tilføj til Leasing: {{ selectedOwnedVehicle.name }}</h3>
        <button class="close-button" @click="closeAddToLeasingModal">×</button>
      </div>
      <div class="modal-body">
        <div class="form-group">
          <label>Køretøj</label>
          <div class="vehicle-info">
            <p><strong>Model:</strong> {{ selectedOwnedVehicle.name }}</p>
            <p><strong>Nummerplade:</strong> {{ selectedOwnedVehicle.plate }}</p>
            <p><strong>Model:</strong> {{ selectedOwnedVehicle.model }}</p>
          </div>
        </div>

        <div class="confirmation-message" style="border-left-color: #0077b6;">
          <p>Er du sikker på, at du vil tilføje dette køretøj til leasing systemet?</p>
          <p>Køretøjet vil blive tilgængeligt for alle at lease.</p>
        </div>
      </div>
      <div class="modal-footer">
        <div class="modal-footer-left">
          <button class="back-button" @click="closeAddToLeasingModal">Annuller</button>
        </div>
        <div class="modal-footer-right">
          <button class="lease-button" @click="confirmAddToLeasing">
            Tilføj til Leasing
          </button>
        </div>
      </div>
    </div>
  </div>

  <!-- Management Modal -->
  <div v-if="showManagementModal" class="modal-overlay">
    <div class="modal-container">
      <div class="modal-header">
        <h3>Administrer Køretøj: {{ selectedVehicle.name }}</h3>
        <button class="close-button" @click="closeManagementModal">×</button>
      </div>
      <div class="modal-body">
        <div class="form-group">
          <label>Køretøj</label>
          <div class="vehicle-info">
            <p><strong>Model: </strong> {{ selectedVehicle.name }}</p>
            <p><strong>Klasse: </strong> {{ selectedVehicle.class }}</p>
            <p><strong>Nummerplade: </strong> {{ selectedVehicle.plate }}</p>
            <p><strong>Nuværende pris: </strong> {{ selectedVehicle.rate }} DKK/dag</p>
          </div>
        </div>

        <div class="form-group">
          <label for="newPrice">Ny Pris (DKK/dag)</label>
          <input 
            type="number" 
            id="newPrice" 
            v-model.number="newPrice" 
            min="1" 
            class="form-input"
          />
        </div>

        <div class="form-group">
          <label for="vehicleImageUrl">Køretøj Billede URL</label>
          <input 
            type="text" 
            id="vehicleImageUrl" 
            v-model="vehicleImageUrl" 
            placeholder="Indtast URL til køretøjsbillede" 
            class="form-input"
          />
          <div class="image-preview" v-if="vehicleImageUrl">
            <img 
              :src="vehicleImageUrl" 
              alt="Køretøj Preview" 
              @error="handleImageError"
            />
          </div>
        </div>

        <div class="action-buttons-container">
          <button class="management-button update" @click="updateVehiclePrice">
            <i class="fas fa-dollar-sign"></i> Opdater Køretøjet
          </button>
          
          <button class="management-button reclaim" @click="reclaimVehicle">
            <i class="fas fa-undo"></i> Tag Køretøj Tilbage
          </button>
        </div>
      </div>
      <div class="modal-footer">
        <div class="modal-footer-left">
          <button class="back-button" @click="closeManagementModal">Annuller</button>
        </div>
      </div>
    </div>
  </div>
  </div>
</template>

<script>
export default {
  data() {
    return {
      display: false, // Add a display state to control visibility
      availableApps: [
        { name: 'policedatabase', label: 'Politi Database', img: 'https://media.discordapp.net/attachments/1339033355764891658/1353919653591646279/politi.png' },
        { name: 'kriminal', label: 'Fængselssystem', img: 'https://hebbkx1anhila5yf.public.blob.vercel-storage.com/prison-9d5YaRXtv3SwilBANoP5mhtOco0wfr.png' },
        { name: 'leasingsystem', label: 'Leasing System', img: 'https://i.fmfile.com/BRWrPjUjPmdLyNSjUbzVD/Pa0zoYN.png' },
        { name: 'leasingdatabase', label: 'Leasing Database', img: 'https://i.fmfile.com/BRWrPjUjPmdLyNSjUbzVD/Pa0zoYN.png' },
        { name: 'ownedvehicles', label: 'Leasing Køretøjer', img: 'https://i.fmfile.com/BRWrPjUjPmdLyNSjUbzVD/Pa0zoYN.png' },
        { name: 'vehiclecatalog', label: 'Køretøjs Katalog', img: 'https://i.fmfile.com/BRWrPjUjPmdLyNSjUbzVD/Pa0zoYN.png' },
      ],
      filteredApps: [], // Filtered apps based on the player's job
      requiredJobs: {}, // Store the required jobs fetched from the client
      playerJobGrade: 0, // Add this line to store the player's job grade
      selectedTitle: '',
      selectedAppName: '',
      selectedApp: [],
      policeSearchQuery: '',
      searchTimeout: null,
      policeRecords: [],
      inmates: [
        { id: 1001, name: 'Mikkel Rasmussen', cell: 'A-12', startDate: '10-03-2023', endDate: '15-06-2023', online: true },
        { id: 1002, name: 'Jonas Christensen', cell: 'B-05', startDate: '22-02-2023', endDate: '22-05-2023', online: false },
        { id: 1003, name: 'Frederik Larsen', cell: 'A-08', startDate: '05-04-2023', endDate: '05-07-2023', online: true },
        { id: 1004, name: 'Emma Sørensen', cell: 'C-03', startDate: '18-03-2023', endDate: '18-09-2023', online: true },
        { id: 1005, name: 'Oliver Madsen', cell: 'B-11', startDate: '01-04-2023', endDate: '01-05-2023', online: false }
      ],
      leasingVehicles: [],
      leasingSystemEntries: [],
      leasingSearchQuery: '',
      filteredLeasingSystemEntries: [],
      
      // Lease Modal Data
      showLeaseModal: false,
      selectedVehicle: {},
      leaseLength: 7, // Default to 7 days
      discount: 0,
      addFullTune: false, // Add this line for the full tune checkbox
      selectedPlayer: '',
      onlinePlayers: [],
      leaseLengthOptions: [
        { value: 1, label: '1 Dag' },
        { value: 3, label: '3 Dage' },
        { value: 7, label: '7 Dage' },
        { value: 14, label: '14 Dage' },
        { value: 30, label: '30 Dage' }
      ],
      showExtendModal: false,
      showWithdrawModal: false,
      extendDays: 7,
      extendDaysOptions: [
        { value: 1, label: '1 Dag' },
        { value: 3, label: '3 Dage' },
        { value: 7, label: '7 Dage' },
        { value: 14, label: '14 Dage' },
        { value: 30, label: '30 Dage' }
      ],
      dataInitialized: false,
      jobGradeRequirements: {},
      // Owned Vehicles Data
      ownedVehicles: [],
      filteredOwnedVehicles: [],
      ownedVehiclesSearchQuery: '',
      isLoadingOwnedVehicles: false,
      
      // Add to Leasing Modal Data
      showAddToLeasingModal: false,
      selectedOwnedVehicle: {},

      // Management Modal Data
      showManagementModal: false,
      newPrice: 0,
      isManagementAction: false,
      
      // Add these new properties
      vehicleImageUrl: '',
      catalogSearchQuery: '',
      availableCatalogVehicles: []
    };
  },
  computed: {
  availableCatalogVehicles() {
    // Filter to only show available vehicles
    return this.filteredLeasingSystemEntries.filter(vehicle => 
      vehicle.status === 'Ledig'
    );
  }
},
  mounted() {
    window.addEventListener('message', this.handleNuiMessage);
    this.fetchLeasingSystemEntries(); // Ensure data is fetched on mount
  },
  methods: {
    // Initialize data when UI is displayed
    initializeData() {
      if (!this.dataInitialized) {
        this.fetchRequiredJobs();
        this.fetchPlayerJob();
        this.fetchLeasingSystemEntries();
        this.fetchJobGradeRequirements(); // Add this line
        this.dataInitialized = true;
      }
    },
    fetchRequiredJobs() {
      fetch('https://fh_leasing/getRequiredJobs', {
        method: 'POST'
      })
        .then(response => response.json())
        .then(data => {
          this.requiredJobs = data; // Store the required jobs
          // After getting required jobs, fetch player job to filter apps
          this.fetchPlayerJob();
        })
        .catch(error => {
          console.error("Error fetching required jobs:", error);
        });
    },
    fetchPlayerJob() {
      fetch('https://fh_leasing/getPlayerJob', {
        method: 'POST'
      })
        .then(response => response.json())
        .then(data => {
        const playerJob = data.job;
        this.playerJobGrade = data.grade || 0; // Store the player's job grade
        this.filteredApps = this.availableApps.filter(app => {
          return this.isJobAllowed(app.name, playerJob);
        });
      })
      .catch(error => {
        console.error("Error fetching player job:", error);
        // If there's an error, show all apps as fallback
        this.filteredApps = this.availableApps;
      });
  },
    fetchLeasingSystemEntries() {
      fetch('https://fh_leasing/getLeasingSystemEntries', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
      })
        .then(response => response.json())
        .then(data => {
          if (data && Array.isArray(data)) {
            this.leasingSystemEntries = data.map(entry => ({
              id: entry.id,
              name: entry.name || "Unknown Vehicle",
              model: entry.model || "Unknown",
              plate: entry.plate || "Unknown",
              rate: entry.rate || 1500,
              status: entry.status === 0 ? "Ledig" : "Ikke Ledig",
              class: entry.class || "Unknown",
            }));
            this.filteredLeasingSystemEntries = [...this.leasingSystemEntries];
          } else {
          }
        })
        .catch(error => {
          console.error("Error fetching leasing system entries:", error);
        });
    },
    fetchOnlinePlayers() {
      fetch('https://fh_leasing/getOnlinePlayers', {
        method: 'POST'
      })
        .then(response => response.json())
        .then(data => {
          this.onlinePlayers = data;
        })
        .catch(error => {
          console.error("Error fetching online players:", error);
          this.onlinePlayers = [];
          });
    },
    isJobAllowed(appName, playerJob) {
      const allowedJobs = this.requiredJobs[appName];
      if (!allowedJobs) return true; 
      return allowedJobs.includes(playerJob);
    },
    
    openApp(app) {
      this.selectedApp = app;
      this.selectedTitle = app.label;
      this.selectedAppName = app.name;

      if (app.name === 'policedatabase') {
        this.fetchPoliceRecords();
      } else if (app.name === 'leasingdatabase') {
        this.fetchLeasingVehicles();
      } else if (app.name === 'leasingsystem') {
        this.fetchLeasingSystemEntries(); // Refresh leasing system entries
        this.fetchOnlinePlayers();
      } else if (app.name === 'ownedvehicles') {
        this.fetchOwnedVehicles();
      } else if (app.name === 'vehiclecatalog') {
        this.fetchAvailableCatalogVehicles();
      }
    },
    
    closeSelectedApp() {
      this.selectedApp = [];
      this.selectedTitle = '';
      this.selectedAppName = '';
      
      // Send NUI message to client
      this.sendNuiMessage('back', {});
    },
    closeApp() {
      // Send NUI message to client with explicit instruction to remove focus
      this.sendNuiMessage('close', {
        removeFocus: true
      });
      
      // Also hide the UI locally
      this.display = false;
    },
    fetchPoliceRecords() {
      this.sendNuiMessage('police:getPoliceRecords', {});
    },
    searchPoliceDatabase() {
      this.sendNuiMessage('searchPoliceDatabase', {
        query: this.policeSearchQuery
      });
    },
    debouncedSearchPoliceDatabase() {
      clearTimeout(this.searchTimeout); // Clear the previous timeout
      this.searchTimeout = setTimeout(() => {
        this.searchPoliceDatabase(); // Trigger the search after a delay
      }, 300); // 300ms debounce delay
    },
    addInmate() {
      // This would normally open a form modal
    },
    manageInmate(id) {
    },
    addLeasing() {
    },
    extendLeasing(id) {
      // Find the vehicle by ID
      const vehicle = this.leasingVehicles.find(v => v.id === id);
      if (vehicle) {
        this.selectedVehicle = vehicle;
        this.showExtendModal = true;
        this.extendDays = 7; // Default to 7 days
      } else {
        console.error("Vehicle not found with ID:", id);
      }
    },
    withdrawLeasing(id) {
      // Find the vehicle by ID
      const vehicle = this.leasingVehicles.find(v => v.id === id);
      if (vehicle) {
        this.selectedVehicle = vehicle;
        this.showWithdrawModal = true;
      } else {
      }
    },
    filterLeasingSystemEntries() {
      const query = this.leasingSearchQuery.toLowerCase();
      this.filteredLeasingSystemEntries = this.leasingSystemEntries.filter(entry => {
        return (
          entry.name.toLowerCase().includes(query) ||
          entry.class.toLowerCase().includes(query) ||
          entry.plate.toLowerCase().includes(query)
        );
      });
    },
    openLeaseModal(vehicle) {
      this.selectedVehicle = vehicle;
      
      // If this is a management action (from the Handlinger button), show the management modal instead
      if (this.isManagementAction) {
        this.showManagementModal = true;
        this.newPrice = vehicle.rate; // Set the current price as default
        this.isManagementAction = false; // Reset the flag
      } else {
        // Regular lease modal
        this.showLeaseModal = true;
        this.leaseLength = 7; // Default to 7 days
        this.discount = 0;
        this.selectedPlayer = '';
        
        // Fetch online players when opening the lease modal
        this.fetchOnlinePlayers();
      }
    },

    // Add a new method to handle the management button click
    openManagementModal(vehicle) {
      this.isManagementAction = true; // Set a flag to indicate this is a management action
      this.selectedVehicle = vehicle;
      this.showManagementModal = true;
      this.newPrice = vehicle.rate; // Set the current price as default
      this.vehicleImageUrl = vehicle.imageUrl;
    },

    // Add methods to close the management modal
    closeManagementModal() {
      this.showManagementModal = false;
    },

    // Add method to update the price
    updateVehiclePrice() {
      if (!this.newPrice || this.newPrice <= 0) {
        alert('Indtast venligst en gyldig pris');
        return;
      }

      const data = {
        vehicleId: this.selectedVehicle.id,
        plate: this.selectedVehicle.plate,
        newPrice: this.newPrice,
        imageUrl: this.vehicleImageUrl
      };
      
      // Send to server
      this.sendNuiMessage('updateLeasingVehiclePrice', data);
      
      // Close the modal
      this.closeManagementModal();
      
      // Refresh the leasing system entries after a short delay
      setTimeout(() => {
        this.fetchLeasingSystemEntries();
      }, 500);
    },

    // Add method to reclaim the vehicle
    reclaimVehicle() {
      const data = {
        vehicleId: this.selectedVehicle.id,
        plate: this.selectedVehicle.plate
      };
      
      // Send to server
      this.sendNuiMessage('reclaimLeasingVehicle', data);
      
      // Close the modal
      this.closeManagementModal();
      
      // Refresh both lists after a short delay
      setTimeout(() => {
        this.fetchLeasingSystemEntries();
        this.fetchOwnedVehicles();
      }, 500);
    },

    fullTuneVehicle() {
      if (!this.selectedVehicle || !this.selectedVehicle.plate) {
        alert('Vælg venligst et køretøj først');
        return;
      }
      
      this.sendNuiMessage('fullTuneVehicle', { 
        plate: this.selectedVehicle.plate 
      });
      
      // Close the modal
      this.closeManagementModal();
      
      // Show notification
      setTimeout(() => {
        lib.notify({
          description: 'Anmodning om at tune køretøjet er sendt',
          type: 'success'
        });
      }, 300);
    },

    closeLeaseModal() {
      this.showLeaseModal = false;
    },
    getLeaseLengthLabel() {
      const option = this.leaseLengthOptions.find(opt => opt.value === this.leaseLength);
      return option ? option.label : '';
    },
    calculateTotalPrice() {
      if (!this.selectedVehicle.rate) return 0;
      const basePrice = this.selectedVehicle.rate * this.leaseLength;
      const discountAmount = basePrice * (this.discount / 100);
      const discountedPrice = basePrice - discountAmount;
      return Math.round(discountedPrice);
    },
    confirmLease() {
      if (!this.selectedPlayer) {
        alert('Vælg venligst en spiller');
        return;
      }

      const leaseData = {
        identifier: this.selectedPlayer,
        seller: this.playerName, // Assuming `playerName` is available in the data
        plate: this.selectedVehicle.plate,
        model: this.selectedVehicle.name,
        data: this.selectedVehicle.data,
        price: this.selectedVehicle.rate,
        discount: this.discount || 0, // Ensure discount defaults to 0
        start: Math.floor(Date.now() / 1000),
        end_date: Math.floor(Date.now() / 1000) + (this.leaseLength * 86400),
        status: "1", // Active lease
        addFullTune: this.addFullTune // Ensure addFullTune is passed correctly
      };

      this.sendNuiMessage('createLeaseContract', leaseData);

      this.closeLeaseModal();

      // Refresh the leasing system entries after a short delay
      setTimeout(() => {
        this.fetchLeasingSystemEntries();
      }, 500);
    },
    
    fetchLeasingVehicles() {      
      // Use the correct event name
      fetch('https://fh_leasing/getLeasingVehicles', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: JSON.stringify({})
      })
      .then(response => {
        return response.json();
      })
      .catch(error => {
        console.error("Error fetching leasing vehicles:", error);
        // Use fallback data if the fetch fails
        this.leasingVehicles = [];
      });
    },

    fetchLeasingVehiclesPlayer() {      
      // Use the correct event name
      fetch('https://fh_leasing/getLeasingVehicles', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: JSON.stringify({})
      })
      .then(response => {
        return response.json();
      })
      .catch(error => {
        console.error("Error fetching leasing vehicles:", error);
        // Use fallback data if the fetch fails
        this.leasingVehicles = [];
      });
    },

    // Add these new methods for owned vehicles
    fetchOwnedVehicles() {
      this.isLoadingOwnedVehicles = true;
      this.ownedVehicles = [];
      this.filteredOwnedVehicles = [];

      // Fetch data from the server
      fetch('https://fh_leasing/getOwnedVehicles', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
      })
        .then(response => response.json())
        .then(data => {
          if (data && Array.isArray(data)) {
            this.ownedVehicles = data.map(vehicle => ({
              id: vehicle.id,
              plate: vehicle.plate || "Unknown",
              name: vehicle.name || "Unknown Vehicle",
              class: vehicle.class || "Unknown"
            }));
            this.filteredOwnedVehicles = [...this.ownedVehicles];
          } else {
          }
        })
        .catch(error => {
          console.error("Error fetching owned vehicles:", error);
        })
        .finally(() => {
          this.isLoadingOwnedVehicles = false;
        });
    },

    // Update the handleNuiMessage method to better handle owned vehicles data
    handleNuiMessage(event) {
      const data = event.data;

      try {
        if (data.type === 'updateLeasingSystemEntries') {
          
          if (data.data && Array.isArray(data.data)) {
            // Process the data to ensure it has all required fields
            const processedEntries = data.data.map(entry => ({
              id: entry.id || Math.floor(Math.random() * 1000),
              name: entry.name || "Unknown Vehicle",
              model: entry.model || "Unknown",
              plate: entry.plate || "Unknown",
              rate: entry.rate || 1500,
              status: entry.status || "Ledig",
              class: entry.class || "Unknown",
              imageUrl: entry.imageUrl || ''
            }));
            
            this.leasingSystemEntries = processedEntries;
            this.filteredLeasingSystemEntries = [...processedEntries];
          } else {
            console.error("Leasing system entries data is not an array:", data.data);
            // Use fallback data
            this.leasingSystemEntries = [
              {
                id: 1,
                name: "Adder",
                model: "adder",
                plate: "ABC 3",
                rate: 1500,
                status: "Ledig",
                class: "Super",
                imageUrl: ''
              },
              {
                id: 2,
                name: "Zentorno",
                model: "zentorno",
                plate: "XYZ 3",
                rate: 2000,
                status: "Ledig",
                class: "Super",
                imageUrl: ''
              }
            ];
            this.filteredLeasingSystemEntries = [...this.leasingSystemEntries];
          }
        }
        
        // Handle other message types...
        else if (data.type === 'ownedVehicles') {
          
          if (data.data && Array.isArray(data.data)) {
            // Process the data to ensure it has all required fields
            const processedVehicles = data.data.map(vehicle => ({
              id: vehicle.id || Math.floor(Math.random() * 1000),
              plate: vehicle.plate || "Unknown",
              model: vehicle.model || "Unknown",
              name: vehicle.name || "Unknown Vehicle",
              class: vehicle.class || "Unknown"
            }));
            
            this.ownedVehicles = processedVehicles;
            this.filteredOwnedVehicles = [...processedVehicles];
            this.isLoadingOwnedVehicles = false;
          } else {
            console.error("Owned vehicles data is not an array:", data.data);
            // Use fallback data
            this.ownedVehicles = [
              {
                id: 1,
                plate: "ABC 4",
                model: "adder",
                name: "Adder",
                class: "Super"
              },
              {
                id: 2,
                plate: "XYZ 4",
                model: "zentorno",
                name: "Zentorno",
                class: "Super"
              }
            ];
            this.filteredOwnedVehicles = [...this.ownedVehicles];
            this.isLoadingOwnedVehicles = false;
          }
        } else if (data.type === 'policeRecords') {
          this.policeRecords = data.data;
        } else if (data.type === 'leaseContractCreated') {
          // alert(`Leasing kontrakt oprettet: ${data.data.message}`);
        } else if (data.type === 'ui') {
          this.display = data.status;
          
          if (data.status) {
            this.initializeData();
          }
        } else if (data.type === 'nearbyPlayers') {
          try {
            const parsedData = JSON.parse(data.data);
            this.nearbyPlayers = Array.isArray(parsedData) ? parsedData : [];
          } catch (error) {
            this.nearbyPlayers = [];
          }
        } else if (data.type === 'leasingVehicles') {          
          if (data.data && Array.isArray(data.data)) {
            this.leasingVehicles = data.data;
          } else {
            console.error("Leasing vehicles data is not an array:", data.data);
            this.leasingVehicles = [];
          }
        } else if (data.type === 'receiveOwnedVehicles') {
          
          if (data.data && Array.isArray(data.data)) {
            // Process the data to ensure it has all required fields
            const processedVehicles = data.data.map(vehicle => ({
              id: vehicle.id || Math.floor(Math.random() * 1000),
              plate: vehicle.plate || "Unknown",
              model: vehicle.model || "Unknown",
              name: vehicle.name || "Unknown Vehicle",
              class: vehicle.class || "Unknown"
            }));
            
            this.ownedVehicles = processedVehicles;
            this.filteredOwnedVehicles = [...processedVehicles];
            this.isLoadingOwnedVehicles = false;
          } else {
            console.error("Owned vehicles data is not an array:", data.data);
            // Use fallback data
            this.ownedVehicles = [
              {
                id: 1,
                plate: "ABC 5",
                model: "adder",
                name: "Adder",
                class: "Super"
              },
              {
                id: 2,
                plate: "XYZ 5",
                model: "zentorno",
                name: "Zentorno",
                class: "Super"
              }
            ];
            this.filteredOwnedVehicles = [...this.ownedVehicles];
            this.isLoadingOwnedVehicles = false;
          }
        } else if (data.type === 'onlinePlayers') {
          try {
            const parsedData = JSON.parse(data.data); // Parse JSON string
            this.onlinePlayers = Array.isArray(parsedData) ? parsedData : [];
          } catch (error) {
            console.error("Error parsing onlinePlayers data:", error);
            this.onlinePlayers = [];
          }
        } else if (data.type === 'availableCatalogVehicles') {
          try {
            const parsedData = JSON.parse(data.data); // Parse JSON string
            this.availableCatalogVehicles = Array.isArray(parsedData) ? parsedData : [];
          } catch (error) {
            console.error("Error parsing availableCatalogVehicles data:", error, data.data);
            this.availableCatalogVehicles = [];
          }
        }
      } catch (error) {
        console.error("Error handling NUI message:", error, event.data);
        // If there's an error, use fallback data for owned vehicles
        if (this.isLoadingOwnedVehicles) {
          this.ownedVehicles = [
            {
              id: 1,
              plate: "ABC 6",
              model: "adder",
              name: "Adder",
              class: "Super"
            },
            {
              id: 2,
              plate: "XYZ 6",
              model: "zentorno",
              name: "Zentorno",
              class: "Super"
            }
          ];
          this.filteredOwnedVehicles = [...this.ownedVehicles];
          this.isLoadingOwnedVehicles = false;
        }
      }
    },
    
    // ... rest of existing methods ...
    filterOwnedVehicles() {
      const query = this.ownedVehiclesSearchQuery.toLowerCase();
      this.filteredOwnedVehicles = this.ownedVehicles.filter(vehicle => {
        return (
          (vehicle.name && vehicle.name.toLowerCase().includes(query)) || 
          (vehicle.plate && vehicle.plate.toLowerCase().includes(query)) ||
          (vehicle.model && vehicle.model.toLowerCase().includes(query)) ||
          (vehicle.class && vehicle.class.toLowerCase().includes(query))
        );
      });
    },

    filterCatalogVehicles() {
      const query = this.catalogSearchQuery.toLowerCase();
      this.filteredLeasingSystemEntries = this.leasingSystemEntries.filter(vehicle => {
        return (
          (vehicle.name && vehicle.name.toLowerCase().includes(query)) || 
          (vehicle.plate && vehicle.plate.toLowerCase().includes(query)) ||
          (vehicle.model && vehicle.model.toLowerCase().includes(query)) ||
          (vehicle.class && vehicle.class.toLowerCase().includes(query))
        );
      });
    },
    
    addToLeasing(vehicle) {
      this.selectedOwnedVehicle = vehicle;
      this.showAddToLeasingModal = true;
    },
    
    closeAddToLeasingModal() {
      this.showAddToLeasingModal = false;
    },
    
    confirmAddToLeasing() {
      const data = {
        vehicleId: this.selectedOwnedVehicle.id,
        model: this.selectedOwnedVehicle.model,
        name: this.selectedOwnedVehicle.name,
        plate: this.selectedOwnedVehicle.plate
      };
      
      // Send to server
      this.sendNuiMessage('addVehicleToLeasing', data);
      
      // Close the modal
      this.closeAddToLeasingModal();
      
      // Refresh owned vehicles list and leasing vehicles list
      setTimeout(() => {
        this.fetchOwnedVehicles();
        this.fetchLeasingVehicles();
        this.fetchLeasingSystemEntries();
      }, 500);
    },
    
    sendNuiMessage(eventName, data) {
      const resourceName = window.GetParentResourceName ? window.GetParentResourceName() : 'police_system';
      
      fetch(`https://${resourceName}/${eventName}`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: JSON.stringify(data)
      })
      .then(response => response.json())
      .catch(error => {
        console.error(`Error sending NUI message (${eventName}):`, error);
      });
    },
    closeExtendModal() {
      this.showExtendModal = false;
    },
    
    closeWithdrawModal() {
      this.showWithdrawModal = false;
    },
    
    calculateNewEndDate(endDate, extendDays) {
      try {
        if (endDate && !isNaN(endDate)) {
          const currentEndDate = new Date(endDate * 1000);
          const futureDate = new Date(currentEndDate.getTime() + (extendDays * 24 * 60 * 60 * 1000));
          return futureDate.toLocaleDateString();
        } else {
          console.error("Invalid endDate format:", endDate);
          return "Ugyldig dato";
        }
      } catch (error) {
        console.error("Error calculating new end date:", error);
        return "Ugyldig dato";
      }
    },
    
    // Update the confirmExtend method to properly handle database operations
    confirmExtend() {
      this.sendNuiMessage('extendLeasing', {
        id: this.selectedVehicle.id,
        plate: this.selectedVehicle.plate,
        days: this.extendDays
      });
      
      // Close the modal
      this.closeExtendModal();
      
      // Refresh the leasing vehicles list after a short delay
      setTimeout(() => {
        this.fetchLeasingVehicles();
      }, 100);
    },
    
    // Update the confirmWithdraw method to properly handle database operations
    confirmWithdraw() {
      this.sendNuiMessage('withdrawLeasing', {
        id: this.selectedVehicle.id,
        plate: this.selectedVehicle.plate
      });
      
      // Close the modal
      this.closeWithdrawModal();
      
      // Refresh the leasing vehicles list after a short delay
      setTimeout(() => {
        this.fetchLeasingVehicles();
      }, 100);
    },
    fetchJobGradeRequirements() {
      fetch('https://fh_leasing/getJobGradeRequirements', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: JSON.stringify({ action: 'extendLeasing' })
      })
        .then(response => response.json())
        .then(data => {
          if (data.success) {
            this.jobGradeRequirements.extendLeasing = data.requiredGrade;
          }
          
          return fetch('https://fh_leasing/getJobGradeRequirements', {
            method: 'POST',
            headers: {
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: JSON.stringify({ action: 'withdrawLeasing' })
          });
        })
        .then(response => response.json())
        .then(data => {
          if (data.success) {
            this.jobGradeRequirements.withdrawLeasing = data.requiredGrade;
          }
          
          return fetch('https://fh_leasing/getJobGradeRequirements', {
            method: 'POST',
            headers: {
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: JSON.stringify({ action: 'settingsLeasing' })
          });
        })
        .then(response => response.json())
        .then(data => {
          if (data.success) {
            this.jobGradeRequirements.settingsLeasing = data.requiredGrade;
          }
        })
        .catch(error => {
          console.error("Error fetching job grade requirements:", error);
        });
    },
    // Update the fetchLeasingVehicles method to better handle errors and show loading state
    fetchLeasingVehicles() {
      
      // Use the correct event name
      fetch('https://fh_leasing/getLeasingVehicles', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: JSON.stringify({})
      })
      .then(response => {
        return response.json();
      })
      .then(data => {
        if (data && data.success === false) {
          console.error("Error fetching leasing vehicles:", data.message);
        }
      })
      .catch(error => {
        console.error("Error fetching leasing vehicles:", error);
      });
    },
    updateVehicleStatus(vehicleId, newStatus) {
      this.sendNuiMessage('updateVehicleStatus', { vehicleId, newStatus });
    },
    fetchAvailableCatalogVehicles() {
      fetch('https://fh_leasing/getAvailableCatalogVehicles', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
      })
        .then(response => response.json())
        .then(data => {
          if (data && Array.isArray(data)) {
            this.availableCatalogVehicles = data;
          } else {
            this.availableCatalogVehicles = [];
          }
        })
        .catch(error => {
          console.error("Error fetching available catalog vehicles:", error);
          this.availableCatalogVehicles = [];
        });
    },
    handleImageError(event) {
      event.target.src = '/placeholder.svg?height=200&width=300'; // Fallback image
    },
  },
  beforeUnmount() {
    window.removeEventListener('message', this.handleNuiMessage);
  }
}
</script>

<style>
* {
  margin: 0;
  padding: 0;
  box-sizing: border-box;
  font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
}

/* body {
  background-color: rgba(0, 0, 0, 0.5);
} */

.blueprints-container {
  width: 1000px;
  height: 750px;
  background-color: #1b1b1b;
  border-radius: 5px;
  box-shadow: 0 0 10px rgba(0, 0, 0, 0.5);
  overflow: hidden;
  position: absolute; /* Change from relative to absolute */
  top: 50%; /* Center vertically */
  left: 50%; /* Center horizontally */
  transform: translate(-50%, -50%); /* Adjust for centering */
  color: white;
}

.blueprints-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 15px 20px;
  background-color: #161616;
  border-bottom: 1px solid #161616;
}

.header-title {
  display: flex;
  align-items: center;
}

.header-title i {
  font-size: 24px;
  margin-right: 10px;
}

.header-title h1 {
  font-size: 22px;
  font-weight: 600;
  text-transform: uppercase;
  letter-spacing: 1px;
}

.header-actions {
  display: flex;
  gap: 10px;
}

.header-button {
  cursor: pointer;
  font-size: 18px;
  width: 30px;
  height: 30px;
  display: flex;
  align-items: center;
  justify-content: center;
  border-radius: 3px;
  background-color: #161616;
}

.header-button:hover {
  background-color: #252525;
}

.blueprints-content {
  padding: 20px;
  display: flex;
  justify-content: center;
  align-items: center;
  height: calc(100% - 60px);
}

.apps-grid {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 30px;
  width: 100%;
  max-width: 600px;
}

.app-item {
  background-color: #131313;
  border-radius: 3px;
  padding: 30px;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  cursor: pointer;
  transition: background-color 0.2s;
  aspect-ratio: 1;
}

.app-item:hover {
  background-color: #252525;
}

.app-icon {
  margin-bottom: 15px;
  width: 60px;
  height: 60px;
  display: flex;
  align-items: center;
  justify-content: center;
}

.app-icon img {
  width: 100%;
  height: 100%;
  object-fit: contain;
}

.app-icon .material-icons {
  font-size: 50px;
  color: #dadada;
}

.app-label {
  text-align: center;
  font-size: 16px;
  color: #ffffff;
  font-weight: 500;
}

/* App Window */
.app-window {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background-color: #141414;
  z-index: 10;
  display: flex;
  flex-direction: column;
}

.window-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 15px 20px;
  background-color: #161616;
  border-bottom: 1px solid #161616;
}

.window-header h2 {
  font-size: 18px;
  font-weight: 600;
}

.window-actions {
  display: flex;
  gap: 10px;
}

.window-button {
  display: flex;
  align-items: center;
  padding: 6px 12px;
  border-radius: 3px;
  cursor: pointer;
  font-size: 14px;
  transition: background-color 0.2s;
}

.window-button i {
  margin-right: 5px;
}

.window-button.back {
  background-color: #161616;
}

.window-button.back:hover {
  background-color: #252525;
}

.window-button.close {
  background-color: #d32f2f;
}

.window-button.close:hover {
  background-color: #e33e3e;
}

.window-content {
  flex: 1;
  padding: 20px;
  overflow: auto;
}

/* Database Content Styles */
.database-content {
  height: 100%;
  display: flex;
  flex-direction: column;
}

.database-search {
  display: flex;
  margin-bottom: 20px;
}

.database-search input {
  flex: 1;
  padding: 10px 15px;
  background-color: #1e1e1e; /* Change from blue to dark */
  border: 1px solid #444;
  border-radius: 3px 0 0 3px;
  color: #e0e0e0;
  font-size: 14px;
  outline: none;
}

.database-search button {
  padding: 10px 20px;
  background-color: #1b1b1b;
  border: none;
  border-radius: 0 3px 3px 0;
  color: white;
  font-weight: 500;
  cursor: pointer;
}

.database-search button:hover {
  background-color: #1d1d1d;
}

.database-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20px;
}

.database-header h3 {
  font-size: 18px;
  font-weight: 500;
  color: #dadada;
}

.header-actions {
  display: flex;
  gap: 10px;
}

.primary-button {
  padding: 8px 15px;
  background-color: #131313;
  border: none;
  border-radius: 3px;
  color: white;
  font-weight: 500;
  cursor: pointer;
}

.primary-button:hover {
  background-color: #1f1f1f;
}

.database-table {
  flex: 1;
  overflow: auto;
  background-color: #1e1e1e; /* Change from blue to dark */
  border-radius: 3px;
  border: 1px solid #444;
}

table {
  width: 100%;
  border-collapse: collapse;
}

table th, table td {
  padding: 12px 15px;
  text-align: left;
  border-bottom: 1px solid #161616;
}

table th {
  background-color: #161616;
  font-weight: 500;
  color: #dadada; 
  text-transform: uppercase;
  font-size: 12px;
}

table tr:hover {
  background-color: #2c2c2c;
}

.status-active, .status-online {
  color: #4caf50;
  font-weight: 500;
}

.status-inactive, .status-offline {
  color: #f44336;
  font-weight: 500;
}

.action-button {
  padding: 6px 12px;
  background-color: #222222;
  border: none;
  border-radius: 3px;
  color: white;
  font-size: 12px;
  cursor: pointer;
}

.action-button:hover {
  background-color: #2b2b2b;
}

.action-button.small {
  padding: 4px 8px;
  font-size: 11px;
}

.action-button.danger {
  background-color: #d32f2f;
}

.action-button.danger:hover {
  background-color: #e33e3e;
}

.action-buttons {
  display: flex;
  gap: 5px;
}

.search-bar {
  padding: 10px;
  width: 100%;
  margin-bottom: 10px;
  border: 1px solid #161616;
  border-radius: 3px;
  font-size: 14px;
  outline: none;
}

/* Modal Styles */
.modal-overlay {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background-color: rgba(0, 0, 0, 0.7);
  display: flex;
  justify-content: center;
  align-items: center;
  z-index: 100;
}

.modal-container {
  background-color: #1a1a1a;
  border-radius: 5px;
  width: 500px;
  max-width: 90%;
  max-height: 90vh;
  overflow-y: auto;
  box-shadow: 0 0 20px rgba(0, 0, 0, 0.5);
  display: flex;
  flex-direction: column;
}

.modal-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 15px 20px;
  background-color: #161616;
  border-bottom: 1px solid #161616;
}

.modal-header h3 {
  font-size: 18px;
  font-weight: 600;
  color: white;
}

.close-button {
  background: none;
  border: none;
  color: white;
  font-size: 24px;
  cursor: pointer;
}

.modal-body {
  padding: 20px;
  color: white;
}

.modal-footer {
  padding: 15px 20px;
  display: flex;
  justify-content: space-between;
  background-color: #161616;
  border-top: 1px solid #161616;
}

.modal-footer-left {
  display: flex;
  gap: 10px;
}

.modal-footer-right {
  display: flex;
  gap: 10px;
}

.form-group {
  margin-bottom: 15px;
}

.form-group label {
  display: block;
  margin-bottom: 5px;
  font-weight: 500;
}

.form-input {
  width: 100%;
  padding: 10px;
  background-color: #3d3d3d;
  border: 1px solid #161616;
  border-radius: 3px;
  color: white;
  font-size: 14px;
}

.vehicle-info {
  background-color: #3d3d3d;
  padding: 10px;
  border-radius: 3px;
  margin-bottom: 15px;
}

.vehicle-info p {
  margin: 5px 0;
}

.lease-length-container {
  display: flex;
  flex-wrap: wrap;
  gap: 10px;
  margin-bottom: 15px;
}

.lease-option {
  padding: 8px 15px;
  background-color: #1e1e1e; /* Change from blue to dark */
  border: 1px solid #444;
  border-radius: 3px;
  cursor: pointer;
  transition: all 0.2s;
}

.lease-option:hover {
  background-color: #333; /* Adjust hover color */
}

.lease-option.selected {
  background-color: #353535;
  border-color: #2b2b2b;
}

.price-calculation {
  background-color: #1e1e1e; /* Change from blue to dark */
  padding: 15px;
  border-radius: 3px;
  margin-top: 20px;
}

.price-row {
  display: flex;
  justify-content: space-between;
  padding: 5px 0;
}

.price-row.total {
  border-top: 1px solid #161616;
  margin-top: 10px;
  padding-top: 10px;
  font-weight: bold;
  font-size: 16px;
}

.cancel-button {
  padding: 8px 15px;
  background-color: #6c757d;
  border: none;
  border-radius: 3px;
  color: white;
  font-weight: 500;
  cursor: pointer;
}

.cancel-button:hover {
  background-color: #5a6268;
}

.back-button {
  padding: 8px 15px;
  background-color: #161616;
  border: none;
  border-radius: 3px;
  color: white;
  font-weight: 500;
  cursor: pointer;
}

.back-button:hover {
  background-color: #252525;
}

.lease-button {
  padding: 8px 15px;
  background-color: #1a1a1a;
  border: none;
  border-radius: 3px;
  color: white;
  font-weight: 500;
  cursor: pointer;
}

.lease-button:hover {
  background-color: #292929;
}

.lease-button:disabled {
  background-color: #6c757d;
  cursor: not-allowed;
}

.sell-button {
  padding: 8px 15px;
  background-color: #28a745;
  border: none;
  border-radius: 3px;
  color: white;
  font-weight: 500;
  cursor: pointer;
}

.sell-button:hover {
  background-color: #218838;
}

.sell-button:disabled {
  background-color: #6c757d;
  cursor: not-allowed;
}

/* Add these new styles */
.confirmation-message {
  background-color: #1e1e1e; /* Change from blue to dark */
  padding: 15px;
  border-radius: 3px;
  margin-top: 20px;
  border-left: 4px solid #b71c1c;
}

.confirmation-message p {
  margin-bottom: 10px;
}

.confirmation-message p:last-child {
  margin-bottom: 0;
}

.hidden {
  display: none;
}

.action-button:disabled {
  background-color: #6c757d;
  cursor: not-allowed;
  opacity: 0.7;
}

.action-button.danger:disabled {
  background-color: #9e3838;
  cursor: not-allowed;
  opacity: 0.7;
}

.loading-container {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 20px;
}

.loading-spinner {
  border: 5px solid #f3f3f3;
  border-top: 5px solid #1a1a1a;
  border-radius: 50%;
  width: 50px;
  height: 50px;
  animation: spin 2s linear infinite;
  margin-bottom: 10px;
}

@keyframes spin {
  0% { transform: rotate(0deg); }
  100% { transform: rotate(360deg); }
}

.empty-state {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 20px;
  color: #dadada;
}

.management-button {
  padding: 10px 15px;
  border: none;
  border-radius: 3px;
  color: white;
  font-weight: 500;
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 5px;
}

.management-button.update {
  background-color: #2e2e2e;
}

.management-button.update:hover {
  background-color: #2e2e2e;
}

.management-button.reclaim {
  background-color: #f39c12;
}

.management-button.reclaim:hover {
  background-color: #e08e0b;
}

.management-button.remove {
  background-color: #e74c3c;
}

.management-button.remove:hover {
  background-color: #c0392b;
}

.action-buttons-container {
  display: flex;
  flex-direction: column;
  gap: 10px;
  margin-top: 20px;
}

.action-buttons-container {
  display: flex;
  flex-direction: column;
  gap: 10px;
  margin-top: 20px;
}

.management-button {
  padding: 12px 15px;
  border: none;
  border-radius: 3px;
  color: white;
  font-weight: 500;
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
  transition: background-color 0.2s;
}

.management-button i {
  margin-right: 8px;
}

.management-button.update {
  background-color: #2e2e2e;
}

.management-button.update:hover {
  background-color: #2e2e2e;
}

.management-button.reclaim {
  background-color: #28a745;
}

.management-button.reclaim:hover {
  background-color: #218838;
}

.management-button.remove {
  background-color: #d32f2f;
}

.management-button.remove:hover {
  background-color: #e33e3e;
}

.management-button.tune {
  background-color: #3498db;
}

.management-button.tune:hover {
  background-color: #2980b9;
}

.checkbox-container {
  display: flex;
  align-items: center;
  position: relative;
  padding-left: 35px;
  margin-bottom: 12px;
  cursor: pointer;
  font-size: 16px;
  user-select: none;
}

.checkbox-container input {
  position: absolute;
  opacity: 0;
  cursor: pointer;
  height: 0;
  width: 0;
}

.checkmark {
  position: absolute;
  top: 0;
  left: 0;
  height: 20px;
  width: 20px;
  background-color: #3d3d3d;
  border-radius: 3px;
}

.checkbox-container:hover input ~ .checkmark {
  background-color: #4d4d4d;
}

.checkbox-container input:checked ~ .checkmark {
  background-color: #3498db;
}

.checkmark:after {
  content: "";
  position: absolute;
  display: none;
}

.checkbox-container input:checked ~ .checkmark:after {
  display: block;
}

.checkbox-container .checkmark:after {
  left: 7px;
  top: 3px;
  width: 5px;
  height: 10px;
  border: solid white;
  border-width: 0 2px 2px 0;
  transform: rotate(45deg);
}

/* Vehicle Catalog Styles */
.vehicle-catalog-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
  gap: 20px;
}

.vehicle-catalog-card {
  background-color: #1e1e1e;
  border-radius: 5px;
  overflow: hidden;
  transition: transform 0.3s ease;
  cursor: pointer;
}

.vehicle-catalog-card:hover {
  transform: translateY(-5px);
}

.vehicle-catalog-image {
  height: 200px;
  overflow: hidden;
  display: flex;
  align-items: center;
  justify-content: center;
}

.vehicle-catalog-image img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  transition: transform 0.3s ease;
}

.vehicle-catalog-card:hover .vehicle-catalog-image img {
  transform: scale(1.1);
}

.vehicle-catalog-info {
  padding: 15px;
}

.vehicle-catalog-info h4 {
  font-size: 18px;
  margin-bottom: 10px;
  color: #fff;
}

.vehicle-catalog-details {
  font-size: 14px;
  color: #ccc;
}

.vehicle-catalog-details p {
  margin-bottom: 5px;
}

.vehicle-catalog-details i {
  margin-right: 5px;
  color: #888;
}

.lease-catalog-button {
  display: block;
  width: 100%;
  padding: 10px;
  margin-top: 15px;
  background-color: #3498db;
  color: #fff;
  border: none;
  border-radius: 5px;
  cursor: pointer;
  transition: background-color 0.3s ease;
}

.lease-catalog-button:hover {
  background-color: #2980b9;
}

.lease-catalog-button:disabled {
  background-color: #777;
  cursor: not-allowed;
}

.image-preview {
  margin-top: 10px;
  max-width: 100%;
  overflow: hidden;
}

.image-preview img {
  width: 100%;
  height: auto;
  display: block;
  object-fit: cover;
}

.vehicle-catalog-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
  gap: 20px;
  padding: 10px;
  overflow-y: auto;
  max-height: calc(100vh - 200px);
}

.vehicle-catalog-card {
  background-color: #1e1e1e;
  border-radius: 5px;
  overflow: hidden;
  transition: transform 0.2s, box-shadow 0.2s;
  cursor: pointer;
  display: flex;
  flex-direction: column;
  height: 100%;
  border: 1px solid #333;
}

.vehicle-catalog-card:hover {
  transform: translateY(-5px);
  box-shadow: 0 10px 20px rgba(0, 0, 0, 0.3);
}

.vehicle-catalog-image {
  height: 180px;
  overflow: hidden;
  background-color: #161616;
  display: flex;
  align-items: center;
  justify-content: center;
}

.vehicle-catalog-image img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  transition: transform 0.3s;
}

.vehicle-catalog-card:hover .vehicle-catalog-image img {
  transform: scale(1.05);
}

.vehicle-catalog-info {
  padding: 15px;
  display: flex;
  flex-direction: column;
  flex-grow: 1;
}

.vehicle-catalog-info h4 {
  margin: 0 0 10px 0;
  font-size: 18px;
  font-weight: 600;
  color: #fff;
}

.vehicle-catalog-details {
  margin-bottom: 15px;
  flex-grow: 1;
}

.vehicle-catalog-details p {
  margin: 5px 0;
  font-size: 14px;
  color: #ccc;
  display: flex;
  align-items: center;
}

.vehicle-catalog-details p i {
  margin-right: 8px;
  width: 16px;
  text-align: center;
  color: #3498db;
}

.lease-catalog-button {
  background-color: #3498db;
  color: white;
  border: none;
  padding: 8px 15px;
  border-radius: 3px;
  cursor: pointer;
  font-weight: 500;
  transition: background-color 0.2s;
  width: 100%;
}

.lease-catalog-button:hover {
  background-color: #2980b9;
}

.lease-catalog-button:disabled {
  background-color: #6c757d;
  cursor: not-allowed;
}

.image-preview {
  margin-top: 10px;
  background-color: #161616;
  border-radius: 3px;
  overflow: hidden;
  max-height: 150px;
  display: flex;
  justify-content: center;
}

.image-preview img {
  max-width: 100%;
  max-height: 150px;
  object-fit: contain;
}
</style>
