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

net.Receive("LMMESTOREOpenDashbord", function()


	local function MoreInfoF()
		local DFrame = vgui.Create( "DFrame" )
		DFrame:SetSize( 300, 250 )
		DFrame:Center()
		DFrame:SetDraggable( true )
		DFrame:MakePopup()
		DFrame:SetTitle( "" )
		DFrame:ShowCloseButton( false )
		DFrame.Paint = function( self, w, h )
			DrawBlur(DFrame, 2)
			drawRectOutline( 0, 0, w, h, Color( 0, 0, 0, 85 ) )	
			draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 85))
--			drawRectOutline( 2, 2, w - 4, h / 5.9, Color( 0, 0, 0, 85 ) )
--			draw.RoundedBox(0, 2, 2, w - 4, h / 6, Color(0,0,0,125))
--			draw.SimpleText( "eStore More Info", "LMMESTORETitleFont", DFrame:GetWide() / 2, 25, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end
		
		local frameclose = vgui.Create( "DButton", DFrame )
		frameclose:SetSize( 35, 35 )
		frameclose:SetPos( DFrame:GetWide() - 36,1 )
		frameclose:SetText( "X" )
		frameclose:SetFont( "fontclose" )
		frameclose:SetTextColor( Color( 255, 255, 255 ) )
		frameclose.Paint = function()
			
		end	
		frameclose.DoClick = function()
			DFrame:Close()
		end
		
		local richtext = vgui.Create( "RichText", DFrame )
		richtext:SetPos(50, 10)
		richtext:Dock( FILL )

		richtext:InsertColorChange( 255, 64, 64, 255 )
		richtext:AppendText( "eStore More Info!\n\n" )		
		
		richtext:InsertColorChange( 192, 192, 192, 255 )
		richtext:AppendText( LMMESTOREConfig.MoreInfoText )
		richtext:InsertColorChange( 255, 64, 64, 255 )
		richtext:AppendText( "This addon was made by XxLMM13xXgaming!" )		
		
	end

	local DFrame = vgui.Create( "DFrame" )
	DFrame:SetSize( 300, 185 )
	DFrame:Center()
	DFrame:SetDraggable( true )
	DFrame:MakePopup()
	DFrame:SetTitle( "" )
	DFrame:ShowCloseButton( false )
	DFrame.Paint = function( self, w, h )
		DrawBlur(DFrame, 2)
		drawRectOutline( 0, 0, w, h, Color( 0, 0, 0, 85 ) )	
		draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 85))
		drawRectOutline( 2, 2, w - 4, h / 3.9, Color( 0, 0, 0, 85 ) )
		draw.RoundedBox(0, 2, 2, w - 4, h / 4, Color(0,0,0,125))
		draw.SimpleText( "eStore Dashbord", "LMMESTORETitleFont", DFrame:GetWide() / 2, 25, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
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

	local GoToShop = vgui.Create( "DButton", DFrame )
	GoToShop:SetPos( 5, 70 )
	GoToShop:SetSize( DFrame:GetWide() - 10,20 )
	GoToShop:SetText( "Go to the eStore" )
	GoToShop:SetTextColor( Color( 255, 255, 255 ) )	
	GoToShop.Paint = function( self, w, h )		
		DrawBlur(GoToShop, 2)
		drawRectOutline( 0, 0, w, h, Color( 0, 0, 0, 85 ) )	
		draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 125))
	end
	GoToShop.DoClick = function()
		net.Start("LMMESTOREOpenShop")
		net.SendToServer()
		DFrame:Close()
	end	
	
	local ManageSelling = vgui.Create( "DButton", DFrame )
	ManageSelling:SetPos( 5, 95 )
	ManageSelling:SetSize( DFrame:GetWide() - 10,20 )
	ManageSelling:SetText( "Manage my items" )
	ManageSelling:SetTextColor( Color( 255, 255, 255 ) )	
	ManageSelling.Paint = function( self, w, h )		
		DrawBlur(ManageSelling, 2)
		drawRectOutline( 0, 0, w, h, Color( 0, 0, 0, 85 ) )	
		draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 125))
	end
	ManageSelling.DoClick = function()
		net.Start("LMMESTOREOpenItems")
		net.SendToServer()
		DFrame:Close()
	end			

	local MyProfile = vgui.Create( "DButton", DFrame )
	MyProfile:SetPos( 5, 120 )
	MyProfile:SetSize( DFrame:GetWide() - 10,20 )
	MyProfile:SetText( "My profile" )
	MyProfile:SetTextColor( Color( 255, 255, 255 ) )	
	MyProfile.Paint = function( self, w, h )		
		DrawBlur(MyProfile, 2)
		drawRectOutline( 0, 0, w, h, Color( 0, 0, 0, 85 ) )	
		draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 125))
	end
	MyProfile.DoClick = function()
		net.Start("LMMESTOREOpenProfile")
		net.SendToServer()
		DFrame:Close()
	end

	local MoreInfo = vgui.Create( "DButton", DFrame )
	MoreInfo:SetPos( 5, 145 )
	MoreInfo:SetSize( DFrame:GetWide() - 10,20 )
	MoreInfo:SetText( "More info" )
	MoreInfo:SetTextColor( Color( 255, 255, 255 ) )	
	MoreInfo.Paint = function( self, w, h )		
		DrawBlur(MoreInfo, 2)
		drawRectOutline( 0, 0, w, h, Color( 0, 0, 0, 85 ) )	
		draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 125))
	end
	MoreInfo.DoClick = function()
		MoreInfoF()
		DFrame:Close()
	end
