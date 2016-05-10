include('shared.lua')
include("lmm_estore_config.lua")

surface.CreateFont( "LMMESTORENPCBounceFont", {
	font = "Lato Light",
	size = 80,
	weight = 250,
	antialias = true,
	strikeout = false,
	additive = true,
} )

net.Receive("LMMESTOREOpeneStoreDMAN", function()

	local thetableshipments = net.ReadTable()
	local thetableweapons = net.ReadTable()
	local thetableammo = net.ReadTable()
	
	local DFrame = vgui.Create( "DFrame" )
	DFrame:SetSize( 550, 580 )
	DFrame:Center()
	DFrame:SetDraggable( true )
	DFrame:MakePopup()
	DFrame:SetTitle( "" )
	DFrame:ShowCloseButton( false )
	DFrame.Paint = function( self, w, h )
		draw.RoundedBox(2, 0, 0, DFrame:GetWide(), DFrame:GetTall(), Color(20, 20, 20, 250))
		draw.RoundedBox(2, 0, 0, DFrame:GetWide(), 30, Color(40, 40, 40, 255))
		draw.SimpleText( "eStore", "LMMESTORETitleFont", DFrame:GetWide() / 2, 15, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end
	
	local frameclose = vgui.Create("DButton", DFrame)
	frameclose:SetSize(20, 20)
	frameclose:SetPos(DFrame:GetWide() - frameclose:GetWide() - 3, 3)
	frameclose:SetText("X")
	frameclose:SetTextColor(Color(0,0,0,255))
	frameclose:SetFont("LMMESTOREfontclose")
	frameclose.hover = false
	frameclose.DoClick = function()
		DFrame:Close()
	end
	frameclose.OnCursorEntered = function(self)
		self.hover = true
	end
	frameclose.OnCursorExited = function(self)
		self.hover = false
	end
	function frameclose:Paint(w, h)	
		draw.RoundedBox(0, 0, 0, w, h, (self.hover and Color(255,15,15,250)) or Color(255,255,255,255)) -- Paints on hover
		frameclose:SetTextColor(self.hover and Color(255,255,255,250) or Color(0,0,0,255))
	end

	local function NoItems()
		local NoItems = vgui.Create( "DLabel", DFrame )
		NoItems:SetText( "There are no items for you to pickup!" )
		NoItems:SetFont( "LMMESTORENoFont" )
		NoItems:SetTextColor( Color( 200, 200, 200 ) )
		NoItems:SizeToContents()
		NoItems:Center()
	end

	instl = vgui.Create("DLabel", DFrame)
	instl:SetText("Click on the item you would like to pickup!")
	instl:SetPos(15, 30)
	instl:SetSize(500, 30)
	instl:SetTextColor(Color(255,0,0))
	
	local DPanelList = vgui.Create( "DPanelList", DFrame )
	DPanelList:SetPos( 10, 60 )
	DPanelList:SetSize( DFrame:GetWide() - 20, DFrame:GetTall() - 110 )
	DPanelList:SetSpacing( 2 )
	DPanelList:EnableVerticalScrollbar( true )
	DPanelList.VBar.Paint = function( s, w, h )
		draw.RoundedBox( 4, 3, 13, 8, h-24, Color(0,0,0,70))
	end
	DPanelList.VBar.btnUp.Paint = function( s, w, h ) end
	DPanelList.VBar.btnDown.Paint = function( s, w, h ) end
	DPanelList.VBar.btnGrip.Paint = function( s, w, h )
		draw.RoundedBox(2, 0, 0, DFrame:GetWide(), DFrame:GetTall(), Color(35, 35, 35, 255))
	end	
	
	if #thetableshipments == 0 and #thetableweapons == 0 and #thetableammo == 0 then
		NoItems()
	else
		for k, v in pairs(thetableshipments) do
			--seller, sellerhere, count, weapon, model, desc, price
			local ItemMain = vgui.Create( "DButton", DPanelList )
			ItemMain:SetSize( DPanelList:GetWide(), 120 )
		--	ItemMain:ShowCloseButton( false )
			ItemMain:SetText( "" )
			ItemMain.Paint = function( self, w, h )
				draw.RoundedBox(2, 0, 0, DFrame:GetWide(), DFrame:GetTall(), Color(40, 40, 40, 250))
			end			
			ItemMain.DoClick = function()
				Derma_Query( "Are you sure you want to pickup this shipment?",
				"eStore comfirm",
				"Yes",
				function()
					net.Start("LMMESTOREPickupShipment")
						net.WriteString(v[8])
						net.WriteEntity(self)
					net.SendToServer()
					DFrame:Close()
				end,
				"No",
				function()
				
				end
				)			
			end
			
			icon = vgui.Create("DModelPanel" , ItemMain )
			icon:SetPos( 5, 10 )
			icon:SetSize( 100, 100 )		
			icon:SetModel(v[5])
			local min, max = icon.Entity:GetRenderBounds()
			icon:SetCamPos(min:Distance(max) * Vector(0.7, 0.7, 0.7))
			icon:SetLookAt((max + min) / 2)

			weaponl = vgui.Create("DLabel", ItemMain)
			weaponl:SetText("Shipment: "..v[4].." (count: "..v[3]..")")
			weaponl:SetPos(100, 10)
			weaponl:SetSize(500, 30)
			weaponl:SetFont("LMMESTORESellLabel")
			
			if v[2] then
				sellerl = vgui.Create("DLabel", ItemMain)
				sellerl:SetText("Seller: "..v[1]:Nick())
				sellerl:SetPos(100, 35)
				sellerl:SetSize(500, 30)
				sellerl:SetFont("LMMESTORESellLabel")
			else
				sellerl = vgui.Create("DLabel", ItemMain)
				sellerl:SetText("Seller: "..v[1])
				sellerl:SetPos(100, 35)
				sellerl:SetSize(500, 30)
				sellerl:SetFont("LMMESTORESellLabel")			
			end
			
			descriptionl = vgui.Create("DLabel", ItemMain)
			descriptionl:SetText(v[6])
			descriptionl:SetPos(100, 60)
			descriptionl:SetSize(500, 30)
			descriptionl:SetFont("LMMESTORESellLabel")			

			pricel = vgui.Create("DLabel", ItemMain)
			pricel:SetText("Price paid: "..v[7])
			pricel:SetPos(100, 85)
			pricel:SetSize(500, 30)
			pricel:SetFont("LMMESTORESellLabel")			

			DPanelList:AddItem(ItemMain)			
		end	
		
		for k, v in pairs(thetableweapons) do
			--seller, sellerhere, weapon, model, string.sub(desc, 1, 63).."...", price
			local ItemMain = vgui.Create( "DButton", DPanelList )
			ItemMain:SetSize( DPanelList:GetWide(), 120 )
		--	ItemMain:ShowCloseButton( false )
			ItemMain:SetText( "" )
			ItemMain.Paint = function( self, w, h )
				draw.RoundedBox(2, 0, 0, DFrame:GetWide(), DFrame:GetTall(), Color(40, 40, 40, 250))
			end			
			ItemMain.DoClick = function()
				Derma_Query( "Are you sure you want to pickup this weapon?",
				"eStore comfirm",
				"Yes",
				function()
					net.Start("LMMESTOREPickupWeapon")
						net.WriteString(v[7])
					net.SendToServer()
					DFrame:Close()
				end,
				"No",
				function()
				
				end
				)
			end
			
			icon = vgui.Create("DModelPanel" , ItemMain )
			icon:SetPos( 5, 10 )
			icon:SetSize( 100, 100 )		
			icon:SetModel(v[4])
			local min, max = icon.Entity:GetRenderBounds()
			icon:SetCamPos(min:Distance(max) * Vector(0.7, 0.7, 0.7))
			icon:SetLookAt((max + min) / 2)

			weaponl = vgui.Create("DLabel", ItemMain)
			weaponl:SetText("Weapon: "..v[3])
			weaponl:SetPos(100, 10)
			weaponl:SetSize(500, 30)
			weaponl:SetFont("LMMESTORESellLabel")
			
			if v[2] then
				sellerl = vgui.Create("DLabel", ItemMain)
				sellerl:SetText("Seller: "..v[1]:Nick())
				sellerl:SetPos(100, 35)
				sellerl:SetSize(500, 30)
				sellerl:SetFont("LMMESTORESellLabel")
			else
				sellerl = vgui.Create("DLabel", ItemMain)
				sellerl:SetText("Seller: "..v[1])
				sellerl:SetPos(100, 35)
				sellerl:SetSize(500, 30)
				sellerl:SetFont("LMMESTORESellLabel")			
			end
			
			descriptionl = vgui.Create("DLabel", ItemMain)
			descriptionl:SetText(v[5])
			descriptionl:SetPos(100, 60)
			descriptionl:SetSize(500, 30)
			descriptionl:SetFont("LMMESTORESellLabel")			

			pricel = vgui.Create("DLabel", ItemMain)
			pricel:SetText("Price paid: "..v[6])
			pricel:SetPos(100, 85)
			pricel:SetSize(500, 30)
			pricel:SetFont("LMMESTORESellLabel")			

			DPanelList:AddItem(ItemMain)	
		end
		
		for k, v in pairs(thetableammo) do
			--seller, sellerhere, count, ammoType, model, string.sub(desc, 1, 63).."...", price
			local ItemMain = vgui.Create( "DButton", DPanelList )
			ItemMain:SetSize( DPanelList:GetWide(), 120 )
		--	ItemMain:ShowCloseButton( false )
			ItemMain:SetText( "" )
			ItemMain.Paint = function( self, w, h )
				draw.RoundedBox(2, 0, 0, DFrame:GetWide(), DFrame:GetTall(), Color(40, 40, 40, 250))
			end			
			ItemMain.DoClick = function()
				Derma_Query( "Are you sure you want to pickup this ammo?",
				"eStore comfirm",
				"Yes",
				function()
					net.Start("LMMESTOREPickupAmmo")
						net.WriteString(v[8])
					net.SendToServer()
					DFrame:Close()
				end,
				"No",
				function()
				
				end
				)
			end
			
			icon = vgui.Create("DModelPanel" , ItemMain )
			icon:SetPos( 5, 10 )
			icon:SetSize( 100, 100 )		
			icon:SetModel(v[5])
			local min, max = icon.Entity:GetRenderBounds()
			icon:SetCamPos(min:Distance(max) * Vector(0.7, 0.7, 0.7))
			icon:SetLookAt((max + min) / 2)

			weaponl = vgui.Create("DLabel", ItemMain)
			weaponl:SetText("Ammo Type: "..v[4].." (count: "..v[3]..")")
			weaponl:SetPos(100, 10)
			weaponl:SetSize(500, 30)
			weaponl:SetFont("LMMESTORESellLabel")
			
			if v[2] then
				sellerl = vgui.Create("DLabel", ItemMain)
				sellerl:SetText("Seller: "..v[1]:Nick())
				sellerl:SetPos(100, 35)
				sellerl:SetSize(500, 30)
				sellerl:SetFont("LMMESTORESellLabel")
			else
				sellerl = vgui.Create("DLabel", ItemMain)
				sellerl:SetText("Seller: "..v[1])
				sellerl:SetPos(100, 35)
				sellerl:SetSize(500, 30)
				sellerl:SetFont("LMMESTORESellLabel")			
			end
			
			descriptionl = vgui.Create("DLabel", ItemMain)
			descriptionl:SetText(v[6])
			descriptionl:SetPos(100, 60)
			descriptionl:SetSize(500, 30)
			descriptionl:SetFont("LMMESTORESellLabel")			

			pricel = vgui.Create("DLabel", ItemMain)
			pricel:SetText("Price paid: "..v[7])
			pricel:SetPos(100, 85)
			pricel:SetSize(500, 30)
			pricel:SetFont("LMMESTORESellLabel")			

			DPanelList:AddItem(ItemMain)	
		end		
	end

	local DashbordB = vgui.Create( "DButton", DFrame )
	DashbordB:SetPos( 10, 540 )
	DashbordB:SetSize( DFrame:GetWide() - 20,20 )
	DashbordB:SetText( "Dashboard" )
	DashbordB.OnCursorEntered = function(self)
		self.hover = true
	end
	DashbordB.OnCursorExited = function(self)
		self.hover = false
	end	
	DashbordB.Paint = function( self, w, h )		
		draw.RoundedBox(0, 0, 0, w, h, (self.hover and Color(0,160,255,250)) or Color(255,255,255,255)) -- Paints on hover
		DashbordB:SetTextColor(self.hover and Color(255,255,255,250) or Color(0,0,0,255))
	end
	DashbordB.DoClick = function()
		net.Start("LMMESTOREOpenTheDashbord")
		net.SendToServer()
		DFrame:Close()
	end
	
end)

local function LMMESTORENPCBounceFunction()
	for k, v in pairs( ents.FindByClass( "estore_npc" ) ) do
	   
		local p
	   
		p = v:GetPos() + Vector(0,0,85 + math.sin(CurTime()*3)*5)

		for _,yaw in pairs({0, 180}) do
			local a = Angle(0, 0, 0)
			a:RotateAroundAxis(a:Forward(), 90)
			a:RotateAroundAxis(a:Right(), yaw)
   
			a:RotateAroundAxis(a:Right(), CurTime() * 15)
			
			render.PushFilterMag(TEXFILTER.ANISOTROPIC)
			render.PushFilterMin(TEXFILTER.ANISOTROPIC)
			cam.Start3D2D(p, a, 0.1)
				draw.DrawText("eStore delivery man", "LMMESTORENPCBounceFont", 0, 0, Color(255, 0, 0, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)				
			cam.End3D2D()
			render.PopFilterMag()
			render.PopFilterMin()
		end
	end	
end 
hook.Add( "PostDrawOpaqueRenderables", "LMMESTORENPCBounceFunction", LMMESTORENPCBounceFunction)
