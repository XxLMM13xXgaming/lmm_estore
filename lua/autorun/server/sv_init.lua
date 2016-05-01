--LMMESTORE
----------------------------------------------------------------------------
-- Network Strings
----------------------------------------------------------------------------
util.AddNetworkString("LMMESTORESellingItem")
util.AddNetworkString("LMMESTORESellItemShipment")
util.AddNetworkString("LMMESTORESellItemWeapon")
util.AddNetworkString("LMMESTORESellItemAmmo")
util.AddNetworkString("LMMESTOREOpenDashbord")
util.AddNetworkString("LMMESTOREOpeneStore")
util.AddNetworkString("LMMESTOREOpenTheDashbord")
util.AddNetworkString("LMMESTOREOpenShop")
util.AddNetworkString("LMMESTOREOpenProfile")
util.AddNetworkString("LMMESTOREOpenTheProfile")
util.AddNetworkString("LMMESTOREBuyShipment")
util.AddNetworkString("LMMESTOREBuyWeapon")
util.AddNetworkString("LMMESTOREBuyAmmo")
util.AddNetworkString("LMMESTOREOpenItems")
util.AddNetworkString("LMMESTOREOpenManageItems")
util.AddNetworkString("LMMESTORESubmitShipment")
util.AddNetworkString("LMMESTORESubmitWeapon")
util.AddNetworkString("LMMESTORESubmitAmmo")
util.AddNetworkString("LMMESTOREChangeShipmentPD")
util.AddNetworkString("LMMESTOREChangeWeaponPD")
util.AddNetworkString("LMMESTOREChangeAmmoPD")
util.AddNetworkString("LMMESTORERemoveShipment")
util.AddNetworkString("LMMESTORERemoveWeapon")
util.AddNetworkString("LMMESTORERemoveAmmo")
util.AddNetworkString("LMMESTOREBuyRenewSub")
util.AddNetworkString("LMMESTOREClaimMoney")
util.AddNetworkString("LMMESTORENotify")
----------------------------------------------------------------------------
-- Network Strings
----------------------------------------------------------------------------
----------------------------------------------------------------------------
-- Functions
----------------------------------------------------------------------------
function LMMESTOREBanUser(calling_ply, target_ply)
	local time = LMMESTOREConfig.BanTime * 60  + os.time()
	LMMESTOREdb:Query("INSERT INTO banned ( banned, time ) VALUES ( "..target_ply:SteamID64()..", "..time.." )")
	net.Start("LMMESTORENotify")
		net.WriteString(target_ply:Nick().." is now banned!")
	net.Send(calling_ply)	
	net.Start("LMMESTORENotify")
		net.WriteString("You have been banned from the eStore by "..calling_ply:Nick().."!")
	net.Send(target_ply)
	target_ply.LMMESTOREIsBanned = true
	target_ply.LMMESTOREBannedTime = LMMESTOREConfig.BanTime * 60  + os.time()
end

function LMMESTOREUnBanUser(target_ply)
	if LMMESTOREUserBanned(target_ply) then
		LMMESTOREdb:Query("DELETE FROM banned WHERE banned = " .. target_ply:SteamID64())
		net.Start("LMMESTORENotify")
			net.WriteString("You have been unbanned from the eStore!")
		net.Send(target_ply)
		
		target_ply.LMMESTOREIsBanned = false
		target_ply.LMMESTOREBannedTime = nil		
	end
end

function LMMESTOREUnSubuser(target_ply)
	if LMMESTOREUserSubscription(target_ply) then
		LMMESTOREdb:Query("DELETE FROM subscriptions WHERE subscribed = " .. target_ply:SteamID64())
		net.Start("LMMESTORENotify")
			net.WriteString("You have been unsubbed from the eStore! Renew now!")
		net.Send(target_ply)
		target_ply.LMMESTOREIsSubscribed = false
		target_ply.LMMESTORESubscribedTime = nil			
	end
end

function LMMESTORESubscribeToStore(target_ply)
	local time = LMMESTOREConfig.SubTime * 60  + os.time()
	LMMESTOREdb:Query("INSERT INTO subscriptions ( subscribed, time ) VALUES ( "..target_ply:SteamID64()..", "..time.." )")
	net.Start("LMMESTORENotify")
		net.WriteString("You are now subscribed to the eStore!")
	net.Send(target_ply)
	target_ply.LMMESTOREIsSubscribed = true
	target_ply.LMMESTORESubscribedTime = LMMESTOREConfig.SubTime * 60  + os.time()
end

function LMMESTOREUserBanned(ply)
	return ply.LMMESTOREIsBanned
end

function LMMESTOREUserSubscription(ply)
	return ply.LMMESTOREIsSubscribed
end	   	 

function LMMESTOREUserSubscriptionTime(ply)
	return ply.LMMESTORESubscribedTime
end
	
local function generateKey()
	local str = ""
	for i=1, 5 do
		str = str .. string.char(math.random(48, 57))
	end
	 
	return str   
end

function LMMESTOREGetUserBySteamID(steamid)
	for k, v in pairs(player.GetAll()) do
		if v:SteamID64() == steamid then
			return v
		end	
	end
	return false
end

