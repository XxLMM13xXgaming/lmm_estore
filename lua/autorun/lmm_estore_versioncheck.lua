--[[You really should not edit this!]]--
local version = "1.0" -- DO NOT EDIT THIS!
local version_url = "https://gist.githubusercontent.com/XxLMM13xXgaming/c761d31a8358565bc758c28b4972ce77/raw/LMMESTORE" -- DO NOT EDIT THIS!
local update_url = "https://github.com/XxLMM13xXgaming/lmm_estore" -- DO NOT EDIT THIS!
local update_ur = "https://gist.githubusercontent.com/XxLMM13xXgaming/c89c161d6424d456acbe0e68cc276384/raw/LMMESTORE%2520UR" -- DO NOT EDIT THIS!
local msg_outdated = "You are using a outdated/un-supported version. You are on version "..version.."! Please download the new version here: " .. update_url -- DO NOT EDIT THIS!
local ranksthatgetnotify = { "superadmin", "owner", "admin" } -- DO NOT EDIT THIS!
local addon_id = "LMMESTORE" -- DO NOT EDIT THIS
local addon_name = "eStore" -- DO NOT EDIT THIS
  
if (SERVER) then  
	require( "tmysql4" )  

	AddCSLuaFile("lmm_estore_config.lua")
	include("lmm_estore_config.lua")
	include("lmm_estore_mysql_config.lua")
	  
	local message = [[------------------------
|  LMM eStore          |
|  Created: 4/11/2016  |
|  Version: ]]..version..[[        |
------------------------
]]
	
	MsgC(Color(68,255,0), message) 
 
	----------------------------------------------------------------------------
	-- Connect to database
	----------------------------------------------------------------------------
	LMMESTOREdb, LMMESTOREerr = tmysql.initialize(LMMESTOREMYSQLConfig.host, LMMESTOREMYSQLConfig.username, LMMESTOREMYSQLConfig.password, LMMESTOREMYSQLConfig.database, LMMESTOREMYSQLConfig.port, nil, CLIENT_MULTI_STATEMENTS )

	if LMMESTOREerr != nil or tostring( type( LMMESTOREdb ) ) == "boolean" then
		MsgC( Color(255,0,0), "[eStore] Error connecting to the database!\n" )
		MsgC( Color(255,0,0), "[eStore] MySQL Error: " .. LMMESTOREerr.."\n")
	else 
		MsgC(Color(0,255,0), "[eStore] Connected to the database!\n")
	end
	----------------------------------------------------------------------------
	-- Connect to database
	----------------------------------------------------------------------------
	
	----------------------------------------------------------------------------
	-- Create tables
	----------------------------------------------------------------------------
	LMMESTORESQLCreateTables = [[CREATE TABLE IF NOT EXISTS `ammo` (
  `id` int(11) NOT NULL,
  `seller` varchar(255) NOT NULL,
  `count` varchar(255) NOT NULL,
  `weapon` varchar(255) NOT NULL,
  `model` varchar(255) NOT NULL,
  `description` varchar(255) NOT NULL,
  `price` varchar(255) NOT NULL,
  `pending` varchar(255) NOT NULL
);

CREATE TABLE IF NOT EXISTS `banned` (
  `id` int(11) NOT NULL,
  `banned` varchar(255) NOT NULL,
  `time` varchar(255) NOT NULL
);

CREATE TABLE IF NOT EXISTS `pickup` (
  `id` int(11) NOT NULL,
  `type` varchar(255) NOT NULL,
  `seller` varchar(255) NOT NULL,
  `count` varchar(255) NOT NULL,
  `weapon` varchar(255) NOT NULL,
  `model` varchar(255) NOT NULL,
  `description` varchar(255) NOT NULL,
  `price` varchar(255) NOT NULL,
  `pending` varchar(255) NOT NULL,
  `buyer` varchar(255) NOT NULL
);

CREATE TABLE IF NOT EXISTS `players` (
  `id` int(11) NOT NULL,
  `player` varchar(255) NOT NULL,
  `earned` varchar(255) NOT NULL,
  `spent` varchar(255) NOT NULL,
  `unclaimed` varchar(255) NOT NULL
);

CREATE TABLE IF NOT EXISTS `shipments` (
  `id` int(11) NOT NULL,
  `seller` varchar(255) NOT NULL,
  `count` varchar(255) NOT NULL,
  `weapon` varchar(255) NOT NULL,
  `model` varchar(255) NOT NULL,
  `description` varchar(255) NOT NULL,
  `price` varchar(255) NOT NULL,
  `pending` varchar(255) NOT NULL
);

CREATE TABLE IF NOT EXISTS `subscriptions` (
  `id` int(11) NOT NULL,
  `subscribed` varchar(255) NOT NULL,
  `time` varchar(255) NOT NULL
);

CREATE TABLE IF NOT EXISTS `weapons` (
  `id` int(11) NOT NULL,
  `seller` varchar(255) NOT NULL,
  `weapon` varchar(255) NOT NULL,
  `model` varchar(255) NOT NULL,
  `description` varchar(255) NOT NULL,
  `price` varchar(255) NOT NULL,
  `pending` varchar(255) NOT NULL
);


ALTER TABLE `ammo`
  ADD PRIMARY KEY (`id`);

ALTER TABLE `banned`
  ADD PRIMARY KEY (`id`);

ALTER TABLE `pickup`
  ADD PRIMARY KEY (`id`);

ALTER TABLE `players`
  ADD PRIMARY KEY (`id`);

ALTER TABLE `shipments`
  ADD PRIMARY KEY (`id`);

ALTER TABLE `subscriptions`
  ADD PRIMARY KEY (`id`);

ALTER TABLE `weapons`
  ADD PRIMARY KEY (`id`);


ALTER TABLE `ammo`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=8;

ALTER TABLE `banned`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=24;

ALTER TABLE `pickup`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=40;

ALTER TABLE `players`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=7;

ALTER TABLE `shipments`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=18;

ALTER TABLE `subscriptions`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=9;

ALTER TABLE `weapons`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=32;

INSERT INTO `players` (`id`, `player`, `earned`, `spent`, `unclaimed`) VALUES
(1, 'server', '0', '0', '0');  
  
 ]]
	
	LMMESTOREdb:Query( LMMESTORESQLCreateTables, function(result)
		if result[1].status == false then
			MsgC(Color(255,0,0), "[eStore] Error setting up the MySQL tables!\n")		
			PrintTable(result)
		else
			MsgC(Color(0,255,0), "[eStore] MySQL tables have been setup!\n")
		end
	end	)
	----------------------------------------------------------------------------
	-- Create tables
	----------------------------------------------------------------------------
	
	if !file.Exists("lmmestore_data", "DATA") then
		file.CreateDir("lmmestore_data", "DATA")
		file.CreateDir("lmmestore_data/errors", "DATA")
	end 
	 
	util.AddNetworkString(addon_id.."VersionCheckCL")
	util.AddNetworkString(addon_id.."VersionCheckCLUR")
	
	http.Fetch(version_url, function(body, len, headers, code, ply)
		if (string.Trim(body) ~= version) then
			MsgC( Color(255,0,0), "["..addon_name.." ("..version..")] You are NOT using the latest version! (version: "..string.Trim(body)..")\n" )
		else
			MsgC( Color(255,0,0), "["..addon_name.." ("..version..")] You are using the latest version!\n" )
		end  
	end )	 
	timer.Create(addon_id.."VersionCheckServerTimer", 600, 0, function()
		http.Fetch(version_url, function(body, len, headers, code, ply)
			if (string.Trim(body) ~= version) then
				MsgC( Color(255,0,0), "["..addon_name.." ("..version..")] You are NOT using the latest version! ("..string.Trim(body)..")\n" )
			end
		end )
	end )
	
	for k, v in pairs(player.GetAll()) do
		if (table.HasValue( ranksthatgetnotify, v:GetUserGroup() ) ~= true) then return end
		
		http.Fetch(version_url, function(body, len, headers, code, ply)
			if (string.Trim(body) ~= version) then
				net.Start(addon_id.."VersionCheckCL")
					net.WriteString(string.Trim(body))
				net.Send(v)
				timer.Create( addon_id.."VersionCheckTimer", 600, 6, function()
					net.Start(addon_id.."VersionCheckCL")
						net.WriteString(string.Trim(body))
					net.Send(v)
				end )
				
				http.Fetch(update_ur, function(body, len, headers, code, ply)
					net.Start(addon_id.."VersionCheckCLUR")
						net.WriteString(body)
					net.Send(v)	
				end)				
			else

			end
			  
		end, function(error)

			-- Silently fail

		end)	
	end
	
	hook.Add("PlayerInitialSpawn", addon_id.."VersionCheck", function(theply)
		if (table.HasValue( ranksthatgetnotify, theply:GetUserGroup() ) ~= true) then return end
		
		http.Fetch(version_url, function(body, len, headers, code, ply)
			if (string.Trim(body) ~= version) then
				net.Start(addon_id.."VersionCheckCL")
					net.WriteString(string.Trim(body))
				net.Send(theply)
				timer.Create( addon_id.."VersionCheckTimer", 600, 6, function()
					net.Start(addon_id.."VersionCheckCL")
						net.WriteString(string.Trim(body))
					net.Send(theply)
				end )
				http.Fetch(update_ur, function(body, len, headers, code, ply)
					net.Start(addon_id.."VersionCheckCLUR")
						net.WriteString(body)
					net.Send(theply)		 
				end)								
			else

			end
			  
		end, function(error)

			-- Silently fail

		end)
	end)
	
	 
end

if (CLIENT) then 
	include("lmm_estore_config.lua")
	local message = [[------------------------
|  LMM eStore          |
|  Created: 4/11/2016  |
|  Version: ]]..version..[[        |
------------------------
]]
	
	MsgC(Color(68,255,0), message) 	
	net.Receive(addon_id.."VersionCheckCL", function()
		local nversion = net.ReadString()
		MsgC(Color(0,0,0), "-----------------------------------------------------------------------------------\n")
		chat.AddText(Color(255,0,0), "["..addon_name.."]: ", Color(255,255,255), addon_name.." is outdated! You are on version "..version.." and version "..nversion.." is out! Check console for more info!")		
		MsgC(Color(0,255,0), msg_outdated.."\n\n")
	end)
	
	net.Receive(addon_id.."VersionCheckCLUR", function()
		local reason = net.ReadString()

		MsgC(Color(0,255,0), "Whats new: "..reason.."\n")
		MsgC(Color(0,0,0), "-----------------------------------------------------------------------------------\n")
	end)
end
