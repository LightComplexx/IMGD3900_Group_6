extends "res://scripts/tank.gd"

var parent

func _ready() -> void:
	parent = get_parent()

func control(delta):
	if parent is PathFollow2D:
		parent.set_progress(parent.get_progress() + speed * delta)
	else:
		pass
