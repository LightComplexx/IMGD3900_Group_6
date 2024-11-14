extends "res://scripts/base_classes/tank.gd"

var base_gun = preload("res://sprites/tank_guns/base_gun.png")
var big_gun = preload("res://sprites/tank_guns/big_gun.png")

var gun_texture = base_gun

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func control(_delta):
	var rot_dir = 0
	
	#$Turret.look_at(get_global_mouse_position())
	
	if Input.is_action_pressed("turn_right"):
		rot_dir += 1
	if Input.is_action_pressed("turn_left"):
		rot_dir -= 1
	
	rotation += rotation_speed * rot_dir * _delta
	velocity = Vector2()
	
	if Input.is_action_pressed("move_forward"):
		if not $MoveSound.playing:
			$MoveSound.play()
		velocity = Vector2(max_speed, 0).rotated(rotation)
	if Input.is_action_pressed("move_backward"):
		if not $MoveSound.playing:
			$MoveSound.play()
		velocity = Vector2(-max_speed/2, 0).rotated(rotation)
	if Input.is_action_pressed("shoot"):
		_on_shoot()
		
	
	if Input.is_action_just_pressed("switch_guns"):
		if gun_texture == base_gun:
			gun_texture = big_gun
			gun_cooldown = 1.5
			$GunTimer.wait_time = gun_cooldown
		else:
			gun_texture = base_gun
			gun_cooldown = 0.2
			$GunTimer.wait_time = gun_cooldown
	
	if not Input.is_anything_pressed():
		$MoveSound.stop()
		$MoveSound.seek(0.0)
		
	
	$Turret.texture = gun_texture
