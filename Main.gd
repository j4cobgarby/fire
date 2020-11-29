extends Node2D

var inv_persontype
var inv_worth
var profit
var holding = false

export var firepoints = [Vector2(15,-3)]
export var thisscene = "res://"
export var nextscene = "res://"

onready var ashpilescene = preload("res://AshPile.tscn")

func _ready():
	$Fire.init(firepoints)
	profit = 0
	
	$HUD/PickupIndicator.visible = false
	$HUD/Profit.text = "PROFIT £0"
	$HUD/Worth.text = "TAKING £0"

func lerp(from, to, prog):
	return from + (to - from) * prog

func _physics_process(delta):
	$HUD/Health.text = "HEALTH: " + str($Firefighter.health)
	
	if $Civilians.get_child_count() == 0 and !holding:
		print("Level finished.")
		get_tree().change_scene(nextscene)
	
	$Cam.position.x = lerp($Cam.position.x, $Firefighter.position.x, 0.05)
	$Cam.position.y = lerp($Cam.position.y, $Firefighter.position.y, 0.05)
	
	# check dead civilians
	for c in $Civilians.get_children():
		for v in $Fire/Visuals.get_children():
			if v.get_node("Area").overlaps_area(c.get_node("Area")):
				var ash = ashpilescene.instance()
				ash.position = c.position
				$AshPiles.add_child(ash)
				c.queue_free()
				
	# check player fire
	for v in $Fire/Visuals.get_children():
		if v.get_node("Area").overlaps_area($Firefighter/Area):
			$Firefighter.damage()
			if $Firefighter.health == 0:
				print("YOU LOSE")
				get_tree().change_scene(thisscene)
			break
	
	if !holding and Input.is_action_just_pressed("rescue"):
		for c in $Civilians.get_children():
			if c.get_node("Area").overlaps_area($Firefighter/Area):
				inv_persontype = c.get_node("Sprite").frame
				inv_worth = c.worth
				print(str(inv_persontype) + "\t" + str(inv_worth))
				$HUD/PickupIndicator/Sprite.frame = inv_persontype
				$HUD/Worth.text = "TAKING £" + str(inv_worth)
				holding = true
				c.queue_free()
				$HUD/PickupIndicator.visible = true
			
	if $Firefighter/Area.overlaps_area($RescueZone) and holding == true:
		profit += inv_worth
		inv_worth = 0
		$HUD/Profit.text = "PROFIT £" + str(profit)
		$HUD/Worth.text = "TAKING £" + str(inv_worth)
		holding = false
		$HUD/PickupIndicator.visible = false