function LMMESTOREOpeneStore(ply)
	if !LMMESTOREUserBanned(ply) then
		thetableshipments = {}
		thetableweapons = {}
		thetableammo = {}
		
		LMMESTOREdb:Query("SELECT * FROM shipments", function(result)
			for i=1, #result[1].data do
				if LMMESTOREGetUserBySteamID(result[1].data[i].seller) != false then
					seller = LMMESTOREGetUserBySteamID(result[1].data[i].seller)
					sellerhere = true
				else
					seller = "Offline Player("..result[1].data[i].seller..")"
					sellerhere = false				
				end
				local count = result[1].data[i].count
				local weapon  = result[1].data[i].weapon
				local model = result[1].data[i].model
				local desc = result[1].data[i].description
				local price = result[1].data[i].price
				local id = result[1].data[i].id
				
				if tonumber(result[1].data[i].pending) == 0 then	
					table.insert( thetableshipments, {seller, sellerhere, count, weapon, model, string.sub(desc, 1, 63).."...", price, id} )
				end
			end
		end)
		
		LMMESTOREdb:Query("SELECT * FROM weapons", function(result)
			for i=1, #result[1].data do
				if LMMESTOREGetUserBySteamID(result[1].data[i].seller) != nil then
					seller = LMMESTOREGetUserBySteamID(result[1].data[i].seller)
					sellerhere = true
				else
					seller = "Offline Player("..result[1].data[i].seller..")"
					sellerhere = false				
				end
				weapon = result[1].data[i].weapon
				model = result[1].data[i].model
				desc = result[1].data[i].description
				price = result[1].data[i].price
				id = result[1].data[i].id
				if tonumber(result[1].data[i].pending) == 0 then	
					table.insert( thetableweapons, {seller, sellerhere, weapon, model, string.sub(desc, 1, 63).."...", price, id} )
				end
			end
		end)		
		
		LMMESTOREdb:Query("SELECT * FROM ammo", function(result)
			for i=1, #result[1].data do
				if LMMESTOREGetUserBySteamID(result[1].data[i].seller) != nil then
					seller = LMMESTOREGetUserBySteamID(result[1].data[i].seller)
					sellerhere = true
				else
					seller = "Offline Player("..result[1].data[i].seller..")"
					sellerhere = false				
				end
				count = result[1].data[i].count
				ammoType = result[1].data[i].weapon
				model = result[1].data[i].model
				desc = result[1].data[i].description
				price = result[1].data[i].price
				id = result[1].data[i].id
				
				if tonumber(result[1].data[i].pending) == 0 then	
					table.insert( thetableammo, {seller, sellerhere, count, ammoType, model, string.sub(desc, 1, 63).."...", price, id} )
				end
			end
		end)		
		
		timer.Simple(.5, function()
			net.Start("LMMESTOREOpeneStore")
				net.WriteTable(thetableshipments)
				net.WriteTable(thetableweapons)
				net.WriteTable(thetableammo)
			net.Send(ply)
		end )
	else
		net.Start("LMMESTORENotify")
			net.WriteString("You are banned from the store!")
		net.Send(ply)
	end
end

function LMMESTOREGetPlayerByName( ply )
	local Players = player.GetAll()
	for i=1, table.Count( Players ) do
		if string.find( string.lower( Players[i]:Nick() ), string.lower( ply ) ) then
			return Players[i]
		end
	end
	return false
end

function LMMESTORECreateBotSale( specialnum )
	tablenum = 0	
	if specialnum == 0 then
		for k, v in pairs(LMMESTOREConfig.BotSales) do
			tablenum = tablenum + 1
		end
		specialnum = math.random(1, tablenum)
	end	
	
	for k, v in pairs(LMMESTOREConfig.BotSales) do
		local index = v.BotSalesIndex
		local type = v.BotSalesType
		local count = v.BotSalesCount
		local weapon = v.BotSalesWeapon
		local model = v.BotSalesModel
		local desc = v.BotSalesDesc
		local price = v.BotSalesPrice	

		if index == specialnum then
			if type == "shipment" then
				local query = ("INSERT INTO shipments ( seller, count, weapon, model, description, price, pending ) VALUES ( %q, %d, %q, %q, %q, %d, 0 )"):format( "server", count, weapon, model, desc, price )			
				LMMESTOREdb:Query(query, function(result)
					net.Start("LMMESTORENotify")
						net.WriteString("A bot has put a shipment for sale on the eStore!")
					net.Broadcast()
				end)
			elseif type == "weapon" then
				local query = ("INSERT INTO weapons ( seller, weapon, model, description, price, pending ) VALUES ( %q, %q, %q, %q, %d, 0 )"):format( "server", weapon, model, desc, price )		
				LMMESTOREdb:Query(query, function(result)
					net.Start("LMMESTORENotify")
						net.WriteString("A bot has put a weapon for sale on the eStore!")
					net.Broadcast()				
				end)
			elseif type == "ammo" then
				local query = ("INSERT INTO ammo ( seller, count, weapon, model, description, price, pending ) VALUES ( %q, %d, %q, %q, %q, %d, 0 )"):format( "server", count, weapon, model, desc, price )
				LMMESTOREdb:Query(query, function(result)
					net.Start("LMMESTORENotify")
						net.WriteString("A bot has put ammo for sale on the eStore!")
					net.Broadcast()				
				end)
			end 
		end
	end
end

LMMESTORECreateBotSale(0)

----------------------------------------------------------------------------
-- Functions
----------------------------------------------------------------------------
----------------------------------------------------------------------------
-- Hooks
----------------------------------------------------------------------------
hook.Add("PlayerInitialSpawn", "LMMESTORESetStoreBanned", function(ply)
	LMMESTOREdb:Query("SELECT * FROM banned WHERE banned = " .. ply:SteamID64(), function(result)
		if result[1].affected >= 1 then
			ply.LMMESTOREIsBanned = true
			ply.LMMESTOREBannedTime = result[1].data[1].time
		else
			ply.LMMESTOREIsBanned = false
			ply.LMMESTOREBannedTime = nil	
		end
	end)
end)

hook.Add("PlayerInitialSpawn", "LMMESTORESetStoreSubscription", function(ply)
	LMMESTOREdb:Query("SELECT * FROM subscriptions WHERE subscribed = " .. ply:SteamID64(), function(result)
		if result[1].affected >= 1 then
			ply.LMMESTOREIsSubscribed = true
			ply.LMMESTORESubscribedTime = result[1].data[1].time
		else
			ply.LMMESTOREIsSubscribed = false
			ply.LMMESTORESubscribedTime = nil
		end
	end) 
end)

