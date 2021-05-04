AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2016 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.HullType = HULL_MEDIUM_TALL
	-- ====Variant Variables==== --
ENT.Model = {"models/hce/spv3/unsc/pelican/pelicanturret.mdl"} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want
ENT.StartHealth = 500 * GetConVarNumber("vj_spv3_HealthModifier")
	-- ====== Blood-Related Variables ====== --
ENT.Bleeds = false-- Does the SNPC bleed? (Blood decal, particle, etc.)
ENT.Immune_Dissolve = true -- Immune to Dissolving | Example: Combine Ball

	-- Relationships ---------------------------------------------------------------------------------------------------------------------------------------------
ENT.HasAllies = true -- Put to false if you want it not to have any allies
ENT.VJ_NPC_Class = {"CLASS_UNSC", "CLASS_PLAYER_ALLY"} -- NPCs with the same class with be allied to each other
ENT.FriendsWithAllPlayerAllies = true -- Should this SNPC be friends with all other player allies that are running on VJ Base?

-- ENT.AnimTbl_WeaponAttackFiringGesture = {} -- Firing Gesture animations used when the SNPC is firing the weapon
-- ENT.AnimTbl_TakingCover = {} -- The animation it plays when hiding in a covered position
ENT.DisableFootStepSoundTimer = true -- If set to true, it will disable the time system for the footstep sound code, allowing you to use other ways like model events
ENT.MovementType = VJ_MOVETYPE_STATIONARY
ENT.HasRangeAttack = true -- Should the SNPC have a range attack?
ENT.RangeAttackEntityToSpawn = "obj_vj_spv3_shade_cannon" -- The entity that is spawned when range attacking
ENT.RangeAttackReps = 30 -- How many times does it run the projectile code?
ENT.NextRangeAttackTime = 0 -- How much time until it can use a range attack?
ENT.NextAnyAttackTime_Range = 5
ENT.TimeUntilRangeAttackProjectileRelease = 0.1 -- How much time until the projectile code is ran?
ENT.RangeUseAttachmentForPos = true -- Should the projectile spawn on a attachment?
ENT.RangeUseAttachmentForPosID = "muzzle" -- The attachment used on the range attack if RangeUseAttachmentForPos is set to true
ENT.RangeAttackPos_Up = 0 -- Up/Down spawning position for range attack
ENT.RangeAttackPos_Forward = 0 -- Forward/Backward spawning position for range attack
ENT.RangeAttackPos_Right = 0 -- Right/Left spawning position for range attack
ENT.RangeDistance = 5000 -- This is how far away it can shoot
ENT.RangeToMeleeDistance = 0 -- How close does it have to be until it uses melee?
ENT.RangeAttackAngleRadius = 180 -- What is the attack angle radius? | 100 = In front of the SNPC | 180 = All around the SNPC
ENT.DisableDefaultRangeAttackCode = true -- When true, it won't spawn the range attack entity, allowing you to make your own
ENT.RangeAttackSound = {
	"warthog/chain_fire (1).ogg",
	"warthog/chain_fire (2).ogg",
	"warthog/chain_fire (3).ogg",
	"warthog/chain_fire (4).ogg",
	"warthog/chain_fire (5).ogg",
	"warthog/chain_fire (6).ogg",
}
ENT.ConstantlyFaceEnemy = true
ENT.ConstantlyFaceEnemy_IfAttacking = true -- Should it face the enemy when attacking?
ENT.RangeAttackAnimationFaceEnemy = false
ENT.UnreachableByMelee = false
function ENT:CustomOnInitialize()
	self:SetCollisionBounds(Vector(30,30,70), Vector(-30, -30, 10))
	self:SetHullSizeNormal()
	self.eyeLight = ents.Create("env_sprite")
	self.eyeLight:SetParent(self,self:LookupAttachment("Light"))
	self.eyeLight:SetPos(self:GetAttachment(self:LookupAttachment("Light"))["Pos"])
	self.eyeLight:SetKeyValue("rendermode", "9")
	self.eyeLight:SetKeyValue("renderamt", "255")
	self.eyeLight:SetKeyValue("model","blueflare1_noz.vmt")
	self.eyeLight:SetKeyValue("GlowProxySize","3")
	self.eyeLight:SetKeyValue("rendercolor",tostring("0 255 50"))
	self.eyeLight:SetKeyValue("scale", "0.3")
	self.eyeLight:Spawn()
	self.eyeLight:Activate()
	timer.Simple(0.01, function() //Need a small delay or wont work
	if (!IsValid(self:GetParent())) then
		local trace = util.TraceLine({
		start = self:GetPos() + Vector(0,0,30),
		endpos = self:GetPos() + self:GetUp()*1000,
		filter = self,
		ignoreworld = false,
		})
		-- if (trace.HitPos:Distance(self:GetPos()) >= 150) then
		-- end
		if (trace.Hit) then
			self:SetPos(trace.HitPos + Vector(0,0,-70))
		end

		
	end
end)
	
end

function ENT:CustomOn_PoseParameterLookingCode(pitch,yaw,roll) 
	if (IsValid(self:GetEnemy())) then
		self:SetAngles(Angle(self:GetAngles().x, self:GetAimVector():Angle().y, self:GetAngles().z))
	end

end

function ENT:CustomOnTakeDamage_BeforeDamage(dmginfo,hitgroup)
	if (dmginfo:GetDamageType()==DMG_BLAST) then
		dmginfo:ScaleDamage(3.5)
	end
end

function ENT:CustomRangeAttackCode() 
	self:FireBullets({
		Damage = 5 * GetConVarNumber("vj_spv3_DamageModifier"),
		Dir = self:GetAimVector(),
		Src = self:GetPos(),
		Spread = Vector(0.03, 0.03, 0)
	})
	self:EmitSound(VJ_PICKRANDOMTABLE(self.RangeAttackSound), 90)
	ParticleEffectAttach("hcea_hunter_plasma_rifle_fire", PATTACH_POINT_FOLLOW, self, self:LookupAttachment("muzzle"))
end