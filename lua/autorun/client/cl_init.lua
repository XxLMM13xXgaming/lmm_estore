include("lmm_estore_config.lua")
  
surface.CreateFont( "LMMESTORETitleFont", {
	font = "Arial",
	size = 20,
	weight = 5000,
	blursize = 0,
	scanlines = 0,
	antialias = true,
}) 
 
surface.CreateFont( "LMMESTORELabelSmall", {
	font = "Arial",
	size = 25,
	weight = 2000,
	blursize = 0,
	scanlines = 0,
	antialias = true,
}) 
 
surface.CreateFont( "LMMESTORENoFont", {
	font = "Lato Light",
	size = 40,
	weight = 250,
	antialias = true,
	strikeout = false,
	additive = true,
} )
 
surface.CreateFont( "LMMESTORESellLabel", {
	font = "Lato Light",
	size = 20,
	weight = 250,
	antialias = true,
	strikeout = false,
	additive = true,
} )

surface.CreateFont( "LMMESTOREfontclose", {
	font = "Arial",
	size = 18,
	weight = 5000,
	blursize = 0,
	scanlines = 0,
	antialias = true,
})
 
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
		DFrame:SetSize( 400, 400 )
		DFrame:Center()
		DFrame:SetDraggable( true )
		DFrame:MakePopup()
		DFrame:SetTitle( "" )
		DFrame:ShowCloseButton( false )
		DFrame.Paint = function( self, w, h )
			draw.RoundedBox(2, 0, 0, DFrame:GetWide(), DFrame:GetTall(), Color(35, 35, 35, 250))
			draw.RoundedBox(2, 0, 0, DFrame:GetWide(), 30, Color(40, 40, 40, 255))
			draw.SimpleText( "More Info", "LMMESTORETitleFont", DFrame:GetWide() / 2, 15, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)			
		end

		local frameclose = vgui.Create("DButton", DFrame)
		frameclose:SetSize(20, 20)
		frameclose:SetPos(DFrame:GetWide() - frameclose:GetWide() - 3, 3)
		frameclose:SetText("X");
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
		
		local richtext = vgui.Create( "RichText", DFrame )
		richtext:SetPos(50, 10)
		richtext:Dock( FILL )

		richtext:InsertColorChange( 255, 64, 64, 255 )
		richtext:AppendText( "eStore More Info!\n\n" )		
		
		richtext:InsertColorChange( 192, 192, 192, 255 )
		richtext:AppendText( LMMESTOREConfig.MoreInfoText )
		richtext:InsertColorChange( 255, 64, 64, 255 )
		richtext:AppendText( "This addon was made by XxLMM13xXgaming!" )		

		local DashbordB = vgui.Create( "DButton", DFrame )
		DashbordB:SetPos( 10, 370 )
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

		
	end

	local DFrame = vgui.Create( "DFrame" )
	DFrame:SetSize( 300, 150 )
	DFrame:Center()
	DFrame:SetDraggable( true )
	DFrame:MakePopup()
	DFrame:SetTitle( "" )
	DFrame:ShowCloseButton( false )
	DFrame.Paint = function( self, w, h )
		draw.RoundedBox(2, 0, 0, DFrame:GetWide(), DFrame:GetTall(), Color(35, 35, 35, 250))
		draw.RoundedBox(2, 0, 0, DFrame:GetWide(), 30, Color(40, 40, 40, 255))
		draw.SimpleText( "eStore Dashboard", "LMMESTORETitleFont", DFrame:GetWide() / 2, 15, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end
	
	local frameclose = vgui.Create("DButton", DFrame)
	frameclose:SetSize(20, 20)
	frameclose:SetPos(DFrame:GetWide() - frameclose:GetWide() - 3, 3)
	frameclose:SetText("X");
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

	local GoToShop = vgui.Create( "DButton", DFrame )
	GoToShop:SetPos( 5, 40 )
	GoToShop:SetSize( DFrame:GetWide() - 10,20 )
	GoToShop:SetText( "Go to the eStore" )
	GoToShop.OnCursorEntered = function(self)
		self.hover = true
	end
	GoToShop.OnCursorExited = function(self)
		self.hover = false
	end	
	GoToShop.Paint = function( self, w, h )		
		draw.RoundedBox(0, 0, 0, w, h, (self.hover and Color(0,160,255,250)) or Color(255,255,255,255)) -- Paints on hover
		GoToShop:SetTextColor(self.hover and Color(255,255,255,250) or Color(0,0,0,255))
	end
	GoToShop.DoClick = function()
		net.Start("LMMESTOREOpenShop")
		net.SendToServer()
		DFrame:Close()
	end	
	
	local ManageSelling = vgui.Create( "DButton", DFrame )
	ManageSelling:SetPos( 5, 65 )
	ManageSelling:SetSize( DFrame:GetWide() - 10,20 )
	ManageSelling:SetText( "Manage my items" )
	ManageSelling.OnCursorEntered = function(self)
		self.hover = true
	end
	ManageSelling.OnCursorExited = function(self)
		self.hover = false
	end	
	ManageSelling.Paint = function( self, w, h )		
		draw.RoundedBox(0, 0, 0, w, h, (self.hover and Color(0,160,255,250)) or Color(255,255,255,255)) -- Paints on hover
		ManageSelling:SetTextColor(self.hover and Color(255,255,255,250) or Color(0,0,0,255))
	end
	ManageSelling.DoClick = function()
		net.Start("LMMESTOREOpenItems")
		net.SendToServer()
		DFrame:Close()
	end			

	local MyProfile = vgui.Create( "DButton", DFrame )
	MyProfile:SetPos( 5, 90 )
	MyProfile:SetSize( DFrame:GetWide() - 10,20 )
	MyProfile:SetText( "My profile" )
	MyProfile.OnCursorEntered = function(self)
		self.hover = true
	end
	MyProfile.OnCursorExited = function(self)
		self.hover = false
	end	
	MyProfile.Paint = function( self, w, h )		
		draw.RoundedBox(0, 0, 0, w, h, (self.hover and Color(0,160,255,250)) or Color(255,255,255,255)) -- Paints on hover
		MyProfile:SetTextColor(self.hover and Color(255,255,255,250) or Color(0,0,0,255))
	end
	MyProfile.DoClick = function()
		net.Start("LMMESTOREOpenProfile")
		net.SendToServer()
		DFrame:Close()
	end

	local MoreInfo = vgui.Create( "DButton", DFrame )
	MoreInfo:SetPos( 5, 115 )
	MoreInfo:SetSize( DFrame:GetWide() - 10,20 )
	MoreInfo:SetText( "More info" )
	MoreInfo.OnCursorEntered = function(self)
		self.hover = true
	end
	MoreInfo.OnCursorExited = function(self)
		self.hover = false
	end	
	MoreInfo.Paint = function( self, w, h )		
		draw.RoundedBox(0, 0, 0, w, h, (self.hover and Color(0,160,255,250)) or Color(255,255,255,255)) -- Paints on hover
		MoreInfo:SetTextColor(self.hover and Color(255,255,255,250) or Color(0,0,0,255))
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
	DFrame:SetSize( 360, 225 )
	DFrame:Center()
	DFrame:SetDraggable( true )
	DFrame:MakePopup()
	DFrame:SetTitle( "" )
	DFrame:ShowCloseButton( false )
	DFrame.Paint = function( self, w, h )
		draw.RoundedBox(2, 0, 0, DFrame:GetWide(), DFrame:GetTall(), Color(35, 35, 35, 250))
		draw.RoundedBox(2, 0, 0, DFrame:GetWide(), 30, Color(40, 40, 40, 255))
		draw.SimpleText( "eStore Profile", "LMMESTORETitleFont", DFrame:GetWide() / 2, 15, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end
	
	local frameclose = vgui.Create("DButton", DFrame)
	frameclose:SetSize(20, 20)
	frameclose:SetPos(DFrame:GetWide() - frameclose:GetWide() - 3, 3)
	frameclose:SetText("X");
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

	
	local ProfitL = vgui.Create("DLabel", DFrame)
	ProfitL:SetText("Earned: "..DarkRP.formatMoney(profit))
	ProfitL:SetPos(10, 30)
	ProfitL:SetSize(500, 35)
	ProfitL:SetTextColor(Color(255,255,255))
	ProfitL:SetFont("LMMESTORELabelSmall")

	local SpentL = vgui.Create("DLabel", DFrame)
	SpentL:SetText("Spent: "..DarkRP.formatMoney(spent))
	SpentL:SetPos(10, 55)
	SpentL:SetSize(500, 35)
	SpentL:SetTextColor(Color(255,255,255))
	SpentL:SetFont("LMMESTORELabelSmall")

	local SubL = vgui.Create("DLabel", DFrame)
	SubL:SetText("Subscription: "..sub)
	SubL:SetPos(10, 80)
	SubL:SetSize(500, 35)
	SubL:SetTextColor(Color(255,255,255))
	SubL:SetFont("LMMESTORELabelSmall")

	if subbool then
		local SubEL = vgui.Create("DLabel", DFrame)
		SubEL:SetText("Expires: "..expirestring)
		SubEL:SetPos(10, 105)
		SubEL:SetSize(500, 35)
		SubEL:SetTextColor(Color(255,255,255))
		SubEL:SetFont("LMMESTORELabelSmall")	
	else
		local SubEL = vgui.Create("DLabel", DFrame)
		SubEL:SetText("Expires: N/A")
		SubEL:SetPos(10, 105)
		SubEL:SetSize(500, 35)
		SubEL:SetTextColor(Color(255,255,255))
		SubEL:SetFont("LMMESTORELabelSmall")		
	end
	
	
	local BRSubB = vgui.Create( "DButton", DFrame )
	BRSubB:SetPos( 10, 140 )
	BRSubB:SetSize( DFrame:GetWide() - 20,20 )
	BRSubB:SetText( "Buy/Review eStore Subscription" )
	BRSubB.OnCursorEntered = function(self)
		self.hover = true
	end
	BRSubB.OnCursorExited = function(self)
		self.hover = false
	end	
	BRSubB.Paint = function( self, w, h )		
		draw.RoundedBox(0, 0, 0, w, h, (self.hover and Color(0,160,255,250)) or Color(255,255,255,255)) -- Paints on hover
		BRSubB:SetTextColor(self.hover and Color(255,255,255,250) or Color(0,0,0,255))
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
	ClaimMoney:SetPos( 10, 165 )
	ClaimMoney:SetSize( DFrame:GetWide() - 20,20 )
	ClaimMoney:SetText( "Claim money ("..DarkRP.formatMoney(unclaimed)..")" )
	ClaimMoney.OnCursorEntered = function(self)
		self.hover = true
	end
	ClaimMoney.OnCursorExited = function(self)
		self.hover = false
	end	
	ClaimMoney.Paint = function( self, w, h )		
		draw.RoundedBox(0, 0, 0, w, h, (self.hover and Color(0,160,255,250)) or Color(255,255,255,255)) -- Paints on hover
		ClaimMoney:SetTextColor(self.hover and Color(255,255,255,250) or Color(0,0,0,255))
	end
	ClaimMoney.DoClick = function()
		net.Start("LMMESTOREClaimMoney")
		net.SendToServer()
		DFrame:Close()
	end
	
	local DashbordB = vgui.Create( "DButton", DFrame )
	DashbordB:SetPos( 10, 190 )
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

net.Receive("LMMESTORESellingItem", function()
	local type = net.ReadString()
	
	if type == "shipment" then	
	
		local count = net.ReadFloat()
		local class = net.ReadString()
		local model = net.ReadString()
		local self = net.ReadEntity()
		
		local DFrame = vgui.Create( "DFrame" )
		DFrame:SetSize( 300, 350 )
		DFrame:Center()
		DFrame:SetDraggable( true )
		DFrame:MakePopup()
		DFrame:SetTitle( "" )
		DFrame:ShowCloseButton( false )
		DFrame.Paint = function( self, w, h )
			draw.RoundedBox(2, 0, 0, DFrame:GetWide(), DFrame:GetTall(), Color(35, 35, 35, 250))
			draw.RoundedBox(2, 0, 0, DFrame:GetWide(), 30, Color(40, 40, 40, 255))
			draw.SimpleText( "Sell Shipment("..count..")", "LMMESTORETitleFont", DFrame:GetWide() / 2, 15, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end
		
		local frameclose = vgui.Create("DButton", DFrame)
		frameclose:SetSize(20, 20)
		frameclose:SetPos(DFrame:GetWide() - frameclose:GetWide() - 3, 3)
		frameclose:SetText("X");
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

		
		local TextEntry = vgui.Create( "DTextEntry", DFrame )
		TextEntry:SetPos( 5, 40 )
		TextEntry:SetSize( DFrame:GetWide() - 10, 20 )
		TextEntry:SetText( "Short Description" )
		TextEntry.OnEnter = function( self )

		end	
		
		local TextEntry2 = vgui.Create( "DTextEntry", DFrame )
		TextEntry2:SetPos( 5, 65 )
		TextEntry2:SetSize( DFrame:GetWide() - 10, 20 )
		TextEntry2:SetText( "Price" )
		TextEntry2.OnEnter = function( self )

		end	

		icon = vgui.Create("DModelPanel" , DFrame )
		icon:SetPos( 5, 90 )
		icon:SetSize( DFrame:GetWide() - 10, 200 )		
		icon:SetModel(model)
		local min, max = icon.Entity:GetRenderBounds()
		icon:SetCamPos(min:Distance(max) * Vector(0.7, 0.7, 0.7))
		icon:SetLookAt((max + min) / 2)
		
		local submittButton = vgui.Create( "DButton", DFrame )
		submittButton:SetPos( 5, 320 )
		submittButton:SetSize( DFrame:GetWide() - 10,20 )
		submittButton:SetText( "Sell item" )
		submittButton.OnCursorEntered = function(self)
			self.hover = true
		end
		submittButton.OnCursorExited = function(self)
			self.hover = false
		end	
		submittButton.Paint = function( self, w, h )		
			draw.RoundedBox(0, 0, 0, w, h, (self.hover and Color(0,160,255,250)) or Color(255,255,255,255)) -- Paints on hover
			submittButton:SetTextColor(self.hover and Color(255,255,255,250) or Color(0,0,0,255))
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
		DFrame:SetSize( 300, 350 )
		DFrame:Center()
		DFrame:SetDraggable( true )
		DFrame:MakePopup()
		DFrame:SetTitle( "" )
		DFrame:ShowCloseButton( false )
		DFrame.Paint = function( self, w, h )
			draw.RoundedBox(2, 0, 0, DFrame:GetWide(), DFrame:GetTall(), Color(35, 35, 35, 250))
			draw.RoundedBox(2, 0, 0, DFrame:GetWide(), 30, Color(40, 40, 40, 255))
			draw.SimpleText( "Sell Weapon", "LMMESTORETitleFont", DFrame:GetWide() / 2, 15, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end
		
		local frameclose = vgui.Create("DButton", DFrame)
		frameclose:SetSize(20, 20)
		frameclose:SetPos(DFrame:GetWide() - frameclose:GetWide() - 3, 3)
		frameclose:SetText("X");
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
		
		local TextEntry = vgui.Create( "DTextEntry", DFrame )
		TextEntry:SetPos( 5, 40 )
		TextEntry:SetSize( DFrame:GetWide() - 10, 20 )
		TextEntry:SetText( "Short Description" )
		TextEntry.OnEnter = function( self )

		end	

		local TextEntry2 = vgui.Create( "DTextEntry", DFrame )
		TextEntry2:SetPos( 5, 65 )
		TextEntry2:SetSize( DFrame:GetWide() - 10, 20 )
		TextEntry2:SetText( "Price" )
		TextEntry2.OnEnter = function( self )

		end	

		icon = vgui.Create("DModelPanel" , DFrame )
		icon:SetPos( 5, 90 )
		icon:SetSize( DFrame:GetWide() - 10, 200 )		
		icon:SetModel(model)
		local min, max = icon.Entity:GetRenderBounds()
		icon:SetCamPos(min:Distance(max) * Vector(0.7, 0.7, 0.7))
		icon:SetLookAt((max + min) / 2)
		
		local submittButton = vgui.Create( "DButton", DFrame )
		submittButton:SetPos( 5, 320 )
		submittButton:SetSize( DFrame:GetWide() - 10,20 )
		submittButton:SetText( "Sell item" )
		submittButton.OnCursorEntered = function(self)
			self.hover = true
		end
		submittButton.OnCursorExited = function(self)
			self.hover = false
		end	
		submittButton.Paint = function( self, w, h )		
			draw.RoundedBox(0, 0, 0, w, h, (self.hover and Color(0,160,255,250)) or Color(255,255,255,255)) -- Paints on hover
			submittButton:SetTextColor(self.hover and Color(255,255,255,250) or Color(0,0,0,255))
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
		DFrame:SetSize( 300, 350 )
		DFrame:Center()
		DFrame:SetDraggable( true )
		DFrame:MakePopup()
		DFrame:SetTitle( "" )
		DFrame:ShowCloseButton( false )
		DFrame.Paint = function( self, w, h )
			draw.RoundedBox(2, 0, 0, DFrame:GetWide(), DFrame:GetTall(), Color(35, 35, 35, 250))
			draw.RoundedBox(2, 0, 0, DFrame:GetWide(), 30, Color(40, 40, 40, 255))
			draw.SimpleText( "Sell Ammo("..count..")", "LMMESTORETitleFont", DFrame:GetWide() / 2, 15, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end
		
		local frameclose = vgui.Create("DButton", DFrame)
		frameclose:SetSize(20, 20)
		frameclose:SetPos(DFrame:GetWide() - frameclose:GetWide() - 3, 3)
		frameclose:SetText("X");
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

		
		local TextEntry = vgui.Create( "DTextEntry", DFrame )
		TextEntry:SetPos( 5, 40 )
		TextEntry:SetSize( DFrame:GetWide() - 10, 20 )
		TextEntry:SetText( "Short Description" )
		TextEntry.OnEnter = function( self )

		end	

		local TextEntry2 = vgui.Create( "DTextEntry", DFrame )
		TextEntry2:SetPos( 5, 65 )
		TextEntry2:SetSize( DFrame:GetWide() - 10, 20 )
		TextEntry2:SetText( "Price" )
		TextEntry2.OnEnter = function( self )

		end	

		icon = vgui.Create("DModelPanel" , DFrame )
		icon:SetPos( 5, 90 )
		icon:SetSize( DFrame:GetWide() - 10, 200 )		
		icon:SetModel(model)
		local min, max = icon.Entity:GetRenderBounds()
		icon:SetCamPos(min:Distance(max) * Vector(0.7, 0.7, 0.7))
		icon:SetLookAt((max + min) / 2)
		
		local submittButton = vgui.Create( "DButton", DFrame )
		submittButton:SetPos( 5, 320 )
		submittButton:SetSize( DFrame:GetWide() - 10,20 )
		submittButton:SetText( "Sell item" )
		submittButton.OnCursorEntered = function(self)
			self.hover = true
		end
		submittButton.OnCursorExited = function(self)
			self.hover = false
		end	
		submittButton.Paint = function( self, w, h )		
			draw.RoundedBox(0, 0, 0, w, h, (self.hover and Color(0,160,255,250)) or Color(255,255,255,255)) -- Paints on hover
			submittButton:SetTextColor(self.hover and Color(255,255,255,250) or Color(0,0,0,255))
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
	DFrame:SetSize( 550, 580 )
	DFrame:Center()
	DFrame:SetDraggable( true )
	DFrame:MakePopup()
	DFrame:SetTitle( "" )
	DFrame:ShowCloseButton( false )
	DFrame.Paint = function( self, w, h )
		draw.RoundedBox(2, 0, 0, DFrame:GetWide(), DFrame:GetTall(), Color(20, 20, 20, 250))
		draw.RoundedBox(2, 0, 0, DFrame:GetWide(), 30, Color(40, 40, 40, 255))
		draw.SimpleText( "Manage Items", "LMMESTORETitleFont", DFrame:GetWide() / 2, 15, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end
	
	local frameclose = vgui.Create("DButton", DFrame)
	frameclose:SetSize(20, 20)
	frameclose:SetPos(DFrame:GetWide() - frameclose:GetWide() - 3, 3)
	frameclose:SetText("X");
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
		NoItems:SetText( "There are no items by you!" )
		NoItems:SetFont( "LMMESTORENoFont" )
		NoItems:SetTextColor( Color( 200, 200, 200 ) )
		NoItems:SizeToContents()
		NoItems:Center()
	end

	instl = vgui.Create("DLabel", DFrame)
	instl:SetText("Click on the item you would like to edit!")
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
			weaponl:SetFont("LMMESTORESellLabel")
			
			CurrAva = vgui.Create("DLabel", ItemMain)
			local thetext = ""
			if v[9] == 1 then thetext = "false" else thetext = "true" end 
			CurrAva:SetText("On the market: "..thetext)
			CurrAva:SetPos(100, 35)
			CurrAva:SetSize(500, 30)
			CurrAva:SetFont("LMMESTORESellLabel")
			
			descriptionl = vgui.Create("DLabel", ItemMain)
			descriptionl:SetText(v[6])
			descriptionl:SetPos(100, 60)
			descriptionl:SetSize(500, 30)
			descriptionl:SetFont("LMMESTORESellLabel")			

			pricel = vgui.Create("DLabel", ItemMain)
			pricel:SetText("Price: "..v[7])
			pricel:SetPos(100, 85)
			pricel:SetSize(500, 30)
			pricel:SetFont("LMMESTORESellLabel")			

			DPanelList:AddItem(ItemMain)			
		end	
		
		for k, v in pairs(thetableweapons) do
			--seller, sellerhere, weapon, model, desc, price, v, pending
			local ItemMain = vgui.Create( "DButton", DPanelList )
			ItemMain:SetSize( DPanelList:GetWide(), 120 )
		--	ItemMain:ShowCloseButton( false )
			ItemMain:SetText( "" )
			ItemMain.Paint = function( self, w, h )
				draw.RoundedBox(2, 0, 0, DFrame:GetWide(), DFrame:GetTall(), Color(40, 40, 40, 250))
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
			weaponl:SetFont("LMMESTORESellLabel")
			
			CurrAva = vgui.Create("DLabel", ItemMain)
			local thetext = ""
			if v[8] == 1 then thetext = "false" else thetext = "true" end 
			CurrAva:SetText("On the market: "..thetext)
			CurrAva:SetPos(100, 35)
			CurrAva:SetSize(500, 30)
			CurrAva:SetFont("LMMESTORESellLabel")
			
			descriptionl = vgui.Create("DLabel", ItemMain)
			descriptionl:SetText(v[5])
			descriptionl:SetPos(100, 60)
			descriptionl:SetSize(500, 30)
			descriptionl:SetFont("LMMESTORESellLabel")			

			pricel = vgui.Create("DLabel", ItemMain)
			pricel:SetText("Price: "..v[6])
			pricel:SetPos(100, 85)
			pricel:SetSize(500, 30)
			pricel:SetFont("LMMESTORESellLabel")			

			DPanelList:AddItem(ItemMain)			
		end	

		for k, v in pairs(thetableammo) do
			--seller, sellerhere, count, ammoType, model, desc, price, v, pending
			local ItemMain = vgui.Create( "DButton", DPanelList )
			ItemMain:SetSize( DPanelList:GetWide(), 120 )
		--	ItemMain:ShowCloseButton( false )
			ItemMain:SetText( "" )
			ItemMain.Paint = function( self, w, h )
				draw.RoundedBox(2, 0, 0, DFrame:GetWide(), DFrame:GetTall(), Color(40, 40, 40, 250))
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
			weaponl:SetFont("LMMESTORESellLabel")
			
			CurrAva = vgui.Create("DLabel", ItemMain)
			local thetext = ""
			if v[9] == 1 then thetext = "false" else thetext = "true" end 
			CurrAva:SetText("On the market: "..thetext)
			CurrAva:SetPos(100, 35)
			CurrAva:SetSize(500, 30)
			CurrAva:SetFont("LMMESTORESellLabel")
			
			descriptionl = vgui.Create("DLabel", ItemMain)
			descriptionl:SetText(v[6])
			descriptionl:SetPos(100, 60)
			descriptionl:SetSize(500, 30)
			descriptionl:SetFont("LMMESTORESellLabel")			

			pricel = vgui.Create("DLabel", ItemMain)
			pricel:SetText("Price: "..v[7])
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

net.Receive("LMMESTOREOpeneStore", function()

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
		NoItems:SetText( "There are no items in the eStore!" )
		NoItems:SetFont( "LMMESTORENoFont" )
		NoItems:SetTextColor( Color( 200, 200, 200 ) )
		NoItems:SizeToContents()
		NoItems:Center()
	end 

	instl = vgui.Create("DLabel", DFrame)
	instl:SetText("Click on the item you would like to buy!")
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
				if v[2] == true then
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
			weaponl:SetFont("LMMESTORESellLabel")

			if v[2] != false then
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
			pricel:SetText("Price: "..v[7])
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
				if v[2] == true then
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
			weaponl:SetFont("LMMESTORESellLabel")
			
			if v[2] != false then
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
			pricel:SetText("Price: "..v[6])
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
				if v[2] == true then
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
			weaponl:SetFont("LMMESTORESellLabel")
			
			if v[2] != false then
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
			pricel:SetText("Price: "..v[7])
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

net.Receive("LMMESTORENotify", function()
	local message = net.ReadString()
	
	chat.AddText(Color(255,0,0), "[eStore] ", Color(0,0,0), message)
	surface.PlaySound( LMMESTOREConfig.SoundOnSellItem )
end)