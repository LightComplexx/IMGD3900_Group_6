extends "res://scripts/base_classes/tank.gd"

@export var detect_radius = 500
@export var bullet_interval = 0.3 
@export var position_markers: Array[Vector2] = []
var current_marker_index: int = 0

var player = null
var speed = 0.0
var bullets_fired = 0
const BULLETS_PER_BURST = 2
var waiting_for_anim = false

func _ready() -> void:
	if position_markers.size() > 0:
		position = position_markers[0]
	
	var circle = CircleShape2D.new()
	$DetectRadius/CollisionShape2D.shape = circle
	$DetectRadius/CollisionShape2D.shape.radius = detect_radius
	health = max_health
	speed = max_speed
	emit_signal("health_changed", health * 100/max_health)
	$GunTimer.wait_time = gun_cooldown
	$BulletIntervalTimer.wait_time = bullet_interval

func control(_delta):
	if position_markers.size() < 2:
		return # Not enough markers to move between

	# Determine target based on is_aggro state
	var target_position: Vector2
	if player:
		# If player in aggro range, set target to player’s position
		target_position = player.position # Assumes player has a position variable
	else:
		# Otherwise, continue moving toward current marker
		target_position = position_markers[current_marker_index]
	
	var current_dir = Vector2(1, 0).rotated(rotation)
	var target_dir = (target_position - position).normalized()
	
	if target_dir.dot(current_dir) > 0.9:
		if player:
			_on_shoot(player)
			if position.distance_to(target_position) > 10.0:
				velocity = current_dir * speed/2
				move_and_slide()
		else:
			velocity = current_dir * speed
			move_and_slide()
	
	# Rotate to face the target position
	var target_angle = target_dir.angle()
	var angle_diff = wrapf(target_angle - rotation, -PI, PI)
	rotation += clamp(angle_diff, -max_rotation_speed * _delta, max_rotation_speed * _delta)
	
	
	# Check if we've reached the current marker
	if not player and position.distance_to(target_position) < 5.0:
		# Switch to the next marker if not in aggro state
		current_marker_index = (current_marker_index + 1) % position_markers.size()

func _on_shoot(target = null) -> void:
	if can_shoot and not waiting_for_anim:
		can_shoot = false
		bullets_fired = 0  # Reset bullet count
		waiting_for_anim = true # Notify self that it's waiting for animation
		$AnimationPlayer.play("shoot_signal") # Start shoot signal animation


func _on_detect_radius_body_entered(body: Node2D) -> void:
	player = body


func _on_detect_radius_body_exited(body: Node2D) -> void:
	if body == player:
		player = null
		

func explode() -> void:
	$BulletDetect/bullet_collision.set_deferred("disabled", true)
	$BodyDetection/detection_shape.set_deferred("disabled", true)
	alive = false
	$BulletIntervalTimer.stop()
	$GunTimer.stop()
	$TankBody.hide()
	$Turret.hide()
	$Explosion.show()
	$Explosion.play()
	emit_signal("dead")

func _on_bullet_interval_timer_timeout() -> void:
	if bullets_fired < BULLETS_PER_BURST and alive and not waiting_for_anim:
		var dir = Vector2(1, 0).rotated($Turret.global_rotation)
		var temp_target
		var position1 = Vector2($Turret/Muzzle.global_position.x, $Turret/Muzzle.global_position.y - 18)
		var position2 = Vector2($Turret/Muzzle.global_position.x, $Turret/Muzzle.global_position.y + 18)
		if player:
			temp_target = player
		else:
			temp_target = null
		# Shoots 2 bullets
		emit_signal("shoot", Bullet, position1, dir, temp_target)
		emit_signal("shoot", Bullet, position2, dir, temp_target)
		# $ShootSound.play()
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