local function LMMESTOREChatCommand(ply, text)
	local text = string.lower(text)
	if text == "!estore" or text == "/estore" then
		self = ply:GetEyeTrace().Entity
		if self:GetClass() == "spawned_shipment" then
			net.Start("LMMESTORESellingItem")
				net.WriteString("shipment")
				net.WriteFloat(self:Getcount())
				net.WriteString(CustomShipments[self:Getcontents()].entity)
				net.WriteString(CustomShipments[self:Getcontents()].model)
				net.WriteEntity(self)
			net.Send(ply)
			LMMESTOREdb:Query("SELECT * FROM players WHERE player = " .. ply:SteamID64(), function(result)
				if result[1].affected <= 0 then
					local query = ("INSERT INTO players ( player, earned, spent, unclaimed ) VALUES ( %q, %q, %q, %q )"):format( ply:SteamID64(), "0", "0", "0" )
					LMMESTOREdb:Query(query, function(result)
						if result[1].status == false then
							MsgC(Color(255,0,0), "[eStore] A error was encountered when attempting to save to the mysql database! Error has been saved to the data folder!\n")
							file.Write("lmmestore_data/errors/"..generateKey()..".txt", "Error: "..tostring(result[1].error).."\nError ID: "..tostring(result[1].errorid).."\nStatus: "..tostring(result[1].status).."\nTime: "..tostring(result[1].time))
							PrintTable(result)
						end
					end)
				end
			end)
		elseif self:GetClass() == "spawned_weapon" then
			net.Start("LMMESTORESellingItem")
				net.WriteString("weapon")
				net.WriteString(self:GetWeaponClass())
				net.WriteString(self:GetModel())
				net.WriteEntity(self)
			net.Send(ply)	
			LMMESTOREdb:Query("SELECT * FROM players WHERE player = " .. ply:SteamID64(), function(result)
				if result[1].affected <= 0 then
					local query = ("INSERT INTO players ( player, earned, spent, unclaimed ) VALUES ( %q, %q, %q, %q )"):format( ply:SteamID64(), "0", "0", "0" )
					LMMESTOREdb:Query(query, function(result)
						if result[1].status == false then
							MsgC(Color(255,0,0), "[eStore] A error was encountered when attempting to save to the mysql database! Error has been saved to the data folder!\n")
							file.Write("lmmestore_data/errors/"..generateKey()..".txt", "Error: "..tostring(result[1].error).."\nError ID: "..tostring(result[1].errorid).."\nStatus: "..tostring(result[1].status).."\nTime: "..tostring(result[1].time))
							PrintTable(result)
						end
					end)
				end
			end)
		elseif self:GetClass() == "spawned_ammo" then
			net.Start("LMMESTORESellingItem")
				net.WriteString("ammo")
				net.WriteFloat(self.amountGiven)
				net.WriteString(self.ammoType)
				net.WriteString(self:GetModel())
				net.WriteEntity(self)
			net.Send(ply)	
			LMMESTOREdb:Query("SELECT * FROM players WHERE player = " .. ply:SteamID64(), function(result)
				if result[1].affected <= 0 then
					local query = ("INSERT INTO players ( player, earned, spent, unclaimed ) VALUES ( %q, %q, %q, %q )"):format( ply:SteamID64(), "0", "0", "0" )
					LMMESTOREdb:Query(query, function(result)
						if result[1].status == false then
							MsgC(Color(255,0,0), "[eStore] A error was encountered when attempting to save to the mysql database! Error has been saved to the data folder!\n")
							file.Write("lmmestore_data/errors/"..generateKey()..".txt", "Error: "..tostring(result[1].error).."\nError ID: "..tostring(result[1].errorid).."\nStatus: "..tostring(result[1].status).."\nTime: "..tostring(result[1].time))
							PrintTable(result)
						end
					end)
				end
			end)
		else
			if LMMESTOREUserSubscription(ply) then
				net.Start("LMMESTOREOpenDashbord")
				net.Send(ply)
				LMMESTOREdb:Query("SELECT * FROM players WHERE player = " .. ply:SteamID64(), function(result)
					if result[1].affected <= 0 then
					local query = ("INSERT INTO players ( player, earned, spent, unclaimed ) VALUES ( %q, %q, %q, %q )"):format( ply:SteamID64(), "0", "0", "0" )
					LMMESTOREdb:Query(query, function(result)
							if result[1].status == false then
								MsgC(Color(255,0,0), "[eStore] A error was encountered when attempting to save to the mysql database! Error has been saved to the data folder!\n")
								file.Write("lmmestore_data/errors/"..generateKey()..".txt", "Error: "..tostring(result[1].error).."\nError ID: "..tostring(result[1].errorid).."\nStatus: "..tostring(result[1].status).."\nTime: "..tostring(result[1].time))
								PrintTable(result)
							end
						end)
					end
				end)
			else
				LMMESTOREOpeneStore(ply)
				LMMESTOREdb:Query("SELECT * FROM players WHERE player = " .. ply:SteamID64(), function(result)
					if result[1].affected <= 0 then
					local query = ("INSERT INTO players ( player, earned, spent, unclaimed ) VALUES ( %q, %q, %q, %q )"):format( ply:SteamID64(), "0", "0", "0" )
					LMMESTOREdb:Query(query, function(result)
							if result[1].status == false then
								MsgC(Color(255,0,0), "[eStore] A error was encountered when attempting to save to the mysql database! Error has been saved to the data folder!\n")
								file.Write("lmmestore_data/errors/"..generateKey()..".txt", "Error: "..tostring(result[1].error).."\nError ID: "..tostring(result[1].errorid).."\nStatus: "..tostring(result[1].status).."\nTime: "..tostring(result[1].time))
								PrintTable(result)
							end
						end)
					end
				end)
			end
		end
		return ''
	end
