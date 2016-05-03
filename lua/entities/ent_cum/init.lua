AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')

/*---------------------------------------------------------
   Name: ENT:Initialize()
---------------------------------------------------------*/
function ENT:Initialize()

	--self.Owner = self.Entity:GetOwner()

	if !IsValid(self.Owner) then
		self:Remove()
		return
	end

	self.Entity:SetModel("models/hunter/plates/plate.mdl")
	self:SetMaterial("Models/effects/vol_light001")
	self:PhysicsInitSphere(1)
	self.Entity:SetMoveType(MOVETYPE_VPHYSICS)
	self.Entity:SetSolid(SOLID_VPHYSICS)
	self.Entity:DrawShadow(false)
	self:GetPhysicsObject():EnableGravity( true )
	
	local phys = self.Entity:GetPhysicsObject()

end

function ENT:Think()
	if self.Entity:WaterLevel() > 2 then
		self.Entity:Remove()
	end
end

function ENT:PhysicsCollide(data, physobj)		

	if data.Speed > 50 then
		self.Entity:EmitSound("physics/flesh/flesh_squishy_impact_hard4.wav",100,100)
	end
			
	local Pos1 = data.HitPos + data.HitNormal
	local Pos2 = data.HitPos - data.HitNormal
	util.Decal("PaintSplatBlue", Pos1, Pos2)
	
	if (data.HitEntity):IsPlayer() or data.HitEntity:IsNPC() then
		local ent = ents.Create("prop_physics") -- This creates our zombie entity
		ent:SetModel("models/props_c17/doll01.mdl")
		ent:SetPos(data.HitPos) -- This positions the zombie at the place our trace hit.
		ent:Spawn()
		ent:EmitSound("ambient/creatures/teddy.wav", 100, 100)
		--SafeRemoveEntityDelayed(ent,10)
		data.HitEntity:TakeDamage( 50 , self.Owner , self.Entity )
	end
		
	SafeRemoveEntity(self)
	
end
