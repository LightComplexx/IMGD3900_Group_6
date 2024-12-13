extends "res://scripts/base_classes/tank.gd"

signal upgrades_done

var base_gun = preload("res://sprites/tank_guns/single_gunonly_pixel.png")
var big_gun = preload("res://sprites/tank_guns/big_gun.png")
var gun_texture = base_gun
var can_control
var acceleration = 200.0  # Speed increase per second
var deceleration = 200.0  # Speed decrease per second
var brake_force = 300.0   # Additional speed decrease per second
var current_speed = 0.0


func _ready() -> void:
	health = max_health
	can_control = true
	health_changed.connect($HUD.update_healthbar)
	emit_signal("health_changed", health * 100/max_health)
	$GunTimer.wait_time = gun_cooldown

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if $HUD.upgrades_selected:
		$UpgradeTimer.start()
		$HUD.upgrades_selected = false


func control(_delta):
	var rot_dir = 0
	
	# Check if forward or backward is pressed along with left or right
	var is_forward_or_backward_pressed = Input.is_action_pressed("move_forward") or Input.is_action_pressed("move_backward")
	var rot_speed_modifier = 0.5 if is_forward_or_backward_pressed else 1.0
	
	# Desired speed based on input
	var target_speed: float = 0.0
	
	# Stop sound if not moving
	if not Input.is_anything_pressed():
		$MoveSound.stop()
		$MoveSound.seek(0.0)
		
	
	# Set gun texture
	$Turret.texture = gun_texture
	
	if can_control:
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
			target_speed = max_speed
		if Input.is_action_pressed("move_backward"):
			if not $MoveSound.playing:
				$MoveSound.play()
			target_speed = -max_speed * 0.75
			
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
		
		# Adjust speed towards target speed
		if (current_speed > 0 and target_speed < 0) or (current_speed < 0 and target_speed > 0):
			# Apply additional brake force for direction change
			if current_speed > 0:
				current_speed = max(current_speed - brake_force * _delta, 0)
			elif current_speed < 0:
				current_speed = min(current_speed + brake_force * _delta, 0)
		else:
			# Smoothly accelerate or decelerate
			if current_speed < target_speed:
				current_speed = min(current_speed + acceleration * _delta, target_speed)
			elif current_speed > target_speed:
				current_speed = max(current_speed - deceleration * _delta, target_speed)
		# Calculate velocity
		velocity = Vector2(current_speed, 0).rotated(rotation)
		# Apply Physics
		move_and_slide()
		
	

# handles shoot action
func _on_shoot(target = null) -> void:
	if can_shoot:
		can_shoot = false
		$GunTimer.start()
		var dir = Vector2(1, 0).rotated($Turret.global_rotation)
		$BulletSound.play()
		emit_signal("shoot", Bullet, $Turret/Muzzle.global_position, dir, target)
		
		# quick makeshift turret recoil 
		$Turret.position += Vector2(-5, 0)
		await get_tree().create_timer(0.1).timeout
		$Turret.position = Vector2(0, 0)

func explode() -> void:
	emit_signal("dead")

func update_damage(damage) -> void:
	emit_signal("update_dmg", damage)

func update_speed(speed) -> void:
	emit_signal("update_spd", speed)

func _on_upgrade_timer_timeout() -> void:
	emit_signal("upgrades_done")
