extends "res://scripts/tank.gd"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func control(delta):
	var rot_dir = 0
	
	$Turret.look_at(get_global_mouse_position())
	
	if Input.is_action_pressed("turn_right"):
		rot_dir += 1
	if Input.is_action_pressed("turn_left"):
		rot_dir -= 1
	
	rotation += rotation_speed * rot_dir * delta
	velocity = Vector2()
	
	if Input.is_action_pressed("move_forward"):
		velocity = Vector2(speed, 0).rotated(rotation)
	if Input.is_action_pressed("move_backward"):
		velocity = Vector2(-speed/2, 0).rotated(rotation)
