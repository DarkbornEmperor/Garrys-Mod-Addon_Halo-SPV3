$include "kigyar_shared.qci"
$modelname "hce\spv3\cov\jackal\Jackal.mdl"

$bodygroup "mybody"
{
	studio "Main_Body.smd"
}
$bodygroup "Shield"
{
	blank
	studio "Shield_Active_test2.smd"
}
$bodygroup "Head"
{
	studio "Head_Minor.smd"
	studio "Head_Major.smd"
	studio "Head_Sniper.smd"
}

$surfaceprop "flesh"

$jointsurfaceprop "frame shield" "no_decal"

$contents "solid"

$illumposition -1.732 -1.612 39.856

$cdmaterials "models\hce\spv3\cov\jackal\"

$attachment "Cannon" "frame gun" 6 0 -1.5 rotate -15 0 0
$attachment "Eyelight" "bip01 head" 3 10 2.5 rotate 0 0 0
$cbox 0 0 0 0 0 0

$bbox -28.687 -28.613 -0.56 31.912 25.149 80.271

// .qc block generated by HLMV begins.

$surfaceprop "flesh"
$jointsurfaceprop "frame shield"	 "no_decal"

$hboxset "shielded"
$hbox 500 "bip01 pelvis"	    -8.26   -6.58   -8.49     8.55    5.69    8.58
$hbox 500 "frame backleftflap"	    -2.45   -3.55  -11.15     1.33    3.23    0.00
$hbox 500 "frame backrightflap"	    -2.47   -3.09  -11.15     1.28    3.68    0.00
$hbox 501 "bip01 l thigh"	    -2.31   -5.41   -4.29    19.26    5.59    3.38
$hbox 501 "bip01 l horselink"	    -3.33   -6.19   -3.84    16.34    4.58    3.98
$hbox 501 "bip01 l foot"	     0.00   -5.49   -4.61     6.66   10.23    4.54
$hbox 502 "bip01 r thigh"	    -2.35   -5.46   -3.38    19.23    5.53    4.24
$hbox 503 "bip01 r horselink"	    -3.35   -6.25   -4.13    16.33    4.54    3.69
$hbox 503 "bip01 r foot"	     0.00   -5.57   -4.53     6.66   10.16    4.62
$hbox 500 "bip01 spine"	     0.00   -5.97   -5.83     7.04    5.69    5.94
$hbox 500 "bip01 spine1"	    -2.50   -7.38   -7.46    12.50    7.62    7.54
$hbox 504 "bip01 l upperarm"	    -4.18   -2.50   -2.50    18.13    2.50    2.50
$hbox 505 "bip01 l forearm"	    -2.02   -2.50   -2.50    18.94    2.50    2.50
$hbox 505 "bip01 l hand"	    -0.50   -1.93   -4.12    10.29    2.90    2.89
$hbox 506 "bip01 head"	    -3.00   -4.84   -3.50     7.00   12.16    3.50
$hbox 507 "bip01 r upperarm"	    -2.72   -2.29   -2.33    12.28    2.71    2.67
$hbox 508 "bip01 r forearm"	    -0.56   -2.50   -2.50    18.56    2.50    2.50
$hbox 508 "bip01 r hand"	    -0.56   -1.84   -3.36     9.21    2.99    3.63
$hbox 500 "frame frontcenterflap"	    -0.36   -3.08  -12.31     2.26    3.11    0.00
$hbox 509 "frame shield"	    -5.84  -13.49  -28.56     3.84   13.51   28.41
$hbox 509 "frame shield"	    -5.50  -20.00    2.50     3.50   20.00   27.50
$hbox 509 "frame shield"	    -5.50  -20.00  -29.50     3.50   20.00   -4.50

