print("^2Dunski Bet^7: Server initialized")

local webhooks = {
  ['bets'] = '',
  ['publicwinner'] = 'https://discord.com/api/webhooks/1358919612682600561/1q3doy2kwWhBStfYCRsvSqEnUix0egWQqVxO6h436WUulcpZvfoBr_2dJrtDk2T2Ix89',
  ['privatewinner'] = 'https://discord.com/api/webhooks/1358851935410720938/S4zD-Z0EiWEqcFeicEDVchvUex1aRCnWi5-285HU7W9ooL9Yvj9iP0kV85HBw5PvtJSd',
  ['deposits'] = 'https://discord.com/api/webhooks/1358851756561535066/cizgqk_E0bM_UHJuX3HuBbj8E7Hz03Z4k5TRefgs-PtqaJ3R3kS2RfYSCfg-eD1OQ62y',
  ['withdrawals'] = 'https://discord.com/api/webhooks/1358851789394280782/g0tkcCK8PdNntWRVxiaLT3vixGOa7rXDGAjvW6uT4eS4LsFRqzJeuAmmkSWV-lBlv-pG',
  ['admin'] = 'https://discord.com/api/webhooks/1358851825033548051/a-ySvQqC-SNcOxkvL7OEnMq9h70qg_mMBs_lrxAVNsMUmadI3-uJGcVmJAdLoCIN5Xzm',
  ['events'] = 'https://discord.com/api/webhooks/1358851859770773634/jZCUil02VOPStvBUlvX_KDDampVmqZ8zkOBq9zK1-mlTSOEbeUe5wEsr90Eo5DrNVpIR',
  ['bet_placed'] = 'https://discord.com/api/webhooks/1358851897058132211/YhXIKdBPeDRBtYdP0Omlhk2GT5cw2603ol81cXoM0kDm74qFiby_EhLLffufLT9os6q4',
  ['bet_won'] = 'https://discord.com/api/webhooks/1358851935410720938/S4zD-Z0EiWEqcFeicEDVchvUex1aRCnWi5-285HU7W9ooL9Yvj9iP0kV85HBw5PvtJSd',
  ['bet_lost'] = 'https://discord.com/api/webhooks/1358851969023873115/ULP9eqSVQmlbomEi7aKPwEnndGLgCRIs82FV4QYQm1VQZ5ED2yy-8C4iWz-pBa9Bjodo',
  ['bet_cashout'] = 'https://discord.com/api/webhooks/1358852012531384430/32zShGSDghZInt8XqPivIHkydossGd5oag7uHy9iGK4m8XY8p5sp_bvzStwW_mPrOGvJ',
  ['public'] = 'https://discord.com/api/webhooks/1358851715914272899/cHV_-WaLG6CTsJRzG4xd-oMzY-kZHobd-o1XGAaSA6NRAmIJwEwH-GS750KOCUvy3Z8K',
  ['economic_report'] = 'https://discord.com/api/webhooks/1360544217033740431/woNVnLoH32UW_gOnR-OV78_LlQVsBo7Kq6M51y3Qlk6nKA64AclFYAgHgp87HsuTjPHI',
  ['parlay_placed'] = 'https://discord.com/api/webhooks/1358851897058132211/YhXIKdBPeDRBtYdP0Omlhk2GT5cw2603ol81cXoM0kDm74qFiby_EhLLffufLT9os6q4',

  ['account_frozen'] = 'https://discord.com/api/webhooks/1358933758102863912/MdYdCDsLfrnY8VMMXuueLMaMx_Z2TYwSoVGfCJxoDZhtV00wOYihvOoyBo2fZXyxWYW1'
}

