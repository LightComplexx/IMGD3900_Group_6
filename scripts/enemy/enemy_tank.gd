extends "res://scripts/base_classes/tank.gd"

@export var turret_speed = 2.0
@export var detect_radius = 400
@export var bullet_interval = 0.3

var parent
var target = null
var speed = 0.0
var bullets_fired = 0
const BULLETS_PER_BURST = 4

func _ready() -> void:
	parent = get_parent()
	var circle = CircleShape2D.new()
	$DetectRadius/CollisionShape2D.shape = circle
	$DetectRadius/CollisionShape2D.shape.radius = detect_radius
	health = max_health
	emit_signal("health_changed", health * 100/max_health)
	$GunTimer.wait_time = gun_cooldown
	$BulletIntervalTimer.wait_time = bullet_interval

func _process(delta) -> void:
	if $LookAhead1.is_colliding() or $LookAhead2.is_colliding():
		speed = lerp(speed, 0.0, 0.1)
	else:
		speed = lerp(speed, max_speed, 0.05)
	
	if target:
		var current_dir = Vector2(1, 0).rotated($Turret.global_rotation)
		var target_dir = (target.global_position - global_position).normalized()
		$Turret.global_rotation = current_dir.lerp(target_dir, turret_speed * delta).angle()
		if target_dir.dot(current_dir) > 0.9:
			_on_shoot()
	else:
		$Turret.global_rotation = lerp_angle($Turret.global_rotation, global_rotation, turret_speed * delta)
		if abs($Turret.global_rotation) < 0.01:
			$Turret.global_rotation = global_rotation


func control(_delta):
	if parent is PathFollow2D:
		parent.set_progress(parent.get_progress() + speed * _delta)
		position = Vector2()
	else:
		pass

func _on_shoot() -> void:
	if can_shoot:
		can_shoot = false
		bullets_fired = 0  # Reset bullet count
		_on_bullet_interval_timer_timeout()  # Fire the first shot immediately


func _on_detect_radius_body_entered(body: Node2D) -> void:
	target = body


func _on_detect_radius_body_exited(body: Node2D) -> void:
	if body == target:
		target = null


func _on_bullet_interval_timer_timeout() -> void:
	if bullets_fired < BULLETS_PER_BURST:
		var dir = Vector2(1, 0).rotated($Turret.global_rotation)
		emit_signal("shoot", Bullet, $Turret/Muzzle.global_position, dir)
		bullets_fired += 1

		# Schedule the next shot if needed
		if bullets_fired < BULLETS_PER_BURST:
			$BulletIntervalTimer.start()  # Start interval for the next shot
		else:
			# After the last shot, start the cooldown timer
			$GunTimer.start()