$hboxset "noShield"
$hbox 500 "bip01 pelvis"	    -8.26   -6.58   -8.49     8.55    5.69    8.58
$hbox 500 "frame backleftflap"	    -2.45   -3.55  -11.15     1.33    3.23    0.00
$hbox 500 "frame backrightflap"	    -2.47   -3.09  -11.15     1.28    3.68    0.00
$hbox 501 "bip01 l thigh"	    -2.31   -5.41   -4.29    19.26    5.59    3.38
$hbox 501 "bip01 l horselink"	    -3.33   -6.19   -3.84    16.34    4.58    3.98
$hbox 501 "bip01 l foot"	     0.00   -5.49   -4.61     6.66   10.23    4.54
$hbox 502 "bip01 r thigh"	    -2.35   -5.46   -3.38    19.23    5.53    4.24
$hbox 503 "bip01 r horselink"	    -3.35   -6.25   -4.13    16.33    4.54    3.69
$hbox 503 "bip01 r foot"	     0.00   -5.57   -4.53     6.66   10.16    4.62
$hbox 500 "bip01 spine"	     0.00   -5.97   -5.83     7.04    5.69    5.94
$hbox 500 "bip01 spine1"	    -2.50   -7.38   -7.46    12.50    7.62    7.54
$hbox 504 "bip01 l upperarm"	    -4.18   -2.50   -2.50    18.13    2.50    2.50
$hbox 505 "bip01 l forearm"	    -2.02   -2.50   -2.50    18.94    2.50    2.50
$hbox 505 "bip01 l hand"	    -0.50   -1.93   -4.12    10.29    2.90    2.89
$hbox 506 "bip01 head"	    -3.00   -4.84   -3.50     7.00   12.16    3.50
$hbox 507 "bip01 r upperarm"	    -2.72   -2.29   -2.33    12.28    2.71    2.67
$hbox 508 "bip01 r forearm"	    -0.56   -2.50   -2.50    18.56    2.50    2.50
$hbox 508 "bip01 r hand"	    -0.56   -1.84   -3.36     9.21    2.99    3.63
$hbox 500 "frame frontcenterflap"	    -0.36   -3.08  -12.31     2.26    3.11    0.00

$definebone "bip01 pelvis" "" 0 -0.053168 37.582687 -89.999982 -89.575588 0 0 0 0 0 0 0
$definebone "frame backleftflap" "bip01 pelvis" 0.071983 -4.982962 4.524538 0.000057 90.000037 89.999811 0 0 0 0 0 0
$definebone "frame backrightflap" "bip01 pelvis" 0.072006 -4.982973 -4.487082 0.000057 90.000037 89.999811 0 0 0 0 0 0
$definebone "bip01 l thigh" "bip01 pelvis" -0.000004 0.000007 5.276073 0.972122 156.70376 -178.487856 0 0 0 0 0 0
$definebone "bip01 l calf" "bip01 l thigh" 16.475706 0.000002 -0.000003 0 -85.933526 0 0 0 0 0 0 0
$definebone "bip01 l horselink" "bip01 l calf" 9.87651 0 0.000002 0 81.519865 0 0 0 0 0 0 0
$definebone "bip01 l foot" "bip01 l horselink" 12.250146 -0.000001 0 0.309913 -18.400082 -1.770669 0 0 0 0 0 0
$definebone "bip01 r thigh" "bip01 pelvis" 0.000004 -0.000007 -5.276085 -0.97189 156.70376 178.48791 0 0 0 0 0 0
$definebone "bip01 r calf" "bip01 r thigh" 16.475708 0 0.000001 0 -85.933526 0 0 0 0 0 0 0
$definebone "bip01 r horselink" "bip01 r calf" 9.876509 -0.000002 -0.000001 0 81.519865 0 0 0 0 0 0 0
$definebone "bip01 r foot" "bip01 r horselink" 12.250146 0.000001 0.000001 -0.309913 -18.400086 1.770669 0 0 0 0 0 0
$definebone "bip01 spine" "bip01 pelvis" 3.034599 -0.537279 0.000003 -0.000057 0.045607 -0.000229 0 0 0 0 0 0
$definebone "bip01 spine1" "bip01 spine" 7.03759 -0.011695 0 0 3.999933 0 0 0 0 0 0 0
$definebone "bip01 l clavicle" "bip01 spine1" 14.723339 -0.000005 2.182273 -60.528576 165.554319 16.431799 0 0 0 0 0 0
$definebone "bip01 l upperarm" "bip01 l clavicle" 8.37705 0 -0.000004 14.558748 10.508103 -5.798791 0 0 0 0 0 0
$definebone "bip01 l forearm" "bip01 l upperarm" 12.272678 0 -0.000008 0.000003 -7.959185 -0.000002 0 0 0 0 0 0
$definebone "bip01 l hand" "bip01 l forearm" 17.026556 -0.000001 -0.000011 14.500075 0.000001 -89.954377 0 0 0 0 0 0
$definebone "bip01 neck" "bip01 spine1" 14.726204 -0.00144 -0.000001 -0.000057 63.999959 -0.000057 0 0 0 0 0 0
$definebone "bip01 head" "bip01 neck" 4.122566 0.000011 0 0.000172 -78.045669 -0.000115 0 0 0 0 0 0
$definebone "bip01 ponytail1" "bip01 head" -0.183929 0.357525 -0.000007 -0.000172 98.480727 -0.000344 0 0 0 0 0 0
$definebone "bip01 ponytail2" "bip01 head" 4.628872 -1.664246 0.2392 0.001146 -37.517611 0.001662 0 0 0 0 0 0
$definebone "bip01 r clavicle" "bip01 spine1" 14.723343 0.000007 -2.182276 60.528522 165.553991 -16.432199 0 0 0 0 0 0
$definebone "bip01 r upperarm" "bip01 r clavicle" 8.37705 -0.000001 -0.000011 -14.558738 10.508102 5.798792 0 0 0 0 0 0
$definebone "bip01 r forearm" "bip01 r upperarm" 12.272682 -0.000001 -0.000011 0.000003 -7.959184 0.000002 0 0 0 0 0 0
$definebone "bip01 r hand" "bip01 r forearm" 17.026558 -0.000007 -0.000027 -14.50007 0.000002 89.954384 0 0 0 0 0 0
$definebone "frame shield" "bip01 r forearm" 11.835348 0.236645 -0.452496 -0.002118 -89.050476 -178.236518 0 0 0 0 0 0
$definebone "frame frontcenterflap" "bip01 pelvis" 0.624001 5.685968 -0.000013 0.000057 90.000037 89.999811 0 0 0 0 0 0
$definebone "frame gun" "bip01 l hand" 10.291614 -0.421692 -3.459959 -8.569387 -9.704756 178.874554 -5 0 -4.5 0 0 0

