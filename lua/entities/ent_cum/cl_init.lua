include('shared.lua')

language.Add("ent_mad_grenadelauncher", "Grenade")

/*---------------------------------------------------------
   Name: ENT:Initialize()
---------------------------------------------------------*/

/*---------------------------------------------------------
   Name: ENT:Draw()
---------------------------------------------------------*/
function ENT:Draw()

	self.Entity:DrawModel()
end

/*---------------------------------------------------------
   Name: ENT:Think()
---------------------------------------------------------*/
function ENT:Think()
end

/*---------------------------------------------------------
   Name: ENT:IsTranslucent()
---------------------------------------------------------*/
function ENT:IsTranslucent()

	return true
end


