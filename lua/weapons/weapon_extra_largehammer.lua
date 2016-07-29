if CLIENT then
	killicon.AddFont( "weapon_hl2_stunstick",	"HL2MPTypeDeath",	"!",	Color( 255, 80, 0, 255 ) )
end

SWEP.Category				= "Extra Weapons"
SWEP.PrintName				= "Reinhardt's Hammer"
SWEP.Base					= "weapon_burger_core_base"
SWEP.WeaponType				= "Melee"

SWEP.Cost					= 0
SWEP.CSSMoveSpeed			= 100

SWEP.Spawnable				= true
SWEP.AdminOnly				= false

SWEP.Slot					= 0
SWEP.SlotPos				= 1

SWEP.ViewModel 				= "models/weapons/c_crowbar.mdl"
SWEP.WorldModel				= "models/weapons/w_crowbar.mdl"
SWEP.DisplayModel			= Model("models/player/ow_reinhardt_hammer_classic.mdl")
SWEP.VModelFlip 			= false
SWEP.HoldType				= "melee2"

SWEP.UseHands				= false

game.AddAmmoType({name = "smod_metal"})

if CLIENT then 
	language.Add("smod_metal_ammo","Metal")
end

SWEP.Primary.Damage			= 250
SWEP.Primary.NumShots		= 1
SWEP.Primary.ClipSize		= -1
SWEP.Primary.SpareClip		= -1
SWEP.Primary.Delay			= 1
SWEP.Primary.Ammo			= "none"
SWEP.Primary.Automatic 		= true 

SWEP.Secondary.Damage		= 0
SWEP.Secondary.NumShots		= 1
SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.SpareClip	= -1
SWEP.Secondary.Delay		= 1
SWEP.Secondary.Ammo			= "none"
SWEP.Secondary.Automatic 	= false 

SWEP.RecoilMul				= 1
SWEP.HasScope 				= false
SWEP.ZoomAmount 			= 1
SWEP.HasCrosshair 			= true
SWEP.HasCSSZoom 			= false

SWEP.HasPumpAction 			= false
SWEP.HasBoltAction 			= false
SWEP.HasBurstFire 			= false
SWEP.HasSilencer 			= false
SWEP.HasDoubleZoom			= false
SWEP.HasSideRecoil			= false

SWEP.MeleeSoundMiss			= Sound("Weapon_Crowbar.Single")
SWEP.MeleeSoundWallHit		= Sound("Flesh.BulletImpact")
SWEP.MeleeSoundFleshSmall	= Sound("Weapon_Crowbar.Melee_Hit")
SWEP.MeleeSoundFleshLarge	= Sound("Weapon_Crowbar.Melee_Hit")

SWEP.IronSightTime			= 0.125
SWEP.IronSightsPos 			= Vector(-10, -10, 5)
SWEP.IronSightsAng 			= Vector(0, 0, -45)

SWEP.AddFOV					= 10

SWEP.EnableBlocking			= false
SWEP.DamageFalloff			= 120
SWEP.MeleeRange				= 120
SWEP.MeleeDamageType		= DMG_CLUB
SWEP.MeleeDelay				= 0.2

SWEP.VElements = {
	["hammer"] = { type = "Model", model = "models/player/ow_reinhardt_hammer_classic.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(2.596, 1.557, -20), angle = Angle(180, 90, 0), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

SWEP.WElements = {
	["hammmer"] = { type = "Model", model = "models/player/ow_reinhardt_hammer_classic.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(8.831, 5.714, -35.845), angle = Angle(180, 90, 0), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

SWEP.ShowViewModel = false
SWEP.ShowWorldModel = false

function SWEP:PrimaryAttack()
	if self:IsUsing() then return end
	if self:GetNextPrimaryFire() > CurTime() then return end
	if self.Owner:KeyDown(IN_ATTACK2) then return end
	self.Owner:SetAnimation(PLAYER_ATTACK1)
	self:SendWeaponAnim(ACT_VM_MISSCENTER)
	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
	self:SetNextSecondaryFire(CurTime() + self.Primary.Delay)
	self:NewSwing(self.Primary.Damage)
end

function SWEP:SpareThink()

	if self.Owner:KeyDown(IN_ATTACK2) then
		self:SetNextPrimaryFire(CurTime() + self.IronSightTime*2)
		self.CSSMoveSpeed				= 240*0.25
	else
		self.CSSMoveSpeed				= 240
	end

	if SERVER then
		if self.Owner:KeyDown(IN_ATTACK2) and self:GetNextSecondaryFire() <= CurTime() then
			self:SetIsBlocking( true )
			self:SetHoldType("melee2")
		else
			self:SetHoldType(self.HoldType)
			self:SetIsBlocking( false )
		end
	end

end


function SWEP:SecondaryAttack()

end

function SWEP:Reload()
	--PrintTable(GetActivities(self))
end

function SWEP:Deploy()
	self.Owner:DrawViewModel(true)
	self:SendWeaponAnim(ACT_VM_DRAW)
	self:SetNextPrimaryFire(CurTime() + self.Owner:GetViewModel():SequenceDuration())	
	self:CheckInventory()
	return true
end

function SWEP:BlockDamage(Damage,Attacker)
	self.Owner:SetAnimation(PLAYER_ATTACK1)
	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay*0.5)
end



hook.Add("CalcView","Large Hammer Calc",function(ply,pos,ang,fov,nearZ,farZ)

	local Weapon = ply:GetActiveWeapon()
	
	if IsValid(Weapon) and Weapon:GetClass() == "weapon_extra_largehammer" then

		local view = {}

		
		
		--PrintTable(Data)
		
		view.drawviewer = true
		view.angles = ang
		view.fov = fov
		local Data = ply:GetAttachment( ply:LookupAttachment( "eyes" ) )
		view.origin = Data.Pos + ang:Forward()*20

		return view
		
	end

	
end)






