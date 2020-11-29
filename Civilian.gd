extends Node2D

export var worth = 500

func _ready():
	$Label.text = "£" + str(worth)
	$Sprite.frame = randi() % 4
