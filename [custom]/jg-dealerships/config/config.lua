-- Generated with https://configurator.jgscripts.com at 2/9/2025, 4:36:47 AM

Config = {}
Config.Locale = 'da'
Config.NumberAndDateFormat = 'da-DK'
Config.Currency = 'DKK'
Config.SpeedUnit = 'kph'
Config.Framework = 'ESX'
Config.FuelSystem = 'ox_fuel'
Config.VehicleKeys = 'none'
Config.Notifications = 'ox_lib'
Config.DrawText = 'ox_lib'
Config.OpenShowroomPrompt = '[E] Åben Showroom'
Config.OpenShowroomKeyBind = 38
Config.ViewInShowroomPrompt = '[E] Se i Showroom'
Config.ViewInShowroomKeyBind = 38
Config.OpenManagementPrompt = '[E] Forhandler Management'
Config.OpenManagementKeyBind = 38
Config.SellVehiclePrompt = '[E] Sælg Køretøj'
Config.SellVehicleKeyBind = 38
Config.SpawnVehiclesWithServerSetter = false
Config.FinancePayments = 12
Config.FinanceDownPayment = 0.1
Config.FinanceInterest = 0.1
Config.FinancePaymentInterval = 12
Config.FinancePaymentFailedHoursUntilRepo = 1
Config.MaxFinancedVehiclesPerPlayer = 5
Config.ShowVehicleImages = true
Config.PlateFormat = '1AA111AA'
Config.TestDrivePlate = 'TESTBIL'
Config.TestDriveTimeSeconds = 120
Config.TestDriveNotInBucket = false
Config.DisplayVehiclesPlate = 'Elevate'
Config.DisplayVehiclesHidePurchasePrompt = false
Config.DealerPurchasePrice = 0.75
Config.VehicleOrderTime = 15
Config.VehicleColourOptions = {
  {
    label = 'Red',
    hex = '#e81416',
  },
  {
    label = 'Orange',
    hex = '#ff7518',
  },
  {
    label = 'Yellow',
    hex = '#ffbf00',
  },
  {
    label = 'Green',
    hex = '#79c314',
  },
  {
    label = 'Blue',
    hex = '#487de7',
  },
  {
    label = 'Purple',
    hex = '#70369d',
  },
  {
    label = 'Black',
    hex = '#000000',
  },
  {
    label = 'White',
    hex = '#ffffff',
  },
}
Config.Categories = {
  planes = 'Planes',
  sportsclassics = 'Sports Classics',
  sedans = 'Sedans',
  compacts = 'Compacts',
  motorcycles = 'Motorcycles',
  super = 'Super',
  superSport = 'Super Sport',
  drift = 'Drift',
  offroad = 'Offroad',
  helicopters = 'Helicopters',
  coupes = 'Coupes',
  muscle = 'Muscle',
  boats = 'Boats',
  vans = 'Vans',
  sports = 'Sports',
  suvs = 'SUVs',
  commercial = 'Commercial',
  cycles = 'Cycles',
  industrial = 'Industrial',
  choppers = 'Choppers',
  tuner = 'Tuner',
  auktion = 'Auktion',
}

