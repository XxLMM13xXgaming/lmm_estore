require( "tmysql4" ) 
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
	LMMESTOREdb, LMMESTOREerr = tmysql.initialize(LMMESTOREMYSQLConfig.host, LMMESTOREMYSQLConfig.username, LMMESTOREMYSQLConfig.password, LMMESTOREMYSQLConfig.database, LMMESTOREMYSQLConfig.port)

	if LMMESTOREerr != nil or tostring( type( LMMESTOREdb ) ) == "bool" then
		MsgC( Color(255,0,0), "[eStore] Error connecting to the database!\n" )
		MsgC( Color(255,0,0), "[eStore] MySQL Error: " .. LMMESTOREerr.."\n")
	else
		MsgC(Color(0,255,0), "[eStore] Connected to the database! MySQL is setup!\n")
	end
	----------------------------------------------------------------------------
	-- Connect to database
	----------------------------------------------------------------------------
	
	----------------------------------------------------------------------------
	-- Create tables
	----------------------------------------------------------------------------
	LMMESTOREdb:Query("CREATE TABLE IF NOT EXISTS `ammo` (  'id' int(11) NOT NULL AUTO_INCREMENT,  `seller` varchar(255) NOT NULL,  `count` varchar(255) NOT NULL,  `weapon` varchar(255) NOT NULL,  `model` varchar(255) NOT NULL,  `description` varchar(255) NOT NULL,  `price` varchar(255) NOT NULL,  `pending` varchar(255) NOT NULL) ENGINE=MyISAM AUTO_INCREMENT=8 DEFAULT CHARSET=utf8;", function(result)
		if result[1].status == true then
			MsgC(Color(0,255,0), "[eStore] Creating ammo table in the MySQL database!")
		else
			MsgC(Color(255,0,0), "[eStore] Error creating ammo table in the MySQL database!")
			PrintTable(result)
		end
	end)

	LMMESTOREdb:Query("CREATE TABLE IF NOT EXISTS `banned` ('id' int(11) NOT NULL AUTO_INCREMENT, `banned` varchar(255) NOT NULL,  `time` varchar(255) NOT NULL) ENGINE=MyISAM AUTO_INCREMENT=24 DEFAULT CHARSET=utf8;", function(result)
		if result[1].status == true then
			MsgC(Color(0,255,0), "[eStore] Creating banned table in the MySQL database!")
		else
			MsgC(Color(255,0,0), "[eStore] Error creating banned table in the MySQL database!")
			PrintTable(result)
		end	
	end)

	LMMESTOREdb:Query("CREATE TABLE IF NOT EXISTS `pickup` (  'id' int(11) NOT NULL AUTO_INCREMENT,  `type` varchar(255) NOT NULL,  `seller` varchar(255) NOT NULL,  `weapon` varchar(255) NOT NULL,  `description` varchar(255) NOT NULL,  `pending` varchar(255) NOT NULL,  `buyer` varchar(255) NOT NULL) ENGINE=MyISAM AUTO_INCREMENT=40 DEFAULT CHARSET=utf8;", function(result)
		if result[1].status == true then
			MsgC(Color(0,255,0), "[eStore] Creating pickup table in the MySQL database!")
		else
			MsgC(Color(255,0,0), "[eStore] Error creating pickup table in the MySQL database!")
			PrintTable(result)
		end
	end)

	LMMESTOREdb:Query("CREATE TABLE IF NOT EXISTS `players` (  'id' int(11) NOT NULL AUTO_INCREMENT,  `player` varchar(255) NOT NULL,  `earned` varchar(255) NOT NULL,  `spent` varchar(255) NOT NULL,  `unclaimed` varchar(255) NOT NULL) ENGINE=MyISAM AUTO_INCREMENT=7 DEFAULT CHARSET=utf8;", function(result)
		if result[1].status == true then
			MsgC(Color(0,255,0), "[eStore] Creating players table in the MySQL database!")
		else
			MsgC(Color(255,0,0), "[eStore] Error creating players table in the MySQL database!")
			PrintTable(result)
		end
	end)

	LMMESTOREdb:Query("CREATE TABLE IF NOT EXISTS `shipments` (  'id' int(11) NOT NULL AUTO_INCREMENT,  `seller` varchar(255) NOT NULL,  `count` varchar(255) NOT NULL,  `weapon` varchar(255) NOT NULL,  `model` varchar(255) NOT NULL,  `description` varchar(255) NOT NULL,  `price` varchar(255) NOT NULL,  `pending` varchar(255) NOT NULL) ENGINE=MyISAM AUTO_INCREMENT=18 DEFAULT CHARSET=utf8;", function(result)
		if result[1].status == true then
			MsgC(Color(0,255,0), "[eStore] Creating shipments table in the MySQL database!")
		else
			MsgC(Color(255,0,0), "[eStore] Error creating shipments table in the MySQL database!")
			PrintTable(result)
		end
	end)

	LMMESTOREdb:Query("CREATE TABLE IF NOT EXISTS `subscriptions` (  'id' int(11) NOT NULL AUTO_INCREMENT, `subscribed` varchar(255) NOT NULL,  `time` varchar(255) NOT NULL) ENGINE=MyISAM AUTO_INCREMENT=9 DEFAULT CHARSET=utf8;", function(result)
		if result[1].status == true then
			MsgC(Color(0,255,0), "[eStore] Creating subscriptions table in the MySQL database!")
		else
			MsgC(Color(255,0,0), "[eStore] Error creating subscriptions table in the MySQL database!")
			PrintTable(result)
		end
	end)

	LMMESTOREdb:Query("CREATE TABLE IF NOT EXISTS `weapons` (  'id' int(11) NOT NULL AUTO_INCREMENT,  `seller` varchar(255) NOT NULL,  `weapon` varchar(255) NOT NULL,  `model` varchar(255) NOT NULL,  `description` varchar(255) NOT NULL,  `price` varchar(255) NOT NULL,  `pending` varchar(255) NOT NULL) ENGINE=MyISAM AUTO_INCREMENT=32 DEFAULT CHARSET=utf8;", function(result)
		if result[1].status == true then
			MsgC(Color(0,255,0), "[eStore] Creating weapons table in the MySQL database!")
		else
			MsgC(Color(255,0,0), "[eStore] Error creating weapons table in the MySQL database!")
			PrintTable(result)
		end
	end)	
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
