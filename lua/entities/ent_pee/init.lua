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
			
	local Victim = data.HitEntity

	if Victim:GetClass() == self:GetClass() then 
		return
	end
	
	if data.Speed > 50 then
		self.Entity:EmitSound("ambient/water/rain_drip3.wav")
	end
			
	if Victim:IsPlayer() and Victim:Team() == self.Owner:Team() and Victim:Team() ~= 1001 then
		Victim:SetHealth( math.Clamp(Victim:Health() + 1,1,Victim:GetMaxHealth()) )
	elseif data.HitEntity:IsPlayer() or data.HitEntity:IsNPC() then
		data.HitEntity:TakeDamage( 2 , self.Owner , self.Entity )
	end

	local Pos1 = data.HitPos + data.HitNormal
	local Pos2 = data.HitPos - data.HitNormal
	util.Decal("BeerSplash", Pos1, Pos2)
		
	local effectdata = EffectData()
	effectdata:SetStart( data.HitPos )
	effectdata:SetOrigin( data.HitPos )
	effectdata:SetScale( 0.1 )
	util.Effect( "StriderBlood", effectdata )	
		
	ParticleEffect( "slime_splash_01_droplets", data.HitPos, data.HitNormal:Angle( ) )
	
	self:GetPhysicsObject():EnableMotion(false)
	SafeRemoveEntityDelayed(self,1)
	
end