end)

net.Receive("LMMESTOREOpenTheProfile", function()
	local profit = net.ReadFloat()
	local spent = net.ReadFloat()
	local unclaimed = net.ReadFloat()
	local subbool = net.ReadBool()
	local expirestring = net.ReadString()
	
	if subbool == true then
		sub = "Active"
	else
		sub = "Not Active"	
	end
	
	if subbool == false then
		expires = "Not Active"
	else
		expires = timeleftstring
	end
	
	local DFrame = vgui.Create( "DFrame" )
	DFrame:SetSize( 360, 280 )
	DFrame:Center()
	DFrame:SetDraggable( true )
	DFrame:MakePopup()
	DFrame:SetTitle( "" )
	DFrame:ShowCloseButton( false )
	DFrame.Paint = function( self, w, h )
		DrawBlur(DFrame, 2)
		drawRectOutline( 0, 0, w, h, Color( 0, 0, 0, 85 ) )	
		draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 85))
		drawRectOutline( 2, 2, w - 4, h / 5.9, Color( 0, 0, 0, 85 ) )
		draw.RoundedBox(0, 2, 2, w - 4, h / 6, Color(0,0,0,125))
		draw.SimpleText( "eStore Profile", "LMMESTORETitleFont", DFrame:GetWide() / 2, 25, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
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
	
	local ProfitL = vgui.Create("DLabel", DFrame)
	ProfitL:SetText("Earned: "..DarkRP.formatMoney(profit))
	ProfitL:SetPos(10, 50)
	ProfitL:SetSize(500, 35)
	ProfitL:SetTextColor(Color(255,255,255))
	ProfitL:SetFont("LMMESTORENameFontSmall")

	local SpentL = vgui.Create("DLabel", DFrame)
	SpentL:SetText("Spent: "..DarkRP.formatMoney(spent))
	SpentL:SetPos(10, 85)
	SpentL:SetSize(500, 35)
	SpentL:SetTextColor(Color(255,255,255))
	SpentL:SetFont("LMMESTORENameFontSmall")

	local SubL = vgui.Create("DLabel", DFrame)
	SubL:SetText("Subscription: "..sub)
	SubL:SetPos(10, 120)
	SubL:SetSize(500, 35)
	SubL:SetTextColor(Color(255,255,255))
	SubL:SetFont("LMMESTORENameFontSmall")

	if subbool then
		local SubEL = vgui.Create("DLabel", DFrame)
		SubEL:SetText("Expires: "..expirestring)
		SubEL:SetPos(10, 155)
		SubEL:SetSize(500, 35)
		SubEL:SetTextColor(Color(255,255,255))
		SubEL:SetFont("LMMESTORENameFontSmall")	
	else
		local SubEL = vgui.Create("DLabel", DFrame)
		SubEL:SetText("Expires: N/A")
		SubEL:SetPos(10, 155)
		SubEL:SetSize(500, 35)
		SubEL:SetTextColor(Color(255,255,255))
		SubEL:SetFont("LMMESTORENameFontSmall")		
	end
	
	
	local BRSubB = vgui.Create( "DButton", DFrame )
	BRSubB:SetPos( 10, 200 )
	BRSubB:SetSize( DFrame:GetWide() - 20,20 )
	BRSubB:SetText( "Buy/Review eStore Subscription" )
	BRSubB:SetTextColor( Color( 255, 255, 255 ) )	
	BRSubB.Paint = function( self, w, h )		
		DrawBlur(BRSubB, 2)
		drawRectOutline( 0, 0, w, h, Color( 0, 0, 0, 85 ) )	
		draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 125))
	end
	BRSubB.DoClick = function()
		if LocalPlayer():getDarkRPVar("money") >= LMMESTOREConfig.RenewBuySub then
			Derma_Query( "Are you sure you want to buy/renew your store subscription for "..	DarkRP.formatMoney(LMMESTOREConfig.RenewBuySub).."?",
			"eStore Subscription",
			"Yes",
			function()
				net.Start("LMMESTOREBuyRenewSub")
				net.SendToServer()
				DFrame:Close()
			end,
			"No",
			function()
			end
			)
		else
			chat.AddText(Color(255,0,0), "[eStore] ", Color(0,0,0), "You do not have enough money to pay for a subscription!")
		end
	end

	local ClaimMoney = vgui.Create( "DButton", DFrame )
	ClaimMoney:SetPos( 10, 225 )
	ClaimMoney:SetSize( DFrame:GetWide() - 20,20 )
	ClaimMoney:SetText( "Claim money ("..DarkRP.formatMoney(unclaimed)..")" )
	ClaimMoney:SetTextColor( Color( 255, 255, 255 ) )	
	ClaimMoney.Paint = function( self, w, h )		
		DrawBlur(ClaimMoney, 2)
		drawRectOutline( 0, 0, w, h, Color( 0, 0, 0, 85 ) )	
		draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 125))
	end
	ClaimMoney.DoClick = function()
		net.Start("LMMESTOREClaimMoney")
		net.SendToServer()
		DFrame:Close()
	end
	
	local DashbordB = vgui.Create( "DButton", DFrame )
	DashbordB:SetPos( 10, 250 )
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

