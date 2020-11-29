extends Node2D

onready var firevisual = preload("res://FireVisual.tscn")
var fires = []
var firestemp = []
var num_tiles = Vector2()
var tile_origin = Vector2()

func contains(list, element):
	for el in list:
		if el == element:
			return true
	return false

# startpositions can be something like
# [Vector2(2,2), Vector2(6,2)]
# tile coordinate
func init(startpositions):
	firestemp = startpositions
		
	update_fire_visuals()
	$Timer.connect("timeout", self, "fire_tick")
	$Timer.wait_time = 1
	num_tiles = get_node("../Tiles").get_used_rect().size
	tile_origin = get_node("../Tiles").get_used_rect().position
	print(num_tiles)

func update_fire_visuals():
	for f in firestemp:
		firestemp.pop_front()
		fires.push_back(f)
		var fv = firevisual.instance()
		fv.position = f * get_node("../Tiles").cell_size.x * 3
		fv.position += Vector2(get_node("../Tiles").cell_size.x*3/2,
			get_node("../Tiles").cell_size.x*3/2)
		$Visuals.add_child(fv)

func fire_tick():
	for i in range(len(fires)):
		var f = fires[i]

		if f.x > tile_origin.x:
			#try to spread right
			if (randi() % 3 == 0):
				var tile = get_node("../Tiles").get_cell(f.x-1,f.y)
				if !contains(fires, Vector2(f.x-1, f.y)) and tile != 0 and tile != 18:
					firestemp.push_back(Vector2(f.x-1, f.y))
		if f.x < num_tiles.x - 1:
			#try to spread left
			if (randi() % 3 == 0):
				var tile = get_node("../Tiles").get_cell(f.x+1,f.y)
				if !contains(fires, Vector2(f.x+1, f.y)) and tile != 0 and tile != 18:
					firestemp.push_back(Vector2(f.x+1, f.y))
		if f.y > tile_origin.y:
			#try to spread up
			if (randi() % 3 == 0):
				var tile = get_node("../Tiles").get_cell(f.x,f.y-1)
				if !contains(fires, Vector2(f.x, f.y-1)) and tile != 0 and tile != 18:
					firestemp.push_back(Vector2(f.x, f.y-1))
		if f.y < num_tiles.y - 1:
			#try to spread down
			if (randi() % 3 == 0):
				var tile = get_node("../Tiles").get_cell(f.x,f.y+1)
				if !contains(fires, Vector2(f.x, f.y+1)) and tile != 0 and tile != 18:
					firestemp.push_back(Vector2(f.x, f.y+1))
	update_fire_visuals()

func _ready():
	pass

func _process(delta):
	pass
