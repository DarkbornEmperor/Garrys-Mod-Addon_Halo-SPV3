if (!file.Exists("autorun/vj_base_autorun.lua","LUA")) then return end
include('weapons/weapon_vj_spv3_wbase/shared.lua')

SWEP.WorldModel					= "models/hce/spv3/weapons/cov/plasma_pistol/plasmapistol.mdl"
SWEP.Primary.Sound				= {"weapons/plasma pistol/fire/plasmapistol1.wav", "weapons/plasma pistol/fire/plasmapistol2.wav", "weapons/plasma pistol/fire/plasmapistol3.wav", "weapons/plasma pistol/fire/plasmapistol4.wav", "weapons/plasma pistol/fire/plasmapistol5.wav"}
SWEP.ReloadSound = {"weapons/brute shot/reload/reload_full_1.wav", "weapons/brute shot/reload/reload_full_2.wav"}
SWEP.NPC_ReloadSound = SWEP.ReloadSound -- Sounds it plays when the base detects the SNPC playing a reload animation
SWEP.Primary.TracerType 		= "AirboatGunHeavyTracer" -- Tracer type (Examples: AR2)
SWEP.Primary.Damage				= 5
SWEP.Primary.ClipSize			= 6000 -- Max amount of bullets per clip
SWEP.NPC_NextPrimaryFire 		= 1.5 -- Next time it can use primary fire
SWEP.NPC_ExtraShotsPerFire		= 2
SWEP.NPC_CustomSpread 			= 1.25 -- This is added on top of the custom spread that's set inside the SNPC! | Starting from 1: Closer to 0 = better accuracy, Farther than 1 = worse accuracy
SWEP.NPC_TimeUntilFire 			= 0.3 -- How much time until the bullet/projectile is fired?
SWEP.Primary.DisableBulletCode	= true -- The bullet won't spawn, this can be used when creating a projectile-based weapon
SWEP.Primary.Projectile = "obj_vj_spv3_pp_shot"
SWEP.Primary.ProjectileSpeed = 4000
SWEP.PrintName					= "Plasma Pistol"
SWEP.HoldType 					= "pistol"