net.Receive("LMMESTORESellingItem", function()
	local type = net.ReadString()
	
	if type == "shipment" then	
	
		local count = net.ReadFloat()
		local class = net.ReadString()
		local model = net.ReadString()
		local self = net.ReadEntity()
		
		local DFrame = vgui.Create( "DFrame" )
		DFrame:SetSize( 300, 410 )
		DFrame:Center()
		DFrame:SetDraggable( true )
		DFrame:MakePopup()
		DFrame:SetTitle( "" )
		DFrame:ShowCloseButton( false )
		DFrame.Paint = function( self, w, h )
			DrawBlur(DFrame, 2)
			drawRectOutline( 0, 0, w, h, Color( 0, 0, 0, 85 ) )	
			draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 85))
			drawRectOutline( 2, 2, w - 4, h / 8.9, Color( 0, 0, 0, 85 ) )
			draw.RoundedBox(0, 2, 2, w - 4, h / 9, Color(0,0,0,125))
			draw.SimpleText( "Sell Shipment("..count..")", "LMMESTORETitleFont", DFrame:GetWide() / 2, 25, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
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
		
		local TextEntry = vgui.Create( "DTextEntry", DFrame )
		TextEntry:SetPos( 5, 65 )
		TextEntry:SetSize( DFrame:GetWide() - 10, 20 )
		TextEntry:SetText( "Short Description" )
		TextEntry.OnEnter = function( self )

		end	

		local TextEntry2 = vgui.Create( "DTextEntry", DFrame )
		TextEntry2:SetPos( 5, 100 )
		TextEntry2:SetSize( DFrame:GetWide() - 10, 20 )
		TextEntry2:SetText( "Price" )
		TextEntry2.OnEnter = function( self )

		end	

		icon = vgui.Create("DModelPanel" , DFrame )
		icon:SetPos( 5, 135 )
		icon:SetSize( DFrame:GetWide() - 10, 200 )		
		icon:SetModel(model)
		local min, max = icon.Entity:GetRenderBounds()
		icon:SetCamPos(min:Distance(max) * Vector(0.7, 0.7, 0.7))
		icon:SetLookAt((max + min) / 2)
		
		local submittButton = vgui.Create( "DButton", DFrame )
		submittButton:SetPos( 5, 380 )
		submittButton:SetSize( DFrame:GetWide() - 10,20 )
		submittButton:SetText( "Sell item" )
		submittButton:SetTextColor( Color( 255, 255, 255 ) )	
		submittButton.Paint = function( self, w, h )		
			DrawBlur(submittButton, 2)
			drawRectOutline( 0, 0, w, h, Color( 0, 0, 0, 85 ) )	
			draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 125))
		end
		submittButton.DoClick = function()
			if isnumber(tonumber(TextEntry2:GetValue())) then
				if tonumber(TextEntry2:GetValue()) >= 0 then
					net.Start("LMMESTORESellItemShipment")
						net.WriteFloat(count)
						net.WriteString(class)
						net.WriteString(model)
						net.WriteString(TextEntry:GetValue())
						net.WriteFloat(tonumber(TextEntry2:GetValue()))
						net.WriteEntity(self)
					net.SendToServer()
					DFrame:Close()
				else
					chat.AddText(Color(255,0,0), "[eStore] ", Color(0,0,0), "You must enter a positive number for the price!")				
				end
			else
				chat.AddText(Color(255,0,0), "[eStore] ", Color(0,0,0), "You must enter a number for the price!")
			end
		end		
	elseif type == "weapon" then
		local class = net.ReadString()
		local model = net.ReadString()
		local self = net.ReadEntity()

		local DFrame = vgui.Create( "DFrame" )
		DFrame:SetSize( 300, 410 )
		DFrame:Center()
		DFrame:SetDraggable( true )
		DFrame:MakePopup()
		DFrame:SetTitle( "" )
		DFrame:ShowCloseButton( false )
		DFrame.Paint = function( self, w, h )
			DrawBlur(DFrame, 2)
			drawRectOutline( 0, 0, w, h, Color( 0, 0, 0, 85 ) )	
			draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 85))
			drawRectOutline( 2, 2, w - 4, h / 8.9, Color( 0, 0, 0, 85 ) )
			draw.RoundedBox(0, 2, 2, w - 4, h / 9, Color(0,0,0,125))
			draw.SimpleText( "Sell Weapon", "LMMESTORETitleFont", DFrame:GetWide() / 2, 25, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
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
		
		local TextEntry = vgui.Create( "DTextEntry", DFrame )
		TextEntry:SetPos( 5, 65 )
		TextEntry:SetSize( DFrame:GetWide() - 10, 20 )
		TextEntry:SetText( "Short Description" )
		TextEntry.OnEnter = function( self )

		end	

		local TextEntry2 = vgui.Create( "DTextEntry", DFrame )
		TextEntry2:SetPos( 5, 100 )
		TextEntry2:SetSize( DFrame:GetWide() - 10, 20 )
		TextEntry2:SetText( "Price" )
		TextEntry2.OnEnter = function( self )

		end	

		icon = vgui.Create("DModelPanel" , DFrame )
		icon:SetPos( 5, 135 )
		icon:SetSize( DFrame:GetWide() - 10, 200 )		
		icon:SetModel(model)
		local min, max = icon.Entity:GetRenderBounds()
		icon:SetCamPos(min:Distance(max) * Vector(0.7, 0.7, 0.7))
		icon:SetLookAt((max + min) / 2)
		
		local submittButton = vgui.Create( "DButton", DFrame )
		submittButton:SetPos( 5, 380 )
		submittButton:SetSize( DFrame:GetWide() - 10,20 )
		submittButton:SetText( "Sell item" )
		submittButton:SetTextColor( Color( 255, 255, 255 ) )	
		submittButton.Paint = function( self, w, h )		
			DrawBlur(submittButton, 2)
			drawRectOutline( 0, 0, w, h, Color( 0, 0, 0, 85 ) )	
			draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 125))
		end
		submittButton.DoClick = function()
			if isnumber(tonumber(TextEntry2:GetValue())) then
				if tonumber(TextEntry2:GetValue()) >= 0 then
					net.Start("LMMESTORESellItemWeapon")
						net.WriteString(class)
						net.WriteString(model)
						net.WriteString(TextEntry:GetValue())
						net.WriteFloat(tonumber(TextEntry2:GetValue()))
						net.WriteEntity(self)
					net.SendToServer()
					DFrame:Close()
				else
					chat.AddText(Color(255,0,0), "[eStore] ", Color(0,0,0), "You must enter a positive number for the price!")				
				end
			else
				chat.AddText(Color(255,0,0), "[eStore] ", Color(0,0,0), "You must enter a number for the price!")
			end
		end		
	elseif type == "ammo" then
		local count = net.ReadFloat()
		local ammotype = net.ReadString()
		local model = net.ReadString()
		local self = net.ReadEntity()		
		
		local DFrame = vgui.Create( "DFrame" )
		DFrame:SetSize( 300, 410 )
		DFrame:Center()
		DFrame:SetDraggable( true )
		DFrame:MakePopup()
		DFrame:SetTitle( "" )
		DFrame:ShowCloseButton( false )
		DFrame.Paint = function( self, w, h )
			DrawBlur(DFrame, 2)
			drawRectOutline( 0, 0, w, h, Color( 0, 0, 0, 85 ) )	
			draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 85))
			drawRectOutline( 2, 2, w - 4, h / 8.9, Color( 0, 0, 0, 85 ) )
			draw.RoundedBox(0, 2, 2, w - 4, h / 9, Color(0,0,0,125))
			draw.SimpleText( "Sell Ammo("..count..")", "LMMESTORETitleFont", DFrame:GetWide() / 2, 25, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
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
		
		local TextEntry = vgui.Create( "DTextEntry", DFrame )
		TextEntry:SetPos( 5, 65 )
		TextEntry:SetSize( DFrame:GetWide() - 10, 20 )
		TextEntry:SetText( "Short Description" )
		TextEntry.OnEnter = function( self )

		end	

		local TextEntry2 = vgui.Create( "DTextEntry", DFrame )
		TextEntry2:SetPos( 5, 100 )
		TextEntry2:SetSize( DFrame:GetWide() - 10, 20 )
		TextEntry2:SetText( "Price" )
		TextEntry2.OnEnter = function( self )

		end	

		icon = vgui.Create("DModelPanel" , DFrame )
		icon:SetPos( 5, 135 )
		icon:SetSize( DFrame:GetWide() - 10, 200 )		
		icon:SetModel(model)
		local min, max = icon.Entity:GetRenderBounds()
		icon:SetCamPos(min:Distance(max) * Vector(0.7, 0.7, 0.7))
		icon:SetLookAt((max + min) / 2)
		
		local submittButton = vgui.Create( "DButton", DFrame )
		submittButton:SetPos( 5, 380 )
		submittButton:SetSize( DFrame:GetWide() - 10,20 )
		submittButton:SetText( "Sell item" )
		submittButton:SetTextColor( Color( 255, 255, 255 ) )	
		submittButton.Paint = function( self, w, h )		
			DrawBlur(submittButton, 2)
			drawRectOutline( 0, 0, w, h, Color( 0, 0, 0, 85 ) )	
			draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 125))
		end
		submittButton.DoClick = function()
			if isnumber(tonumber(TextEntry2:GetValue())) then
				if tonumber(TextEntry2:GetValue()) >= 0 then
					net.Start("LMMESTORESellItemAmmo")
						net.WriteFloat(count)
						net.WriteString(ammotype)
						net.WriteString(model)
						net.WriteString(TextEntry:GetValue())
						net.WriteFloat(tonumber(TextEntry2:GetValue()))
						net.WriteEntity(self)
					net.SendToServer()
					DFrame:Close()
				else
					chat.AddText(Color(255,0,0), "[eStore] ", Color(0,0,0), "You must enter a positive number for the price!")								
				end
			else
				chat.AddText(Color(255,0,0), "[eStore] ", Color(0,0,0), "You must enter a number for the price!")
			end
		end			
	end
