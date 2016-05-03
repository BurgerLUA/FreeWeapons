if CLIENT then
	killicon.AddFont( "weapon_cs_crowbar",		"HL2MPTypeDeath",	"6",	Color( 255, 80, 0, 255 ) )
	SWEP.WepSelectIcon 		= surface.GetTextureID("vgui/achievements/pistol_round_knife_kill")
end

SWEP.Category				= "Extra Weapons"
SWEP.PrintName				= "CROWBAR"
SWEP.Base					= "weapon_cs_base"
SWEP.WeaponType				= "Free"

SWEP.Cost					= 0
SWEP.MoveSpeed				= 250

SWEP.Spawnable				= true
SWEP.AdminOnly				= false

SWEP.Slot					= 0
SWEP.SlotPos				= 1

SWEP.ViewModel 				= "models/weapons/c_crowbar.mdl"
SWEP.WorldModel				= "models/weapons/w_crowbar.mdl"
SWEP.VModelFlip 			= false
SWEP.HoldType				= "melee"

SWEP.Primary.Damage			= 20
SWEP.Primary.NumShots		= 1
SWEP.Primary.ClipSize		= -1
SWEP.Primary.SpareClip		= -1
SWEP.Primary.Delay			= 1/(240/60)
SWEP.Primary.Ammo			= "none"
SWEP.Primary.Automatic 		= true 

SWEP.Secondary.Damage		= 40
SWEP.Secondary.NumShots		= 1
SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.SpareClip	= -1
SWEP.Secondary.Delay		= 1/(120/60)
SWEP.Secondary.Ammo			= "none"
SWEP.Secondary.Automatic 	= true 

SWEP.RecoilMul				= 1
SWEP.HasScope 				= false
SWEP.ZoomAmount 			= 1
SWEP.HasCrosshair 			= false
SWEP.HasCSSZoom 			= false

SWEP.HasPumpAction 			= false
SWEP.HasBoltAction 			= false
SWEP.HasBurstFire 			= false
SWEP.HasSilencer 			= false
SWEP.HasDoubleZoom			= false
SWEP.HasSideRecoil			= false

SWEP.MeleeSoundMiss			= Sound("weapons/iceaxe/iceaxe_swing1.wav")
SWEP.MeleeSoundWallHit		= Sound("physics/concrete/concrete_impact_bullet1.wav")
SWEP.MeleeSoundFleshSmall	= Sound("physics/flesh/flesh_impact_bullet1.wav")
SWEP.MeleeSoundFleshLarge	= Sound("physics/flesh/flesh_bloody_break.wav")

function SWEP:PrimaryAttack()
	if self:IsUsing() then return end
	self.Owner:SetAnimation(PLAYER_ATTACK1)
	self:SendWeaponAnim(ACT_VM_HITCENTER)
	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
	self:SetNextSecondaryFire(CurTime() + self.Primary.Delay)
	
	if self:NewSwing(self.Primary.Damage) then
		self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
		self:SetNextSecondaryFire(CurTime() + self.Primary.Delay)
	else
		self:SetNextPrimaryFire(CurTime() + self.Primary.Delay*2)
		self:SetNextSecondaryFire(CurTime() + self.Primary.Delay*2)
	end
	
end

function SWEP:SecondaryAttack()

	if self:IsUsing() then return end
	self.Owner:SetAnimation(PLAYER_ATTACK1)
	self:SendWeaponAnim(ACT_VM_MISSCENTER)
	self:SetNextPrimaryFire(CurTime() + self.Secondary.Delay)
	self:SetNextSecondaryFire(CurTime() + self.Secondary.Delay)
	
	if self:NewSwing(self.Secondary.Damage) then
		self:SetNextPrimaryFire(CurTime() + self.Secondary.Delay)
		self:SetNextSecondaryFire(CurTime() + self.Secondary.Delay)
	else
		self:SetNextPrimaryFire(CurTime() + self.Secondary.Delay*2)
		self:SetNextSecondaryFire(CurTime() + self.Secondary.Delay*2)
	end
	
end

function SWEP:Reload()
	--PrintTable(GetActivities(self))
end

function SWEP:Deploy()
	self.Owner:DrawViewModel(true)
	self:SendWeaponAnim(ACT_VM_DRAW)
	self:SetNextPrimaryFire(CurTime() + self.Owner:GetViewModel():SequenceDuration())	
	return true
end



