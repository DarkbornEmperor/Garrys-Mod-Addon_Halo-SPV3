AddCSLuaFile("shared.lua")
include('shared.lua')
include('entities/npc_vj_halo_cov_spv3_elite_min/init.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2016 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.modelColor = Color(255,191,0)
ENT.bodyGroupTable = {
	0,
	2,
	2,
	2,
}
ENT.StartHealth = 60
ENT.ShieldHealth = 150
ENT.ExtraShotCount = 3
ENT.HasSword = true
ENT.Skin = 3