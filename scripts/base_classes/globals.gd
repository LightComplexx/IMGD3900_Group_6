extends Node

var current_level = 0
var enemy_level = 0
var player_stats = {"gun_damage": 20, "gun_cooldown": 0.25, "gun_speed": 2500, "hp": 100, "tank_speed": 300, "rotate_speed": 4}

var levels = ["res://scenes/ui/main_menu.tscn", "res://scenes/maps/map01.tscn"]

func main_menu():
	current_level = 0
	enemy_level = 0
	reset_player_stats()
	get_tree().change_scene_to_file(levels[current_level])

# Called every frame. 'delta' is the elapsed time since the previous frame.
func next_scene():
	current_level += 1
	if current_level < levels.size():
		get_tree().change_scene_to_file(levels[current_level])
	else:
		main_menu()


func adv_enemy_level():
	enemy_level += 1
	get_tree().change_scene_to_file(levels[1])

func reset_player_stats():
	player_stats["gun_damage"] = 20
	player_stats["gun_cooldown"] = 0.25
	player_stats["gun_speed"] = 2500
	player_stats["hp"] = 100
	player_stats["tank_speed"] = 300
	player_stats["rotate_speed"] = 4