end 
hook.Add("PlayerSay", "LMMESTOREChatCommand", LMMESTOREChatCommand)

local function LMMESTOREChatCommandBan(ply, text)
	local text = string.lower(text)
	if(string.sub(text, 0, 10)== "!estoreban" or string.sub(text, 0, 10)== "/estoreban") then
		if !table.HasValue(LMMESTOREConfig.AdminGroups, ply:GetUserGroup()) then
			net.Start("LMMESTORENotify")
				net.WriteString("This command is for admins only!")
			net.Send(ply)
			return ''
		end
		
		local text = string.Explode(' ', text)
				
		if LMMESTOREGetPlayerByName(text[2]) == false then
			net.Start("LMMESTORENotify")
				net.WriteString("This player is not found!")
			net.Send(ply)
			return ''
		end
		
		if LMMESTOREUserBanned(LMMESTOREGetPlayerByName(text[2])) == true then
			net.Start("LMMESTORENotify")
				net.WriteString("This player is already banned!")
			net.Send(ply)			
			return ''
		end
		
		LMMESTOREBanUser(ply, LMMESTOREGetPlayerByName(text[2]))
		return ''
	end
end 
hook.Add("PlayerSay", "LMMESTOREChatCommandBan", LMMESTOREChatCommandBan)

local function LMMESTOREChatCommandUnBan(ply, text)
	local text = string.lower(text)
	if(string.sub(text, 0, 12)== "!estoreunban" or string.sub(text, 0, 12)== "/estoreunban") then
		local text = string.Explode(' ', text)

		if !table.HasValue(LMMESTOREConfig.AdminGroups, ply:GetUserGroup()) then
			net.Start("LMMESTORENotify")
				net.WriteString("This command is for admins only!")
			net.Send(ply)			
			return ''
		end
		
		if LMMESTOREGetPlayerByName(text[2]) == false then
			net.Start("LMMESTORENotify")
				net.WriteString("You need to specify a player!")
			net.Send(ply)			
			return ''
		end
		
		if LMMESTOREUserBanned(LMMESTOREGetPlayerByName(text[2])) == false then
			net.Start("LMMESTORENotify")
				net.WriteString("This player is not banned!")
			net.Send(ply)			
			return ''
		end
		
		LMMESTOREUnBanUser(ply)
		return ''
	end
end 
hook.Add("PlayerSay", "LMMESTOREChatCommandUnBan", LMMESTOREChatCommandUnBan)
----------------------------------------------------------------------------
-- Hooks
----------------------------------------------------------------------------
----------------------------------------------------------------------------
-- Timers
----------------------------------------------------------------------------
timer.Create("LMMESTORECheckForUnBan", 10, 0, function()
	for k, v in pairs(player.GetAll()) do
		if LMMESTOREUserBanned(v) then
			if os.time() >= v.LMMESTOREBannedTime then
				LMMESTOREUnBanUser(v)
			end
		end
	end
end)

timer.Create("LMMESTORECheckForUnSub", 10, 0, function()
	for k, v in pairs(player.GetAll()) do
		if LMMESTOREUserSubscription(v) then
			if os.time() >= tonumber(v.LMMESTORESubscribedTime) then
				LMMESTOREUnSubuser(v)
				net.Start("LMMESTORENotify")
					net.WriteString("Your subscription to the eStore has ran out!")
				net.Send(v)
				MsgC(Color(0,0,255), "[eStore] "..v:Nick().."'s eStore subscription has ran out!\n")
			end
		end
	end
end)
----------------------------------------------------------------------------
-- Timers
----------------------------------------------------------------------------
----------------------------------------------------------------------------
-- Net Receives
----------------------------------------------------------------------------
net.Receive("LMMESTOREClaimMoney", function(len, ply)
	LMMESTOREdb:Query("SELECT * FROM players WHERE player = "..ply:SteamID64(), function(result)	
		if result[1].affected > 0 then
			if tonumber(result[1].data[1].unclaimed) > 0 then
				ply:addMoney(tonumber(result[1].data[1].unclaimed))
				net.Start("LMMESTORENotify")
					net.WriteString(DarkRP.formatMoney(tonumber(result[1].data[1].unclaimed)).." has been added to your funds!")
				net.Send(ply)
				LMMESTOREdb:Query("UPDATE players SET unclaimed = 0 WHERE player = "..ply:SteamID64(), function(result)
				end)
			else
				net.Start("LMMESTORENotify")
					net.WriteString("There is no money to add to your wallet! Go make some money by selling stuff!")
				net.Send(ply)			
			end
		else
			PrintTable(result)
		end	
	end)
end)

net.Receive("LMMESTOREBuyRenewSub", function(len, ply)
	if !LMMESTOREUserBanned(ply) then
		if LMMESTOREUserSubscription(ply) then
			net.Start("LMMESTORENotify")
				net.WriteString("You already have a active subscription!")
			net.Send(ply)
		else
			if ply:getDarkRPVar("money") >= LMMESTOREConfig.RenewBuySub then
				ply:addMoney(-LMMESTOREConfig.RenewBuySub)
				LMMESTORESubscribeToStore(ply)
			end
		end
	end
end)

net.Receive("LMMESTOREOpenProfile", function(len, ply)
	if !LMMESTOREUserBanned(ply) then
		LMMESTOREdb:Query("SELECT * FROM players WHERE player = "..ply:SteamID64(), function(result)
			net.Start("LMMESTOREOpenTheProfile")
				net.WriteFloat(tonumber(result[1].data[1].earned))
				net.WriteFloat(tonumber(result[1].data[1].spent))
				net.WriteFloat(tonumber(result[1].data[1].unclaimed))				
				net.WriteBool(LMMESTOREUserSubscription(ply))
				net.WriteString(tostring(os.date("%m/%d/%Y", LMMESTOREUserSubscriptionTime(ply))))
			net.Send(ply)		
		end)
	end
end)

