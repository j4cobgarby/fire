extends KinematicBody2D

var jumps_left = 2

var accel = Vector2()
var vel = Vector2()

var health = 3
var damage_timer = 0

func damage():
	print("Ouch")
	if (damage_timer > 1):
		print(health)
		health -= 1
		damage_timer = 0

func _physics_process(delta):
	damage_timer += delta
	
	accel = Vector2(0,0)
	accel.y = 45
	
	if Input.is_action_pressed("ui_right"):
		$Sprite.animation = "running"
		$Sprite.flip_h = false
		accel.x = 30
	if Input.is_action_pressed("ui_left"):
		$Sprite.animation = "running"
		$Sprite.flip_h = true
		accel.x -= 30
	if Input.is_action_just_pressed("ui_up") and jumps_left > 0:
		accel.y -= 1300
		jumps_left -= 1

	vel += accel
	vel *= 0.91
	
	if !(Input.is_action_pressed("ui_right") or Input.is_action_pressed("ui_left")) and vel.length() > 100:
		$Sprite.animation = "skid"

	if vel.length() <= 50:
		$Sprite.animation = "idle"
	
	vel = move_and_slide(vel, Vector2(0,-1))
	if is_on_floor():
		jumps_left = 2