local function getPlayerDetails(source)
  local identifiers = {
    steamid = 'Ukendt',
    license = 'Ukendt',
    discord = 'Ukendt'
  }

  for k, v in ipairs(GetPlayerIdentifiers(source)) do
    if string.find(v, "steam:") then
      identifiers.steamid = v
    elseif string.find(v, "license:") then
      identifiers.license = v
    elseif string.find(v, "discord:") then
      identifiers.discord = v
    end
  end

  local xPlayer = ESX.GetPlayerFromId(source)
  local playerName = "Ukendt Spiller"
  if xPlayer then
    playerName = xPlayer.getName()
  end

  return {
    name = playerName,
    identifiers = identifiers
  }
end

function DiscordLog(webhookType, source, message)
  local webhook = webhooks[webhookType]
  if not webhook then
    -- print("^1Ugyldig webhook type: " .. webhookType .. "^7")
    return
  end

  local playerInfo = {}
  if source and source > 0 then
    playerInfo = getPlayerDetails(source)
  end

  local webhookTitles = {
    ['bets'] = "Væddemål",
    ['deposits'] = "Indbetalinger",
    ['withdrawals'] = "Udbetalinger",
    ['admin'] = "Admin Handlinger",
    ['events'] = "Begivenheder",
    ['bet_placed'] = "Væddemål Placeret",
    ['bet_won'] = "Væddemål Vundet",
    ['bet_lost'] = "Væddemål Tabt",
    ['bet_cashout'] = "Væddemål Udbetalt",
    ['account_frozen'] = "Konto Frosset"
  }

  local title = webhookTitles[webhookType] or webhookType:gsub("^%l", string.upper)
  
  local fields = {}
  
  table.insert(fields, {
    name = "Tidspunkt",
    value = os.date("%d/%m/%Y %H:%M:%S")
  })
  
  if source and source > 0 then
    table.insert(fields, {
      name = "Spiller",
      value = playerInfo.name .. " (ID: " .. source .. ")"
    })
    
    table.insert(fields, {
      name = "Identifikatorer",
      value = "Steam: " .. playerInfo.identifiers.steamid .. "\nLicense: " .. playerInfo.identifiers.license
    })
  end
  
  table.insert(fields, {
    name = "Detaljer",
    value = message
  })

  local payload = {
    content = nil,
    embeds = {
      {
        title = "DunskiBet - " .. title .. "\n",
        color = 21645,
        image = {
          url = "https://media.discordapp.net/attachments/1351358587141619753/1357380198613389324/iPhone_13_Instagram_Mockups_kit_-_01.png?ex=67f54452&is=67f3f2d2&hm=4497035d330603cdf79ad536b9e623f5c2494dba517523b153ed2452e28efc87&=&format=webp&quality=lossless&width=1843&height=1216"
        },
        author = {
          name = "DunskiBet.dk - Spil- og betting virksomhed!",
          url = "https://media.discordapp.net/attachments/1234990218466037820/1357398006361620721/DBET_app_icon2.png?ex=67f4ac27&is=67f35aa7&hm=9a6c1c91864271e1deb0653c15cf3553d6e11a682543653df11fda509432b528&=&format=webp&quality=lossless&width=960&height=960",
          icon_url = "https://media.discordapp.net/attachments/1234990218466037820/1357398006361620721/DBET_app_icon2.png?ex=67f4ac27&is=67f35aa7&hm=9a6c1c91864271e1deb0653c15cf3553d6e11a682543653df11fda509432b528&=&format=webp&quality=lossless&width=960&height=960"
        },
        fields = fields,
        description = "Log fra DunskiBet betting system\n",
        thumbnail = {
          url = "https://media.discordapp.net/attachments/1351358587141619753/1357380197258891385/ios-app-icon-mockup-iphone-16-pro-mockups-v1-front-vew.png?ex=67f54451&is=67f3f2d1&hm=b971ad55f7a34f1dfe6c0441402cc06d613010b26e3a7f5fe2173847ddf5e6fc&=&format=webp&quality=lossless&width=1823&height=1216"
        }
      }
    },
    attachments = {},
    author = {
      icon_url = "https://media.discordapp.net/attachments/1234990218466037820/1357398006361620721/DBET_app_icon2.png?ex=67f4ac27&is=67f35aa7&hm=9a6c1c91864271e1deb0653c15cf3553d6e11a682543653df11fda509432b528&=&format=webp&quality=lossless&width=960&height=960",
      name = "Dunski Bet"
    }
  }

  -- print("^2Dunski Bet^7: " .. title .. " - " .. message)
  if source then
    -- print("Forsøgerrrrr")
    exports.onl_logsender:SendLog(source, "Dunski Bet: " .. title .. " - " .. message, {
      labels = {
          job = "logs",
          discordId = true,
          steamId = true,
          license = true,
          playerJob = true,
          jobGrade = true,
          playerName = true,
          screenshot = false,
          money = true,
          black_money = true,
          bank = true,
          coords = true,
          radio = false,

      },
      discordTitle = "Dunski Bet - " .. title,
      discordColor = 16777215,
      discordDescription = message,
      discordWebhook = "https://discord.com/api/webhooks/1359240050864292051/VRYqKwaE0kaQzZEEEMX-WuEsNf2KE3P3SKK8NQGOEFN4EPTD4ahpB3NJPCracXlJGdtw?thread_id=1359239940529066106" -- Another webhook      
    })
  end



  PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode(payload), { ['Content-Type'] = 'application/json' })
