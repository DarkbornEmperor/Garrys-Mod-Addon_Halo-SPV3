AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2016 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.HullType = HULL_MEDIUM
	-- ====Variant Variables==== --
ENT.Model = {"models/hce/spv3/cov/phantom/phantom.mdl"} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want
ENT.StartHealth = 5000 * GetConVarNumber("vj_spv3_HealthModifier")
	-- ====== Blood-Related Variables ====== --
ENT.Bleeds = false-- Does the SNPC bleed? (Blood decal, particle, etc.)
ENT.Immune_Dissolve = true -- Immune to Dissolving | Example: Combine Ball
ENT.GibOnDeathDamagesTable = {"All"} -- Damages that it gibs from | "UseDefault" = Uses default damage types | "All" = Gib from any damage
	-- Relationships ---------------------------------------------------------------------------------------------------------------------------------------------
ENT.HasAllies = true -- Put to false if you want it not to have any allies
ENT.VJ_NPC_Class = {"CLASS_COV"} -- NPCs with the same class with be allied to each other
ENT.ConstantlyFaceEnemy_IfVisible = false -- Should it only face the enemy if it's visible?
ENT.CallForHelpAnimationFaceEnemy = false-- Should it face the enemy when playing the animation?
-- ENT.AnimTbl_WeaponAttackFiringGesture = {} -- Firing Gesture animations used when the SNPC is firing the weapon
-- ENT.AnimTbl_TakingCover = {} -- The animation it plays when hiding in a covered position
ENT.AnimTbl_MoveToCover = {ACT_RUN} -- The animation it plays when moving to a covered position
ENT.AnimTbl_ShootWhileMovingRun = {ACT_RUN} -- Animations it will play when shooting while running | NOTE: Weapon may translate the animation that they see fit!
ENT.AnimTbl_ShootWhileMovingWalk = {ACT_RUN} -- Animations it will play when shooting while walking | NOTE: Weapon may translate the animation that they see fit!
ENT.AnimTbl_WeaponReload = {ACT_ARM} -- Animations that play when the SNPC reloads
ENT.DisableFootStepSoundTimer = true -- If set to true, it will disable the time system for the footstep sound code, allowing you to use other ways like model events
ENT.MovementType = VJ_MOVETYPE_STATIONARY
ENT.Behavior = VJ_BEHAVIOR_PASSIVE_NATURE
ENT.UnitCost = {
	{Name = "grunt_min", Cost = 1},
	{Name = "grunt_maj", Cost = 2},
	{Name = "grunt_spc", Cost = 3},
	{Name = "grunt_ult", Cost = 4},
	{Name = "elite_min", Cost = 7},
	{Name = "elite_maj", Cost = 8},
	{Name = "elite_spc", Cost = 9},
	{Name = "elite_ult", Cost = 10},
	{Name = "elite_zel", Cost = 11},
	{Name = "elite_hg_min", Cost = 12},
	{Name = "elite_hg_maj", Cost = 13},
	{Name = "elite_hg_ult", Cost = 14},
	{Name = "elite_hg_zel", Cost = 15},
	{Name = "brute_min", Cost = 7},
	{Name = "brute_maj", Cost = 8},
	{Name = "brute_ult", Cost = 9},
	{Name = "brute_chf", Cost = 10},
	{Name = "brute_wchf", Cost = 11},
	{Name = "hunter_min", Cost = 9},
	{Name = "hunter_maj", Cost = 10},
	{Name = "hunter_spc", Cost = 11},
	{Name = "jackal_min", Cost = 3},
	{Name = "jackal_maj", Cost = 4},
	{Name = "jackal_spc", Cost = 5},
	{Name = "jackal_mkm_min", Cost = 4},
	{Name = "jackal_mkm_maj", Cost = 5},
	{Name = "jackal_mkm_ult", Cost = 6},
}

ENT.TableSpawns = {}
ENT.AnimTbl_Spawn = {
	"Spawn_1",
	"Spawn_2",
	"Spawn_3",
}

