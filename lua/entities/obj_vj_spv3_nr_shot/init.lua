AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2016 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/hce/spv3/misc/needle.mdl"} -- The models it should spawn with | Picks a random one from the table
ENT.DoesRadiusDamage = false -- Should it do a blast damage when it hits something?
ENT.RadiusDamageRadius = 0 -- How far the damage go? The farther away it's from its enemy, the less damage it will do | Counted in world units
ENT.RadiusDamage = 0 -- How much damage should it deal? Remember this is a radius damage, therefore it will do less damage the farther away the entity is from its enemy
ENT.RadiusDamageUseRealisticRadius = true -- Should the damage decrease the farther away the enemy is from the position that the projectile hit?
ENT.RadiusDamageType = DMG_BURN -- Damage type
ENT.ShakeWorldOnDeath = false -- Should the world shake when the projectile hits something?
ENT.DecalTbl_DeathDecals = {"FadingScorch"}
ENT.SoundTbl_Idle = {""}
ENT.SoundTbl_OnCollide = {"weapons/needler/impact/whistle1.ogg","weapons/needler/impact/whistle2.ogg","weapons/needler/impact/whistle3.ogg","weapons/needler/impact/whistle4.ogg","weapons/needler/impact/whistle5.ogg","weapons/needler/impact/whistle6.ogg",}
ENT.RemoveOnHit = false -- Should it remove itself when it touches something? | It will run the hit sound, place a decal, etc.
ENT.CollideCodeWithoutRemoving = true -- If RemoveOnHit is set to false, you can still make the projectile deal damage, place a decal, etc.
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
	self.RadiusDamage = self.RadiusDamage * GetConVarNumber("vj_spv3_damageModifier") -- How much damage should it deal? Remember this is a radius damage, therefore it will do less damage the farther away the entity is from its enemy
	-- ParticleEffectAttach("hcea_hunter_needler_proj", PATTACH_ABSORIGIN_FOLLOW, self, 0)
	util.SpriteTrail(self, 0, Color(255,0,255), true, 5, 0, 0.35, 0.1, "trails/plasma")
	self.glow = ents.Create("env_sprite")
	self.glow:SetKeyValue("rendermode", "9")
	self.glow:SetKeyValue("renderamt", "255")
	self.glow:SetKeyValue("model","blueflare1_noz.vmt")
	self.glow:SetKeyValue("GlowProxySize","1")
	self.glow:SetKeyValue("rendercolor", "150 0 150")
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
ENT.stopTracking = false
function ENT:CustomOnCollideWithoutRemove(data,phys) 
	if (data.HitEntity:IsNPC() or data.HitEntity:IsPlayer()) then
		if (data.HitEntity:GetBoneCount() > 0) then
			local closestBone
			for i=0, data.HitEntity:GetBoneCount()-1 do
				if (closestBone == nil or data.HitEntity:GetBonePosition(i):Distance(self:GetPos()) < data.HitEntity:GetBonePosition(closestBone):Distance(self:GetPos())) then
					closestBone = i
				end
			end
			closestBone = math.Clamp(closestBone + math.random(-1, 1), 0, data.HitEntity:GetBoneCount()-1)
			self:SetMoveType(MOVETYPE_NONE)
			self:FollowBone(data.HitEntity, closestBone)
			self:SetPos(select(1, data.HitEntity:GetBonePosition(closestBone)))
			self:SetAngles(select(2, data.HitEntity:GetBonePosition(closestBone)) + Angle(90, 0, 0))
			self:SetVelocity(Vector(0,0,0))
		else
			self:SetParent(data.HitEntity)
			self:SetMoveType(8)
		end
		self:SetSolid(0)
		if (data.HitEntity.needles==nil) then
			data.HitEntity.needles = {}
		end
		table.insert(data.HitEntity.needles, self)
	end
	if ((data.HitEntity:IsNPC() or data.HitEntity:IsPlayer()) and #data.HitEntity.needles <= 7) then
		for i,j in pairs(ents.FindInSphere(self:GetPos(), 100)) do
			if (j:GetClass()=="obj_vj_spv3_nr_shot" and j:GetParent()==self:GetParent()) then
				timer.Adjust("Needles"..j:GetCreationID(), 1.5, nil, nil)
			end
		end
	end
	if (!(timer.Exists("Needles"..self:GetCreationID()))) then
		timer.Create("Needles"..self:GetCreationID(), 1.5, 1, function()
			if IsValid(self) then
				if ((data.HitEntity:IsNPC() or data.HitEntity:IsPlayer()) and #data.HitEntity.needles >= 7) then
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
					for i,j in pairs(data.HitEntity.needles) do
						if IsValid(j) then
							j:Remove()
						end
					end
					table.Empty(data.HitEntity.needles)
				elseif (data.HitEntity.needles == nil or #data.HitEntity.needles < 7) then
					if (data.HitEntity:IsNPC() or data.HitEntity:IsPlayer()) then
						data.HitEntity:TakeDamage(10 * GetConVarNumber("vj_spv3_damageModifier"), self:GetOwner(), self:GetOwner())
						table.remove(data.HitEntity.needles)
					end
					self:Remove()
					self:EmitSound("weapons/needler/expire/1.ogg") 
					ParticleEffect("hcea_hunter_needler_pistol_impact", self:LocalToWorld(Vector(0,0,0)), self:GetAngles(), nil)
				end
			end
		end)
	end
	if ((data.HitEntity:IsNPC() or data.HitEntity:IsPlayer()) and #data.HitEntity.needles >= 7) then
		if (data.HitEntity.Berserked!=nil and data.HitEntity.Berserked!=true and math.random(0, 1)==1) then
			data.HitEntity:Berserk()
		else
			if (data.HitEntity.SoundTbl_Stuck) then
				data.HitEntity:EmitSound(VJ_PICKRANDOMTABLE(data.HitEntity.SoundTbl_Stuck))
			end
			if (data.HitEntity:LookupSequence("Transform")!=-1) then
				data.HitEntity:VJ_ACT_PLAYACTIVITY("Transform", true, 4, false)
			end
		end
	end
	self.stopTracking=true
	if (data.OurOldVelocity:Dot(data.HitNormal) >= 900) then self:SetMoveType(0) end
end


function ENT:CustomOnThink()
	self:GetPhysicsObject():SetVelocity(self:GetVelocity():GetNormalized()*1000)	
	if (!IsValid(self:GetParent()) and self:GetMoveType()!=0) then self:SetAngles(self:GetVelocity():Angle()) end
	if (!IsValid(self.targetedEnemy)) then return end
	if (IsValid(self) and self.stopTracking==false and self.targetedEnemy) then
		if (self.targetedEnemy:IsPlayer()) then
			self:GetPhysicsObject():AddVelocity(self.targetedEnemy:GetVelocity()/(self:GetPos():Distance(self.targetedEnemy:GetPos()) * 0.005)) //There's probably a better way to do this that's less taxing
		elseif (self.targetedEnemy:IsNPC()) then
			self:GetPhysicsObject():AddVelocity(self.targetedEnemy:GetGroundSpeedVelocity()/(self:GetPos():Distance(self.targetedEnemy:GetPos()) * 0.006)) //There's probably a better way to do this that's less taxing
		end	
	end
end
/*-----------------------------------------------
	*** Copyright (c) 2012-2016 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/