extends "res://scripts/base_classes/tank.gd"

@export var turret_speed = 2.0
@export var detect_radius = 400
@export var bullet_interval = 0.3
@export var position_markers: Array[Vector2] = []
var current_marker_index: int = 0

var target = null
var speed = 0.0
var bullets_fired = 0
const BULLETS_PER_BURST = 4
var waiting_for_anim = false

func _ready() -> void:
	if position_markers.size() > 0:
		position = position_markers[0]
	
	var circle = CircleShape2D.new()
	$DetectRadius/CollisionShape2D.shape = circle
	$DetectRadius/CollisionShape2D.shape.radius = detect_radius
	health = max_health
	emit_signal("health_changed", health * 100/max_health)
	$GunTimer.wait_time = gun_cooldown
	$BulletIntervalTimer.wait_time = bullet_interval

func _process(delta) -> void:
	#if $Turret.position != $Turret.global_position
		#$Turret.         (TODO!!!)
	if $LookAhead1.is_colliding() or $LookAhead2.is_colliding():
		speed = lerp(speed, 0.0, 0.1)
	else:
		speed = lerp(speed, max_speed, 0.05)
	
	if target:
		var player_pos = target.global_position
		var current_dir = Vector2(1, 0).rotated(global_rotation)
		var target_dir = (player_pos - global_position).normalized()
		
		global_rotation = current_dir.lerp(target_dir, turret_speed * delta).angle()
		
		if target_dir.dot(current_dir) > 0.9:
			_on_shoot()
	else:
		global_rotation = lerp_angle(global_rotation, 0.0, turret_speed * delta)
		if abs(global_rotation) < 0.01:
			global_rotation = 0.0


func control(_delta):
	if position_markers.size() < 2:
		return # Not enough markers to move between

	# Get current and target positions
	var target_position = position_markers[current_marker_index]

	# Move towards the target position
	var direction = (target_position - position).normalized()
	velocity = direction * speed
	move_and_slide()
	

	# Rotate to face the target position
	rotation = direction.angle()

	# Check if we have reached the current marker
	if position.distance_to(target_position) < 5.0:  # Adjust threshold as needed
		# Switch to the next marker
		current_marker_index = (current_marker_index + 1) % position_markers.size()

func _on_shoot() -> void:
	if can_shoot and not waiting_for_anim:
		can_shoot = false
		bullets_fired = 0  # Reset bullet count
		waiting_for_anim = true # Notify self that it's waiting for animation
		$AnimationPlayer.play("shoot_signal") # Start shoot signal animation
		


func _on_detect_radius_body_entered(body: Node2D) -> void:
	target = body


func _on_detect_radius_body_exited(body: Node2D) -> void:
	$GunTimer.wait_time = gun_cooldown
	$BulletIntervalTimer.wait_time = bullet_interval
	
	if body == target:
		target = null


func _on_bullet_interval_timer_timeout() -> void:
	if bullets_fired < BULLETS_PER_BURST and not waiting_for_anim:
		var dir = Vector2(1, 0).rotated($Turret.global_rotation)
		emit_signal("shoot", Bullet, $Turret/Muzzle.global_position, dir)
		$Turret.move_local_x(-10)
		bullets_fired += 1

		# Schedule the next shot if needed
		if bullets_fired < BULLETS_PER_BURST:
			$BulletIntervalTimer.start()  # Start interval for the next shot
		else:
			# After the last shot, start the cooldown timer
			$GunTimer.start()


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "shoot_signal":
		waiting_for_anim = false
		_on_bullet_interval_timer_timeout()  # Fire the first shot after animation finishes
