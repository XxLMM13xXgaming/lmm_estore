LMMESTOREConfig = {}
LMMESTOREConfig.DevMode = true
/*
	Made By: XxLMM13xXgaming
*/

LMMESTOREConfig.SoundOnSellItem = "HL1/fvox/bell.wav" -- The sound the eStore makes!

LMMESTOREConfig.BanTime = 2880 -- Time in min to ban the user (2880 is 2 days)

LMMESTOREConfig.AdminGroups = {"superadmin", "admin", "owner"} -- Groups that are admin

LMMESTOREConfig.RenewBuySub = 1000 -- How much does it cost to buy/renew a subscription to the estore?

LMMESTOREConfig.SubTime = 10080 -- How much time in min for the subcription to last (10080 is 1 week) simply use google to translate time in min (https://gyazo.com/b61b268fb54a76e24702ca02a44bd0a8)

-- I would not change this it has some good info in here!
LMMESTOREConfig.MoreInfoText = "Welcome to the eStore! This is a garrysmod market place for selling weapons, shipments, and ammo!\n\n FOR USERS/BUYERS\n To buy a item simply click on the item in the estore and click 'yes' to the are you sure and then go to your local eStore delivery man and collect your item!\n\nFOR SELLERS/MERCHANTS\n To sell a item buy a shipment, weapon, or ammo box and look at it and type !estore and you will be prompted to enter a short description and a price! Next you will need to visit your profile by typing !estore and clicking 'Dashbored' and going to 'My profile', there you will click 'Buy/renew a subscription' and buy a subscription! Next go to the dashbored and click 'Manage my items' and click on your item and click 'submit to the market'! Your item will be added to the market for all to see AND for people to buy even when your offline! TO collect your income you can go to your profile and click 'collect money' you will then receive your money!\n\n" -- Text to display in the more info section

LMMESTOREConfig.BotSalesTime = 60 -- Time in min to create a bot sale

LMMESTOREConfig.BotSales = {}

/*
LMMESTOREConfig.BotSales.S0 = {
	BotSalesIndex = 0, -- this is the same as the S thing above.. a unique index
	BotSalesType = "type", -- this can be shipment, weapon, or ammo 
	BotSalesCount = 10, -- This is the count of shipment/ammo USE 0 FOR SHIPMENTS
	BotSalesWeapon = "weapon_ak472", -- This is the weapon or ammo type to use 
	BotSalesModel = "models/weapons/w_rif_ak47.mdl", -- The model to display ex the weapon or ammo box
	BotSalesDesc = "Short Description", -- The description
	BotSalesPrice = 100 -- The pice
}
*/

LMMESTOREConfig.BotSales.S1 = {
	BotSalesIndex = 1,
	BotSalesType = "shipment",
	BotSalesCount = 10,
	BotSalesWeapon = "weapon_ak472",
	BotSalesModel = "models/weapons/w_rif_ak47.mdl",
	BotSalesDesc = "Short Description",
	BotSalesPrice = 100
}

LMMESTOREConfig.BotSales.S2 = {
	BotSalesIndex = 2,
	BotSalesType = "weapon",
	BotSalesCount = 0,
	BotSalesWeapon = "weapon_ak472",
	BotSalesModel = "models/weapons/w_rif_ak47.mdl",
	BotSalesDesc = "Short Description",
	BotSalesPrice = 100
}

LMMESTOREConfig.BotSales.S3 = {
	BotSalesIndex = 3,
	BotSalesType = "ammo",
	BotSalesCount = 10,
	BotSalesWeapon = "pistol",
	BotSalesModel = "models/items/boxsrounds.mdl",
	BotSalesDesc = "Short Description",
	BotSalesPrice = 100
}