net.Receive("LMMESTORERemoveShipment", function(len, ply)
	local id = net.ReadString()

	if !LMMESTOREUserBanned(ply) then
		LMMESTOREdb:Query("DELETE FROM shipments WHERE id = "..id.." AND seller = "..ply:SteamID64(), function(result)
			if result[1].status == true then 
				net.Start("LMMESTORENotify")
					net.WriteString("Your item is now off the estore!")
				net.Send(ply)
			else
				print("Hey")
			end
		end)
	end	
end)

net.Receive("LMMESTORERemoveWeapon", function(len, ply)
	local id = net.ReadString()

	if !LMMESTOREUserBanned(ply) then
		LMMESTOREdb:Query("DELETE FROM weapon WHERE id = "..id.." AND seller = "..ply:SteamID64(), function(result)
			if result[1].status == true then 
				net.Start("LMMESTORENotify")
					net.WriteString("Your item is now off the estore!")
				net.Send(ply)
			else
				print("Hey")
			end
		end)
	end	
end)

net.Receive("LMMESTORERemoveAmmo", function(len, ply)
	local id = net.ReadString()

	if !LMMESTOREUserBanned(ply) then
		LMMESTOREdb:Query("DELETE FROM ammo WHERE id = "..id.." AND seller = "..ply:SteamID64(), function(result)
			if result[1].status == true then 
				net.Start("LMMESTORENotify")
					net.WriteString("Your item is now off the estore!")
				net.Send(ply)
			else
				print("Hey") 
			end
		end)
	end	
end)
 
net.Receive("LMMESTOREChangeShipmentPD", function(len, ply)
	local id = net.ReadString()
	local price = net.ReadString()
	local desc = net.ReadString()
	
	if !LMMESTOREUserBanned(ply) then	
		LMMESTOREdb:Query("UPDATE shipments SET price = "..price..", description = '"..desc.."' WHERE id = "..id.." AND seller = "..ply:SteamID64(), function(result)
			if result[1].status == false then
				PrintTable(result)
			else
				net.Start("LMMESTORENotify")
					net.WriteString("The price and description has been changed!")
				net.Send(ply)
			end
		end)
	end
end)

net.Receive("LMMESTOREChangeWeaponPD", function(len, ply)
	local id = net.ReadString()
	local price = net.ReadString()
	local desc = net.ReadString()
	
	if !LMMESTOREUserBanned(ply) then	
		LMMESTOREdb:Query("UPDATE weapons SET price = "..price..", description = '"..desc.."' WHERE id = "..id.." AND seller = "..ply:SteamID64(), function(result)
			if result[1].status == false then
				PrintTable(result)
			else
				net.Start("LMMESTORENotify")
					net.WriteString("The price and description has been changed!")
				net.Send(ply)
			end
		end)
	end
end)

net.Receive("LMMESTOREChangeAmmoPD", function(len, ply)
	local id = net.ReadString()
	local price = net.ReadString()
	local desc = net.ReadString()
	
	if !LMMESTOREUserBanned(ply) then	
		LMMESTOREdb:Query("UPDATE ammo SET price = "..price..", description = '"..desc.."' WHERE id = "..id.." AND seller = "..ply:SteamID64(), function(result)
			if result[1].status == false then
				PrintTable(result)
			else
				net.Start("LMMESTORENotify")
					net.WriteString("The price and description has been changed!")
				net.Send(ply)
			end
		end)
	end
end)

net.Receive("LMMESTORESubmitShipment", function(len, ply)
	local id = net.ReadString()

	if LMMESTOREUserSubscription(ply) then
		if !LMMESTOREUserBanned(ply) then
			LMMESTOREdb:Query("UPDATE shipments SET pending = 0 WHERE id = "..id.." AND seller = "..ply:SteamID64().." AND pending = 1", function(result)
				if result[1].affected <= 0 then
					net.Start("LMMESTORENotify")
						net.WriteString("This item is already on the eStore!")
					net.Send(ply)					
				else
					net.Start("LMMESTORENotify")
						net.WriteString("Congrats! Your item is now in the eStore!")
					net.Send(ply)				
				end
			end)
		else
			net.Start("LMMESTORENotify")
				net.WriteString("You are banned from the store!")
			net.Send(ply)			
		end	
	else
		net.Start("LMMESTORENotify")
			net.WriteString("You need a subscription to the eStore! Please visit the 'My profile' tab!")
		net.Send(ply)	
	end

end)

net.Receive("LMMESTORESubmitWeapon", function(len, ply)
	local id = net.ReadString()

	if LMMESTOREUserSubscription(ply) then
		if !LMMESTOREUserBanned(ply) then
			LMMESTOREdb:Query("UPDATE weapons SET pending = 0 WHERE id = "..id.." AND seller = "..ply:SteamID64().." AND pending = 1", function(result)
				if result[1].affected <= 0 then
					net.Start("LMMESTORENotify")
						net.WriteString("This item is already on the eStore!")
					net.Send(ply)					
				else
					net.Start("LMMESTORENotify")
						net.WriteString("Congrats! Your item is now in the eStore!")
					net.Send(ply)				
				end
			end)
		else
			net.Start("LMMESTORENotify")
				net.WriteString("You are banned from the store!")
			net.Send(ply)			
		end	
	else
		net.Start("LMMESTORENotify")
			net.WriteString("You need a subscription to the eStore! Please visit the 'My profile' tab!")
		net.Send(ply)	
	end
end)
 
