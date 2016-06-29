if CLIENT then
	killicon.AddFont( "weapon_hl2_stunstick",	"HL2MPTypeDeath",	"!",	Color( 255, 80, 0, 255 ) )
end

SWEP.Category				= "Extra Weapons"
SWEP.PrintName				= "STUNSTICK"
SWEP.Base					= "weapon_cs_base"
SWEP.WeaponType				= "Free"

SWEP.Cost					= 0
SWEP.CSSMoveSpeed				= 240

SWEP.Spawnable				= true
SWEP.AdminOnly				= false

SWEP.Slot					= 0
SWEP.SlotPos				= 1

SWEP.ViewModel 				= "models/weapons/c_stunstick.mdl"
SWEP.WorldModel				= "models/weapons/w_stunbaton.mdl"
SWEP.VModelFlip 			= false
SWEP.HoldType				= "melee"

game.AddAmmoType({name = "smod_metal"})

if CLIENT then 
	language.Add("smod_metal_ammo","Metal")
end

SWEP.Primary.Damage			= 75
SWEP.Primary.NumShots		= 1
SWEP.Primary.ClipSize		= 100
SWEP.Primary.SpareClip		= 0
SWEP.Primary.Delay			= 0.6
SWEP.Primary.Ammo			= "smod_weeb"
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
SWEP.HasCrosshair 			= false
SWEP.HasCSSZoom 			= false

SWEP.HasPumpAction 			= false
SWEP.HasBoltAction 			= false
SWEP.HasBurstFire 			= false
SWEP.HasSilencer 			= false
SWEP.HasDoubleZoom			= false
SWEP.HasSideRecoil			= false

SWEP.MeleeSoundMiss			= Sound("Weapon_StunStick.Melee_Miss")
SWEP.MeleeSoundWallHit		= Sound("Weapon_StunStick.Melee_HitWorld")
SWEP.MeleeSoundFleshSmall	= Sound("Weapon_StunStick.Melee_Hit")
SWEP.MeleeSoundFleshLarge	= Sound("Weapon_StunStick.Melee_Hit")

SWEP.IronSightTime			= 0.125
SWEP.IronSightsPos 			= Vector(-10, -10, 5)
SWEP.IronSightsAng 			= Vector(0, 0, -45)

SWEP.AddFOV					= 10

SWEP.DamageFalloff			= 1000

SWEP.EnableBlocking			= true

function SWEP:PrimaryAttack()
	if self:IsUsing() then return end
	if self:GetNextPrimaryFire() > CurTime() then return end
	if self.Owner:KeyDown(IN_ATTACK2) then return end
	self.Owner:SetAnimation(PLAYER_ATTACK1)
	self:SendWeaponAnim(ACT_VM_HITCENTER)
	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
	self:SetNextSecondaryFire(CurTime() + self.Primary.Delay)
	if self:NewSwing(self.Primary.Damage*0.75 + (self.Primary.Damage*0.25*self:Clip1()*0.01) ) then
		self:AddDurability(-math.random(1,3))
	end
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

function SWEP:AddDurability(amount)

	self:SetClip1( math.Clamp(self:Clip1() + amount,0,100) )

	if self:Clip1() <= 0 then
		self.Owner:EmitSound("physics/metal/sawblade_stick1.wav")
		if self and SERVER then
			self.Owner:StripWeapon(self:GetClass())
		end
	end
	
end

function SWEP:Deploy()

	self:EmitGunSound(Sound("Weapon_SMODSword.Deploy"))
	self.Owner:DrawViewModel(true)
	self:SendWeaponAnim(ACT_VM_DRAW)
	self:SetNextPrimaryFire(CurTime() + self.Owner:GetViewModel():SequenceDuration())	
	
	return true
end

function SWEP:BlockDamage(Damage)
	self.Owner:SetAnimation(PLAYER_ATTACK1)
	self:SendWeaponAnim(ACT_VM_HITCENTER)
	self:EmitGunSound(self.MeleeSoundMiss)
	self.Owner:EmitSound(Sound("AlyxEMP.Discharge"))
	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay*0.5)
	--self:SetNextSecondaryFire(CurTime() + self.Primary.Delay*0.25)
	self:AddDurability( -math.random(1,3) )
end

function SHIELD_ScalePlayerDamage(victim,hitgroup,dmginfo)
	--[[
	local attacker = dmginfo:GetAttacker()
	local Weapon = victim:GetActiveWeapon()
	local Damage = dmginfo:GetDamage()
	local WeaponAttacker = dmginfo:GetInflictor()

	if Weapon and Weapon ~= NULL and Weapon:GetClass() == "weapon_ex_swordandshield" then
	
		local VictimKeyDown = Weapon:GetIsBlocking()
		
		local ShouldProceed = true
		
		if attacker:IsPlayer() and attacker:GetActiveWeapon() and attacker:GetActiveWeapon():IsValid() then
			WeaponAttacker = attacker:GetActiveWeapon()
			
			if WeaponAttacker:IsScripted() and (WeaponAttacker.Base == "weapon_cs_base" or WeaponAttacker.BurgerBase) then
				if WeaponAttacker.Primary.NumShots > 1 then
					ShouldProceed = false
				end
			end
		end
	
		if ShouldProceed and VictimKeyDown and Weapon:GetNextSecondaryFire() <= CurTime() then
		
			if (hitgroup == HITGROUP_LEFTLEG or hitgroup == HITGROUP_RIGHTLEG) then

			else
			
				local VictimAngles = victim:GetAngles() + Angle(0,180,0)
				local AttackerAngles = attacker:GetAngles()
				VictimAngles:Normalize()
				AttackerAngles:Normalize()
				local NewAngles = VictimAngles - AttackerAngles
				NewAngles:Normalize()
				local Yaw = math.abs(NewAngles.y)
				
				if Yaw < 45 then
					Weapon:BlockDamage(Damage)
					return true
				end
				
			end
			
		end
	end
	--]]
end

hook.Add("ScalePlayerDamage","SHIELD_ScalePlayerDamage",SHIELD_ScalePlayerDamage)






