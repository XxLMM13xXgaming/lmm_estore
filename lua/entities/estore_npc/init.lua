-- LMMESTORE
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include('shared.lua')

util.AddNetworkString("LMMESTOREOpeneStoreDMAN")
util.AddNetworkString("LMMESTOREPickupShipment")
util.AddNetworkString("LMMESTOREPickupWeapon")
util.AddNetworkString("LMMESTOREPickupAmmo")

function ENT:Initialize()
	self:SetModel( "models/humans/group01/male_05.mdl" )
	self:SetHullType( HULL_HUMAN )
	self:SetHullSizeNormal( )
	self:SetNPCState( NPC_STATE_SCRIPT )
	self:SetSolid(  SOLID_BBOX )
	self:CapabilitiesAdd( CAP_ANIMATEDFACE, CAP_TURN_HEAD )
	self:SetUseType( SIMPLE_USE )
	self:DropToFloor()
	self.damage = 100
	self:SetMaxYawSpeed( 90 )
end

net.Receive("LMMESTOREPickupShipment", function(len, ply)
	local id = net.ReadString()
	self = net.ReadEntity()
	
	LMMESTOREdb:Query("SELECT * FROM pickup WHERE id = "..id, function(result)
		if ply:SteamID64() == result[1].data[1].buyer then	
			count = tonumber(result[1].data[1].count)
			class = result[1].data[1].weapon
			model = result[1].data[1].model

			local weapon = ents.Create(class)
			
			weapon:SetPos(ply:GetPos() + Vector(0, 0, 20))
			weapon:SetAngles(Angle(0,0,0))
			weapon:SetModel(model)
			weapon:Spawn()
			weapon:Activate()		
			if count > 1 then
				timer.Create("LMMESTOREReceiveItems", 0, count - 1, function()
					local weapon = ents.Create(class)
					
					weapon:SetPos(ply:GetPos() + Vector(0, 0, 20))
					weapon:SetAngles(Angle(0,0,0))
					weapon:SetModel(model)
					weapon:Spawn()
					weapon:Activate()		
				end)
			end
			
			LMMESTOREdb:Query("DELETE FROM pickup WHERE id = " .. id, function(result)
			end)
			
			net.Start("LMMESTORENotify")
				net.WriteString("Your shipment has been givin in singles! Thanks for choosing eStore!")
			net.Send(ply)		
		end
	end)	
end)

net.Receive("LMMESTOREPickupWeapon", function(len, ply)
	local id = net.ReadString()
	
	LMMESTOREdb:Query("SELECT * FROM pickup WHERE id = "..id, function(result)
		if ply:SteamID64() == result[1].data[1].buyer then	
			class = result[1].data[1].weapon
			model = result[1].data[1].model

			local weapon = ents.Create(class)
			
			weapon:SetPos(ply:GetPos() + Vector(0, 0, 20))
			weapon:SetAngles(Angle(0,0,0))
			weapon:SetModel(model)
			weapon:Spawn()
			weapon:Activate()		
		
			LMMESTOREdb:Query("DELETE FROM pickup WHERE id = " .. id, function(result)
			end)
		
			net.Start("LMMESTORENotify")
				net.WriteString("Your weapon has been givin! Thanks for choosing eStore!")
			net.Send(ply)		
		end
	end)	
end)

net.Receive("LMMESTOREPickupAmmo", function(len, ply)
	local id = net.ReadString()
	
	LMMESTOREdb:Query("SELECT * FROM pickup WHERE id = "..id, function(result)
		if ply:SteamID64() == result[1].data[1].buyer then
			count = tonumber(result[1].data[1].count)
			class = result[1].data[1].weapon
			model = result[1].data[1].model

			local weapon = ents.Create(class)
			
			ply:GiveAmmo( count, class, true )
			
			LMMESTOREdb:Query("DELETE FROM pickup WHERE id = " .. id, function(result)
			end)
			
			net.Start("LMMESTORENotify")
				net.WriteString("Your ammo has been givin! Thanks for choosing eStore!")
			net.Send(ply)		
		end
	end)	
end)

function LMMESTOREOpeneStoreDMANOpen(ply, seller)
	if !LMMESTOREUserBanned(ply) then
		thetableshipments = {}
		thetableweapons = {}
		thetableammo = {}
		
		LMMESTOREdb:Query("SELECT * FROM pickup", function(result)
			for i=1, #result[1].data do
				if result[1].data[i].type == "shipment" then
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
					
					if result[1].data[i].buyer == ply:SteamID64() then	
						table.insert( thetableshipments, {seller, sellerhere, count, weapon, model, string.sub(desc, 1, 63).."...", price, id} )
					end
				elseif result[1].data[i].type == "weapon" then
					print("weapon")				
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
					
					if result[1].data[i].buyer == ply:SteamID64() then	
						table.insert( thetableweapons, {seller, sellerhere, weapon, model, string.sub(desc, 1, 63).."...", price, id} )
					end				
				elseif result[1].data[i].type == "ammo" then
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
					
					if result[1].data[i].buyer == ply:SteamID64() then	
						table.insert( thetableammo, {seller, sellerhere, count, ammoType, model, string.sub(desc, 1, 63).."...", price, id} )
					end				
				end
			end
		end)
		
		timer.Simple(.2, function()
			net.Start("LMMESTOREOpeneStoreDMAN")
				net.WriteTable(thetableshipments)
				net.WriteTable(thetableweapons)
				net.WriteTable(thetableammo)
				net.WriteEntity(self)
			net.Send(ply)
		end )
	else
		net.Start("LMMESTORENotify")
			net.WriteString("You are banned from the eStore!")
		net.Send(Caller)	
	end
end

function ENT:AcceptInput( Name, Activator, Caller )		
	if Name == "Use" and Caller:IsPlayer() then
		if !LMMESTOREUserBanned(Caller) then
			LMMESTOREOpeneStoreDMANOpen(Caller, self)
		else
			net.Start("LMMESTORENotify")
				net.WriteString("You are banned from the eStore!")
			net.Send(Caller)
		end
	end
end