if CLIENT then
	killicon.AddFont( "weapon_cs_smg",		"HL2MPTypeDeath",	"/",	Color( 255, 80, 0, 255 ) )
	SWEP.WepSelectIcon 		= surface.GetTextureID("vgui/gfx/vgui/mp5")
end

SWEP.Category				= "Extra Weapons"
SWEP.PrintName				= "GAS GUN"
SWEP.Base					= "weapon_cs_base"
SWEP.WeaponType				= "Primary"

SWEP.Spawnable				= true
SWEP.AdminOnly				= false

SWEP.Slot					= 2
SWEP.SlotPos				= 1

SWEP.ViewModel 				= "models/weapons/c_smg1.mdl"
SWEP.WorldModel				= "models/weapons/w_smg1.mdl"
SWEP.VModelFlip 			= false
SWEP.HoldType				= "smg"

game.AddAmmoType({name = "ex_gas"})

if CLIENT then 
	language.Add("ex_gas_ammo","Gas")
end

SWEP.Primary.Damage			= 10
SWEP.Primary.NumShots		= 1
SWEP.Primary.Sound			= Sound("weapons/smg1/smg1_fire1.wav")
SWEP.Primary.Cone			= .0025
SWEP.Primary.ClipSize		= -1
SWEP.Primary.SpareClip		= 50
SWEP.Primary.Delay			= 0.1
SWEP.Primary.Ammo			= "ex_gas"
SWEP.Primary.Automatic 		= true
--SWEP.ReloadSound			= Sound("weapons/smg1/smg1_reload.wav")
--SWEP.BurstSound				= Sound("weapons/smg1/smg1_fireburst1.wav")

SWEP.RecoilMul				= 1
SWEP.SideRecoilMul			= 0.25
SWEP.VelConeMul				= 1.25
SWEP.HeatMul				= 0.5

SWEP.BurstConeMul			= 0.5
SWEP.BurstRecoilMul			= 0.5

SWEP.HasScope 				= false
SWEP.ZoomAmount 			= 0.25
SWEP.HasCrosshair 			= true
SWEP.HasCSSZoom 			= false

SWEP.HasPumpAction 			= false
SWEP.HasBoltAction 			= false
SWEP.HasBurstFire 			= false
SWEP.HasSilencer 			= false
SWEP.HasDoubleZoom			= false
SWEP.HasSideRecoil			= true
SWEP.HasDownRecoil			= false
SWEP.HasDryFire				= false

SWEP.Object					= "ent_cs_gasparticle"

SWEP.HasIronSights 			= false
SWEP.EnableIronCross		= true
SWEP.HasGoodSights			= true
SWEP.IronSightTime			= 0.25
SWEP.IronSightsPos 			= Vector(-6.43, 0, 0)
SWEP.IronSightsAng 			= Vector(0, 0, 0)

SWEP.DamageFalloff			= 1000

function SWEP:PrimaryAttack()

	if not self:CanPrimaryAttack() then	return end
	if self:IsBusy() then return end
	if self:GetNextPrimaryFire() > CurTime() then return end
	
	if self.Owner:GetAmmoCount(self.Primary.Ammo) < 1 then return end
	self:TakePrimaryAmmo(1)
	--self.Owner:SetAnimation(PLAYER_ATTACK1)
	--self:WeaponAnimation(self:Clip1(),ACT_VM_SECONDARYATTACK)

	if (IsFirstTimePredicted() or game.SinglePlayer()) then
		if (CLIENT or game.SinglePlayer()) then 
			self:AddRecoil() -- Predict
		end

		self:ThrowObject(self.Object,200)
		
		--self:EmitGunSound(self.Primary.Sound)
	end
	
	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
	
end
