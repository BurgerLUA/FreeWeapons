AddCSLuaFile()

SWEP.PrintName			= "MODIFIED MEDKIT"
SWEP.Author				= "robotboy655 & MaxOfS2D"
SWEP.Purpose    		= "Heal people with your primary attack, or yourself with the secondary."
SWEP.Category 			= "Extra Weapons"
SWEP.WeaponType			= "Free"


SWEP.Base				= "weapon_cs_base"


SWEP.MoveSpeed			= 200

SWEP.Spawnable			= true
SWEP.UseHands			= true

SWEP.ViewModel			= "models/weapons/c_medkit.mdl"
SWEP.WorldModel			= "models/weapons/w_medkit.mdl"

SWEP.ViewModelFOV		= 54
SWEP.Slot				= 0
SWEP.SlotPos			= 1

game.AddAmmoType({name = "medical"})

if CLIENT then 
	language.Add("medical_ammo","Medical Supplies")
end

SWEP.Primary.Damage			= 10
SWEP.Primary.NumShots		= 1
SWEP.Primary.Sound			= Sound("weapons/357/357_fire2.wav")
SWEP.Primary.Cone			= 0.01
SWEP.Primary.ClipSize		= -1
SWEP.Primary.SpareClip		= 50
SWEP.Primary.Delay			= 1
SWEP.Primary.Ammo			= "medical"
SWEP.Primary.Automatic 		= true

SWEP.Secondary.Delay		= 1
SWEP.Secondary.Automatic	= true

SWEP.RecoilMul				= 1
SWEP.SideRecoilMul			= 1
SWEP.VelConeMul				= 0.1
SWEP.HeatMul				= 1

SWEP.HasScope 				= false
SWEP.ZoomAmount 			= 1
SWEP.HasCrosshair			= true
SWEP.HasCSSZoom 			= false

SWEP.HasPumpAction 			= false
SWEP.HasBoltAction 			= false
SWEP.HasBurstFire 			= false
SWEP.HasSilencer 			= false
SWEP.HasDoubleZoom			= false
SWEP.HasSideRecoil			= false
SWEP.HasDryFire				= false

SWEP.HasIronSights 			= true
SWEP.EnableIronCross		= true
SWEP.HasGoodSights			= true
SWEP.IronSightTime			= 1
SWEP.IronSightsPos 			= Vector(0,0,0)
SWEP.IronSightsAng 			= Vector(0,0,0)

local HealSound = Sound( "items/smallmedkit1.wav" )
local DenySound = Sound( "items/medshotno1.wav" )

function SWEP:PrimaryAttack()

	self:Animation()
	
	if CLIENT then return end

	if IsFirstTimePredicted() then
		local tr = util.TraceLine( {
			start = self.Owner:GetShootPos(),
			endpos = self.Owner:GetShootPos() + self.Owner:GetAimVector() * 64,
			filter = self.Owner
		} )

		local target = tr.Entity
		self:HealTarget(target)
	end
	
end

function SWEP:SecondaryAttack()

	self:Animation()
	
	if CLIENT then return end
	
	if IsFirstTimePredicted() then
		self:HealTarget(self.Owner)
	end
	
end

function SWEP:Animation()
	self.Owner:SetAnimation( PLAYER_ATTACK1 )
	self:SendWeaponAnim( ACT_VM_PRIMARYATTACK )
	self:SetNextPrimaryFire( CurTime() + self:SequenceDuration() )
	self:SetNextSecondaryFire( CurTime() + self:SequenceDuration() )
end


function SWEP:CanHeal(target)
	return ( IsValid( target ) && self:Ammo1() ~= 0 && target:Health() < target:GetMaxHealth() )
end

function SWEP:HealTarget(target)

	if self:CanHeal(target) then
	
		local DesiredHeal = math.Clamp(target:GetMaxHealth() - target:Health(),0, math.min(10,self:Ammo1()))
		
		self:TakePrimaryAmmo( DesiredHeal )

		target:SetHealth( target:Health() + DesiredHeal )
		target:EmitSound( HealSound )
		
	else
		self.Owner:EmitSound( DenySound )
	end


end