end

function PublicEventLog(eventData)
  local webhook = webhooks['public']
  if not webhook then
    -- print("^1Public webhook ikke konfigureret^7")
    return
  end
  
  local fields = {}
  
  table.insert(fields, {
    name = "📅 Tidspunkt",
    value = os.date("%d/%m/%Y %H:%M:%S")
  })
  
  table.insert(fields, {
    name = "🏆 Kamp",
    value = eventData.home_team .. " vs " .. eventData.away_team
  })
  
  table.insert(fields, {
    name = "⚽ Sport",
    value = eventData.sport_key
  })
  
  if eventData.commence_time then
    local formattedTime = "TBA"
    if type(eventData.commence_time) == "string" then
      local year, month, day, hour, min = string.match(eventData.commence_time, "(%d+)-(%d+)-(%d+) (%d+):(%d+)")
      if year and month and day and hour and min then
        formattedTime = day .. "/" .. month .. "/" .. year .. " kl. " .. hour .. ":" .. min
      end
    end
    
    table.insert(fields, {
      name = "⏰ Dato og tid",
      value = formattedTime
    })
  end
  
  table.insert(fields, {
    name = "💰 Odds",
    value = "**" .. eventData.home_team .. "**: " .. eventData.home_odds .. "\n**" .. eventData.away_team .. "**: " .. eventData.away_odds
  })

  local payload = {
    content = nil,
    embeds = {
      {
        title = "DunskiBet - Ny Betting Mulighed\n",
        color = 21645,
        image = {
          url = "https://media.discordapp.net/attachments/1351358587141619753/1357380198613389324/iPhone_13_Instagram_Mockups_kit_-_01.png?ex=67f54452&is=67f3f2d2&hm=4497035d330603cdf79ad536b9e623f5c2494dba517523b153ed2452e28efc87&=&format=webp&quality=lossless&width=1843&height=1216"
        },
        author = {
          name = "DunskiBet.dk - Spil- og betting virksomhed!",
          url = "https://media.discordapp.net/attachments/1234990218466037820/1357398006361620721/DBET_app_icon2.png?ex=67f4ac27&is=67f35aa7&hm=9a6c1c91864271e1deb0653c15cf3553d6e11a682543653df11fda509432b528&=&format=webp&quality=lossless&width=960&height=960",
          icon_url = "https://media.discordapp.net/attachments/1234990218466037820/1357398006361620721/DBET_app_icon2.png?ex=67f4ac27&is=67f35aa7&hm=9a6c1c91864271e1deb0653c15cf3553d6e11a682543653df11fda509432b528&=&format=webp&quality=lossless&width=960&height=960"
        },
        fields = fields,
        description = "🎮 **Ny odds er tilgængelig i appen!** \nÅbn DunskiBet appen på din telefon for at placere dit væddemål nu.\n <@&1358876161089994773> \n",
        thumbnail = {
          url = "https://media.discordapp.net/attachments/1351358587141619753/1357380197258891385/ios-app-icon-mockup-iphone-16-pro-mockups-v1-front-vew.png?ex=67f54451&is=67f3f2d1&hm=b971ad55f7a34f1dfe6c0441402cc06d613010b26e3a7f5fe2173847ddf5e6fc&=&format=webp&quality=lossless&width=1823&height=1216"
        },
        footer = {
          text = "DunskiBet - Din online bookmaker"
        }
      }
    },
    attachments = {},
    author = {
      icon_url = "https://media.discordapp.net/attachments/1234990218466037820/1357398006361620721/DBET_app_icon2.png?ex=67f4ac27&is=67f35aa7&hm=9a6c1c91864271e1deb0653c15cf3553d6e11a682543653df11fda509432b528&=&format=webp&quality=lossless&width=960&height=960",
      name = "Dunski Bet"
    }
  }

  PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode(payload), { ['Content-Type'] = 'application/json' })
