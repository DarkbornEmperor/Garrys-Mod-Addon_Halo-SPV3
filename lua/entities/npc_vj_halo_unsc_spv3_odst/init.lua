AddCSLuaFile("shared.lua")
include('shared.lua')
include('entities/npc_vj_halo_unsc_spv3_marine/init.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2016 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.StartHealth = 100
ENT.ShieldMaxHealth = 65
//65 shields
ENT.otherInit = function(entity) 
	entity.Appearance = {
		Color = Color(math.random(0, 255), math.random(0, 255), math.random(0, 255)),
		Bodygroups = {25, 5, 9, 4},
		Skin = entity.Skins[math.random(1, 5)],
	}
end
ENT.ExtraWeapons = {
	"weapon_vj_cov_spv3_bruteshot",
	"weapon_vj_cov_spv3_focusrifle",
	"weapon_vj_cov_spv3_particleCarbine",
}