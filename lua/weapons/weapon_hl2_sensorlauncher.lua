SWEP.Category				= "Extra Weapons"
SWEP.PrintName				= "SENSOR LAUNCHER"
SWEP.Base					= "weapon_cs_base"
SWEP.WeaponType				= "Primary"

SWEP.Cost					= 2000
SWEP.MoveSpeed				= 200

SWEP.Spawnable				= true
SWEP.AdminOnly				= false

SWEP.Slot					= 2
SWEP.SlotPos				= 2

SWEP.ViewModel				= "models/weapons/c_shotgun.mdl"
SWEP.WorldModel				= "models/weapons/w_shotgun.mdl"
SWEP.VModelFlip 			= false
SWEP.HoldType				= "shotgun"

SWEP.Primary.Damage			= 100
SWEP.Primary.NumShots		= 1
SWEP.Primary.Sound			= Sound("weapons/ar2/npc_ar2_altfire.wav")
SWEP.Primary.Cone			= 0.01
SWEP.Primary.ClipSize		= 1
SWEP.Primary.SpareClip		= 2
SWEP.Primary.Delay			= 0.25
SWEP.Primary.Ammo			= "bur_sensor"
SWEP.Primary.Automatic 		= false

SWEP.ReloadSound = Sound("weapons/shotgun/shotgun_reload3.wav")

SWEP.RecoilMul				= 1
SWEP.VelConeMul				= 2

SWEP.HasScope 				= true
SWEP.ZoomAmount 			= 8
SWEP.HasCrosshair 			= true
SWEP.HasCSSZoom 			= true

SWEP.HasPumpAction 			= true
SWEP.HasBoltAction 			= false
SWEP.HasBurstFire 			= false
SWEP.HasSilencer 			= false
SWEP.HasDoubleZoom			= false
SWEP.HasSideRecoil			= false

SWEP.IsReloading = false
SWEP.ReloadDelay = 0

SWEP.HasHL2Pump				= true

SWEP.PumpSound				= Sound("weapons/shotgun/shotgun_cock.wav")

game.AddAmmoType({
	name = "bur_sensor",
	dmgtype = DMG_BULLET,
	tracer = TRACER_LINE_AND_WHIZ
})

if CLIENT then
	language.Add("bur_sensor_ammo","Wall Sensor")
end

SWEP.FuckBots = true

SWEP.BulletEnt				= "ent_bur_sensor"
SWEP.SourceOverride			= Vector(2,0,-6)
SWEP.BulletAngOffset		= Angle(0 - 1,0,0)
