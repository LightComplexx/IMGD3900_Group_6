extends "res://scripts/tank.gd"

@export var turret_speed = 1.0
@export var detect_radius = 200

var parent
var target = null

func _ready() -> void:
	parent = get_parent()
	var circle = CircleShape2D.new()
	$DetectRadius/CollisionShape2D.shape = circle
	$DetectRadius/CollisionShape2D.shape.radius = detect_radius

func _process(delta) -> void:
	if target:
		var current_dir = Vector2(1, 0).rotated($Turret.global_rotation)
		var target_dir = (target.global_position - global_position).normalized()
		$Turret.global_rotation = current_dir.lerp(target_dir, turret_speed * delta).angle()
	else:
		$Turret.global_rotation = global_rotation - (turret_speed * delta)


func control(delta):
	if parent is PathFollow2D:
		parent.set_progress(parent.get_progress() + speed * delta)
		position = Vector2()
	else:
		pass


func _on_detect_radius_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		target = body


func _on_detect_radius_body_exited(body: Node2D) -> void:
	if body == target:
		target = null
