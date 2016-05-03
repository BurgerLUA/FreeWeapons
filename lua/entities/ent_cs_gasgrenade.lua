ENT.Type = "anim"
ENT.Base = "base_entity"
ENT.PrintName = "GAS GRENADE"
ENT.Author = ""
ENT.Information = ""
ENT.Spawnable = false
ENT.AdminSpawnable = false 

ENT.BounceSound = Sound("SmokeGrenade.Bounce")
ENT.ExplodeSound = Sound("BaseSmokeEffect.Sound")

AddCSLuaFile()

function ENT:Initialize()
	if SERVER then
		self:SetModel("models/weapons/w_eq_smokegrenade.mdl") 
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
		self:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
		
		local phys = self:GetPhysicsObject()
		if phys:IsValid() then
			phys:Wake()
			phys:SetBuoyancyRatio(0)
		end
		
		self.Delay = CurTime() + 1
		self.NextParticle = 0
		self.IsDetonated = false
		
	end
end

function ENT:PhysicsCollide(data, physobj)
	if SERVER then
	
		if self:GetVelocity():Length() > 50 then
			self:EmitSound(self.BounceSound)
		end
		--[[
		if self:GetVelocity():Length() < 10 then
			self:EnableMotion(false)
		end
		--]]
	end
end



function ENT:Think()
	if SERVER then
		if CurTime() > self.Delay then 

			if self.NextParticle <= CurTime() then 
			
				local ent = ents.Create("ent_cs_gasparticle")
				ent:SetPos(self:GetPos() + self:GetUp()*5)
				ent:SetAngles(Angle(0,0,0))
				ent:Spawn()
				ent:Activate()
				ent:SetOwner(self.Owner)
				ent:GetPhysicsObject():SetVelocity( self:GetUp()*50 + self:GetRight()*math.random(-10,10) + self:GetForward()*math.random(-10,10) )
				
				
				self.NextParticle = CurTime() + 0.2
			end
			
			if self.IsDetonated == false then
				self:Detonate(self,self:GetPos())
				self.IsDetonated = true
			end
			
		end
	end
end

function ENT:Detonate(self,pos)
	if SERVER then
		if not self:IsValid() then return end
		self:EmitSound(self.ExplodeSound)
		SafeRemoveEntityDelayed(self,15)
	end
end

function ENT:Draw()
	if CLIENT then
		self:DrawModel()
	end
end
