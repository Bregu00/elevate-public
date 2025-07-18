<script lang="ts">
  import { visibilityStore as visibility, impoundedVehicles, job } from '$lib/stores/VisibilityStore';
  import { fetchNui } from '$lib/utils/fetchNui';
  let currentTime = Math.floor(Date.now() / 1000);
  let activeTab = 'all';
  let searchQuery = '';
  
  // Derived values
  $: readyVehicles = $impoundedVehicles.filter(v => currentTime >= v.ReleaseTime);
  $: pendingVehicles = $impoundedVehicles.filter(v => currentTime < v.ReleaseTime);
  
  // Search and filter functionality
  $: filteredVehicles = $impoundedVehicles.filter(vehicle => {
    if (!searchQuery.trim()) return true;
    
    const query = searchQuery.toLowerCase().trim();
    return (
      vehicle.VehicleLabel.toLowerCase().includes(query) || 
      vehicle.Plate.toLowerCase().includes(query) ||
      vehicle.Reason.toLowerCase().includes(query)
    );
  });
  
  $: filteredReadyVehicles = readyVehicles.filter(vehicle => {
    if (!searchQuery.trim()) return true;
    
    const query = searchQuery.toLowerCase().trim();
    return (
      vehicle.VehicleLabel.toLowerCase().includes(query) || 
      vehicle.Plate.toLowerCase().includes(query) ||
      vehicle.Reason.toLowerCase().includes(query)
    );
  });
  
  $: filteredPendingVehicles = pendingVehicles.filter(vehicle => {
    if (!searchQuery.trim()) return true;
    
    const query = searchQuery.toLowerCase().trim();
    return (
      vehicle.VehicleLabel.toLowerCase().includes(query) || 
      vehicle.Plate.toLowerCase().includes(query) ||
      vehicle.Reason.toLowerCase().includes(query)
    );
  });
  
  $: displayedVehicles = [];
  $: {
    if (activeTab === 'all') {
      displayedVehicles = filteredVehicles;
    } else if (activeTab === 'ready') {
      displayedVehicles = filteredReadyVehicles;
    } else if (activeTab === 'pending') {
      displayedVehicles = filteredPendingVehicles;
    }
  }
  
  // Format Unix timestamp to readable date/time
  function formatReleaseTime(timestamp) {
    const date = new Date(timestamp * 1000);
    return date.toLocaleString();
  }
  
  // Format price with commas and dollar sign
  function formatPrice(price) {
    return price.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',') + ' DKK';
  }
  
  // Calculate time remaining until release
  function getTimeRemaining(releaseTime) {
    const remaining = releaseTime - currentTime;
    
    if (remaining <= 0) return 'Klar';
    
    const hours = Math.floor(remaining / 3600);
    const minutes = Math.floor((remaining % 3600) / 60);
    const seconds = remaining % 60;
    
    return `${hours}h ${minutes}m ${seconds}s tilbage`;
  }

  const handleClientData = () => {
		fetchNui("getClientData")
			.then((returnData) => {
				clientData = returnData;
			})
			.catch(() => {
				clientData = { x: 100, y: 100, z: 100 };
			});
	};
  
  // Handle vehicle release
  function releaseVehicle(vehicle) {

    fetchNui("releaseVehicle", vehicle)
			.then((returnData) => {
			if (returnData) {
				impoundedVehicles.update((v) => v.filter(v => v.Plate !== vehicle.Plate));
			}
			})
  }
  
  // Clear search query
  function clearSearch() {
    searchQuery = '';
  }
  
  // Close the UI
  function closeUI() {
    visibility.hide();
    fetchNui("hideUI");
  }
  
  // Set active tab
  function setTab(tab) {
    activeTab = tab;
  }
</script>

