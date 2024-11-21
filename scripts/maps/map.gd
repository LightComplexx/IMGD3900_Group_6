extends Node2D

@export var enemy_scene: PackedScene

var enemy_count
var enemy_layout: Array[int] = []


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	enemy_layout = [1, 1, 2, 3, 3, 4, 4, 4, 5, 6]
	set_camera_limits()
	add_enemies()
	enemy_count = get_tree().get_nodes_in_group("Enemy").size()
	$HUD.update_score(enemy_count)
	$HUD.update_level(Globals.enemy_level + 1)


func set_camera_limits():
	var map_limits = $terrain.get_used_rect()
	var map_cellsize = $terrain.tile_set.tile_size
	$Player/Camera2D.limit_left = map_limits.position.x * map_cellsize.x
	$Player/Camera2D.limit_right = map_limits.end.x * map_cellsize.x
	$Player/Camera2D.limit_top = map_limits.position.y * map_cellsize.y
	$Player/Camera2D.limit_bottom = map_limits.end.y * map_cellsize.y
	

func add_enemies():
	for i in range(enemy_layout[Globals.enemy_level]):
		# Create a new instance of the Enemy scene
		var enemy = enemy_scene.instantiate()
		
		# Choose random locations for Enemy to patrol
		enemy.position_markers.append(Vector2(randi_range(60, 4400), randi_range(60, 1600)))
		enemy.position_markers.append(Vector2(randi_range(60, 4400), randi_range(60, 1600)))
		enemy.position_markers.append(Vector2(randi_range(60, 4400), randi_range(60, 1600)))
		# Set enemy variables if needed
		
		# Spawn the mob by adding it to the Main scene.
		add_child(enemy)
		
		# Connect signals
		enemy.shoot.connect(_on_Tank_shoot)
		enemy.dead.connect(_on_enemy_dead)
		
		
	print(Globals.enemy_level)

func _on_Tank_shoot(bullet, _position, _direction):
	var b = bullet.instantiate()
	add_child(b)
	b.start(_position, _direction)


func _on_player_dead() -> void:
	Globals.main_menu()


func _on_enemy_dead():
	enemy_count -= 1
	$HUD.update_score(enemy_count)
	
	if enemy_count == 0:
		$HUD/Message.show()
		$ProgessTimer.start()


func _on_progress_timer_timeout() -> void:
	$HUD/Message.hide()
	Globals.adv_enemy_level()