Config.DealershipLocations = {
  pdm = {
    type = 'owned',
    showroomType = 'car',
    openShowroom = {
      coords = vector3(-40.65, -1094.71, 27.27),
      size = 1,
    },
    openManagement = {
      coords = vector3(-25.63, -1104.61, 27.27),
      size = 1,
    },
    sellVehicle = {
      coords = vector3(-23.85418, -1095.249, 27.30523),
      size = 2,
    },
    purchaseSpawn = vector4(-15.09, -1092.86, 26.76, 159.88),
    testDriveSpawn = vector4(-58.40, -1071.81, 27.04, 68.88),
    camera = {
      name = 'Car',
      coords = vector4(-146.6166, -596.6301, 166.0, 270.0),
      positions = {
        5,
        8,
        12,
        8,
      },
    },
    categories = {
      'sedans',
      'compacts',
      'offroad',
      'coupes',
      'muscle',
      'vans',
      'suvs',
      'sports',
      'superSport',
    },
    enableTestDrive = true,
    hideBlip = false,
    blip = {
      id = 326,
      color = 2,
      scale = 0.5,
    },
    societyPurchaseJobWhitelist = {
    },
    societyPurchaseGangWhitelist = {},
    enableSellVehicle = false,
    sellVehiclePercent = 0.6,
    enableFinance = false,
    hideMarkers = false,
    markers = {
      id = 21,
      size = {
        x = 0.3,
        y = 0.3,
        z = 0.3,
      },
      color = {
        r = 255,
        g = 255,
        b = 255,
        a = 120,
      },
      bobUpAndDown = 0,
      faceCamera = 0,
      rotate = 1,
      drawOnEnts = 0,
    },
    showroomJobWhitelist = {},
    showroomGangWhitelist = {},
    disableShowroomPurchase = false,
    directSaleDistance = 50,
    job = 'pdm',
  },

  redline = {
    type = 'owned',
    showroomType = 'car',
    openShowroom = {
      coords = vector3(-838.3716, -258.8850, 38.8873),
      size = 1,
    },
    openManagement = {
      coords = vector3(-844.4639, -260.5088, 42.9452),
      size = 1,
    },
    sellVehicle = {
      coords = vector3(-824.6268, -282.9051, 37.8398),
      size = 2,
    },
    purchaseSpawn = vector4(-839.8364, -277.9362, 39.1003, 144.2089),
    testDriveSpawn = vector4(-839.8417, -277.9360, 39.1014, 149.9703),
    camera = {
      name = 'Car',
      coords = vector4(-841.18, -250.45, 37.89, 298.27),
      positions = {
        5,
        8,
        12,
        8,
      },
    },
    categories = {
      'suvs',
      'sports',
      'auktion',
    },
    enableTestDrive = false,
    hideBlip = false,
    blip = {
      id = 326,
      color = 2,
      scale = 0.5,
    },
    societyPurchaseJobWhitelist = {
    },
    societyPurchaseGangWhitelist = {},
    enableSellVehicle = false,
    sellVehiclePercent = 0.6,
    enableFinance = false,
    hideMarkers = false,
    markers = {
      id = 21,
      size = {
        x = 0.3,
        y = 0.3,
        z = 0.3,
      },
      color = {
        r = 255,
        g = 255,
        b = 255,
        a = 120,
      },
      bobUpAndDown = 0,
      faceCamera = 0,
      rotate = 1,
      drawOnEnts = 0,
    },
    showroomJobWhitelist = {},
    showroomGangWhitelist = {},
    disableShowroomPurchase = true,
    directSaleDistance = 50,
    job = 'redline',
  },

  sixstr = {
    type = 'owned',
    showroomType = 'car',
    openShowroom = {
      coords = vec3(150.28, -3015.16, 7.04),
      size = 1,
    },
    openManagement = {
      coords = vec3(149.26, -3013.28, 7.04),
      size = 1,
    },
    sellVehicle = {
      coords = vector3(-824.6268, -282.9051, 37.8398),
      size = 2,
    },
    purchaseSpawn = vec4(162.05, -3006.05, 4.61, 270.56),
    testDriveSpawn = vec4(162.05, -3006.05, 4.61, 270.56),
    camera = {
      name = 'Car',
      coords = vec4(140.68, -3038.86, 5.70, 310.22),
      positions = {
        5,
        8,
        12,
        8,
      },
    },
    categories = {
      'tuner',
    },
    enableTestDrive = false,
    hideBlip = true,
    blip = {
      id = 326,
      color = 2,
      scale = 0.5,
    },
    societyPurchaseJobWhitelist = {
    },
    societyPurchaseGangWhitelist = {},
    enableSellVehicle = false,
    sellVehiclePercent = 0.6,
    enableFinance = false,
    hideMarkers = false,
    markers = {
      id = 21,
      size = {
        x = 0.3,
        y = 0.3,
        z = 0.3,
      },
      color = {
        r = 255,
        g = 255,
        b = 255,
        a = 120,
      },
      bobUpAndDown = 0,
      faceCamera = 0,
      rotate = 1,
      drawOnEnts = 0,
    },
    showroomJobWhitelist = {},
    showroomGangWhitelist = {},
    disableShowroomPurchase = true,
    directSaleDistance = 50,
    job = '6str',
  },

  mcforhandler = {
    type = 'owned',
    showroomType = 'bike',
    openShowroom = {
      coords = vec3(-64.80, 71.83, 71.61),
      size = 1,
    },
    openManagement = {
      coords = vec3(-53.33, 76.60, 71.63),
      size = 1,
    },
    sellVehicle = {
      coords = vector3(263.8009, -1164.4813, 29.1663),
      size = 1,
    },
    purchaseSpawn = vec4(-83.43, 80.68, 70.52, 152.39),
    testDriveSpawn = vec4(-83.43, 80.68, 70.52, 152.39),
    camera = {
      name = 'bike',
      coords = vec4(-73.93, 75.44, 70.61, 238.39),
      positions = {
        5,
        8,
        12,
        8,
      },
    },
    categories = {
      'motorcycles',
      'choppers',
      'offroad'
      
    },
    enableTestDrive = true,
    hideBlip = false,
    blip = {
      id = 348,
      color = 2,
      scale = 0.5,
    },
    societyPurchaseJobWhitelist = {
    },
    societyPurchaseGangWhitelist = {},
    enableSellVehicle = false,
    sellVehiclePercent = 0.6,
    enableFinance = false,
    hideMarkers = false,
    markers = {
      id = 21,
      size = {
        x = 0.3,
        y = 0.3,
        z = 0.3,
      },
      color = {
        r = 255,
        g = 255,
        b = 255,
        a = 120,
      },
      bobUpAndDown = 0,
      faceCamera = 0,
      rotate = 1,
      drawOnEnts = 0,
    },
    showroomJobWhitelist = {},
    showroomGangWhitelist = {},
    disableShowroomPurchase = true,
    directSaleDistance = 50,
    job = 'mcforhandler',
  },

  boatdealer = {
    isBoat = true,
    type = 'self-service',
    showroomType = 'car',
    openShowroom = {
      coords = vector3(-815.60, -1346.54, 5.15),
      size = 1,
    },
    openManagement = {
      coords = vector3(-25.63, -1104.61, 27.27),
      size = 1,
    },
    sellVehicle = {
      coords = vector3(-23.85418, -1095.249, 27.30523),
      size = 2,
    },
    purchaseSpawn = vector4(-846.18, -1362.11, -0.41, 109.53),
    testDriveSpawn = vector4(-848.54, -1353.27, -0.41, 108.18),
    camera = {
      name = 'sea',
      coords = vector4(-808.28, -1491.19, -0.47, 113.53),
      positions = {
        5,
        8,
        12,
        8,
      },
    },
    categories = {
      'boats',
    },
    enableTestDrive = true,
    hideBlip = false,
    blip = {
      id = 410,
      color = 3,
      scale = 0.5,
    },
    societyPurchaseJobWhitelist = {
    },
    societyPurchaseGangWhitelist = {},
    enableSellVehicle = false,
    sellVehiclePercent = 0.4,
    enableFinance = false,
    hideMarkers = false,
    markers = {
      id = 21,
      size = {
        x = 0.3,
        y = 0.3,
        z = 0.3,
      },
      color = {
        r = 255,
        g = 255,
        b = 255,
        a = 120,
      },
      bobUpAndDown = 0,
      faceCamera = 0,
      rotate = 1,
      drawOnEnts = 0,
    },
    showroomJobWhitelist = {},
    showroomGangWhitelist = {},
    disableShowroomPurchase = false,
    directSaleDistance = 50,
    job = 'boatdealer',
  },

  drift = {
    type = 'self-service',
    showroomType = 'car',
    openShowroom = {
      coords = vector3(910.9935, -1805.618, 22.37094),
      size = 1,
    },
    openManagement = {
      coords = vector3(907.7209, -1801.119, 22.37095),
      size = 1,
    },
    sellVehicle = {
      coords = vector3(908.6396, -1825.487, 22.14003),
      size = 2,
    },
    purchaseSpawn = vector4(913.6029, -1780.213, 22.13869, 355.231),
    testDriveSpawn = vector4(1030.676, -1766.944, 18.03365, 174.1852),
    camera = {
      name = 'Car',
      coords = vector4(-146.6166, -596.6301, 166.0, 270.0),
      positions = {
        5,
        8,
        12,
        8,
      },
    },
    categories = {
      'drift',
    },
    enableTestDrive = true,
    hideBlip = true,
    blip = {
      id = 326,
      color = 2,
      scale = 0.5,
    },
    societyPurchaseJobWhitelist = {
    },
    societyPurchaseGangWhitelist = {},
    enableSellVehicle = false,
    sellVehiclePercent = 0.6,
    enableFinance = false,
    hideMarkers = false,
    markers = {
      id = 21,
      size = {
        x = 0.3,
        y = 0.3,
        z = 0.3,
      },
      color = {
        r = 255,
        g = 255,
        b = 255,
        a = 120,
      },
      bobUpAndDown = 0,
      faceCamera = 0,
      rotate = 1,
      drawOnEnts = 0,
    },
    showroomJobWhitelist = {},
    showroomGangWhitelist = {},
    disableShowroomPurchase = false,
    directSaleDistance = 50,
    job = 'pdm',
  },
}
Config.MyFinanceCommand = 'myfinance'
Config.DirectSaleCommand = 'directsale'
Config.DealerAdminCommand = 'dealeradmin'
Config.ReturnToPreviousRoutingBucket = false
Config.Logging = true
