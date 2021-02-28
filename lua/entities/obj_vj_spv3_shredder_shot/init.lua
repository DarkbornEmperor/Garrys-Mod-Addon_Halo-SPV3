AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2016 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/hce/spv3/misc/needle.mdl"} -- The models it should spawn with | Picks a random one from the table
ENT.DoesRadiusDamage = true -- Should it do a blast damage when it hits something?
ENT.RadiusDamageRadius = 1 -- How far the damage go? The farther away it's from its enemy, the less damage it will do | Counted in world units
ENT.RadiusDamage = 3 -- How much damage should it deal? Remember this is a radius damage, therefore it will do less damage the farther away the entity is from its enemy
ENT.RadiusDamageUseRealisticRadius = true -- Should the damage decrease the farther away the enemy is from the position that the projectile hit?
ENT.RadiusDamageType = DMG_SLASH -- Damage type
ENT.ShakeWorldOnDeath = false -- Should the world shake when the projectile hits something?
ENT.DecalTbl_DeathDecals = {"FadingScorch"}
ENT.SoundTbl_Idle = {""}
ENT.SoundTbl_OnCollide = {"weapons/needler/impact/whistle1.ogg","weapons/needler/impact/whistle2.ogg","weapons/needler/impact/whistle3.ogg","weapons/needler/impact/whistle4.ogg","weapons/needler/impact/whistle5.ogg","weapons/needler/impact/whistle6.ogg",}
ENT.RemoveOnHit = false -- Should it remove itself when it touches something? | It will run the hit sound, place a decal, etc.
ENT.CollideCodeWithoutRemoving = true -- If RemoveOnHit is set to false, you can still make the projectile deal damage, place a decal, etc.


---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
	self.RadiusDamage = self.RadiusDamage * GetConVarNumber("vj_spv3_damageModifier") -- How much damage should it deal? Remember this is a radius damage, therefore it will do less damage the farther away the entity is from its enemy
	//ParticleEffectAttach("hcea_hunter_needler_proj", PATTACH_ABSORIGIN_FOLLOW, self, 0)
	util.SpriteTrail(self, 0, Color(255,50,0), true, 5, 0, 0.35, 0.1, "trails/plasma")
	self:SetColor(Color(255,50,0))
	self.glow = ents.Create("env_sprite")
	self.glow:SetKeyValue("rendermode", "9")
	self.glow:SetKeyValue("renderamt", "255")
	self.glow:SetKeyValue("model","blueflare1_noz.vmt")
	self.glow:SetKeyValue("GlowProxySize","1")
	self.glow:SetKeyValue("rendercolor", "150 0 0")
	self.glow:SetKeyValue("scale","1")
	self.glow:SetPos(self:GetPos())
	self.glow:SetParent(self)
	self.glow:Spawn()
	self.glow:Activate()
	self:DeleteOnRemove(self.glow)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:DeathEffects(data,phys)
	ParticleEffect("hcea_hunter_plasma_rifle_impact",self:GetPos(),Angle(0,0,0),nil)
	self.ExplosionLight1 = ents.Create("light_dynamic")
	self.ExplosionLight1:SetKeyValue("brightness", "4")
	self.ExplosionLight1:SetKeyValue("distance", "100")
	self.ExplosionLight1:SetLocalPos(data.HitPos)
	self.ExplosionLight1:SetLocalAngles(self:GetAngles())
	self.ExplosionLight1:Fire("Color", "173 61 224")
	self.ExplosionLight1:SetParent(self)
	self.ExplosionLight1:Spawn()
	self.ExplosionLight1:Activate()
	self.ExplosionLight1:Fire("TurnOn", "", 0)
	self:DeleteOnRemove(self.ExplosionLight1)
end

ENT.needles = 0
function ENT:CustomOnCollideWithoutRemove(data,phys) 
	for k,v in pairs(ents.FindInSphere(self:GetPos(), 100)) do
		if (v:IsNPC() or v:IsPlayer()) then
			if (v.ShieldCurrentHealth==nil or v.ShieldCurrentHealth<=0) then
				if (v:GetBoneCount()>4) then
					self:SetMoveType(8)
					self:SetCollisionGroup(0)
					self:SetNotSolid(true)
					local closestBone = 0
					local boneDistance = 1000
					self.BonePos, self.BoneAng = v:GetBonePosition(1)
					for i=1, v:GetBoneCount()-1 do
						if (v:GetBonePosition(i):Distance(self:GetPos()) < boneDistance) then
							boneDistance = v:GetBonePosition(i):Distance(self:GetPos())
							closestBone = i
							self.BonePos, self.BoneAng = v:GetBonePosition(closestBone)
						end
					end
					self:SetMoveType(MOVETYPE_NONE)
					self:SetCollisionGroup(0)
					self:SetNotSolid(true)
					if ((closestBone > 1) or (closestBone < v:GetBoneCount()-1)) then
						self.BoneToFollow = closestBone + math.random(-1,1)
					else
						self.BoneToFollow = closestBone
					end
					self.BonePos, self.BoneAng = v:GetBonePosition(self.BoneToFollow)
					self:FollowBone(v, self.BoneToFollow)
					self:SetPos(self.BonePos)
					self:SetAngles(self.BoneAng + Angle(90, 0, 0))
					self:SetVelocity(Vector(0,0,0))
				else
					self:SetParent(v)
					self:SetMoveType(8)
				end
			end
		elseif (v:GetClass()=="obj_vj_spv3_shredder_shot" and IsValid(self:GetParent()) and v:GetParent()==self:GetParent()) then
			self.needles = self.needles + 1
		end
	end
	if (self.needles >= 7) then
		self:EmitSound("weapons/needler/super/superneedleboom.ogg")
		local BlastInfo = DamageInfo()
		BlastInfo:SetDamageType(DMG_BLAST)
		BlastInfo:SetDamage(40 * GetConVarNumber("vj_spv3_damageModifier"))
		BlastInfo:SetDamagePosition(self:GetPos())
		if (IsValid(self:GetOwner())) then
			BlastInfo:SetAttacker(self:GetOwner())
		end
		BlastInfo:SetReportedPosition(self:GetPos())
		util.BlastDamageInfo(BlastInfo, self:GetPos(), 50)
		util.ScreenShake(self:GetPos(),16,100,1,800)
		ParticleEffect("hcea_hunter_shade_cannon_explode_ground", self:LocalToWorld(Vector(0,0,20)), self:GetAngles(), nil)
		for k,v in pairs(ents.FindInSphere(self:GetPos(), 100)) do
			if (v:GetClass()=="obj_vj_spv3_shredder_shot" and v:GetParent()==self:GetParent()) then
				v:Remove()
			end
		end
	end
	timer.Simple(6, function() 
		if (IsValid(self)) then 
			self:Remove() 
			self:EmitSound("weapons/needler/expire/1.ogg") 
			ParticleEffect("hcea_hunter_needler_pistol_impact", self:LocalToWorld(Vector(0,0,0)), self:GetAngles(), nil)
		end 
	end)
	self.targetedEnemy = ""
	if (data.OurOldVelocity:Dot(data.HitNormal) < 900) then phys:SetVelocity((1 * (-2*(data.OurOldVelocity:Dot(data.HitNormal))*data.HitNormal + data.OurOldVelocity)):GetNormalized()*3000) else self:SetMoveType(0) end
end

function ENT:CustomOnThink() 
	self:GetPhysicsObject():SetVelocity(self:GetVelocity():GetNormalized()*3000)
end
/*-----------------------------------------------
	*** Copyright (c) 2012-2016 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/