ENT.Base = "base_ai"
ENT.Type = "ai"
ENT.PrintName = "eStore delivery man"
ENT.Category = "eStore"
ENT.Spawnable = true
ENT.AdminSpawnable = true
ENT.AutomaticFrameAdvance = true  
 
function ENT:SetAutomaticFrameAdvance( bUsingAnim )
	self.AutomaticFrameAdvance = bUsingAnim
end