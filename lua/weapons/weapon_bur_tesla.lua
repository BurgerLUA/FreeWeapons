AddCSLuaFile()

SWEP.PrintName			= "TESLA TURRET"			
SWEP.Author				= "Burger"
SWEP.Instructions		= "Left Click to throw c4, right click to detonate."

SWEP.Spawnable 			= true
SWEP.AdminOnly 			= false

SWEP.Weight				= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false
SWEP.Category				= "Extra Weapons"

SWEP.Slot				= 4
SWEP.SlotPos			= 1
SWEP.DrawAmmo			= false
SWEP.DrawCrosshair		= true

SWEP.ViewModel			= "models/weapons/c_arms_citizen.mdl"
SWEP.WorldModel			= ""
SWEP.HoldType 			= "normal"

game.AddAmmoType({name = "bur_tesla_ball"})

if CLIENT then 
	language.Add("bur_tesla_ball_ammo","Tesla Ball")
end

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= 3
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "bur_tesla_ball"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= true
SWEP.Secondary.Ammo			= "none"

if CLIENT then
	killicon.AddFont( "ent_cs_tesla", "HL2MPTypeDeath", "!", Color( 255, 200, 0, 255 ) )
end

function SWEP:PrimaryAttack()
	
	if ( CLIENT ) then return end
	
	
	self.Weapon:SetNextPrimaryFire( CurTime() + 0.75 )	
	
	if self.Owner:GetAmmoCount(self.Primary.Ammo) <= 0 then return end
	
	
	local Exists = false
	
	for k, v in pairs(ents.FindByClass("ent_cs_tesla")) do
		if v:GetOwner() == self.Owner then
			Exists = true
		end
	end
	
	if Exists then
		self.Owner:ChatPrint("Only 1 tesla turret can be deployed at a time.")
	return end
		
	self:TakePrimaryAmmo(1)

	if self  == nil then return end
	if self:IsValid() == false then return end
	if self.Owner == nil then return end
	if self.Owner:IsValid() == false then return end
	if self.Owner:Alive() == false then return end
	
	local ent = ents.Create( "ent_cs_tesla" )
	EA =  self.Owner:EyeAngles()
	pos = self.Owner:GetShootPos()
	pos = pos + EA:Right() * 5 - EA:Up() * 4 + EA:Forward() * 8
				
	ent:SetPos(pos)
	ent:SetAngles(EA + Angle(-90,0,0))
	ent:Spawn()
	ent:Activate()
	ent:SetOwner(self.Owner)
	ent:GetPhysicsObject():SetVelocity(self.Owner:GetVelocity() + EA:Forward() * 500 + EA:Up()*100)

end
 

function SWEP:SecondaryAttack()
	if SERVER then
		for k, v in pairs(ents.FindByClass("ent_cs_tesla")) do
			if v:GetOwner() == self.Owner then
				v:FreeFire()
			end
		end
	end
end


function SWEP:Reload()
	if SERVER then
		for k, v in pairs(ents.FindByClass("ent_cs_tesla")) do
			if v:GetOwner() == self.Owner then
				v:Detonate(v:GetPos())
			end
		end
	end
end