net.Receive("LMMESTORESubmitAmmo", function(len, ply)
	local id = net.ReadString()

	if LMMESTOREUserSubscription(ply) then
		if !LMMESTOREUserBanned(ply) then
			LMMESTOREdb:Query("UPDATE ammo SET pending = 0 WHERE id = "..id.." AND seller = "..ply:SteamID64().." AND pending = 1", function(result)
				if result[1].affected <= 0 then
					net.Start("LMMESTORENotify")
						net.WriteString("This item is already on the eStore!")
					net.Send(ply)					
				else
					net.Start("LMMESTORENotify")
						net.WriteString("Congrats! Your item is now in the eStore!")
					net.Send(ply)				
				end
			end)
		else
			net.Start("LMMESTORENotify")
				net.WriteString("You are banned from the store!")
			net.Send(ply)			
		end	
	else
		net.Start("LMMESTORENotify")
			net.WriteString("You need a subscription to the eStore! Please visit the 'My profile' tab!")
		net.Send(ply)	
	end
end)

net.Receive("LMMESTOREOpenItems", function(len, ply)
	if !LMMESTOREUserBanned(ply) then
		thetableshipments = {}
		thetableweapons = {}
		thetableammo = {}
		
		LMMESTOREdb:Query("SELECT * FROM shipments", function(result)
			for i=1, #result[1].data do
				if LMMESTOREGetUserBySteamID(result[1].data[i].seller) != nil then
					seller = LMMESTOREGetUserBySteamID(result[1].data[i].seller)
					sellerhere = true
				else
					seller = "Offline Player("..result[1].data[i].seller..")"
					sellerhere = false				
				end
				local count = result[1].data[i].count
				local weapon  = result[1].data[i].weapon
				local model = result[1].data[i].model
				local desc = result[1].data[i].description
				local price = result[1].data[i].price
				local id = result[1].data[i].id
				
				if seller == ply:SteamID64() then
					table.insert( thetableshipments, {seller, sellerhere, count, weapon, model, string.sub(desc, 1, 63).."...", price, id, tonumber(result[1].data[i].pending)} )
				end
			end
		end)
		
		LMMESTOREdb:Query("SELECT * FROM weapons", function(result)
			for i=1, #result[1].data do
				if LMMESTOREGetUserBySteamID(result[1].data[i].seller) != nil then
					seller = LMMESTOREGetUserBySteamID(result[1].data[i].seller)
					sellerhere = true
				else
					seller = "Offline Player("..result[1].data[i].seller..")"
					sellerhere = false				
				end
				weapon = result[1].data[i].weapon
				model = result[1].data[i].model
				desc = result[1].data[i].description
				price = result[1].data[i].price
				id = result[1].data[i].id
				
				if seller == ply:SteamID64() then				
					table.insert( thetableweapons, {seller, sellerhere, weapon, model, string.sub(desc, 1, 63).."...", price, id, tonumber(result[1].data[i].pending)} )
				end
			end
		end)		
		
		LMMESTOREdb:Query("SELECT * FROM ammo", function(result)
			for i=1, #result[1].data do
				if LMMESTOREGetUserBySteamID(result[1].data[i].seller) != nil then
					seller = LMMESTOREGetUserBySteamID(result[1].data[i].seller)
					sellerhere = true
				else
					seller = "Offline Player("..result[1].data[i].seller..")"
					sellerhere = false				
				end
				count = result[1].data[i].count
				ammoType = result[1].data[i].weapon
				model = result[1].data[i].model
				desc = result[1].data[i].description
				price = result[1].data[i].price
				id = result[1].data[i].id
				
				if seller == ply:SteamID64() then
					table.insert( thetableammo, {seller, sellerhere, count, ammoType, model, string.sub(desc, 1, 63).."...", price, id, tonumber(result[1].data[i].pending)} )
				end
			end
		end)		
		
		timer.Simple(.5, function()
			net.Start("LMMESTOREOpenManageItems")
				net.WriteTable(thetableshipments)
				net.WriteTable(thetableweapons)
				net.WriteTable(thetableammo)
			net.Send(ply)
		end )
	else
		net.Start("LMMESTORENotify")
			net.WriteString("You are banned from the store!")
		net.Send(ply)
	end
end)

net.Receive("LMMESTOREOpenShop", function(len, ply)
	LMMESTOREOpeneStore(ply)
end)

net.Receive("LMMESTOREBuyShipment", function(len, ply)
	local id = net.ReadString()
	local thebuyer = ply:SteamID64()
	
	if !LMMESTOREUserBanned(ply) then
		LMMESTOREdb:Query("SELECT * FROM shipments WHERE id = "..id, function(result)
			thetype = "shipment"
			seller = result[1].data[1].seller
			count = result[1].data[1].count
			weapon = result[1].data[1].weapon
			model = result[1].data[1].model
			description = result[1].data[1].description
			price = tonumber(result[1].data[1].price)
			pending = tonumber(result[1].data[1].pending)
			if pending == 1 then
				pendingbool = true
			else
				pendingbool = false			
			end
			
			if ply:getDarkRPVar("money") > price then
				if pendingbool == false then
					local query = ("INSERT pickup ( type, seller, count, weapon, model, description, price, pending, buyer ) VALUES ( %q, %q, %q, %q, %q, %q, %q, %q, %q )"):format( thetype, seller, count, weapon, model, description, price, pending, thebuyer )				
					LMMESTOREdb:Query(query, function(result)
						ply:addMoney(-price)
						net.Start("LMMESTORENotify")
							net.WriteString("$"..price.." has been taken from your account! You can pick up your weapons from the eStore delivery man!")
						net.Send(ply)	
						LMMESTOREdb:Query("SELECT * FROM players WHERE player = "..thebuyer, function(result)
							if result[1].affected > 0 then
								LMMESTOREdb:Query("UPDATE players SET spent = "..tonumber(result[1].data[1].spent) + price.." WHERE player = "..thebuyer, function(result)
									if result[1].affected > 0 then
									
									else

									end
								end)
							else

							end
						end)	
						LMMESTOREdb:Query("SELECT * FROM players WHERE player = "..seller, function(result)
							if result[1].affected > 0 then
								LMMESTOREdb:Query("UPDATE players SET earned = "..tonumber(result[1].data[1].earned) + price..", unclaimed = "..tonumber(result[1].data[1].unclaimed) + price.." WHERE player = "..seller, function(result)
									if result[1].affected > 0 then
										
									else	
										PrintTable(result)
									end
								end)														
							end						
						end)						
						LMMESTOREdb:Query("DELETE FROM shipments WHERE id = "..id.." AND seller = "..seller, function(result)
							if result[1].status == false then

							end
						end)
					end)
				end
			else
				net.Start("LMMESTORENotify")
					net.WriteString("You do not have enough money!")
				net.Send(ply)				
			end
		end)
	else
		net.Start("LMMESTORENotify")
			net.WriteString("You are banned from the store!")
		net.Send(ply)	
	end
end)