$animation "wF" "jackal_anims\wF.smd" {
	fps 30
	loop
	cmdlist wF_ik
	walkframe 23 LX LY
}

$animation "EvadeL" "jackal_anims\EvadeL.smd" {
	fps 30
	walkframe 44 LX LY
}

$animation "EvadeR" "jackal_anims\EvadeR.smd" {
	fps 30
	walkframe 49 LX LY
}

$sequence "Run" {
	"wB"
	"wR"
	"wF"
	"wL"
	"wB"
	activity "ACT_RUN" 1
	blend "move_yaw" -180 180
	blendwidth 5
	loop
	{ event 1100 1 "Step" }
	{ event 1100 12 "Step" }
	fadein 0.2
	fadeout 0.2
}

$sequence "EvadeLeft" {
	"EvadeL"
	activity "ACT_SIGNAL1" 1
	blend "move_yaw" -180 180
	{ event 1100 0 "EvadeL" }
	fadein 0.2
	fadeout 0.2
}

$sequence "EvadeRight" {
	"EvadeR"
	activity "ACT_SIGNAL2" 1
	blend "move_yaw" -180 180
	{ event 1100 0 "EvadeR" }
	fadein 0.2
	fadeout 0.2
}

$collisionjoints "jackal_physics.smd"
{
	$mass 90
	$inertia 10
	$damping 0.01
	$rotdamping 1.5
	$rootbone "bip01 pelvis"


	$jointconstrain "bip01 l thigh" x limit -30 30 0
	$jointconstrain "bip01 l thigh" y limit -10 60 0
	$jointconstrain "bip01 l thigh" z limit -70 70 0

	$jointconstrain "bip01 l calf" x limit 0 0 0
	$jointconstrain "bip01 l calf" y limit 0 0 0
	$jointconstrain "bip01 l calf" z limit -40 40 0

	$jointconstrain "bip01 l horselink" x limit 0 0 0
	$jointconstrain "bip01 l horselink" y limit 0 0 0
	$jointconstrain "bip01 l horselink" z limit -40 40 0

	$jointconstrain "bip01 r thigh" x limit -30 30 0
	$jointconstrain "bip01 r thigh" y limit -60 10 0
	$jointconstrain "bip01 r thigh" z limit -70 70 0

	$jointconstrain "bip01 r calf" x limit 0 0 0
	$jointconstrain "bip01 r calf" y limit 0 0 0
	$jointconstrain "bip01 r calf" z limit -40 40 0

	$jointconstrain "bip01 r horselink" x limit 0 0 0
	$jointconstrain "bip01 r horselink" y limit 0 0 0
	$jointconstrain "bip01 r horselink" z limit -40 40 0

	$jointconstrain "bip01 r foot" x limit -30 30 0
	$jointconstrain "bip01 r foot" y limit -30 30 0
	$jointconstrain "bip01 r foot" z limit -30 30 0

	$jointconstrain "bip01 spine1" x limit -30 30 0
	$jointconstrain "bip01 spine1" y limit -30 30 0
	$jointconstrain "bip01 spine1" z limit -40 40 0

	$jointconstrain "bip01 l upperarm" x limit -30 30 0
	$jointconstrain "bip01 l upperarm" y limit -60 40 0
	$jointconstrain "bip01 l upperarm" z limit -70 70 0

	$jointconstrain "bip01 l forearm" x limit 0 0 0
	$jointconstrain "bip01 l forearm" y limit 0 0 0
	$jointconstrain "bip01 l forearm" z limit -100 0 0

	$jointconstrain "bip01 head" x limit -30 30 0
	$jointconstrain "bip01 head" y limit -30 30 0
	$jointconstrain "bip01 head" z limit -30 30 0

	$jointconstrain "bip01 r upperarm" x limit -30 30 0
	$jointconstrain "bip01 r upperarm" y limit -40 60 0
	$jointconstrain "bip01 r upperarm" z limit -70 70 0

	$jointconstrain "bip01 r forearm" x limit 0 0 0
	$jointconstrain "bip01 r forearm" y limit 0 0 0
	$jointconstrain "bip01 r forearm" z limit -100 0 0

	$jointconstrain "bip01 r hand" x limit -30 30 0
	$jointconstrain "bip01 r hand" y limit -30 30 0
	$jointconstrain "bip01 r hand" z limit -30 30 0

	$jointconstrain "bip01 l hand" x limit -30 30 0
	$jointconstrain "bip01 l hand" y limit -30 30 0
	$jointconstrain "bip01 l hand" z limit -30 30 0

	$jointconstrain "bip01 l foot" x limit -30 30 0
	$jointconstrain "bip01 l foot" y limit -30 30 0
	$jointconstrain "bip01 l foot" z limit -30 30 0
}