end

function AnnounceWinner(source, eventData, winnerData, isPublic)
  local webhook = isPublic and webhooks['publicwinner'] or webhooks['privatewinner']
  
  if not webhook or webhook == '' then
    return
  end
  
  if not isPublic and (not winnerData.allWinners or #winnerData.allWinners == 0) then
    return
  end
  
  local fields = {}
  
  table.insert(fields, {
    name = "📅 Tidspunkt",
    value = os.date("%d/%m/%Y %H:%M:%S")
  })
  
  table.insert(fields, {
    name = "🏆 Kamp",
    value = eventData.home_team .. " vs " .. eventData.away_team
  })
  
  table.insert(fields, {
    name = "🏅 Vinder",
    value = eventData.winner == "draw" and "Uafgjort" or eventData.winner
  })
  table.insert(fields, {
    name = "⚽ Sport",
    value = eventData.sport_key
  })
  
  if isPublic and winnerData.topBettor then
    table.insert(fields, {
      name = "🥇 Største Vinder",
      value = winnerData.topBettor.name
    })
    
    table.insert(fields, {
      name = "💰 Gevinst",
      value = winnerData.topBettor.winAmount .. " DKK (Indsats: " .. winnerData.topBettor.betAmount .. " DKK)"
    })
    
    table.insert(fields, {
      name = "📊 Odds",
      value = winnerData.topBettor.odds
    })
  elseif isPublic then
    table.insert(fields, {
      name = "🏆 Resultat",
      value = "Ingen vindere i denne kamp"
    })
  end
  
  if not isPublic and winnerData.allWinners and #winnerData.allWinners > 0 then
    local winnersText = ""
    local maxWinnersPerField = 15
    local totalWinners = #winnerData.allWinners
    
    local firstFieldCount = math.min(maxWinnersPerField, totalWinners)
    
    for i = 1, firstFieldCount do
      local winner = winnerData.allWinners[i]
      winnersText = winnersText .. i .. ". " .. winner.name .. " - " .. winner.winAmount .. " DKK (Indsats: " .. winner.betAmount .. " DKK, Odds: " .. winner.odds .. ")\n"
    end
    
    table.insert(fields, {
      name = "🏆 Vindere (" .. totalWinners .. " i alt)",
      value = winnersText ~= "" and winnersText or "Ingen vindere"
    })
    
    if totalWinners > maxWinnersPerField then
      local remainingWinners = ""
      local currentField = 2
      
      for i = maxWinnersPerField + 1, totalWinners do
        local winner = winnerData.allWinners[i]
        remainingWinners = remainingWinners .. i .. ". " .. winner.name .. " - " .. winner.winAmount .. " DKK (Odds: " .. winner.odds .. ")\n"
        
        if i % maxWinnersPerField == 0 or i == totalWinners then
          table.insert(fields, {
            name = "🏆 Flere Vindere (del " .. currentField .. ")",
            value = remainingWinners
          })
          remainingWinners = ""
          currentField = currentField + 1
        end
      end
    end
  end
  
  local title = isPublic and "DunskiBet - Væddemål Afgjort!" or "DunskiBet - Alle Vindere (Intern)"
  local description = isPublic 
    and "🎮 **Væddemålet er nu afgjort!** \nTillykke til alle vindere! Åbn DunskiBet appen for at indløse dine gevinster.\n <@&1358876161089994773> \n"
    or "Intern oversigt over alle vindere af væddemålet.\n"
  
    exports.onl_logsender:SendLog(source, "Dunski Win: " .. title, {
      labels = {
          job = "logs",
          discordId = true,
          steamId = true,
          license = true,
          playerJob = true,
          jobGrade = true,
          playerName = true,
          screenshot = false,
          money = true,
          black_money = true,
          bank = true,
          coords = true,
          radio = false,

      },
      discordTitle = "Dunski Bet - " .. title,
      discordColor = 16777215,
      discordDescription = title .. " \n \n " .. description,
      discordWebhook = "https://discord.com/api/webhooks/1359240050864292051/VRYqKwaE0kaQzZEEEMX-WuEsNf2KE3P3SKK8NQGOEFN4EPTD4ahpB3NJPCracXlJGdtw?thread_id=1359239940529066106"    
    })

  local payload = {
    content = isPublic and "<@&1358876161089994773>" or nil,
    embeds = {
      {
        title = title,
        color = 5763719,
        image = {
          url = "https://media.discordapp.net/attachments/1351358587141619753/1357380198613389324/iPhone_13_Instagram_Mockups_kit_-_01.png?ex=67f54452&is=67f3f2d2&hm=4497035d330603cdf79ad536b9e623f5c2494dba517523b153ed2452e28efc87&=&format=webp&quality=lossless&width=1843&height=1216"
        },
        author = {
          name = "DunskiBet.dk - Spil- og betting virksomhed!",
          url = "https://media.discordapp.net/attachments/1234990218466037820/1357398006361620721/DBET_app_icon2.png?ex=67f4ac27&is=67f35aa7&hm=9a6c1c91864271e1deb0653c15cf3553d6e11a682543653df11fda509432b528&=&format=webp&quality=lossless&width=960&height=960",
          icon_url = "https://media.discordapp.net/attachments/1234990218466037820/1357398006361620721/DBET_app_icon2.png?ex=67f4ac27&is=67f35aa7&hm=9a6c1c91864271e1deb0653c15cf3553d6e11a682543653df11fda509432b528&=&format=webp&quality=lossless&width=960&height=960"
        },
        fields = fields,
        description = description,
        thumbnail = {
          url = "https://media.discordapp.net/attachments/1351358587141619753/1357380197258891385/ios-app-icon-mockup-iphone-16-pro-mockups-v1-front-vew.png?ex=67f54451&is=67f3f2d1&hm=b971ad55f7a34f1dfe6c0441402cc06d613010b26e3a7f5fe2173847ddf5e6fc&=&format=webp&quality=lossless&width=1823&height=1216"
        },
        footer = {
          text = "DunskiBet - Din online bookmaker"
        }
      }
    },
    attachments = {},
    author = {
      icon_url = "https://media.discordapp.net/attachments/1234990218466037820/1357398006361620721/DBET_app_icon2.png?ex=67f4ac27&is=67f35aa7&hm=9a6c1c91864271e1deb0653c15cf3553d6e11a682543653df11fda509432b528&=&format=webp&quality=lossless&width=960&height=960",
      name = "Dunski Bet"
    }
  }

  PerformHttpRequest(webhook, function(err, text, headers)
    if err == 200 or err == 204 then
      -- print("^2Webhook Sent Successfully^7: " .. (isPublic and "Public" or "Private") .. " (Status: " .. err .. ")")
    else
      
      if text then
      else
      end
    end
  end, 'POST', json.encode(payload), { ['Content-Type'] = 'application/json' })
end