end)

net.Receive("LMMESTOREOpenManageItems", function()
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
		draw.SimpleText( "Manage Items", "LMMESTORETitleFont", DFrame:GetWide() / 2, 25, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
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
		NoItems:SetText( "There are no items by you!" )
		NoItems:SetFont( "LMMESTORENameFont" )
		NoItems:SetTextColor( Color( 200, 200, 200 ) )
		NoItems:SizeToContents()
		NoItems:Center()
	end

	instl = vgui.Create("DLabel", DFrame)
	instl:SetText("Click on the item you would like to edit!")
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
				Derma_Query(
				"What would you like to do?",
				"eStore Manage Items",
				"Submit to market",
				function()
					net.Start("LMMESTORESubmitShipment")
						net.WriteString(v[8])
					net.SendToServer()
					DFrame:Close()
				end,
				"Chance price/description",
				function()
					Derma_StringRequest(
						"eStore Manage Items",
						"What would you like to change the price to",
						v[7],
						function( text )
							if isnumber(tonumber(text)) then
								Derma_StringRequest(
									"eStore Manage Items",
									"What would you like to change the description to",
									v[6],
									function( text2 )
										net.Start("LMMESTOREChangeShipmentPD")
											net.WriteString(v[8])
											net.WriteString(text)
											net.WriteString(text2)
										net.SendToServer()
										DFrame:Close()										
									end,
									function( text2 )

									end
								 )
							else
								chat.AddText(Color(255,0,0), "This needs to be a number!")
							end
						end,
						function( text )

						end
					 )
				end,
				"Remove item",
				function()
					Derma_Query(
					"Are you sure you would like remove this item?",
					"eStore Manage Items",
					"Yes",
					function()
						net.Start("LMMESTORERemoveShipment")
							net.WriteString(v[8])
						net.SendToServer()
						DFrame:Close()
					end,
					"No",
					function()
					
					end
					)
				end,
				"Nothing",
				function()
				
				end)
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
			
			CurrAva = vgui.Create("DLabel", ItemMain)
			local thetext = ""
			if v[9] == 1 then thetext = "false" else thetext = "true" end 
			CurrAva:SetText("On the market: "..thetext)
			CurrAva:SetPos(100, 35)
			CurrAva:SetSize(500, 30)
			CurrAva:SetFont("LMMESTOREJobFont")
			
			descriptionl = vgui.Create("DLabel", ItemMain)
			descriptionl:SetText(v[6])
			descriptionl:SetPos(100, 60)
			descriptionl:SetSize(500, 30)
			descriptionl:SetFont("LMMESTOREJobFont")			

			pricel = vgui.Create("DLabel", ItemMain)
			pricel:SetText("Price: "..v[7])
			pricel:SetPos(100, 85)
			pricel:SetSize(500, 30)
			pricel:SetFont("LMMESTOREJobFont")			

			DPanelList:AddItem(ItemMain)			
		end	
		
		for k, v in pairs(thetableweapons) do
			--seller, sellerhere, weapon, model, desc, price, v, pending
			local ItemMain = vgui.Create( "DButton", DPanelList )
			ItemMain:SetSize( DPanelList:GetWide(), 120 )
		--	ItemMain:ShowCloseButton( false )
			ItemMain:SetText( "" )
			ItemMain.Paint = function( self, w, h )
				drawRectOutline( 2, 2, w - 2, h - 2, Color( 0, 0, 0, 85 ) )
				draw.RoundedBox(0, 2, 2, w , h , Color(0,0,0,125))
			end			
			ItemMain.DoClick = function()
				Derma_Query(
				"What would you like to do?",
				"eStore Manage Items",
				"Submit to market",
				function()
					net.Start("LMMESTORESubmitWeapon")
						net.WriteString(v[7])
					net.SendToServer()
					DFrame:Close()
				end,
				"Chance price/description",
				function()
					Derma_StringRequest(
						"eStore Manage Items",
						"What would you like to change the price to",
						v[6],
						function( text )
							if isnumber(tonumber(text)) then
								Derma_StringRequest(
									"eStore Manage Items",
									"What would you like to change the description to",
									v[5],
									function( text2 )
										net.Start("LMMESTOREChangeWeaponPD")
											net.WriteString(v[7])
											net.WriteString(text)
											net.WriteString(text2)
										net.SendToServer()
										DFrame:Close()										
									end,
									function( text2 )

									end
								 )
							else
								chat.AddText(Color(255,0,0), "This needs to be a number!")
							end
						end,
						function( text )

						end
					 )
				end,
				"Remove item",
				function()
					Derma_Query(
					"Are you sure you would like remove this item?",
					"eStore Manage Items",
					"Yes",
					function()
						net.Start("LMMESTORERemoveWeapon")
							net.WriteString(v[7])
						net.SendToServer()
						DFrame:Close()
					end,
					"No",
					function()
					
					end
					)
				end,
				"Nothing",
				function()
				
				end)
			end
			--seller, sellerhere, weapon, model, string.sub(desc, 1, 63).."...", price, v, pending
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
			
			CurrAva = vgui.Create("DLabel", ItemMain)
			local thetext = ""
			if v[8] == 1 then thetext = "false" else thetext = "true" end 
			CurrAva:SetText("On the market: "..thetext)
			CurrAva:SetPos(100, 35)
			CurrAva:SetSize(500, 30)
			CurrAva:SetFont("LMMESTOREJobFont")
			
			descriptionl = vgui.Create("DLabel", ItemMain)
			descriptionl:SetText(v[5])
			descriptionl:SetPos(100, 60)
			descriptionl:SetSize(500, 30)
			descriptionl:SetFont("LMMESTOREJobFont")			

			pricel = vgui.Create("DLabel", ItemMain)
			pricel:SetText("Price: "..v[6])
			pricel:SetPos(100, 85)
			pricel:SetSize(500, 30)
			pricel:SetFont("LMMESTOREJobFont")			

			DPanelList:AddItem(ItemMain)			
		end	

		for k, v in pairs(thetableammo) do
			--seller, sellerhere, count, ammoType, model, desc, price, v, pending
			local ItemMain = vgui.Create( "DButton", DPanelList )
			ItemMain:SetSize( DPanelList:GetWide(), 120 )
		--	ItemMain:ShowCloseButton( false )
			ItemMain:SetText( "" )
			ItemMain.Paint = function( self, w, h )
				drawRectOutline( 2, 2, w - 2, h - 2, Color( 0, 0, 0, 85 ) )
				draw.RoundedBox(0, 2, 2, w , h , Color(0,0,0,125))
			end			
			ItemMain.DoClick = function()
				Derma_Query(
				"What would you like to do?",
				"eStore Manage Items",
				"Submit to market",
				function()
					net.Start("LMMESTORESubmitAmmo")
						net.WriteString(v[8])
					net.SendToServer()
					DFrame:Close()
				end,
				"Chance price/description",
				function()
					Derma_StringRequest(
						"eStore Manage Items",
						"What would you like to change the price to",
						v[7],
						function( text )
							if isnumber(tonumber(text)) then
								Derma_StringRequest(
									"eStore Manage Items",
									"What would you like to change the description to",
									v[6],
									function( text2 )
										net.Start("LMMESTOREChangeAmmoPD")
											net.WriteString(v[8])
											net.WriteString(text)
											net.WriteString(text2)
										net.SendToServer()
										DFrame:Close()										
									end,
									function( text2 )

									end
								 )
							else
								chat.AddText(Color(255,0,0), "This needs to be a number!")
							end
						end,
						function( text )

						end
					 )
				end,
				"Remove item",
				function()
					Derma_Query(
					"Are you sure you would like remove this item?",
					"eStore Manage Items",
					"Yes",
					function()
						net.Start("LMMESTORERemoveAmmo")
							net.WriteString(v[8])
						net.SendToServer()
						DFrame:Close()
					end,
					"No",
					function()
					
					end
					)
				end,
				"Nothing",
				function()
				
				end)
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
			
			CurrAva = vgui.Create("DLabel", ItemMain)
			local thetext = ""
			if v[9] == 1 then thetext = "false" else thetext = "true" end 
			CurrAva:SetText("On the market: "..thetext)
			CurrAva:SetPos(100, 35)
			CurrAva:SetSize(500, 30)
			CurrAva:SetFont("LMMESTOREJobFont")
			
			descriptionl = vgui.Create("DLabel", ItemMain)
			descriptionl:SetText(v[6])
			descriptionl:SetPos(100, 60)
			descriptionl:SetSize(500, 30)
			descriptionl:SetFont("LMMESTOREJobFont")			

			pricel = vgui.Create("DLabel", ItemMain)
			pricel:SetText("Price: "..v[7])
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

net.Receive("LMMESTOREOpeneStore", function()

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
		NoItems:SetText( "There are no items in the eStore!" )
		NoItems:SetFont( "LMMESTORENameFont" )
		NoItems:SetTextColor( Color( 200, 200, 200 ) )
		NoItems:SizeToContents()
		NoItems:Center()
	end

	instl = vgui.Create("DLabel", DFrame)
	instl:SetText("Click on the item you would like to buy!")
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
			print(tostring(v[2]))
			local ItemMain = vgui.Create( "DButton", DPanelList )
			ItemMain:SetSize( DPanelList:GetWide(), 120 )
		--	ItemMain:ShowCloseButton( false )
			ItemMain:SetText( "" ) 
			ItemMain.Paint = function( self, w, h )
				drawRectOutline( 2, 2, w - 2, h - 2, Color( 0, 0, 0, 85 ) )
				draw.RoundedBox(0, 2, 2, w , h , Color(0,0,0,125))
			end			
			ItemMain.DoClick = function()
				if v[2] == false then
					Derma_Query( "Are you sure you want to buy this Shipment?\nWeapon: "..v[4].."\nCount: "..v[3].."\nSeller: "..v[1]:Nick().."\nPrice: "..v[7], "eStore comfirm", "Yes", function() net.Start("LMMESTOREBuyShipment") net.WriteString(v[8]) net.SendToServer() DFrame:Close() end, "No", function() end)			
				else
					Derma_Query( "Are you sure you want to buy this Shipment?\nWeapon: "..v[4].."\nCount: "..v[3].."\nSeller: "..v[1].."\nPrice: "..v[7], "eStore comfirm", "Yes", function() net.Start("LMMESTOREBuyShipment") net.WriteString(v[8]) net.SendToServer() DFrame:Close() end, "No", function() end)			
				end
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

			if v[2] != false then
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
			pricel:SetText("Price: "..v[7])
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
				if tobool(v[1]) != false then
					Derma_Query( "Are you sure you want to buy this Weapon?\nWeapon: "..v[3].."\nSeller: "..v[1]:Nick().."\nPrice: "..v[6], "eStore comfirm", "Yes", function() net.Start("LMMESTOREBuyWeapon") net.WriteString(v[7]) net.SendToServer() DFrame:Close() end, "No", function() end)			
				else
					Derma_Query( "Are you sure you want to buy this Weapon?\nWeapon: "..v[3].."\nSeller: Offline Player\nPrice: "..v[6], "eStore comfirm", "Yes", function() net.Start("LMMESTOREBuyWeapon") net.WriteString(v[7]) net.SendToServer() DFrame:Close() end, "No", function() end)			
				end
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
			
			if tobool(v[1]) != false then
				sellerl = vgui.Create("DLabel", ItemMain)
				sellerl:SetText("Seller: "..v[1]:Nick())
				sellerl:SetPos(100, 35)
				sellerl:SetSize(500, 30)
				sellerl:SetFont("LMMESTOREJobFont")
			else
				sellerl = vgui.Create("DLabel", ItemMain)
				sellerl:SetText("Seller: Offline Player")
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
			pricel:SetText("Price: "..v[6])
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
				if tobool(v[1]) != false then
					Derma_Query( "Are you sure you want to buy this ammo?\nAmmo type: "..v[4].."\nAmmo count: "..v[3].."\nSeller: "..v[1]:Nick().."\nPrice: "..v[7], "eStore comfirm", "Yes", function() net.Start("LMMESTOREBuyAmmo") net.WriteString(v[8]) net.SendToServer() DFrame:Close() end, "No", function() end)			
				else
					Derma_Query( "Are you sure you want to buy this ammo?\nAmmo type: "..v[4].."\nAmmo count: "..v[3].."\nSeller: "..v[1].."\nPrice: "..v[7], "eStore comfirm", "Yes", function() net.Start("LMMESTOREBuyAmmo") net.WriteString(v[8]) net.SendToServer() DFrame:Close() end, "No", function() end)							
				end
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
			
			if tobool(v[1]) != false then
				sellerl = vgui.Create("DLabel", ItemMain)
				sellerl:SetText("Seller: "..v[1]:Nick())
				sellerl:SetPos(100, 35)
				sellerl:SetSize(500, 30)
				sellerl:SetFont("LMMESTOREJobFont")
			else
				sellerl = vgui.Create("DLabel", ItemMain)
				sellerl:SetText("Seller: Offline Player")
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
			pricel:SetText("Price: "..v[7])
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

net.Receive("LMMESTORENotify", function()
	local message = net.ReadString()
	
	chat.AddText(Color(255,0,0), "[eStore] ", Color(0,0,0), message)
	surface.PlaySound( LMMESTOREConfig.SoundOnSellItem )
end)