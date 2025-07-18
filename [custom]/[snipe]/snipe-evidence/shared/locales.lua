-- this is the locales for mapping to show on the ui.
Config.EvidenceMappings = {
    ["casing"] = "Patronhylster",
    ["vehiclefragment"] = "Køretøjsfragment",
    ["projectile"] = "Projektil",
    ["blood"] = "Blod",
    ["casing_car"] = "Bilpatronhylstre",
    ["blood_car"] = "Bilblod",
    ["image"] = "Billede",
    ["fingerprintevidence"] = "Fingeraftryk"
}
Config.EvidenceColors = {
    ["casing"] = { r = 255, g = 0, b = 0 },
    ["vehiclefragment"] = { r = 0, g = 255, b = 0 },
    ["projectile"] = { r = 0, g = 0, b = 255 },
    ["blood"] = { r = 255, g = 255, b = 0 },
    ["casing_car"] = { r = 255, g = 165, b = 0 },
    ["blood_car"] = { r = 128, g = 0, b = 128 },
    ["image"] = { r = 255, g = 20, b = 147 },
    ["fingerprintevidence"] = { r=0,g=255,b=127}
}
-- do not touch isSearchable. You can only change label here
Config.EvidenceInfoMapping = {
    { id= 'fingerprint', label= "Fingeraftryk", isSearchable= true }, 
    { id= 'dna', label= "DNA", isSearchable= true },
    { id = "modelLabel", label = "Køretøjsnavn"},
    { id = "weaponserial", label = "Serienummer", isSearchable= false},
    { id = "weaponlabel", label = "Våbenmærke", isSearchable= false},
    { id = "ammoname", label = "Ammokaliber", isSearchable = false},
    
}
Locales = {
    ["photo_taken"] = "Billede taget. Du kan se det i din bevismenu.",
    ["no_evidence_found"] = "Ingen beviser fundet",
    ["car_evidence_title"] = "Bilbevis",
    ["cleanup_g"] = "[G] Ryd op",
    ["projectile_e"] = "[E] Projektil",
    ["projectile"] = "Projektil",
    ["casing_e"] = "[E] Patronhylster",
    ["casing"] = "Patronhylster",
    ["blood_e"] = "[E] Blod",
    ["blood"] = "Blod",
    ["vehiclefragment_e"] = "[E] Køretøjsfragment",
    ["vehiclefragment"] = "Køretøjsfragment",
    ["failed_to_create"] = "Kunne ikke oprette gerningssted",
    ['evidence_already_picked'] = "Bevis allerede samlet op",
    ['evidence_already_cleaned'] = "Bevis allerede ryddet op",
    ["blood_3d_text"] = "Blod \n DNA: %s",
    ["casing_3d_text"] = "Patronhylster \n Serienummer: %s",
    ["projectile_3d_text"] = "Projektil \n Serienummer: %s",
    ["vehiclefragment_3d_text"] = "Køretøjsfragment \n Model: %s",
    ["casing_in_car_string"] = 'Patronhylster i bil: %s',
    ["blood_in_car_string"] = 'Blod i bil: %s',
    ["no_evidence_for_crime_scene"] = "Ingen beviser for gerningssted",
    ["no_nearby_players"] = "Ingen spillere i nærheden",
    ["dna_already_taken"] = "DNA allerede taget",
    ["dna_taken"] = "Dit DNA er blevet indsamlet",

    ["no_perm_camera"] = "Ingen tilladelse til at bruge kamera",
    ["no_access"] = "Ingen adgang til bevis systemet",
    ["access_tool_no_access"] = "Du har ikke adgang til dette værktøj",
    ["not_near_location"] = "Du er ikke tæt på den angivne placering",
    ["no_nearby_car"] = "Ingen biler fundet i nærheden",
    ["access_tool_success"] = "Bil låst op. Nøgler givet",
    ["inventory_full"] = "Inventar fuldt",
    ["evidence_pouch_label"] = "Bevispose",
    ["nearby_scene_cleared"] = "Nærliggende scene er blevet ryddet",
    ["cant_use_camera_in_recreate_menu"] = "Du kan ikke bruge kameraet i genskabelsesmenuen",
    ["fingerprint_e"] = "[E] Fingeraftryk",
    ["fingerprint"] = "Fingeraftryk",
    ["fingerprint_3d_text"] = "Fingeraftryk \n Fingeraftryks-ID: %s",

    -- added after 14th March 2025
    ["gsr_cleaned"] = "GSR er blevet renset",
    ["gsr_positive"] = "Personen er GSR positiv",
    ["gsr_negative"] = "Ingen GSR fundet på personen",
    ["missing_item"] = "Du mangler en genstand for at samle beviset op",
    -- Added after 5th April 2025
    ["press_evidence"] = "[E] Bevis",
    ["failed_to_edit"] = "Kunne ikke redigere gerningssted",
    -- Added after 19th May 2025
    ["serial_label_text"] = "Serienummer",
    ["dna_label_text"] = "DNA",
    ["model_label_text"] = "Model",
    ["fingerprint_label_text"] = "Fingeraftryk",
    ["custom_label"] = "Mærke"
}