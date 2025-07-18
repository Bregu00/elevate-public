--
-- Discord Webhooks
--

Webhooks = {}
Webhooks.TestDrive = "https://discord.com/api/webhooks/1338009650674663455/1wiiNTWc1adKoMSj2j-ONnGlaJt5M7LfSHThBCnNe7i4hG9NWLe4G5606YC15eDB4Klc?thread_id=1338009358436536330"
Webhooks.Purchase = "https://discord.com/api/webhooks/1338009720857821184/TfwOCOmTs8xBHiQ42beLHJXfU07c2h1aylDy6Z5bm4tzTPDOk1SOhCC0K8QNhLEJNyQZ?thread_id=1338009534349705237"
Webhooks.Finance = "https://discord.com/api/webhooks/1338009759588155444/xPSPjlyy7bOnhos_mhR7uz__JiMW-H8SnedmgUHmUTgMYC17r9kWFfbzNXyYhv4ebcuF?thread_id=1338009555879333969"
Webhooks.Dealership = "https://discord.com/api/webhooks/1338009811790331965/Mz5CA3F0NgOazc50EzvcyJiFJ0VljoWrxNVAAVSd6ItE-EVBh8t8LIbufPj_2mOHNDh6?thread_id=1338009580386390048"
Webhooks.Admin = "https://discord.com/api/webhooks/1338009854970822706/XbJF85gNa3iy3Tp2HX2PNeh7H_VrxSz-SidKpxVeEHvK8gA0um5fj9ASZXXSdLaZChDb?thread_id=1338009604793040966"

--[[
  EXAMPLE WEBHOOK CALL

  sendWebhook(src, Webhooks.Admin, "Webhook Title", "success", {
    { key = "Data fields", value = "Data value" },
    { key = "Data fields 2", value = "Data value 2" }
  })
]]--

function sendWebhook(playerId, webhookUrl, title, type, data)
  if not webhookUrl then return end

  local player = Framework.Server.GetPlayerInfo(playerId)
  if not player then return false end

  local color = 0xff6700
  if type == "success" then color = 0x2ecc71 end
  if type == "danger" then color = 0xe74c3c end

  local fields = {
    {
      name = "Player",
      value = string.format("%s (id: %s)", player.name, tostring(playerId)),
      inline = false
    }
  }
  for _, row in pairs(data) do
    fields[#fields + 1] = {
      name = row.key,
      value = tostring(row.value),
      inline = true
    }
  end

  local body = {
    username = "JG Dealerships Webhook",
    avatar_url = "https://forum.cfx.re/user_avatar/forum.cfx.re/jgscripts/288/3621910_2.png",
    content = "",
    embeds = {
      {
        type = "rich",
        title = title,
        description = "",
        color = color,
        fields = fields
      }
    }
  }

  PerformHttpRequest(
    webhookUrl,
    function(err, text, header) end,
    "POST",
    json.encode(body),
    {["Content-Type"] = "application/json"}
  )
end