local ESX = nil
Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	ESX.PlayerData = ESX.GetPlayerData()
end)
RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    ESX.PlayerData.job = job
end)
 

RegisterCommand('admin:labs', function()
  local xPlayer = ESX.GetPlayerData()
  if (xPlayer.group == "user") or (xPlayer.group == "mod") then return end
  lib.registerContext({
      id = 'adminlab',
      title = 'Lab Administration',
      options = {
        {
              title = 'Registreret labs',
              event = 'registreret_labs',
              icon = 'bars',
              arrow = true
        },
        {
          title = 'Bande oversigt',
          event = 'bande_oversigt',
          icon = 'user-group',
          arrow = true
        },
        {
          title = '',
          disabled = true
        },
        {
          title = 'Opret lab',
          icon = 'plus',
          iconColor = 'green',
          iconAnimation = 'beatFade',
          onSelect = function()
            ESX.TriggerServerCallback('elm_druglab:getgangscreate', function(gangs)
              local availablegangs = {}
              for k,v in pairs(gangs) do
                table.insert(availablegangs, 
                {
                  value = k,
                  label = v.label,
                  name = v.name
                })
              end
              lib.progressCircle({
                duration = 500,
                position = 'middle',
                useWhileDead = false,
                canCancel = false,
                disable = {
                  move = true,
                  car = true,
                  combat = true,
                  mouse = true,
                  sprint = true,
                }
              })
              local input = lib.inputDialog("Lab oprettelse", {
                {
                  type = 'select', 
                  label = 'Produktion', 
                  required = true, 
                  icon = 'pills', 
                  description = 'Vælg stoffet der skal pakkes i labbet', 
                  options = {
                    { value = 'weed', label = 'Joints' },
                    { value = 'coke', label = 'Kokain' },
                    { value = 'meth', label = 'Meth' },
                    { value = 'heroin', label = 'Heroin'},
                  }
                },
                {
                  type = 'select', 
                  label = 'Ejerskab', 
                  required = true, 
                  icon = 'key', 
                  description = 'Vælg banden som skal have ejerskab over labbet', 
                  options = availablegangs
                },
                {
                  type = 'number', 
                  label = 'Pinkode', 
                  placeholder = '1234',
                  min = 1000,
                  max = 999999,
                  required = true, 
                  icon = 'keyboard', 
                  description = 'Vælg pinkoden som skal bruges ved adgang', 
                }
                })

                if input then
                  --LAB CREATOR
                    ESX.TriggerServerCallback('elm_druglab:getLab', function(hasLab)
                      if #hasLab < 1 then
                        lib.progressCircle({
                          label = 'Indlæser',
                          duration = 1000,
                          position = 'middle',
                          useWhileDead = false,
                          canCancel = false,
                          disable = {
                            move = true,
                            car = true,
                            combat = true,
                            mouse = true,
                            sprint = true,
                          }
                        })
                        keypaddata = KeyPad()
                        TriggerEvent('elm_druglabs:createshell', input[1], availablegangs[input[2]].name, availablegangs[input[2]].label, input[3], keypaddata)
                      else
                        lib.notify({
                          title = 'Fejl',
                          description = 'Banden har allerede et registreret lab!',
                          duration = 2500,
                          style = {
                              backgroundColor = '#141517',
                              color = '#C1C2C5',
                              ['.description'] = {
                                color = '#909296'
                              }
                          },
                          icon = 'ban',
                          iconColor = '#C53030'
                        })
                        lib.progressCircle({
                          duration = 500,
                          position = 'middle',
                          useWhileDead = false,
                          canCancel = false,
                          disable = {
                            move = true,
                            car = true,
                            combat = true,
                            mouse = true,
                            sprint = true,
                          }
                        })
                        lib.showContext('adminlab')
                      end
                    end, availablegangs[input[2]].name)
                else
                  lib.showContext('adminlab')
                end



            end, source) 
          end
        },
      }
    })
    lib.showContext('adminlab')  
end, false)

