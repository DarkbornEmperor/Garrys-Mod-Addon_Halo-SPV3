AddCSLuaFile("shared.lua")
include('shared.lua')
include('entities/npc_vj_halo_cov_spv3_elite_hg_min/init.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2016 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.modelColor = Color(255,191,0)
ENT.bodyGroupTable = {
	3,
	2,
	2,
	3,
}
ENT.StartHealth = 100
ENT.ShieldMaxHealth = 450
ENT.ExtraShotCount = 4
ENT.WeaponProfficiency = 100
ENT.Skin = 3
ENT.HasSword = true