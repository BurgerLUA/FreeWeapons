ENT.Type = "anim"
ENT.Base = "base_entity"
ENT.PrintName = "PLASMA PROJECTILE"
ENT.Author = ""
ENT.Information = ""
ENT.Spawnable = false
ENT.AdminSpawnable = false 
ENT.RenderGroup = RENDERGROUP_BOTH

AddCSLuaFile()

function ENT:Initialize()

	if SERVER then
	
		local size = 1
		self:SetModel("models/Items/AR2_Grenade.mdl") 
		self:PhysicsInitSphere( size, "wood" )
		self:SetCollisionBounds( Vector( -size, -size, -size ), Vector( size, size, size ) )
		self:SetCollisionGroup(COLLISION_GROUP_PROJECTILE)

		local phys = self:GetPhysicsObject()
		
		if phys:IsValid() then
			phys:Wake()
			phys:SetBuoyancyRatio(0)
			phys:EnableGravity(false)
			phys:EnableDrag(false)
			phys:SetMass(1)
			phys:SetVelocity( self:GetForward()*2000 )
		end
		
	end

	self.SpawnTime = CurTime()
	self.SpawnedTrail = false

end

function ENT:PhysicsCollide(colData,collider)

	local Victim = colData.HitEntity
	
	if Victim and Victim:IsValid() and Victim ~= NULL and Victim:Health() then

		local Damage = DamageInfo()
		
		Damage:SetDamage( 20 )
		Damage:SetDamageType( DMG_CLUB )
		Damage:SetInflictor( self )
		Damage:SetAttacker( self.Owner )

		Victim:TakeDamageInfo(Damage)
	end
	
	collider:EnableMotion(false)
	collider:EnableCollisions(false)
	

	SafeRemoveEntityDelayed(self,0.25)

end

function ENT:Think()
	if SERVER then
		if self.SpawnTime + 0.1 <= CurTime() then
			if not self.SpawnedTrail then
			
				util.SpriteTrail(self, 0, Color(0, 255, 255, 255), false, 8, 0, 0.1, 1, "trails/physbeam.vmt")
			
			
				self.SpawnedTrail = true
			end
		end
	end
end

local mat1 = Material( "sprites/physg_glow1" )

function ENT:Draw()
	if CLIENT then
		self:DrawShadow(false)
	end
end

function ENT:DrawTranslucent()

	if CLIENT then
		cam.Start3D(EyePos(),EyeAngles()) -- Start the 3D function so we can draw onto the screen.
			render.SetMaterial( mat1 ) -- Tell render what material we want, in this case the flash from the gravgun
			render.DrawSprite( self:GetPos(), 8, 8, Color(0,255,255,255)) -- Draw the sprite in the middle of the map, at 16x16 in it's original colour with full alpha.
		cam.End3D()

		local FlashLight = DynamicLight( self:EntIndex() )
		
		if FlashLight then
			local FadeOutTime = 1
			FlashLight.Pos = self:GetPos()
			FlashLight.Size = 256
			FlashLight.DieTime = CurTime() + FadeOutTime*10
			FlashLight.Decay = 1000 / FadeOutTime
			FlashLight.MinLight = 0
			FlashLight.r = 0
			FlashLight.g = 255
			FlashLight.b = 255
		end

		
	end
	
end