RegisterNetEvent('bande_oversigt', function()
    -- BANDE OVERSIGT
    gangview = {}
    ESX.TriggerServerCallback('elm_druglab:getgangs', function(result)
      for k,v in pairs(result) do
        ESX.TriggerServerCallback('elm_druglab:doesGangHave', function(gangStatus)
          if gangStatus then
            ESX.TriggerServerCallback('elm_druglab:getLab', function(ganginfo)
              table.insert(gangview,
              {
                title = v.label,
                icon = 'users',
                iconColor = 'green',
                iconAnimation = 'bounce',
                description = 'Lab registreret',
                readOnly = true,
                metadata = {
                  {label = 'Type:', value = ganginfo[1].object},
                  {label = 'Pinkode:', value = ganginfo[1].pin},
                  {label = 'ID:', value = ganginfo[1].id},
                },
              })
            end, v.name)
          else
            table.insert(gangview,
            {
              title = v.label,
              icon = 'hashtag',
              iconColor = 'red',
              readOnly = true,
            })
          end
        end, v.name)
      end
      lib.progressCircle({
        duration = 500,
        position = 'middle',
        useWhileDead = false,
        canCancel = false,
        disable = {
          move = true,
          car = true,
          combat = true,
          mouse = true,
          sprint = true,
        }
      })
      lib.registerContext({
          id = 'bande_oversigt',
          title = 'Bande oversigt',
          menu = 'adminlab',
          options = gangview,
      })
      lib.showContext('bande_oversigt')
  end, source)
end)

RegisterNetEvent('registreret_labs', function()
  -- REGISTRERET LABS
  registerview = {}
  ESX.TriggerServerCallback('elm_druglab:getRegLabs', function(result)
    for k,v in pairs(result) do
    table.insert(registerview,
    {
      title = v.label,
      icon = 'warehouse',
      arrow = true,
      event = 'editlab',
      args = {
        data = v
      }
    })
    end
    lib.progressCircle({
      duration = 500,
      position = 'middle',
      useWhileDead = false,
      canCancel = false,
      disable = {
        move = true,
        car = true,
        combat = true,
        mouse = true,
        sprint = true,
      }   
    })
    lib.registerContext({
        id = 'registreret_labs',
        title = 'Registreret labs',
        menu = 'adminlab',
        options = registerview,
    })
    lib.showContext('registreret_labs')
end, source)
end)

