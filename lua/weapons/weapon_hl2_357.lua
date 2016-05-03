if CLIENT then
	killicon.AddFont( "weapon_cs_357",			"HL2MPTypeDeath",	".",	Color( 255, 80, 0, 255 ) )
	killicon.AddFont( "ent_cs_crossbow_bolt",		"HL2MPTypeDeath",	"1",	Color( 255, 80, 0, 255 ) )
	killicon.AddFont( "ent_cs_combine_ball",	"HL2MPTypeDeath",	"8",	Color( 255, 80, 0, 255 ) )
	killicon.AddFont( "ent_cs_smg1_grenade",		"HL2MPTypeDeath",	"7",	Color( 255, 80, 0, 255 ) )
	killicon.AddFont( "weapon_cs_stunstick",	"HL2MPTypeDeath",	"!",	Color( 255, 80, 0, 255 ) )
end

SWEP.Category				= "Extra Weapons"
SWEP.PrintName				= ".357"
SWEP.Base					= "weapon_cs_base"
SWEP.WeaponType				= "Secondary"

SWEP.Spawnable				= true
SWEP.AdminOnly				= false

SWEP.Slot					= 1
SWEP.SlotPos				= 1

SWEP.ViewModel 				= "models/weapons/c_357.mdl"
SWEP.WorldModel				= "models/weapons/w_357.mdl"
SWEP.VModelFlip 			= false
SWEP.HoldType				= "revolver"

SWEP.Primary.Damage			= 100
SWEP.Primary.NumShots		= 1
SWEP.Primary.Sound			= Sound("weapons/357/357_fire2.wav")
SWEP.Primary.Cone			= 0.002
SWEP.Primary.ClipSize		= 6
SWEP.Primary.SpareClip		= 36
SWEP.Primary.Delay			= 1/(90/60)
SWEP.Primary.Ammo			= "357"
SWEP.Primary.Automatic 		= false

SWEP.RecoilMul				= 0.5
SWEP.SideRecoilMul			= 0.5
SWEP.VelConeMul				= 2
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

SWEP.BurstOverride			= 6
SWEP.BurstConeMul			= 10

SWEP.HasIronSights 			= true
SWEP.EnableIronCross		= true
SWEP.HasGoodSights			= true
SWEP.IronSightTime			= 0.25
SWEP.IronSightsPos 			= Vector(-4, 4, 0)
SWEP.IronSightsAng 			= Vector(0, 0, 0)

SWEP.DamageFalloff			= 800