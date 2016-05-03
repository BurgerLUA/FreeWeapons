if CLIENT then
	killicon.AddFont( "weapon_cs_pistol",		"HL2MPTypeDeath",	"-",	Color( 255, 80, 0, 255 ) )
	SWEP.WepSelectIcon 		= surface.GetTextureID("vgui/gfx/vgui/usp45")
end

SWEP.Category				= "Extra Weapons"
SWEP.PrintName				= "PISTOL"
SWEP.Base					= "weapon_cs_base"
SWEP.WeaponType				= "Secondary"

SWEP.Spawnable				= true
SWEP.AdminOnly				= false

SWEP.Slot					= 1
SWEP.SlotPos				= 1

SWEP.ViewModel 				= "models/weapons/c_pistol.mdl"
SWEP.WorldModel				= "models/weapons/w_pistol.mdl"
SWEP.VModelFlip 			= false
SWEP.HoldType				= "revolver"

SWEP.Primary.Damage			= 25
SWEP.Primary.NumShots 		= 1
SWEP.Primary.Sound			= Sound("weapons/pistol/pistol_fire2.wav")
SWEP.Primary.Cone			= 0.01
SWEP.Primary.ClipSize		= 18
SWEP.Primary.SpareClip		= 150
SWEP.Primary.Delay			= 1/(700/60)
SWEP.Primary.Ammo			= "pistol"
SWEP.Primary.Automatic 		= true
SWEP.ReloadSound			= Sound("weapons/pistol/pistol_reload1.wav")

SWEP.RecoilMul				= 1
SWEP.SideRecoilMul			= 0.25
SWEP.VelConeMul				= 1
SWEP.HeatMul				= 1.5

SWEP.BurstOverride			= 3
SWEP.BurstConeMul			= 0.1
SWEP.BurstSpeedOverride 	= 1
SWEP.BurstHeatMul			= 0.5

SWEP.HasScope 				= false
SWEP.ZoomAmount 			= 0.75
SWEP.HasCrosshair 			= true
SWEP.HasCSSZoom 			= false

SWEP.HasPumpAction 			= false
SWEP.HasBoltAction 			= false
SWEP.HasBurstFire 			= true
SWEP.HasSilencer 			= false
SWEP.HasDoubleZoom			= false
SWEP.HasSideRecoil			= true
SWEP.HasDownRecoil			= false
SWEP.HasDryFire				= false

SWEP.HasIronSights 			= true
SWEP.EnableIronCross		= true
SWEP.HasGoodSights			= true
SWEP.IronSightTime			= 0.25
SWEP.IronSightsPos 			= Vector(0, 20, 0)
SWEP.IronSightsAng 			= Vector(0, 5, -45)

SWEP.DamageFalloff			= 1000