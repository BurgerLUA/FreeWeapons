AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()

	self:SetModel("models/weapons/w_slam.mdl") 
	self:PhysicsInit(SOLID_VPHYSICS)
	--self:SetModelScale(0.5)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	--self:SetCollisionGroup(COLLISION_GROUP_NONE)
	self:SetUseType(CONTINUOUS_USE)
	self.Hit = false
	
	
	self.EnableHitPlayers = 1
	
	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:Wake()
		phys:SetBuoyancyRatio(0)
	end
end

function ENT:PhysicsCollide(data, physobj)
	
	if self.Hit then return end

	if data.HitEntity:GetClass() == "worldspawn" or data.HitEntity:GetPhysicsObject():IsValid() or data.HitEntity:GetClass() == "player" then 
		if data.HitEntity:GetClass() == self:GetClass() then return end
		
		self:SetSolid(SOLID_NONE)
	
		self.HitP = data.HitPos
		self.HitN = data.HitNormal
		
		self.armTime = CurTime() + 1
		self.soundVar = 0
	
		self.Hit = true
		physobj:SetAngles(self.HitN:Angle()+Angle(-90,0,0))
		self:EmitSound("weapons/tripwire/hook.wav")
		--self:SetCollisionGroup(COLLISION_GROUP_DEBRIS)

		if data.HitEntity:GetClass() == "worldspawn" then
			physobj:SetPos(self.HitP-self.HitN*2)
	
		elseif data.HitEntity:GetClass() == "prop_physics" then
			physobj:SetPos(self.HitP-self.HitN*2)
			
			timer.Simple(0.1,function()
				--self:SetParent(data.HitEntity)
				if data.HitEntity == nil then return end
				if data.HitEntity:IsValid() == false then return end
				constraint.Weld(self,data.HitEntity,0,0,0,true)
				self.Welded = 1
			end)

			timer.Create("CheckValid"..self:EntIndex(), 0, 0, function()
				if data.HitEntity:IsValid() == false then
					timer.Destroy("CheckValid"..self:EntIndex()) 
				return end
				
				if data.HitEntity:Health() < 0 then 
					--physobj:SetParent(nil) 
					physobj:SetSolid( SOLID_VPHYSICS )
				end
			end)
			
	
		else
			physobj:SetPos(self.HitP+self.HitN*6)
			
			timer.Simple(0.1,function()
				if data.HitEntity:IsValid() == false then return end
				self:SetPos(data.HitPos)
				self:SetParent(data.HitEntity)
				self.Parented = 1
				self.HitEntity = data.HitEntity
			end)
			
			
			timer.Create("CheckValid"..self:EntIndex(), 0, 0, function()
				if data.HitEntity == nil then
					timer.Destroy("CheckValid"..self:EntIndex()) 
					return 
				
				elseif data.HitEntity:IsValid() == false then
					timer.Destroy("CheckValid"..self:EntIndex()) 
					return
				
				elseif data.HitEntity:IsPlayer() and not data.HitEntity:Alive() then
					if self:IsValid() then
						self:Detonate(self,self.HitEntity:GetPos())
						timer.Destroy("CheckValid"..self:EntIndex()) 
					end
				end
				
				
			end)

		end
		
		physobj:EnableMotion(false)
		
		timer.Simple(0.1,function()
			if data.HitEntity:GetClass() ~= "worldspawn" then
				physobj:EnableMotion(true)
			end
		end)
	
	end
	
	
	
	
end



function ENT:Think()

	if not self.FakeOwner:IsValid() then self:Remove() return end
	
	if not self.Hit then return end

	if CurTime() >= self.armTime then
		if self.soundVar == 0 then
			self:EmitSound("weapons/tripwire/mine_activate.wav")
			--print("penis")
			self.soundVar = 1
		end
	else return end

	if not self.FakeOwner:Alive() then self:Detonate(self,self:GetPos()) return end
	
	if self.FakeOwner:GetActiveWeapon():GetClass() == "weapon_bur_c4" and self.FakeOwner:KeyDown( IN_ATTACK2 ) then
		if self.Parented == 1 then
			self:Detonate(self,self.HitEntity:GetPos())
		else
			self:Detonate(self,self:GetPos())
		end
			
	end

end



function ENT:Use( activator, caller )
 
	self:Remove()
 
end


function ENT:OnTakeDamage( dmginfo )
	return dmginfo
end


function ENT:Detonate(self,pos)

	if not self:IsValid() then return end
	local effectdata = EffectData()
	effectdata:SetStart( pos ) // not sure if we need a start and origin (endpoint) for this effect, but whatever
	effectdata:SetOrigin( pos )
	effectdata:SetScale( 1 )
	util.Effect( "Explosion", effectdata )	
	util.BlastDamage(self, self.FakeOwner, pos, 250, 250)
	
	local SphereEnts = ents.FindInSphere(self:GetPos(),250)
	
	if table.Count(SphereEnts) > 0 then
		for k,v in pairs(SphereEnts) do
		
			if v:GetClass() == "prop_physics" then
				timer.Simple(0,function() 
					if v:IsValid() then
						constraint.RemoveAll(v)
						v:GetPhysicsObject():EnableMotion(true)
						v:GetPhysicsObject():Wake()
					end
				 end)
			end
			
			if v:GetClass() == "prop_door_rotating" then
				v:Fire( "Unlock", 0 )
				v:Fire( "Open", 0.1 )
			end
			
		end
	end
					
	self.Pos1 = self.HitP + self.HitN
	self.Pos2 = self.HitP - self.HitN
	util.Decal("Scorch", self.Pos1, self.Pos2)
			
	self:Remove()
end