RegisterNetEvent('editlab', function(args)
  lib.progressCircle({
    duration = 250,
    position = 'middle',
    useWhileDead = false,
    canCancel = false,
    disable = {
      move = true,
      car = true,
      combat = true,
      mouse = true,
      sprint = true,
    }
  })
  lib.registerContext({
    id = 'editlab',
    title = 'Administrer lab',
    menu = 'registreret_labs',
    options = {
      {
        title = 'Lab information',
        description = 'Hold musen over for at se data om labbet',
        icon = 'circle-info',
        iconColor = 'teal',
        readOnly = true,
        metadata = {
          {label = 'Type', value = args.data.object},
          {label = 'Pinkode', value = args.data.pin},
          {label = 'ID', value = args.data.id},
          {label = 'Oprettet', value = args.data.timecreated},
          {label = 'Sidst opdateret', value = args.data.timeupdated},
        },
      },
      {
        title = 'Ændre produktion',
        description = 'Skift produkt der pakkes & labtype',
        icon = 'rotate-right',
        onSelect = function()
          local input = lib.inputDialog("Vælg produktionstype", {
            { type = 'select', label = 'Produkt', required = true, icon = 'pills', description = 'Vær opmærksom på at ingen må være i labbet', options = {
                { value = 'weed', label = 'Joints' },
                { value = 'coke', label = 'Kokain' },
                { value = 'meth', label = 'Meth' },
                { value = 'heroin', label = 'Heroin'},
            }}
            })
          if input[1] == args.data.object then
            lib.notify({
              title = 'Fejl',
              description = 'Labbet har allerede samme produktionstype!',
              duration = 2500,
              style = {
                  backgroundColor = '#141517',
                  color = '#C1C2C5',
                  ['.description'] = {
                    color = '#909296'
                  }
              },
              icon = 'ban',
              iconColor = '#C53030'
            })
            lib.progressCircle({
              duration = 350,
              position = 'middle',
              useWhileDead = false,
              canCancel = false,
              disable = {
                move = true,
                car = true,
                combat = true,
                mouse = true,
                sprint = true,
              }
            })
            lib.showContext('adminlab')
          else
            ESX.TriggerServerCallback('elm_druglab:changeStof', function(result)
              if result then
                TriggerEvent("syn_labs:reloadLabs")
                lib.notify({
                  title = 'Druglabs',
                  description = 'LAB ID: '..args.data.id..' fik ændret produktionstype',
                  duration = 2500,
                  icon = 'check-circle',
                  iconColor = 'green'
                })
                lib.showContext('adminlab')
              end
            end, input[1], args.data.id) 
          end
        end,
      },
      {
        title = 'Lab lokation',
        description = 'Tryk for at få lokationen på indgangen',
        icon = 'location-dot',
        onSelect = function()
          local info = json.decode(args.data.info)
          SetNewWaypoint(info[1].entrypos.x, info[1].entrypos.y)
          lib.showContext('adminlab')
        end,
      },
      {
        title = '',
        disabled = true
      },
      {
        title = 'Slet',
        description = 'Fjerner labbet samt dets data',
        icon = 'trash',
        iconColor = 'red',
        onSelect = function()
          if lib.alertDialog({
            header = 'Lab Administration',
            content = 'Er du sikker på du vil slette labbet?  \n Denne handling kan ikke fortrydes',
            centered = true,
            cancel = true,
            labels = {
              cancel = 'Annuller',
              confirm = 'Bekræft'
            }
            }) == "confirm" then
            ESX.TriggerServerCallback('elm_druglab:deleteLab', function(result)
              if result == true then
                local info = json.decode(args.data.info)
                TriggerEvent("syn_labs:reloadLabs", info)
                lib.notify({
                  title = 'Druglabs',
                  description = 'LAB ID: '..args.data.id..' blev slettet!',
                  duration = 2500,
                  icon = 'check-circle',
                  iconColor = 'green'
                })
                lib.progressCircle({
                  duration = 350,
                  position = 'middle',
                  useWhileDead = false,
                  canCancel = false,
                  disable = {
                    move = true,
                    car = true,
                    combat = true,
                    mouse = true,
                    sprint = true,
                  }
                })
                lib.showContext('adminlab')
              else
                lib.notify({
                  title = 'Druglabs',
                  description = 'Der skete en fejl!',
                  duration = 2500,
                  icon = 'ban',
                  iconColor = '#C53030'
                })
                lib.progressCircle({
                  duration = 350,
                  position = 'middle',
                  useWhileDead = false,
                  canCancel = false,
                  disable = {
                    move = true,
                    car = true,
                    combat = true,
                    mouse = true,
                    sprint = true,
                  }
                })
                lib.showContext('adminlab')
              end
            end, args.data.id)
          else
            lib.showContext('adminlab')
          end
        end,
      },
    }
  })
  lib.showContext('editlab')
end)

function KeyPad()
  local objectName = 'hei_prop_hei_keypad_03'
  local playerPed = PlayerPedId()
  local offset = GetOffsetFromEntityInWorldCoords(playerPed, 0, 1.0, 0)

  local model = joaat(objectName)
  lib.requestModel(model, 5000)

  local object = CreateObject(model, offset.x, offset.y, offset.z, true, false, false)

  local objectPositionData = exports.object_gizmo:useGizmo(object) --export for the gizmo. just pass an object handle to the function.

  DeleteEntity(object)
  return objectPositionData
end