$animation "rif_f" "jackal_anims/Rif_moveF" {
	fps 30
	cmdlist rif_f_ik
	loop
	walkframe 60 LX LY
	rotate -90
	
}
$animation "rif_b" "jackal_anims/Rif_moveB" {
	fps 30
	cmdlist rif_b_ik
	loop
	walkframe 60 LX LY
	rotate -90
}
$animation "rif_r" "jackal_anims/Rif_moveR" {
	fps 30
	cmdlist rif_r_ik
	loop
	walkframe 60 LX LY
	rotate -90
}
$animation "rif_l" "jackal_anims/Rif_moveL" {
	fps 30
	cmdlist rif_l_ik
	loop
	walkframe 60 LX LY
	rotate -90
}

$sequence "Rifle_run" {
	"rif_b"
	"rif_r"
	"rif_f"
	"rif_l"
	"rif_b"
	{ event 1100 2 "Step" }
	{ event 1100 14 "Step" }
	
	blend "move_yaw" -180 180
	blendwidth 5
	activity "ACT_RUN_RIFLE" 1
	fadein 0.2
	fadeout 0.2

}

$texturegroup "skinfamilies"
{
	{ "jackal_shield_deepblue_color" }
	{ "jackal_shield_purple_color"   }
	{ "jackal_shield_orange_color" }
	{ "jackal_shield_green_color"   }
	{ "jackal_shield_white_color"   }
}