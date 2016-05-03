include("shared.lua")

function ENT:Initialize()

end

local NextThink = 0
local Mat = Material("sprites/bomb_planted_ring")

function ENT:Draw()	
	self:DrawModel()
	
	if LocalPlayer():GetPos():Distance(self:GetPos()) <= 200 then
		if self:GetVelocity():Length() == 0 then
			render.SetMaterial(Mat)
			render.DrawSprite(self:GetPos() + self:OBBCenter(),5,5, Color(255,0,0,255))
		end
	end
	
	
	
end