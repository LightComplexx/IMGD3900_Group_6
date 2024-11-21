extends "res://scripts/base_classes/tank.gd"

var base_gun = preload("res://sprites/tank_guns/base_gun.png")
var big_gun = preload("res://sprites/tank_guns/big_gun.png")

var gun_texture = base_gun

func _ready() -> void:
	health = max_health
	health_changed.connect($HUD.update_healthbar)
	emit_signal("health_changed", health * 100/max_health)
	$GunTimer.wait_time = gun_cooldown

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func control(_delta):
	var rot_dir = 0
	
	# Check if forward or backward is pressed along with left or right
	var is_forward_or_backward_pressed = Input.is_action_pressed("move_forward") or Input.is_action_pressed("move_backward")
	var rot_speed_modifier = 0.5 if is_forward_or_backward_pressed else 1.0
	
	# Check rotation buttons
	if Input.is_action_pressed("turn_right"):
		rot_dir += 1
	if Input.is_action_pressed("turn_left"):
		rot_dir -= 1
	
	rotation += max_rotation_speed * rot_dir * rot_speed_modifier * _delta
	velocity = Vector2()
	
	# Check movement buttons
	if Input.is_action_pressed("move_forward"):
		if not $MoveSound.playing:
			$MoveSound.play()
		velocity = Vector2(max_speed, 0).rotated(rotation)
	if Input.is_action_pressed("move_backward"):
		if not $MoveSound.playing:
			$MoveSound.play()
		velocity = Vector2(-max_speed * 0.75, 0).rotated(rotation)
		
	# Check shoot button
	if Input.is_action_pressed("shoot"):
		_on_shoot()
		
	
	# Check gun switch button
	if Input.is_action_just_pressed("switch_guns"):
		if gun_texture == base_gun:
			gun_texture = big_gun
			gun_cooldown = 1.5
			$GunTimer.wait_time = gun_cooldown
		else:
			gun_texture = base_gun
			gun_cooldown = 0.25
			$GunTimer.wait_time = gun_cooldown
	
	# Stop sound if not moving
	if not Input.is_anything_pressed():
		$MoveSound.stop()
		$MoveSound.seek(0.0)
		
	
	# Set gun texture
	$Turret.texture = gun_texture
	move_and_slide()

func explode() -> void:
	emit_signal("dead")
