include('shared.lua')

surface.CreateFont( "LMMESTORENPCBounceFont", {
	font = "Lato Light",
	size = 80,
	weight = 250,
	antialias = true,
	strikeout = false,
	additive = true,
} )
include("lmm_estore_config.lua")

surface.CreateFont( "fontclose", {
	font = "Lato Light",
	size = 25,
	weight = 250,
	antialias = true,
	strikeout = false,
	additive = true,
} )
 
surface.CreateFont( "LMMESTORETitleFont", {
	font = "Lato Light",
	size = 30,
	weight = 250,
	antialias = true,
	strikeout = false,
	additive = true,
} )
 
surface.CreateFont( "LMMESTORENameFont", {
	font = "Lato Light",
	size = 46,
	weight = 250,
	antialias = true,
	strikeout = false,
	additive = true,
} )
 
surface.CreateFont( "LMMESTORENameFontSmall", {
	font = "Lato Light",
	size = 34,
	weight = 250,
	antialias = true,
	strikeout = false,
	additive = true,
} )
 
surface.CreateFont( "LMMESTOREJobFont", {
	font = "Lato Light",
	size = 20,
	weight = 250,
	antialias = true,
	strikeout = false,
	additive = true,
} )
 
local blur = Material("pp/blurscreen")
local function DrawBlur(panel, amount) --Panel blur function
	local x, y = panel:LocalToScreen(0, 0)
	local scrW, scrH = ScrW(), ScrH()
	surface.SetDrawColor(255, 255, 255)
	surface.SetMaterial(blur)
	for i = 1, 6 do 
		blur:SetFloat("$blur", (i / 3) * (amount or 6))
		blur:Recompute()
		render.UpdateScreenEffectTexture()
		surface.DrawTexturedRect(x * -1, y * -1, scrW, scrH)
	end
end
 
local function drawRectOutline( x, y, w, h, color )
	surface.SetDrawColor( color )
	surface.DrawOutlinedRect( x, y, w, h )
end

