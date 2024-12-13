extends Node2D

# 0 = tank enemy
# 1 = jet enemy
@export var enemy_scene: Array[PackedScene] = []

var enemy_count
var enemy_layout: Array[int] = []


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	enemy_layout = [1, 1, 2, 3, 3, 4, 4, 4, 5, 5, 5, 6, 6, 7, 7, 8, 8, 9, 9, 10, \
	10, 10, 11, 11, 12, 12, 13, 13, 14, 14, 15, 16, 16, 17, 17, 18, 18, 19, 19, 20]
	set_camera_limits()
	add_enemies()
	enemy_count = get_tree().get_nodes_in_group("Enemy").size()
	set_player_stats()
	$Player.upgrades_done.connect(_on_upgrade_timer_timeout)
	$Player/HUD.update_score(enemy_count)
	$Player/HUD.update_level(Globals.enemy_level + 1)
	$MainTheme.play(Globals.song_position)


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
		var select
		if Globals.enemy_level > 0 and i%2 == 0:
			select = 1
		else:
			select = 0
		
		var enemy = enemy_scene[select].instantiate()
		
		# Choose random locations for Enemy to patrol
		enemy.position_markers.append(Vector2(randi_range(60, 4400), randi_range(60, 1600)))
		enemy.position_markers.append(Vector2(randi_range(60, 4400), randi_range(60, 1600)))
		enemy.position_markers.append(Vector2(randi_range(60, 4400), randi_range(60, 1600)))
		
		# Spawn the mob by adding it to the Main scene.
		add_child(enemy)
		
		# Connect signals
		enemy.shoot.connect(_on_Tank_shoot)
		enemy.dead.connect(_on_enemy_dead)
		
	print(Globals.enemy_level)

func set_player_stats():
	$Player.max_health = Globals.player_stats["hp"]
	$Player.health = $Player.max_health
	$Player.gun_cooldown = Globals.player_stats["gun_cooldown"]
	$Player.max_speed = Globals.player_stats["tank_speed"]
	$Player.max_rotation_speed = Globals.player_stats["rotate_speed"]


func _on_Tank_shoot(bullet, _position, _direction, _target = null):
	var b = bullet.instantiate()
	add_child(b)
	b.start(_position, _direction, _target)


func _on_player_dead() -> void:
	Globals.song_position = $MainTheme.get_playback_position() + AudioServer.get_time_since_last_mix()
	Globals.main_menu()


func _on_enemy_dead():
	enemy_count -= 1
	$Player/HUD.update_score(enemy_count)
	
	if enemy_count == 0:
		$Player.can_control = false
		$Player/BulletDetect/bullet_collision.set_deferred("disabled", true)
		$Player/HUD/Message.show()
		$ProgessTimer.start()


func _on_progress_timer_timeout() -> void:
	$Player/HUD/Message.hide()
	$Player/HUD/UpgradeWindow.show()


func _on_upgrade_timer_timeout() -> void:
	Globals.song_position = $MainTheme.get_playback_position() + AudioServer.get_time_since_last_mix()
	Globals.adv_enemy_level()