net.Receive("LMMESTOREBuyWeapon", function(len, ply)
	local id = net.ReadString()
	local thebuyer = ply:SteamID64()

	if !LMMESTOREUserBanned(ply) then
		LMMESTOREdb:Query("SELECT * FROM weapons WHERE id = "..id, function(result)
			thetype = "weapon"
			seller = result[1].data[1].seller
			count = 0
			weapon = result[1].data[1].weapon
			model = result[1].data[1].model
			description = result[1].data[1].description
			price = tonumber(result[1].data[1].price)
			pending = tonumber(result[1].data[1].pending)
			if pending == 1 then
				pendingbool = true
			else
				pendingbool = false			
			end
			
			if ply:getDarkRPVar("money") > price then
				if pendingbool == false then
					local query = ("INSERT pickup ( type, seller, count, weapon, model, description, price, pending, buyer ) VALUES ( %q, %q, %q, %q, %q, %q, %q, %q, %q )"):format( thetype, seller, count, weapon, model, description, price, pending, thebuyer )				
					LMMESTOREdb:Query(query, function(result)
						ply:addMoney(-price)
						net.Start("LMMESTORENotify")
							net.WriteString("$"..price.." has been taken from your account! You can pick up your weapon from the eStore delivery man!")
						net.Send(ply)
						LMMESTOREdb:Query("SELECT * FROM players WHERE player = "..thebuyer, function(result)
							if result[1].affected > 0 then
								LMMESTOREdb:Query("UPDATE players SET spent = "..tonumber(result[1].data[1].spent) + price.." WHERE player = "..thebuyer, function(result)
									if result[1].affected > 0 then
									
									else

									end
								end)
							else

							end
						end)	
						LMMESTOREdb:Query("SELECT * FROM players WHERE player = "..seller, function(result)
							if result[1].affected > 0 then
								LMMESTOREdb:Query("UPDATE players SET earned = "..tonumber(result[1].data[1].earned) + price..", unclaimed = "..tonumber(result[1].data[1].unclaimed) + price.." WHERE player = "..seller, function(result)
									if result[1].affected > 0 then
									
									else	

									end
								end)														
							end						
						end)
						LMMESTOREdb:Query("DELETE FROM weapons WHERE id = "..id.." AND seller = "..seller, function(result)
							if result[1].status == false then

							end
						end)
					end)
				end
			else
				net.Start("LMMESTORENotify")
					net.WriteString("You do not have enough money!")
				net.Send(ply)
			end
		end)
	else
		net.Start("LMMESTORENotify")
			net.WriteString("You are banned from the store!")
		net.Send(ply)	
	end
end)

net.Receive("LMMESTOREBuyAmmo", function(len, ply)
	local id = net.ReadString()
	local thebuyer = ply:SteamID64()

	if !LMMESTOREUserBanned(ply) then
		LMMESTOREdb:Query("SELECT * FROM ammo WHERE id = "..id, function(result)
			thetype = "ammo"
			seller = result[1].data[1].seller
			count = result[1].data[1].count
			weapon = result[1].data[1].weapon
			model = result[1].data[1].model
			description = result[1].data[1].description
			price = tonumber(result[1].data[1].price)
			pending = tonumber(result[1].data[1].pending)
			if pending == 1 then
				pendingbool = true
			else
				pendingbool = false			
			end
			
			if ply:getDarkRPVar("money") > price then
				if pendingbool == false then
					local query = ("INSERT pickup ( type, seller, count, weapon, model, description, price, pending, buyer ) VALUES ( %q, %q, %q, %q, %q, %q, %q, %q, %q )"):format( thetype, seller, count, weapon, model, description, price, pending, thebuyer )				
					LMMESTOREdb:Query(query, function(result)
						ply:addMoney(-price)
						net.Start("LMMESTORENotify")
							net.WriteString("$"..price.." has been taken from your account! You can pick up your ammo from the eStore delivery man!")
						net.Send(ply)
						LMMESTOREdb:Query("SELECT * FROM players WHERE player = "..thebuyer, function(result)
							if result[1].affected > 0 then
								LMMESTOREdb:Query("UPDATE players SET spent = "..tonumber(result[1].data[1].spent) + price.." WHERE player = "..thebuyer, function(result)
									if result[1].affected > 0 then
									
									else

									end
								end)
							else

							end
						end)	
						LMMESTOREdb:Query("SELECT * FROM players WHERE player = "..seller, function(result)
							if result[1].affected > 0 then
								LMMESTOREdb:Query("UPDATE players SET earned = "..tonumber(result[1].data[1].earned) + price..", unclaimed = "..tonumber(result[1].data[1].unclaimed) + price.." WHERE player = "..seller, function(result)
									if result[1].affected > 0 then
										
									else	

									end
								end)														
							end						
						end)						
						LMMESTOREdb:Query("DELETE FROM ammo WHERE id = "..id.." AND seller = "..seller, function(result)
							if result[1].status == false then

							end
						end)
					end)
				end
			else
				net.Start("LMMESTORENotify")
					net.WriteString("You do not have enough money!")
				net.Send(ply)				
			end
		end)
	else
		net.Start("LMMESTORENotify")
			net.WriteString("You are banned from the store!")
		net.Send(ply)	
	end
end)