net.Receive("LMMESTOREOpeneStoreDMAN", function()

	local thetableshipments = net.ReadTable()
	local thetableweapons = net.ReadTable()
	local thetableammo = net.ReadTable()
	
	local DFrame = vgui.Create( "DFrame" )
	DFrame:SetSize( 550, 600 )
	DFrame:Center()
	DFrame:SetDraggable( true )
	DFrame:MakePopup()
	DFrame:SetTitle( "" )
	DFrame:ShowCloseButton( false )
	DFrame.Paint = function( self, w, h )
		DrawBlur(DFrame, 2)
		drawRectOutline( 0, 0, w, h, Color( 0, 0, 0, 85 ) )	
		draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 85))
		drawRectOutline( 2, 2, w - 4, h / 12.9, Color( 0, 0, 0, 85 ) )
		draw.RoundedBox(0, 2, 2, w - 4, h / 13, Color(0,0,0,125))
		draw.SimpleText( "eStore", "LMMESTORETitleFont", DFrame:GetWide() / 2, 25, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end
	
	local frameclose = vgui.Create( "DButton", DFrame )
	frameclose:SetSize( 35, 35 )
	frameclose:SetPos( DFrame:GetWide() - 36,9 )
	frameclose:SetText( "X" )
	frameclose:SetFont( "fontclose" )
	frameclose:SetTextColor( Color( 255, 255, 255 ) )
	frameclose.Paint = function()
		
	end
	frameclose.DoClick = function()
		DFrame:Close()
		DFrame:Remove()
	end

	local function NoItems()
		local NoItems = vgui.Create( "DLabel", DFrame )
		NoItems:SetText( "There are no items for you to pickup!" )
		NoItems:SetFont( "LMMESTORENameFont" )
		NoItems:SetTextColor( Color( 200, 200, 200 ) )
		NoItems:SizeToContents()
		NoItems:Center()
	end

	instl = vgui.Create("DLabel", DFrame)
	instl:SetText("Click on the item you would like to pickup!")
	instl:SetPos(15, 50)
	instl:SetSize(500, 30)
	instl:SetTextColor(Color(255,0,0))
	
	local DPanelList = vgui.Create( "DPanelList", DFrame )
	DPanelList:SetPos( 10, 80 )
	DPanelList:SetSize( DFrame:GetWide() - 20, DFrame:GetTall() - 130 )
	DPanelList:SetSpacing( 2 )
	DPanelList:EnableVerticalScrollbar( true )
	DPanelList.VBar.Paint = function( s, w, h )
		draw.RoundedBox( 4, 3, 13, 8, h-24, Color(0,0,0,70))
	end
	DPanelList.VBar.btnUp.Paint = function( s, w, h ) end
	DPanelList.VBar.btnDown.Paint = function( s, w, h ) end
	DPanelList.VBar.btnGrip.Paint = function( s, w, h )
		draw.RoundedBox( 4, 5, 0, 4, h+22, Color(0,0,0,70))
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
				drawRectOutline( 2, 2, w - 2, h - 2, Color( 0, 0, 0, 85 ) )
				draw.RoundedBox(0, 2, 2, w , h , Color(0,0,0,125))
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
			weaponl:SetFont("LMMESTOREJobFont")
			
			if v[2] then
				sellerl = vgui.Create("DLabel", ItemMain)
				sellerl:SetText("Seller: "..v[1]:Nick())
				sellerl:SetPos(100, 35)
				sellerl:SetSize(500, 30)
				sellerl:SetFont("LMMESTOREJobFont")
			else
				sellerl = vgui.Create("DLabel", ItemMain)
				sellerl:SetText("Seller: "..v[1])
				sellerl:SetPos(100, 35)
				sellerl:SetSize(500, 30)
				sellerl:SetFont("LMMESTOREJobFont")			
			end
			
			descriptionl = vgui.Create("DLabel", ItemMain)
			descriptionl:SetText(v[6])
			descriptionl:SetPos(100, 60)
			descriptionl:SetSize(500, 30)
			descriptionl:SetFont("LMMESTOREJobFont")			

			pricel = vgui.Create("DLabel", ItemMain)
			pricel:SetText("Price paid: "..v[7])
			pricel:SetPos(100, 85)
			pricel:SetSize(500, 30)
			pricel:SetFont("LMMESTOREJobFont")			

			DPanelList:AddItem(ItemMain)			
		end	
		
		for k, v in pairs(thetableweapons) do
			--seller, sellerhere, weapon, model, string.sub(desc, 1, 63).."...", price
			local ItemMain = vgui.Create( "DButton", DPanelList )
			ItemMain:SetSize( DPanelList:GetWide(), 120 )
		--	ItemMain:ShowCloseButton( false )
			ItemMain:SetText( "" )
			ItemMain.Paint = function( self, w, h )
				drawRectOutline( 2, 2, w - 2, h - 2, Color( 0, 0, 0, 85 ) )
				draw.RoundedBox(0, 2, 2, w , h , Color(0,0,0,125))
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
			weaponl:SetFont("LMMESTOREJobFont")
			
			if v[2] then
				sellerl = vgui.Create("DLabel", ItemMain)
				sellerl:SetText("Seller: "..v[1]:Nick())
				sellerl:SetPos(100, 35)
				sellerl:SetSize(500, 30)
				sellerl:SetFont("LMMESTOREJobFont")
			else
				sellerl = vgui.Create("DLabel", ItemMain)
				sellerl:SetText("Seller: "..v[1])
				sellerl:SetPos(100, 35)
				sellerl:SetSize(500, 30)
				sellerl:SetFont("LMMESTOREJobFont")			
			end
			
			descriptionl = vgui.Create("DLabel", ItemMain)
			descriptionl:SetText(v[5])
			descriptionl:SetPos(100, 60)
			descriptionl:SetSize(500, 30)
			descriptionl:SetFont("LMMESTOREJobFont")			

			pricel = vgui.Create("DLabel", ItemMain)
			pricel:SetText("Price paid: "..v[6])
			pricel:SetPos(100, 85)
			pricel:SetSize(500, 30)
			pricel:SetFont("LMMESTOREJobFont")			

			DPanelList:AddItem(ItemMain)	
		end
		
		for k, v in pairs(thetableammo) do
			--seller, sellerhere, count, ammoType, model, string.sub(desc, 1, 63).."...", price
			local ItemMain = vgui.Create( "DButton", DPanelList )
			ItemMain:SetSize( DPanelList:GetWide(), 120 )
		--	ItemMain:ShowCloseButton( false )
			ItemMain:SetText( "" )
			ItemMain.Paint = function( self, w, h )
				drawRectOutline( 2, 2, w - 2, h - 2, Color( 0, 0, 0, 85 ) )
				draw.RoundedBox(0, 2, 2, w , h , Color(0,0,0,125))
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
			weaponl:SetFont("LMMESTOREJobFont")
			
			if v[2] then
				sellerl = vgui.Create("DLabel", ItemMain)
				sellerl:SetText("Seller: "..v[1]:Nick())
				sellerl:SetPos(100, 35)
				sellerl:SetSize(500, 30)
				sellerl:SetFont("LMMESTOREJobFont")
			else
				sellerl = vgui.Create("DLabel", ItemMain)
				sellerl:SetText("Seller: "..v[1])
				sellerl:SetPos(100, 35)
				sellerl:SetSize(500, 30)
				sellerl:SetFont("LMMESTOREJobFont")			
			end
			
			descriptionl = vgui.Create("DLabel", ItemMain)
			descriptionl:SetText(v[6])
			descriptionl:SetPos(100, 60)
			descriptionl:SetSize(500, 30)
			descriptionl:SetFont("LMMESTOREJobFont")			

			pricel = vgui.Create("DLabel", ItemMain)
			pricel:SetText("Price paid: "..v[7])
			pricel:SetPos(100, 85)
			pricel:SetSize(500, 30)
			pricel:SetFont("LMMESTOREJobFont")			

			DPanelList:AddItem(ItemMain)	
		end		
	end

	local DashbordB = vgui.Create( "DButton", DFrame )
	DashbordB:SetPos( 10, 565 )
	DashbordB:SetSize( DFrame:GetWide() - 20,20 )
	DashbordB:SetText( "Dashbord" )
	DashbordB:SetTextColor( Color( 255, 255, 255 ) )	
	DashbordB.Paint = function( self, w, h )		
		DrawBlur(DashbordB, 2)
		drawRectOutline( 0, 0, w, h, Color( 0, 0, 0, 85 ) )	
		draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 125))
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