ENT.AnimTbl_Leave = {
	"Leave_1",
	"Leave_2",
	"Leave_3",
}
function ENT:CustomOnPreInitialize()
	self.SpawnAnim = VJ_PICK(self.AnimTbl_Spawn)
	self.LeaveAnim = VJ_PICK(self.AnimTbl_Leave)

	if (GetConVar("vj_spv3_phantomSpawns"):GetInt()!=0) then
		local v = 1
		for k=3, (tonumber(string.sub(GetConVar("vj_spv3_phantomSpawns"):GetString(), 1, 2))*2)+1, 2 do
			self.TableSpawns[v] = self.UnitCost[tonumber(string.sub(tostring(GetConVar("vj_spv3_phantomSpawns"):GetString()), k, k+1))]
			-- PrintMessage(3, tostring(GetConVar("vj_spv3_phantomSpawns"):GetString()))
			-- PrintMessage(3, tostring(string.sub(tostring(GetConVar("vj_spv3_phantomSpawns"):GetString()), k, k+1)))
			v = v + 1
		end
	else
		self.Resource = math.random(GetConVar("vj_spv3_phantomMinReinfStr"):GetInt(), GetConVar("vj_spv3_phantomMaxReinfStr"):GetInt())
		local unit
		local k = 1
		local tries = 0
		while (self.Resource >= GetConVar("vj_spv3_phantomMinUnitStr"):GetInt()) do
			unit = VJ_PICK(self.UnitCost)
			if (unit["Cost"] <= self.Resource and unit["Cost"] <= GetConVar("vj_spv3_phantomMaxUnitStr"):GetInt() and unit["Cost"] >= GetConVar("vj_spv3_phantomMinUnitStr"):GetInt()) then
				self.Resource = self.Resource - unit["Cost"]
				self.TableSpawns[k] = unit
				k = k + 1
			end
		end
	end
end

function ENT:CustomOnInitialize()
	self:SetAngles(Angle(0, math.random(0, 360), 0))
	self:SetSolid(6)
	local trace = util.TraceLine({
		start = self:GetPos(),
		endpos = self:GetPos() + self:GetUp()*-10000,
		filter = self,
	})
	if (trace.Hit) then
		self:SetPos(trace.HitPos + Vector(0,0,math.random(300, 1000)))
	end
	timer.Simple(0.001, function() 	self:VJ_ACT_PLAYACTIVITY(self.SpawnAnim,true,self:SequenceDuration(self:LookupSequence(self.SpawnAnim)),false)	end) --Since June 17th VJ Update, line will not work without a delay
	self:SetCollisionBounds(Vector(-500, -300, -50), Vector(500, 300, 400))
	self.engineSound = CreateSound(self, "phantom/engine_hover.wav")
	self.movingSound = CreateSound(self, "phantom/engine_moving.wav")
	self.hoverSound = CreateSound(self, "phantom/hover (2).wav")
	self.gravSound = CreateSound(self, "phantom/grav_lift.wav")
	self.engineSound:SetSoundLevel(105)
	self.hoverSound:SetSoundLevel(100)
	self.gravSound:SetSoundLevel(85)
	self.movingSound:SetSoundLevel(115)
	self.engineSound:Play()
	self.movingSound:Play()
	self.hoverSound:Play()
	self.gravSound:Play()
	self.movingSound:ChangeVolume(0)
	self.gravSound:ChangeVolume(0)
	self.hoverSound:ChangeVolume(0)
	self.engineSound:ChangeVolume(0)
	local i
	self.turret = {}
	for i=1, 1 do
		self.turret[i] = ents.Create("npc_vj_halo_cov_spv3_phantom_turret")
		self.turret[i]:SetPos(self:GetAttachment(self:LookupAttachment("Cannon"..i))["Pos"])
		self.turret[i]:SetAngles(self:GetAttachment(self:LookupAttachment("Cannon"..i))["Ang"])
		self.turret[i]:SetParent(self, 2)
		self.turret[i]:SetPos(self:GetAttachment(self:LookupAttachment("Cannon"..i))["Pos"])
		self.turret[i]:SetAngles(self:GetAttachment(self:LookupAttachment("Cannon"..i))["Ang"])
		self.turret[i]:SetOwner(self)
		self.turret[i]:Spawn()
		self.turret[i]:SetNoDraw(true)
	end
	timer.Simple(0.3, function()
		if (IsValid(self) and IsValid(self.turret[1])) then
			self:SetNoDraw(false)
			for i=1, 1 do
				self.turret[i]:SetNoDraw(false)
			end
		end
	end)
	timer.Simple(self:SequenceDuration(self:LookupSequence(self.SpawnAnim)), function()
		if (IsValid(self)) then
			self:SpawnCovies()
		end
	end)