<div class="fixed inset-0 flex items-center justify-center bg-black/85">
  <div class="bg-gray-900 text-white rounded-xl shadow-xl w-full max-w-3xl max-h-[85vh] overflow-hidden flex flex-col border border-gray-800">
    <!-- Header -->
    <div class="bg-gray-800 px-6 py-5 flex items-center justify-between border-b border-gray-700/50">
      <div class="flex items-center space-x-3">
        <div class="bg-blue-500 h-8 w-1.5 rounded-full"></div>
        <h1 class="text-2xl font-bold tracking-tight">Opbevaring</h1>
      </div>
      <button 
        class="text-gray-400 hover:text-white transition-colors p-1.5 hover:bg-gray-800/50 rounded-lg"
        on:click={closeUI}
      >
        <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
        </svg>
      </button>
    </div>
    
    {#if $job === 'police'}
    <!-- Search Bar -->
    <div class="px-6 py-4 border-b border-gray-800">
      <div class="relative">
        <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 absolute left-3 top-1/2 transform -translate-y-1/2 text-gray-400" fill="none" viewBox="0 0 24 24" stroke="currentColor">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z" />
        </svg>
        <input 
          type="text" 
          bind:value={searchQuery} 
          placeholder="Søg efter køretøj, nummerplade eller grund..." 
          class="w-full bg-gray-800 text-white placeholder-gray-500 rounded-lg py-2 pl-10 pr-10 focus:outline-none focus:ring-2 focus:ring-blue-500 border border-gray-700"
        />
        {#if searchQuery}
          <button 
            class="absolute right-3 top-1/2 transform -translate-y-1/2 text-gray-400 hover:text-white"
            on:click={clearSearch}
          >
            <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
            </svg>
          </button>
        {/if}
      </div>
    </div>
    {/if}
    
    <!-- Tabs -->
    <div class="flex border-b border-gray-800 px-6 pt-4">
      <button 
        class={`px-4 py-2 font-medium text-sm transition-colors rounded-t-lg ${activeTab === 'all' ? 'bg-gray-800 text-white' : 'text-gray-400 hover:text-white'}`}
        on:click={() => setTab('all')}
      >
        Alle Køretøjer ({filteredVehicles.length})
      </button>
      <button 
        class={`px-4 py-2 font-medium text-sm transition-colors rounded-t-lg ${activeTab === 'ready' ? 'bg-gray-800 text-white' : 'text-gray-400 hover:text-white'}`}
        on:click={() => setTab('ready')}
      >
        Klar ({filteredReadyVehicles.length})
      </button>
      <button 
        class={`px-4 py-2 font-medium text-sm transition-colors rounded-t-lg ${activeTab === 'pending' ? 'bg-gray-800 text-white' : 'text-gray-400 hover:text-white'}`}
        on:click={() => setTab('pending')}
      >
        Afventer ({filteredPendingVehicles.length})
      </button>
    </div>
    
    <!-- Content -->
    <div class="flex-1 overflow-y-auto p-6 bg-gray-900/30">
      {#if displayedVehicles.length === 0}
        <div class="flex flex-col items-center justify-center h-64 text-gray-400">
          <svg xmlns="http://www.w3.org/2000/svg" class="h-16 w-16 mb-4 opacity-50" fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M19 9l-7 7-7-7" />
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M5 5h14a2 2 0 012 2v10a2 2 0 01-2 2H5a2 2 0 01-2-2V7a2 2 0 012-2z" />
          </svg>
          {#if searchQuery}
            <p class="text-xl font-medium">Ingen resultater fundet</p>
            <p class="text-gray-500 mt-2">Prøv at søge efter noget andet</p>
            <button 
              class="mt-4 px-4 py-2 bg-blue-600 hover:bg-blue-700 rounded-lg text-white font-medium transition-colors"
              on:click={clearSearch}
            >
              Ryd søgning
            </button>
          {:else}
            <p class="text-xl font-medium">Ingen køretøjer fundet</p>
            <p class="text-gray-500 mt-2">Der er ingen køretøjer under denne kategori</p>
          {/if}
        </div>
      {:else}
        <div class="grid gap-4">
          {#each displayedVehicles as vehicle}
            <div class="bg-gray-800 rounded-xl overflow-hidden border border-gray-700/50 shadow-lg hover:shadow-xl transition-all hover:translate-y-[-2px] duration-300">
              <div class="p-5">
                <div class="flex justify-between items-start">
                  <div>
                    <h2 class="text-xl font-bold">{vehicle.VehicleLabel}</h2>
                    <div class="mt-1.5 inline-flex items-center px-2.5 py-1 rounded-md text-xs font-medium bg-gray-700/70 text-gray-300">
                      {vehicle.Plate}
                    </div>
                    
                    <div class="mt-4">
                      <div class="text-xs uppercase tracking-wider text-gray-500 font-medium">Grund for impound</div>
                      <div class="text-gray-300 mt-1">{vehicle.Reason}</div>
                    </div>
                  </div>
                  
                  <div class="text-right">
                    <div 
                      class={`inline-flex items-center px-2.5 py-1 rounded-md text-xs font-medium ${
                        currentTime >= vehicle.ReleaseTime 
                          ? 'bg-green-500/20 text-green-400 border border-green-500/30' 
                          : 'bg-blue-500/20 text-blue-400 border border-blue-500/30'
                      }`}
                    >
                      {currentTime >= vehicle.ReleaseTime ? 'Klar' : 'Afventer'}
                    </div>
                    
                    <div class="mt-3">
                      <div class="text-xs uppercase tracking-wider text-gray-500 font-medium">Frigivelsesdato</div>
                      <div class="font-medium text-sm mt-1">{formatReleaseTime(vehicle.ReleaseTime)}</div>
                    </div>
                    
                    <div class="mt-3">
                      <div class="text-xs uppercase tracking-wider text-gray-500 font-medium">Udgift</div>
                      <div class="font-medium text-sm mt-1 text-blue-400">{formatPrice(vehicle.Price)}</div>
                    </div>
                  </div>
                </div>
                
                <div class="mt-5 pt-4 border-t border-gray-700/50 flex items-center justify-between">
                  <div class={`text-sm font-medium ${currentTime >= vehicle.ReleaseTime ? 'text-green-400' : 'text-blue-400'}`}>
                    {getTimeRemaining(vehicle.ReleaseTime)}
                  </div>
                  
                  <div class="flex items-center gap-2">
                    {#if $job !== 'police'}
                    <div class="text-sm font-medium text-gray-400">
                      Betal: <span class="text-blue-400">{formatPrice(vehicle.Price)}</span>
                    </div>
                    {/if}
                    
                    <button 
                      class={`px-4 py-2 rounded-lg font-medium transition-all duration-200 ${
                        (currentTime >= vehicle.ReleaseTime || $job === 'police') 
                          ? $job === 'police' ? 'bg-red-600 hover:bg-red-700 text-white shadow-md' : 'bg-green-600 hover:bg-green-700 text-white shadow-md' 
                          : 'bg-gray-700/70 text-gray-400 cursor-not-allowed'
                      }`}
                      disabled={currentTime < vehicle.ReleaseTime && $job !== 'police'}
                      on:click={() => releaseVehicle(vehicle)}
                    >
                      {currentTime >= vehicle.ReleaseTime ? 'Frigiv Køretøj' : $job === 'police' ? 'Frigiv Før Tid' : 'Ikke tilgængelig'}
                    </button>
                  </div>
                </div>
              </div>
            </div>
          {/each}
        </div>
      {/if}
    </div>
    
    <!-- Footer -->
    <div class="bg-gray-800 px-6 py-3 border-t border-gray-800 text-sm text-gray-500 flex justify-between items-center">
      <div>Københavns Politi Opbevaring</div>
      <div class="text-xs bg-gray-700 px-2 py-1 rounded-md">
        {new Date(currentTime * 1000).toLocaleTimeString()}
      </div>
    </div>
  </div>
</div>

<style>
  /* Custom scrollbar */
  :global(*::-webkit-scrollbar) {
    width: 8px;
  }
  
  :global(*::-webkit-scrollbar-track) {
    background: rgba(31, 41, 55, 0.5);
  }
  
  :global(*::-webkit-scrollbar-thumb) {
    background-color: rgba(75, 85, 99, 0.5);
    border-radius: 20px;
  }
</style>