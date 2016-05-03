AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()

	self:SetModel("models/Items/AR2_Grenade.mdl") 
	
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetCollisionGroup(COLLISION_GROUP_NONE)
	
	local phys = self:GetPhysicsObject()

	if phys and phys:IsValid() then
		phys:Wake()
		phys:AddGameFlag(FVPHYSICS_NO_IMPACT_DMG)
		phys:AddGameFlag(FVPHYSICS_NO_NPC_IMPACT_DMG)
		phys:AddGameFlag(FVPHYSICS_PENETRATING)
		phys:SetVelocity(self:GetForward() * 9000 * phys:GetMass())
	end
	
	self.Hit = false
	
end

function ENT:Use(activator, caller)
	return
end

function ENT:OnRemove()
	return
end 

local vel, len, pos, owner

function ENT:PhysicsCollide(data, physobj)

	if not self.Hit then
	
		if data.HitEntity:Health() > 0 and data.Speed > 500 then 
			data.HitEntity:TakeDamage( 100, self.Owner, self.Entity )
		end	

		self.HitP = data.HitPos + self.Entity:GetUp()
		self.HitN = data.HitNormal
		
		self:SetNWVector( self.EntIndex().."HITP", self.HitP)
		self:SetNWVector( self.EntIndex().."HITN", self.HitN)

		if data.HitEntity:GetClass() == "worldspawn" && data.Speed > 2000 then
		
			self.Hit = 1
			
			physobj:EnableCollisions( false )
			physobj:EnableMotion(false)
			
			physobj:SetPos(data.HitPos + data.HitNormal)
			physobj:SetAngles(data.HitNormal:Angle()+Angle(0,0,0))
			self:EmitSound("Concrete_Block.ImpactHard")
				
			self.effectdata = EffectData()
			self.effectdata:SetStart( self:GetPos() - self:GetRight() ) // not sure if we need a start and origin (endpoint) for this effect, but whatever
			self.effectdata:SetOrigin( self:GetPos() - self:GetRight()*6 )
			self.effectdata:SetScale( 1 )
			
			for i = 1, 25 do
				util.Effect( "GlassImpact", self.effectdata )	
			end
				
				
			self.Pos1 = self.HitP + self.HitN
			self.Pos2 = self.HitP - self.HitN
			util.Decal("ExplosiveGunshot", self.Pos1, self.Pos2)

			self.Sound1PlayTime = CurTime() + 3
			self.Sound1HasPlayed = false
			
			self.Sound2PlayTime = CurTime() + 4.25
			self.Sound2HasPlayed = false
			
			timer.Simple(4.25, function()
				if not self:IsValid() then return end
				self.EnableTrace = 1
			end)
			
				
		elseif data.Speed > 500 then
			self:EmitSound("Missile.ShotDown")
			SafeRemoveEntityDelayed(self,5)
		end
		
	end
	
end

function ENT:OnTakeDamage(dmginfo)
	SafeRemoveEntity(self)
end

local NextThink = 0

function ENT:Think()
	if NextThink <= CurTime() then
		if self.Owner and self.Owner ~= NULL then
			if self.Owner:Alive() == false then
				SafeRemoveEntity(self)
			end
		else
			SafeRemoveEntity(self)
		end
		NextThink = CurTime() + 0.25
	end
end