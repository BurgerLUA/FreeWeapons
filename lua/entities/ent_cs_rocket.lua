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
	
		self:SetModel("models/weapons/w_missile_closed.mdl") 
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
		
		local phys = self:GetPhysicsObject()
		
		if phys:IsValid() then
			phys:Wake()
			phys:SetBuoyancyRatio(0)
			phys:EnableGravity(false)
		end
		
		util.SpriteTrail( self, 0, Color(255,255,255,255), false, 0, 32,5, 32, "trails/smoke.vmt" )

	end
end

function ENT:PhysicsCollide(data, physobj)
	if SERVER then
	
		self.HitP = data.HitPos
		self.HitN = data.HitNormal
		
		if not self:GetNWBool("Detonated",false) then 
			self:Detonate(data.HitPos)
		end
		
	end
end

function ENT:Think()
	if SERVER then
	
		local TraceData = {
			start = self.Owner:EyePos(),
			endpos = self.Owner:EyePos() + self.Owner:EyeAngles():Forward()*1000000,
			filter = function(ent) 
						if ent ~= self and ent ~= self.Owner then
							return true 
						end
					end,
			mask = MASK_SHOT,
			ignoreworld = false,
		}
		
		local Trace = util.TraceLine(TraceData)
		
		local Base = Trace.HitPos - self:GetPos()
		local Force = Base:GetNormal()
		local Max = 500

		Force.x = math.Clamp(Force.x,-Max,Max)
		Force.y = math.Clamp(Force.y,-Max,Max)
		Force.z = math.Clamp(Force.z,-Max,Max)
		Force = Force + self:GetForward()

		self:GetPhysicsObject():ApplyForceCenter(Force*FrameTime()*self:GetPhysicsObject():GetMass()*100000)
		
	end
end

function ENT:Detonate(pos)
	if SERVER then
	
		if not self:IsValid() then return end
		
		local effectdata = EffectData()
			effectdata:SetStart( pos + Vector(0,0,100)) // not sure if we need a start and origin (endpoint) for this effect, but whatever
			effectdata:SetOrigin( pos)
			effectdata:SetScale( 100 )
			effectdata:SetRadius( 5000 )
		util.Effect( "Explosion", effectdata)

		if self.Owner then
			util.BlastDamage(self, self.Owner, pos, 500, 200)
		end
		
		self:EmitSound("weapons/hegrenade/explode"..math.random(3,5)..".wav",100,100)
		
		if IsValid(self.HitP) then
			self.Pos1 = self.HitP + self.HitN
			self.Pos2 = self.HitP - self.HitN
			util.Decal("Scorch", self.Pos1, self.Pos2)
		end
				
		self:SetNWBool("Detonated",true)
		
		local Phys = self:GetPhysicsObject()
		
		if Phys:IsValid() then
			Phys:EnableMotion(false)
			Phys:EnableCollisions(false)
		end
		
		SafeRemoveEntityDelayed(self,5)
		
	end
end

function ENT:Draw()
	if CLIENT then
		if not self:GetNWBool("Detonated",false) then
			self:DrawModel()
		end
	end
end