end

ENT.covies = {}
ENT.leaving = false
ENT.SpawnedUnits = 1
function ENT:SpawnCovies()
	self.SpawnedUnits = 1
	local nc = nil
	timer.Create("Spawn"..self:GetCreationID(), 2, #self.TableSpawns, function()
		if (IsValid(self)) then
			local covie = ents.Create("npc_vj_halo_cov_spv3_"..self.TableSpawns[self.SpawnedUnits]["Name"])
			covie:SetPos(self:GetAttachment(self:LookupAttachment("Spawn"))["Pos"] + Vector(0,0,50))
			covie:SetAngles(self:GetAngles())
			covie:Spawn()
			nc = constraint.NoCollide(self, covie, 0, 0)
			timer.Simple(1, function()
				if (IsValid(self) and IsValid(covie)) then
					covie:SetVelocity(Vector(math.random(-150, 150),math.random(-150, 150), 0))
					nc:Remove()
				end
			end)	
			
			timer.Simple(2, function() if (IsValid(self) and IsValid(covie)) then covie:VJ_TASK_COVER_FROM_ENEMY()  end end)
			
			if (list.Get("NPC")[covie:GetClass()].Weapons != nil) then
				covie:Give(VJ_PICK(list.Get("NPC")[covie:GetClass()].Weapons))
			end
			self.SpawnedUnits = self.SpawnedUnits + 1
			if (self.SpawnedUnits==(#self.TableSpawns + 1)) then
				self.stickAround = 3
				for i=1, 1 do
					if (IsValid(self.turret[i])) then
						self.stickAround = GetConVar("vj_spv3_phantomAssistTime"):GetInt()
					end
				end
				timer.Simple(self.stickAround, function()
					if (IsValid(self)) then
						self:Leave()
					end
				end)
			end
		end
	end)
end

ENT.IsLeaving = false
function ENT:Leave()
	if (self.IsLeaving==true) then return end
	self.IsLeaving = true
	self:VJ_ACT_PLAYACTIVITY(self.LeaveAnim,true,self:SequenceDuration(self:LookupSequence(self.LeaveAnim)),false)
	self.movingSound:ChangeVolume(0, 5)	
	timer.Simple(self:SequenceDuration(self:LookupSequence(self.LeaveAnim)), function()
		if (IsValid(self)) then
			self:Remove()
		end
	end)
end


function ENT:CustomOnAcceptInput(key,activator,caller,data)
	if key == "Engine_moving"then
		self.hoverSound:ChangeVolume(0, 10)
		self.movingSound:ChangeVolume(1, 10)
		self.engineSound:ChangeVolume(0, 10)
		self.gravSound:ChangeVolume(0, 10)
	elseif key == "Engine_hovering" then
		self.hoverSound:ChangeVolume(1, 10)
		self.movingSound:ChangeVolume(0, 10)
		self.engineSound:ChangeVolume(1, 10)
		self.gravSound:ChangeVolume(1, 10)
	end
end

function ENT:CustomOnRemove()
	self.engineSound:Stop()
	self.hoverSound:Stop()
	self.movingSound:Stop()
	self.gravSound:Stop()
end
ENT.gibTable = {
	"models/gibs/metal_gib5.mdl",
	"models/gibs/metal_gib5.mdl",
	"models/gibs/metal_gib5.mdl",
	"models/combine_helicopter/bomb_debris_3.mdl",
	"models/combine_helicopter/bomb_debris_3.mdl",
	"models/combine_helicopter/bomb_debris_3.mdl",
	"models/gibs/metal_gib5.mdl",
	"models/gibs/metal_gib5.mdl",
	"models/gibs/metal_gib5.mdl",
	"models/combine_helicopter/bomb_debris_3.mdl",
	"models/combine_helicopter/bomb_debris_3.mdl",
	"models/combine_helicopter/bomb_debris_3.mdl",
	"models/gibs/metal_gib5.mdl",
	"models/gibs/metal_gib5.mdl",
	"models/gibs/metal_gib5.mdl",
	"models/combine_helicopter/bomb_debris_3.mdl",
	"models/combine_helicopter/bomb_debris_3.mdl",
	"models/combine_helicopter/bomb_debris_3.mdl",
}
function ENT:SetUpGibesOnDeath(dmginfo, hitgroup)
	util.BlastDamage(self,self,self:GetPos()+ Vector(0,0,self:BoundingRadius()/2 + 10),1000,500) 
	ParticleEffect("", self:LocalToWorld(Vector(0,0,20)), self:GetAngles(), nil)
	for i=1, 10 do
		local effect = EffectData()
		local explosion = self:GetPos() + (self:GetForward()*math.random(-550, 550)) + (self:GetRight()*math.random(-300, 300)) + Vector(0,0,math.random(50, 300))
		effect:SetOrigin(explosion)
		util.Effect("phantomFX", effect) 
	end
	local front = ents.Create("prop_physics")
	front:SetModel("models/hce/spv3/cov/phantom/garbage/front.mdl")
	front:SetPos(self:GetPos() + self:GetForward() * 250)
	front:SetAngles(self:GetAngles())
	front:Spawn()
	front:GetPhysicsObject():SetVelocity(self:GetForward() * math.random(100, 200))
	front:GetPhysicsObject():AddAngleVelocity(Vector(math.random(-100, 100),math.random(-100, 100), math.random(-50, 50)))
	timer.Create("FireFallFXSmall".."front"..self:GetCreationID(), 0.2, 300, function() 
		if (IsValid(front)) then 
			local effect = EffectData()
			effect:SetOrigin(front:GetPos())
			util.Effect("PhantomFXDead", effect)
			end 
		end)
	local left = ents.Create("prop_physics")
	left:SetModel("models/hce/spv3/cov/phantom/garbage/left.mdl")
	left:SetPos(self:GetPos() + self:GetRight() * -240)
	left:SetAngles(self:GetAngles())
	left:Spawn()
	left:GetPhysicsObject():SetVelocity(self:GetRight() * math.random(-100, -200))
	left:GetPhysicsObject():AddAngleVelocity(Vector(math.random(-100, 100),math.random(-100, 100), math.random(-50, 50)))
	timer.Create("FireFallFXSmall".."left"..self:GetCreationID(), 0.2, 300, function() 
		if (IsValid(left)) then 
			local effect = EffectData()
			effect:SetOrigin(left:GetPos())
			util.Effect("PhantomFXDead", effect)
			end 
		end)
	local right = ents.Create("prop_physics")
	right:SetModel("models/hce/spv3/cov/phantom/garbage/right.mdl")
	right:SetPos(self:GetPos() + self:GetRight() * 240)
	right:SetAngles(self:GetAngles())
	right:Spawn()
	right:GetPhysicsObject():SetVelocity(self:GetRight() * math.random(100, 200))
	right:GetPhysicsObject():AddAngleVelocity(Vector(math.random(-100, 100),math.random(-100, 100), math.random(-50, 50)))
	timer.Create("FireFallFXSmall".."right"..self:GetCreationID(), 0.2, 300, function() 
		if (IsValid(right)) then 
			local effect = EffectData()
			effect:SetOrigin(right:GetPos())
			util.Effect("PhantomFXDead", effect)
			end 
		end)
	local back = ents.Create("prop_physics")
	back:SetModel("models/hce/spv3/cov/phantom/garbage/back.mdl")
	back:SetPos(self:GetPos() + self:GetForward() * -250)
	back:SetAngles(self:GetAngles())
	back:Spawn()
	back:GetPhysicsObject():SetVelocity(self:GetForward() * math.random(-100, -200))
	back:GetPhysicsObject():AddAngleVelocity(Vector(math.random(-100, 100),math.random(-100, 100), math.random(-50, 50)))
	timer.Create("FireFallFXSmall".."back"..self:GetCreationID(), 0.2, 300, function() 
		if (IsValid(back)) then 
			local effect = EffectData()
			effect:SetOrigin(back:GetPos())
			util.Effect("PhantomFXDead", effect)
			end 
		end)
	local ent = {}
	for k,v in pairs(self.gibTable) do
			ent[k] = self:CreateGibEntity("obj_vj_sent_gib",self.gibTable[k])
			constraint.NoCollide(ent[k], self, 0, 0)
			constraint.NoCollide(ent[k], front, 0, 0)
			constraint.NoCollide(ent[k], back, 0, 0)
			constraint.NoCollide(ent[k], left, 0, 0)
			constraint.NoCollide(ent[k], right, 0, 0)
			ent[k]:SetPos(self:GetPos() + (self:GetForward()*math.random(-350, 350)) + (self:GetRight()*math.random(-200, 200)) + Vector(0,0,math.random(-150, 250)))
			ent[k]:GetPhysicsObject():AddAngleVelocity(Vector(math.random(-100, 100),math.random(-100, 100), math.random(75, 250)))
			ent[k]:GetPhysicsObject():AddVelocity(Vector(math.random(-1000, 1000),math.random(-1000, 1000), math.random(1000, -400)))
			local effect=EffectData()
			if (GetConVarNumber("vj_sent_useParticles")==1) then timer.Create("FireFallFXSmall"..self:GetCreationID()..k, 0.03, math.random(75, 150), function() 
				if (IsValid(ent[k])) then 
					effect:SetOrigin(ent[k]:GetPos()) 
					util.Effect("fireFallFXSmall", effect)
					end 
				end) 
			end
		end
	return true
end
function ENT:CustomGibOnDeathSounds(dmginfo,hitgroup) 
	self:EmitSound("phantom/phantom_destroyed.ogg", 130)
	return false
end -- returning false will make the default gibbing sounds not play

ENT.IsDead = false

function ENT:CustomOnTakeDamage_BeforeDamage(dmginfo,hitgroup)
	local mins1, maxs1 = self:GetHitBoxBounds(9, 0)
	mins1 = self:LocalToWorld(mins1) - Vector(300, 250, 150)
	maxs1 = self:LocalToWorld(maxs1) + Vector(300, 250, 150)
	local mins2, maxs2 = self:GetHitBoxBounds(10, 0)
	mins2 = self:LocalToWorld(mins2)- Vector(300, 250, 150)
	maxs2 = self:LocalToWorld(maxs2)+ Vector(300, 250, 150)

	if (dmginfo:GetDamageType()==DMG_BLAST) then
		dmginfo:ScaleDamage(3.5)
	end
	-- PrintMessage(3, "Min "..tostring(mins1))
	-- PrintMessage(3, "Damage"..tostring(dmginfo:GetDamagePosition()))
	-- PrintMessage(3, "Max "..tostring(maxs1))
	if (dmginfo:GetDamagePosition():WithinAABox(mins1, maxs1) or dmginfo:GetDamagePosition():WithinAABox(mins2, maxs2)) then
		dmginfo:ScaleDamage(3.5)
		-- PrintMessage(3, tostring("Hit"))
	end
	if (hitgroup==503 and IsValid(self.turret)) then
		self.turret:TakeDamage(5, self, self)
	end
	if ((dmginfo:GetDamage() >= self:Health()) and (self.IsDead==false)) then
		self.IsDead = true
		self:SetHealth(9999)
		self:EmitSound("phantom/phantom_windup.ogg", 130)
		local effect = EffectData()
		effect:SetEntity(self)
		effect:SetOrigin(self:GetPos() + (self:GetForward()*math.random(-350, 350)) + (self:GetRight()*math.random(-200, 200)) + Vector(0,0,math.random(250, 300)))
		util.Effect("phantomFXBurst", effect) 

		timer.Create("miniexplosions"..self:GetCreationID(), 0.25, 2, function()
			if (IsValid(self)) then
				local effect = EffectData()
				local explosionLoc = self:GetPos() + (self:GetForward()*math.random(-350, 350)) + (self:GetRight()*math.random(-200, 200)) + Vector(0,0,math.random(250, 300))
				effect:SetEntity(self)
				effect:SetOrigin(explosionLoc)
				util.Effect("phantomFXBurst", effect) 
				for k=1, 5 do
					local ent = {}
					ent[k] = self:CreateGibEntity("obj_vj_sent_gib",self.gibTable[k])
					constraint.NoCollide(ent[k], self, 0, 0)
					ent[k]:SetPos(explosionLoc)
					ent[k]:GetPhysicsObject():AddAngleVelocity(Vector(math.random(-100, 100),math.random(-100, 100), math.random(75, 250)))
					ent[k]:GetPhysicsObject():AddVelocity(Vector(math.random(-1000, 1000),math.random(-1000, 1000), math.random(-100, 300)))
					local effect=EffectData()
					if (GetConVarNumber("vj_sent_useParticles")==1) then timer.Create("FireFallFXSmall"..self:GetCreationID()..math.random(0,100)..k, 0.03, math.random(75, 150), function() 
						if (IsValid(ent[k])) then 
							effect:SetOrigin(ent[k]:GetPos()) 
							util.Effect("fireFallFXSmall", effect)
							end 
						end) 
					end
				end
			end
		end)
		if (math.random(0,1)==1) then
			self:PhysicsInit(SOLID_VPHYSICS)
			self:GetPhysicsObject():Wake()
		end
		timer.Simple(1.2, function()
			if (IsValid(self)) then
				self:TakeDamage(9999)
			end
		end)
	end
end

function ENT:CreateGibEntity(Ent,Models,Tbl_Features,CustomCode)
	// self:CreateGibEntity("prop_ragdoll","",{Pos=self:LocalToWorld(Vector(0,3,0)),Ang=self:GetAngles(),Vel=})
	if self.AllowedToGib == false then return end
	Ent = Ent or "prop_ragdoll"
	if Models == "UseAlien_Small" then Models = {"models/gibs/xenians/sgib_01.mdl","models/gibs/xenians/sgib_02.mdl","models/gibs/xenians/sgib_03.mdl"} end
	if Models == "UseAlien_Big" then Models = {"models/gibs/xenians/mgib_01.mdl","models/gibs/xenians/mgib_02.mdl","models/gibs/xenians/mgib_03.mdl","models/gibs/xenians/mgib_04.mdl","models/gibs/xenians/mgib_05.mdl","models/gibs/xenians/mgib_06.mdl","models/gibs/xenians/mgib_07.mdl"} end
	if Models == "UseHuman_Small" then Models = {"models/gibs/humans/sgib_01.mdl","models/gibs/humans/sgib_02.mdl","models/gibs/humans/sgib_03.mdl"} end
	if Models == "UseHuman_Big" then Models = {"models/gibs/humans/mgib_01.mdl","models/gibs/humans/mgib_02.mdl","models/gibs/humans/mgib_03.mdl","models/gibs/humans/mgib_04.mdl","models/gibs/humans/mgib_05.mdl","models/gibs/humans/mgib_06.mdl","models/gibs/humans/mgib_07.mdl"} end
	Models = VJ_PICKRANDOMTABLE(Models)
	local vTbl_BloodType = "Red"
	if VJ_HasValue({"models/gibs/xenians/sgib_01.mdl","models/gibs/xenians/sgib_02.mdl","models/gibs/xenians/sgib_03.mdl","models/gibs/xenians/mgib_01.mdl","models/gibs/xenians/mgib_02.mdl","models/gibs/xenians/mgib_03.mdl","models/gibs/xenians/mgib_04.mdl","models/gibs/xenians/mgib_05.mdl","models/gibs/xenians/mgib_06.mdl","models/gibs/xenians/mgib_07.mdl"},Models) then
		vTbl_BloodType = "Yellow"
	end
	vTbl_Features = Tbl_Features or {}
	vTbl_Position = vTbl_Features.Pos or self:GetPos() +self:OBBCenter()
	vTbl_Angle = vTbl_Features.Ang or Angle(math.Rand(-180,180),math.Rand(-180,180),math.Rand(-180,180)) //self:GetAngles()
	vTbl_Velocity_NoDamageForce = vTbl_Features.Vel_NoDmgForce or false -- If set to true, it won't add the damage force to the given velocity
	vTbl_Velocity = vTbl_Features.Vel or Vector(math.Rand(-100,100),math.Rand(-100,100),math.Rand(150,250)) -- Used to set the velocity | "UseDamageForce" = To use the damage's force only
	if self.LatestDmgInfo != nil then
		local dmgforce = self.LatestDmgInfo:GetDamageForce()/70
		if vTbl_Velocity_NoDamageForce == false && vTbl_Features.Vel != "UseDamageForce" then
			vTbl_Velocity = vTbl_Velocity + dmgforce
		end
		if vTbl_Features.Vel == "UseDamageForce" then
			vTbl_Velocity = dmgforce
		end
	end
	vTbl_AngleVelocity = vTbl_Features.AngVel or Vector(math.Rand(-200,200),math.Rand(-200,200),math.Rand(-200,200)) -- Angle velocity, how fast it rotates as it's flying
	vTbl_BloodType = vTbl_Features.BloodType or vTbl_BloodType -- Certain entities such as the VJ Gib entity, you can use this to set its gib type
	vTbl_BloodDecal = vTbl_Features.BloodDecal or "Default" -- The decal it spawns when it collides with something, leave empty to let the base decide
	vTbl_NoFade = vTbl_Features.NoFade or false -- Should it fade away and delete?
	vTbl_RemoveOnCorpseDelete = vTbl_Features.RemoveOnCorpseDelete or false -- Should the entity get removed if the corpse is removed?
	local gib = ents.Create(Ent)
	gib:SetModel(Models)
	gib:SetPos(vTbl_Position)
	gib:SetAngles(vTbl_Angle)
	if gib:GetClass() == "obj_vj_gib" then
		gib.BloodType = vTbl_BloodType
		gib.Collide_Decal = vTbl_BloodDecal
	end
	gib:Spawn()
	gib:Activate()
	gib.IsVJBase_Gib = true
	gib.RemoveOnCorpseDelete = vTbl_RemoveOnCorpseDelete
	if GetConVarNumber("vj_npc_gibcollidable") == 0 then gib:SetCollisionGroup(1) end
	local phys = gib:GetPhysicsObject()
	if IsValid(phys) then
		//phys:SetMass(60)
		phys:AddVelocity(vTbl_Velocity)
		phys:AddAngleVelocity(vTbl_AngleVelocity)
	end
	cleanup.ReplaceEntity(gib)
	if GetConVarNumber("vj_npc_fadegibs") == 1 && vTbl_NoFade == false then
		if gib:GetClass() == "prop_ragdoll" then gib:Fire("FadeAndRemove","",GetConVarNumber("vj_npc_fadegibstime")) end
		if gib:GetClass() == "prop_physics" then gib:Fire("kill","",GetConVarNumber("vj_npc_fadegibstime")) end
	end
	if vTbl_RemoveOnCorpseDelete == true then//self.Corpse:DeleteOnRemove(extraent)
		self.ExtraCorpsesToRemove_Transition[#self.ExtraCorpsesToRemove_Transition+1] = gib
	end
	if (CustomCode) then CustomCode(gib) end
	return gib
end