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
	
		self:SetModel("models/dav0r/hoverball.mdl") 
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
		
		local phys = self:GetPhysicsObject()
		
		if phys:IsValid() then
			phys:Wake()
			phys:SetBuoyancyRatio(0)
			phys:EnableGravity(true)
			phys:AddAngleVelocity( VectorRand()*100 )
		end
		
		self.Ammo = 30
		self.NextFire = 0
		
		util.SpriteTrail( self, 0, Color(0,0,255,255), false, 32,0,1, 32, "trails/laser.vmt" )

	end
end

function ENT:PhysicsCollide(data, physobj)
	if SERVER then
	
		self.HitP = data.HitPos
		self.HitN = data.HitNormal
		
		if data.HitEntity:IsWorld() then
			if not self:GetNWBool("Armed",false) then 
				self:Arm()
			end
		end
		
	end
end

function ENT:OnTakeDamage(damageinfo)
	self:Detonate(self:GetPos())
end

function ENT:FreeFire()
	if self.NextFire <= CurTime() then
			
		if self:GetNWBool("Armed",false) and not self:GetNWBool("Detonated",false) then
			if self.Ammo > 0 then
				self:FireBullet(self.Owner:EyeAngles())
			end
		end
		
		self.NextFire = CurTime() + 0.1
		
	end
end

function ENT:Think()
	if SERVER then
	
		if self.NextFire <= CurTime() then
			if self:GetNWBool("Armed",false) and not self:GetNWBool("Detonated",false) then
				if self.Ammo > 0 then
		
					local Target = self:FindTarget()

					if IsValid(Target) then

						local TargetPos = Target:GetPos() + Target:OBBCenter()
						local Angles = (TargetPos - self:GetPos()):Angle()
						
						self:FireBullet(Angles)
						
					end

				else		
					if not self:GetNWBool("Detonated",false) then
						self:Detonate(self:GetPos())
					end
				end

			end
		
			self.NextFire = CurTime() + 0.33

		end

	end
end

function ENT:FireBullet(ang)
		
	local Cone = 0
	local Damage = 5

	local PhysBullet = ents.Create("ent_cs_bullet")
	PhysBullet:SetPos(self:GetPos() + ang:Forward()*10 )
	PhysBullet:SetAngles( ang + Angle(math.Rand(-Cone,Cone)*45,math.Rand(-Cone,Cone)*45,0) )
	PhysBullet:SetColor(Color(0,0,255,255))
	PhysBullet:Spawn()
	PhysBullet:SetNWFloat("Damage",Damage)
	PhysBullet:SetOwner(self.Owner or self)
	
	self.Ammo = self.Ammo - 1
	self:EmitSound("weapons/ar2/ar2_altfire.wav")
		
end

function ENT:FindTarget()

	local Targets = {}


	for k,v in pairs(player.GetAll()) do
		if v:IsLineOfSightClear( self ) and v ~= self.Owner and v:Alive() then
			Targets[v] = -v:GetPos():Distance(self:GetPos())
		end
	end

	if table.Count(Targets) > 0 then
	
		local Winner = table.GetWinningKey(Targets)
		local Winner = table.GetWinningKey(Targets)
	
		if math.abs(Targets[Winner]) < 500 then
			return Winner
		end	

	end
end

function ENT:Arm()

	self:SetNWBool("Armed",true)
	
	local Phys = self:GetPhysicsObject()
	
	if IsValid(Phys) then
		Phys:EnableMotion(false)
	end

	self.NextFire = CurTime() + 1

end

function ENT:Detonate(pos)
	if SERVER then
	
		if not self:IsValid() then return end
		
		self:SetCollisionGroup(COLLISION_GROUP_WORLD)
		
		self:SetNWBool("Detonated",true)
		
		local Phys = self:GetPhysicsObject()
		
		if Phys:IsValid() then
			Phys:EnableMotion(false)
			Phys:EnableCollisions(false)
		end
		
		SafeRemoveEntityDelayed(self,1)
		
	end
end

function ENT:Draw()
	if CLIENT then
		if not self:GetNWBool("Detonated",false) then
			self:DrawModel()
		end
	end
end