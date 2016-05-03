if CLIENT then
	killicon.AddFont( "weapon_cs_ar2",			"HL2MPTypeDeath",	"2",	Color( 255, 80, 0, 255 ) )
	SWEP.WepSelectIcon 		= surface.GetTextureID("vgui/gfx/vgui/sg552")
end

SWEP.Category				= "Extra Weapons"
SWEP.PrintName				= "CROSSBOW"
SWEP.Base					= "weapon_cs_base"
SWEP.WeaponType				= "Primary"

SWEP.Cost					= 3500
SWEP.MoveSpeed				= 230

SWEP.Spawnable				= true
SWEP.AdminOnly				= false

SWEP.Slot					= 3
SWEP.SlotPos				= 1

SWEP.ViewModel 				= "models/weapons/c_crossbow.mdl"
SWEP.WorldModel				= "models/weapons/w_crossbow.mdl"
SWEP.VModelFlip 			= false
SWEP.HoldType				= "crossbow"

SWEP.Primary.Damage			= 100
SWEP.Primary.NumShots		= 1
SWEP.Primary.Sound			= Sound("weapons/crossbow/fire1.wav")
SWEP.Primary.Cone			= 0
SWEP.Primary.ClipSize		= -1
SWEP.Primary.SpareClip		= 6
SWEP.Primary.Delay			= 1/(30/60)
SWEP.Primary.Ammo			= "XBowBolt"
SWEP.Primary.Automatic 		= false

SWEP.RecoilMul				= 0.1
SWEP.SideRecoilMul			= 0
SWEP.VelConeMul				= 0
SWEP.HeatMul				= 0

SWEP.HasScope 				= true
SWEP.ZoomAmount 			= 7
SWEP.HasCrosshair 			= true
SWEP.HasCSSZoom 			= true

SWEP.HasPumpAction 			= false
SWEP.HasBoltAction 			= true
SWEP.HasBurstFire 			= false
SWEP.HasSilencer 			= false
SWEP.HasDoubleZoom			= false
SWEP.HasSideRecoil			= false
SWEP.HasDryFire				= false

SWEP.HasIronSights 			= false
SWEP.EnableIronCross		= false
SWEP.HasGoodSights			= false
SWEP.IronSightTime			= 0
SWEP.IronSightsPos 			= Vector(0, 0, 0)
SWEP.IronSightsAng 			= Vector(0, 0, 0)

function SWEP:ShootBullet(Damage,Shots,Cone,Source,Direction,Source)
	self:ThrowObject("crossbow_bolt",4000)
	self:SendWeaponAnim(ACT_VM_RELOAD)
	self.Owner:SetAnimation(PLAYER_RELOAD)
	self.Owner:EmitSound("weapons/crossbow/reload1.wav")
end