function CreateAddonAccount(name, owner, money)
	local self = {}

	self.name  = name
	self.owner = owner
	self.money = money
	if name ~= nil then
		local hasUnderscore = string.find(name, "_")
		if hasUnderscore then
			self.jobName = string.match(name, "_(.*)")
		end
	end
	function self.addMoney(amount)
		self.money = self.money + amount
		self.save()
		print(self.jobName, amount, self.money)
	end

	function self.removeMoney(amount)
		self.money = self.money - amount
		self.save()
		print(self.jobName, amount, self.money)
	end

	function self.setMoney(amount)
	end

	function self.save()
		if self.owner == nil then
			MySQL.update('UPDATE addon_account_data SET money = ? WHERE account_name = ?', { self.money, self.name })
		else
			MySQL.update('UPDATE addon_account_data SET money = ? WHERE account_name = ? AND owner = ?',
				{ self.money, self.name, self.owner })
		end
		TriggerClientEvent('esx_addonaccount:setMoney', -1, self.name, self.money)
	end

	return self
end
