// QC File generated by the Wall Worm Model Tools Version 4.0.29
// Exported From: C:\Users\sgtfl\Documents\3dsMax\autoback\sentinel_agressor.max
// Get the latest version and notes at:
// http://dev.wallworm.com 
$cdmaterials "models/hce/spv3/forerunner/enforcer"
$origin 0 0 0 -90
$scale 1.0
$modelname	"hce\spv3\forerunner\enforcer\enforcer.mdl"
$body SPV3Enforcer "Enforcer.smd"
$surfaceprop "Metal"
$collisionjoints "Enforcer.smd" {
	$mass 100
}

$sequence "Idle" {
	"Enforcer_Idle.smd"  
	loop 
	activity ACT_IDLE -1
	fps 30
}

$attachment "root" "frame hull" 0.00 0.00 0.00 rotate -0 -0 0
$attachment "right_arm" "frame right arm" 7 -75 0 rotate 0 0 0
$attachment "left_arm" "frame left arm" -7 -75 0 rotate -0 0 -0
$attachment "left_eye" "frame left sarm" 5 -3 20 rotate 0 0 -0
$attachment "right_eye" "frame right sarm" -5 -3 20 rotate -0 0 -0
$attachment "left_thruster" "frame left thruster panels" 0 -25 0.00 rotate -0 -0 0
$attachment "right_thruster" "frame right thruster panels" -25 0 0 rotate -0 0 0