net.Receive("LMMESTOREOpenTheDashbord", function(len, ply)
	if !LMMESTOREUserBanned(ply) then
		net.Start("LMMESTOREOpenDashbord")
		net.Send(ply)
	else
		net.Start("LMMESTORENotify")
			net.WriteString("You are banned from the store!")
		net.Send(ply)	
	end
end)

net.Receive("LMMESTORESellItemShipment", function(len, ply)
	if !LMMESTOREUserBanned(ply) then
		local count = net.ReadFloat()
		local class = net.ReadString()
		local model = net.ReadString()
		local desc = net.ReadString()
		local price = net.ReadFloat()
		local ent = net.ReadEntity()
		local steamid = ply:SteamID64()
		local key = generateKey()
		local desc = string.gsub(desc, "|", "/")
		local query = ("INSERT INTO shipments ( seller, count, weapon, model, description, price, pending ) VALUES ( %q, %d, %q, %q, %q, %d, 1 )"):format( ply:SteamID64(), count, class, model, desc, price )

		if !isnumber(price) then
			return
		end

		if price < 0 then
			return
		end
		
		LMMESTOREdb:Query( query, function(result)
			if result[1].status == true then
				MsgC(Color(0,255,0), "[eStore] A shipment has been saved to the mysql database!\n")
			else
				MsgC(Color(255,0,0), "[eStore] A error was encountered when attempting to save to the mysql database! Error has been saved to the data folder!\n")
				file.Write("lmmestore_data/errors/"..generateKey()..".txt", "Error: "..tostring(result[1].error).."\nError ID: "..tostring(result[1].errorid).."\nStatus: "..tostring(result[1].status).."\nTime: "..tostring(result[1].time))
				PrintTable(result)
			end
		end)		
		ent:Remove()
		net.Start("LMMESTORENotify")
			net.WriteString("Your shipment has been added to your 'Manage my items' tab in the eStore! Please tpye !estore and check it out to publish!")
		net.Send(ply)
	else
		net.Start("LMMESTORENotify")
			net.WriteString("You are banned from selling items!")
		net.Send(ply)
	end
end)

net.Receive("LMMESTORESellItemWeapon", function(len, ply)
	if !LMMESTOREUserBanned(ply) then
		local class = net.ReadString()
		local model = net.ReadString()
		local desc = net.ReadString()
		local price = net.ReadFloat()
		local ent = net.ReadEntity()
		local steamid = ply:SteamID64()
		local key = generateKey()
		local desc = string.gsub(desc, "|", "/")
		local query = ("INSERT INTO weapons ( seller, weapon, model, description, price, pending ) VALUES ( %q, %q, %q, %q, %d, 1 )"):format( ply:SteamID64(), class, model, desc, price )

		if !isnumber(price) then
			return
		end

		if price < 0 then
			return
		end		
		
		LMMESTOREdb:Query( query, function(result)
			if result[1].status == true then
				MsgC(Color(0,255,0), "[eStore] A weapon has been saved to the mysql database!\n")
			else
				MsgC(Color(255,0,0), "[eStore] A error was encountered when attempting to save to the mysql database! Error has been saved to the data folder!\n")
				file.Write("lmmestore_data/errors/"..generateKey()..".txt", "Error: "..tostring(result[1].error).."\nError ID: "..tostring(result[1].errorid).."\nStatus: "..tostring(result[1].status).."\nTime: "..tostring(result[1].time))
				PrintTable(result)
			end
		end)		
		ent:Remove()
		net.Start("LMMESTORENotify")
			net.WriteString("Your weapon has been added to your 'Manage my items' tab in the eStore! Please tpye !estore and check it out to publish!")
		net.Send(ply)
	else
		net.Start("LMMESTORENotify")
			net.WriteString("You are banned from selling items!")
		net.Send(ply)
	end
end)

net.Receive("LMMESTORESellItemAmmo", function(len, ply)
	if !LMMESTOREUserBanned(ply) then	
		local count = net.ReadFloat()
		local ammotype = net.ReadString()
		local model = net.ReadString()
		local desc = net.ReadString()
		local price = net.ReadFloat()
		local ent = net.ReadEntity()
		local steamid = ply:SteamID64()
		local key = generateKey()
		local desc = string.gsub(desc, "|", "/")
		local query = ("INSERT INTO ammo ( seller, count, weapon, model, description, price, pending ) VALUES ( %q, %d, %q, %q, %q, %d, 1 )"):format( ply:SteamID64(), count, ammotype, model, desc, price )

		if !isnumber(price) then
			return
		end

		if price < 0 then
			return
		end		
		
		LMMESTOREdb:Query( query, function(result)
			if result[1].status == true then
				MsgC(Color(0,255,0), "[eStore] A ammo has been saved to the mysql database!\n")
			else
				MsgC(Color(255,0,0), "[eStore] A error was encountered when attempting to save to the mysql database! Error has been saved to the data folder!\n")
				file.Write("lmmestore_data/errors/"..generateKey()..".txt", "Error: "..tostring(result[1].error).."\nError ID: "..tostring(result[1].errorid).."\nStatus: "..tostring(result[1].status).."\nTime: "..tostring(result[1].time))
				PrintTable(result)
			end
		end)		
		ent:Remove()
		net.Start("LMMESTORENotify")
			net.WriteString("Your ammo has been added to your 'Manage my items' tab in the eStore! Please tpye !estore and check it out to publish!")
		net.Send(ply)
	else
		net.Start("LMMESTORENotify")
			net.WriteString("You are banned from selling items!")
		net.Send(ply)
	end
end)
----------------------------------------------------------------------------
-- Net Receives
----------------------------------------------------------------------------