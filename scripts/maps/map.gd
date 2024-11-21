extends Node2D

var enemy_count


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_camera_limits()
	enemy_count = get_tree().get_nodes_in_group("Enemy").size()
	$HUD.update_score(enemy_count)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("restart"):
		get_tree().reload_current_scene()


func set_camera_limits():
	var map_limits = $terrain.get_used_rect()
	var map_cellsize = $terrain.tile_set.tile_size
	$Player/Camera2D.limit_left = map_limits.position.x * map_cellsize.x
	$Player/Camera2D.limit_right = map_limits.end.x * map_cellsize.x
	$Player/Camera2D.limit_top = map_limits.position.y * map_cellsize.y
	$Player/Camera2D.limit_bottom = map_limits.end.y * map_cellsize.y
	

func _on_Tank_shoot(bullet, _position, _direction):
	var b = bullet.instantiate()
	add_child(b)
	b.start(_position, _direction)


func _on_player_dead() -> void:
	get_tree().change_scene_to_file("res://scenes/ui/main_menu.tscn")


func _on_enemy_dead() -> void:
	enemy_count -= 1
	$HUD.update_score(enemy_count)
