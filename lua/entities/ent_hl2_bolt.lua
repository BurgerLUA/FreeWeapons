ENT.Type = "anim"
ENT.Base = "base_entity"
ENT.PrintName = "HE GRENADE"
ENT.Author = ""
ENT.Information = ""
ENT.Spawnable = false
ENT.AdminSpawnable = false 

AddCSLuaFile()

function ENT:Initialize()
	if SERVER then
		self:SetModel("models/crossbow_bolt.mdl") 
		self:PhysicsInit(SOLID_NONE)
		self:SetMoveType(MOVETYPE_NONE)
		self:SetSolid(SOLID_NONE)
		

		
		self.Delay = CurTime() + 3
	end
end

function ENT:Think()
	if SERVER then
	
		if IsFirstTimePredicted() then
			self:SetPos(self:GetPos() + self:GetForward() * (1/engine.TickInterval()) * 2 )
		
			local TraceData = {
				start = self:GetPos(),
				endpos = self:GetPos(),
				filter = {self,self.Owner},
				mask = MASK_SOLID,
				ignoreworld = false
				}

			local Trace = util.TraceEntity(TraceData,self)
			
			if Trace.Hit then
				SafeRemoveEntity(self)
			end
		end
		
		self:NextThink( CurTime() + engine.TickInterval())
		
		return true

	end
end

function ENT:Draw()
	if CLIENT then
		self:DrawModel()
	end
end


