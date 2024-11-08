extends "res://scripts/base_classes/tank.gd"

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
		
	if not Input.is_anything_pressed():
		$MoveSound.stop()
		$MoveSound.seek(0.0)
