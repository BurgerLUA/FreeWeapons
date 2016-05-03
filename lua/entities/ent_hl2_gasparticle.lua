ENT.Type = "anim"
ENT.Base = "base_entity"
ENT.PrintName = "GAS"
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
			phys:EnableDrag(true)
			phys:SetMass(1)
		end
		
		SafeRemoveEntityDelayed(self,20)
		
	end
	
	self.SpawnTime = CurTime()
	
end


function ENT:Think()

	if CLIENT then return end

	if self.SpawnTime + 1 <= CurTime() then
	
		local Players = player.GetAll()
		
		for k,v in pairs(Players) do
			if v:GetPos():Distance(self:GetPos()) <= 100 and v:IsLineOfSightClear(self) then
			
				local Damage = 5
				
				if v:Health() <= Damage then
					v:TakeDamage(5,self.Owner,self)
				else
					v:SetHealth(v:Health() - Damage)
				end
				
			end
		end
		
	end
	
	self:NextThink(CurTime() + 1)
	
	return true
	
end

local mat1 = Material( "particle/particle_smokegrenade" )

function ENT:Draw()
	if CLIENT then
		self:DrawShadow(false)
	end
end

function ENT:DrawTranslucent()
	if CLIENT then
	
		local bonus = CurTime() - self.SpawnTime
		
		local r = 0
		local g = 255
		local b = 0
		local a = 255 - (bonus)*0.5*25.5
		
		cam.Start3D(EyePos(),EyeAngles()) -- Start the 3D function so we can draw onto the screen.
			render.SetMaterial( mat1 ) -- Tell render what material we want, in this case the flash from the gravgun
			render.DrawSprite( self:GetPos(), 8 + bonus*50, 8 + bonus*50, Color(r,g,b,a)) -- Draw the sprite in the middle of the map, at 16x16 in it's original colour with full alpha.
		cam.End3D()
	end
end